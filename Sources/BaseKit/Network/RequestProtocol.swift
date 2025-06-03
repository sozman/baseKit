//
//  RequestProtocol.swift
//  BaseKit
//
//  Created by Sinan Özman on 3.06.2025.
//

import Foundation

/// A protocol that defines the structure of a network request used by `NetworkClient`.
///
/// `RequestProtocol` enforces type safety by associating specific `Body` and `Response` types
/// with each request, enabling compile-time validation and automatic JSON encoding/decoding.
///
/// Conforming types describe:
/// - The endpoint configuration (URL path, method, headers)
/// - The request body (if any)
/// - The expected response type
///
/// This protocol is the core abstraction for making clean and composable API calls.
public protocol RequestProtocol {

    /// The type of the request body.
    ///
    /// Must conform to `Encodable`. Use `Never` or `EmptyBody` for requests with no body.
    associatedtype Body: Encodable

    /// The type of the expected decoded response.
    ///
    /// Must conform to `Decodable`. This is the final model returned on success.
    associatedtype Response: Decodable

    /// Defines the endpoint being targeted, including path, method, and headers.
    var endpoint: EndpointProtocol { get }

    /// The body payload to be encoded and attached to the request.
    ///
    /// Return `nil` if the request has no body (e.g., `GET`, `DELETE`).
    var body: Body? { get }
}
