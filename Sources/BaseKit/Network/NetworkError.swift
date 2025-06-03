//
//  NetworkError.swift
//  BaseKit
//
//  Created by Sinan Özman on 3.06.2025.
//

import Foundation

/// A comprehensive enumeration of errors that can occur during network operations.
///
/// `NetworkError` encapsulates common failure scenarios such as:
/// - Malformed URLs
/// - Failed HTTP responses
/// - JSON decoding issues
/// - Unknown or unexpected underlying errors
///
/// It conforms to both `Error` and `LocalizedError`, enabling user-friendly
/// error messages via `error.localizedDescription`.
public enum NetworkError: Error, LocalizedError {

    /// Indicates that the constructed URL was invalid.
    ///
    /// Typically caused by a malformed endpoint path or base URL.
    case invalidURL

    /// Indicates that the request completed but failed with a non-2xx status code.
    ///
    /// - Parameter statusCode: The HTTP status code returned from the server.
    case requestFailed(statusCode: Int)

    /// Indicates a failure to decode the response body into the expected model.
    ///
    /// - Parameter error: The original decoding error.
    case decodingError(Error)

    /// A fallback case for any other unexpected errors.
    ///
    /// - Parameter error: The underlying error that caused the failure.
    case other(Error)

    // MARK: - LocalizedError

    /// A user-friendly description of the error.
    ///
    /// This can be displayed directly in alerts or error views.
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The provided URL is invalid."
        case .requestFailed(let statusCode):
            return "The request failed with status code \(statusCode)."
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .other(let error):
            return "An unknown error occurred: \(error.localizedDescription)"
        }
    }
}
