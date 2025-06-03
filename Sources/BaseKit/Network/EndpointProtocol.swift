//
//  EndpointProtocol.swift
//  BaseKit
//
//  Created by Sinan Özman on 3.06.2025.
//

import Foundation

/// A protocol that defines the structure of an API endpoint.
///
/// Conforming types provide all the necessary information to construct a `URLRequest`,
/// including the path, HTTP method, and optional headers.
///
/// This abstraction promotes a clean separation between endpoint configuration
/// and request execution, making the networking layer more modular and testable.
public protocol EndpointProtocol {

    /// The relative path for the endpoint (e.g., "/users/profile").
    ///
    /// This path is typically appended to a base URL to form the full request URL.
    var path: String { get }

    /// The HTTP method used for the request (e.g., GET, POST, PUT).
    ///
    /// This determines the type of action the endpoint performs.
    var method: HTTPMethod { get }

    /// Optional headers to be added to the request.
    ///
    /// Use this to pass custom headers like `Authorization`, `Content-Type`, etc.
    var headers: [String: String]? { get }
}
