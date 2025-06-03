//
//  Middleware.swift
//  BaseKit
//
//  Created by Sinan Özman on 3.06.2025.
//

import Foundation
import os

/// Private logger instance for the networking layer.
private let networkLogger = Logger(subsystem: "com.baseKit.network", category: "network")

// MARK: - Middleware Protocol

/// A protocol that defines hooks for intercepting and modifying
/// network requests and responses.
///
/// Middlewares allow for pre-processing requests (e.g., logging, auth)
/// and post-processing responses (e.g., caching, analytics).
public protocol Middleware {

    /// Called before the request is sent.
    /// Use this to modify headers, log info, or attach auth tokens.
    ///
    /// - Parameter request: The URLRequest to be modified.
    /// - Throws: Can throw custom errors if the middleware wants to cancel the request.
    func processRequest(_ request: inout URLRequest) throws

    /// Called after a response is received from the server.
    ///
    /// - Parameters:
    ///   - data: The raw data received.
    ///   - response: The URLResponse object.
    /// - Throws: Can be used to throw custom validation or decoding errors.
    func processResponse(_ data: Data, _ response: URLResponse) throws
}

/// A middleware that logs outgoing requests and incoming responses
/// in a developer-friendly format using `os.Logger`.
///
/// This middleware is intended for debugging and development use.
/// It logs URL, method, headers, and body (truncated) for both requests and responses.
public final class LoggingMiddleware: Middleware {

    /// Initializes the logger middleware.
    public init() {}

    public func processRequest(_ request: inout URLRequest) throws {
        let req = request

        var log = ""
        log += "📤 REQUEST START ------------------------------\n"
        log += "🌍 URL          : \(req.url?.absoluteString ?? "❌ URL not found")\n"
        log += "📬 METHOD       : \(req.httpMethod ?? "❌ Unknown")\n"

        if let headers = req.allHTTPHeaderFields, !headers.isEmpty {
            let headerString = headers.map { "\($0): \($1)" }.joined(separator: " | ")
            log += "🧾 HEADERS      : \(headerString)\n"
        } else {
            log += "🧾 HEADERS      : ❌ No headers\n"
        }

        if let body = req.httpBody,
           let bodyString = String(data: body, encoding: .utf8)?
                .replacingOccurrences(of: "\n", with: " ")
                .prefix(500) {
            log += "📦 BODY         : \(bodyString)...\n"
        } else {
            log += "📦 BODY         : ❌ No body\n"
        }

        log += "📤 REQUEST END --------------------------------"
        networkLogger.debug("\n\(log)")
    }

    public func processResponse(_ data: Data, _ response: URLResponse) throws {
        guard let res = response as? HTTPURLResponse else {
            networkLogger.fault("❌ Failed to cast response to HTTPURLResponse – type: \(type(of: response))")
            return
        }

        var log = ""
        log += "📥 RESPONSE START -----------------------------\n"
        log += "🌍 URL          : \(res.url?.absoluteString ?? "❌ URL missing")\n"
        log += "🔢 STATUS CODE  : \(res.statusCode)\n"

        let headers = res.allHeaderFields
        if !headers.isEmpty {
            let headerString = headers.map { "\($0): \($1)" }.joined(separator: " | ")
            log += "🧾 HEADERS      : \(headerString)\n"
        } else {
            log += "🧾 HEADERS      : ❌ No headers\n"
        }

        let responseString = String(data: data, encoding: .utf8)?
            .replacingOccurrences(of: "\n", with: " ")
            .prefix(1000) ?? "📛 UTF-8 decode failed"

        log += "📦 BODY         : \(responseString)\n"
        log += "📥 RESPONSE END ------------------------------"

        networkLogger.debug("\n\(log)")
    }
}

/// A middleware that attaches a Bearer Authorization header to each request.
///
/// Useful for authenticated endpoints that require dynamic or persisted tokens.
/// If no token is available, the request will fail before being sent.
public final class AuthTokenMiddleware: Middleware {

    /// A closure that returns the current token when requested.
    /// This allows integration with Keychain, UserDefaults, or in-memory stores.
    private let tokenProvider: () -> String?

    /// Initializes the middleware with a token provider closure.
    ///
    /// - Parameter tokenProvider: Closure that returns the current Bearer token (if any).
    public init(tokenProvider: @escaping () -> String?) {
        self.tokenProvider = tokenProvider
    }

    public func processRequest(_ request: inout URLRequest) throws {
        guard let token = tokenProvider() else {
            throw NetworkError.other(
                NSError(
                    domain: "AuthMiddleware",
                    code: 401,
                    userInfo: [NSLocalizedDescriptionKey: "Authorization token not found."]
                )
            )
        }

        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }

    public func processResponse(_ data: Data, _ response: URLResponse) throws {
        // No-op: This middleware doesn’t process responses.
    }
}
