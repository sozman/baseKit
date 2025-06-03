//
//  NetworkClient.swift
//  BaseKit
//
//  Created by Sinan Özman on 3.06.2025.
//

import Foundation

// MARK: - NetworkClient

/// A type-safe, middleware-driven network client designed for modular and testable API requests.
///
/// `NetworkClient` handles:
/// - Building `URLRequest` from `RequestProtocol` conforming types
/// - Applying headers, HTTP methods, and body data
/// - Executing the request via `URLSession`
/// - Parsing the response using `JSONDecoder`
/// - Triggering custom middleware hooks for logging, authentication, etc.
///
/// This structure encourages composability and separation of concerns across networking logic.
public final class NetworkClient {

    // MARK: - Properties

    /// The base URL used for all relative endpoint paths.
    private let baseURL: URL

    /// The URLSession instance used for executing requests.
    private let session: URLSession

    /// A list of middleware components to be applied before and after the request.
    private let middlewares: [Middleware]

    // MARK: - Initialization

    /// Initializes a new instance of `NetworkClient`.
    ///
    /// - Parameters:
    ///   - baseURL: The base URL used for constructing full request URLs.
    ///   - session: The URLSession to use for executing network calls (default: `.shared`).
    ///   - middlewares: Middleware array for pre-/post-processing of requests and responses.
    public init(
        baseURL: URL,
        session: URLSession = .shared,
        middlewares: [Middleware] = []
    ) {
        self.baseURL = baseURL
        self.session = session
        self.middlewares = middlewares
    }

    // MARK: - Public API

    /// Sends a type-safe network request and returns a decoded response.
    ///
    /// - Parameters:
    ///   - request: A type conforming to `RequestProtocol`, defining the endpoint and expected response.
    ///   - completion: A closure that returns either a decoded response or a `NetworkError`.
    public func send<R: RequestProtocol>(
        _ request: R,
        completion: @escaping (Result<R.Response, NetworkError>) -> Void
    ) {
        // Construct URL from base + endpoint path
        guard let url = URL(string: request.endpoint.path, relativeTo: baseURL) else {
            return completion(.failure(.invalidURL))
        }

        // Initialize and configure URLRequest
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.endpoint.method.rawValue
        addHeaders(to: &urlRequest, headers: request.endpoint.headers)

        // Encode body if present
        if let body = request.body {
            do {
                urlRequest.httpBody = try JSONEncoder().encode(body)
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                return completion(.failure(.other(error)))
            }
        }

        // Apply middleware (request phase)
        do {
            try middlewares.forEach { try $0.processRequest(&urlRequest) }
        } catch {
            return completion(.failure(.other(error)))
        }

        // Perform the network request
        session.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let self else { return }

            if let error = error {
                return completion(.failure(.other(error)))
            }

            guard
                let httpResponse = response as? HTTPURLResponse,
                let data = data
            else {
                return completion(.failure(.requestFailed(statusCode: -1)))
            }

            // Apply middleware (response phase)
            do {
                try self.middlewares.forEach {
                    try $0.processResponse(data, httpResponse)
                }
            } catch {
                return completion(.failure(.other(error)))
            }

            // Validate HTTP status code
            guard (200...299).contains(httpResponse.statusCode) else {
                return completion(.failure(.requestFailed(statusCode: httpResponse.statusCode)))
            }

            // Decode response body into expected model
            do {
                let decoded = try JSONDecoder().decode(R.Response.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }

    // MARK: - Private Helpers

    /// Adds custom headers to the URL request.
    ///
    /// - Parameters:
    ///   - request: The URLRequest to be modified.
    ///   - headers: A dictionary of headers to apply.
    private func addHeaders(to request: inout URLRequest, headers: [String: String]?) {
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}
