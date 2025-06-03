//
//  HttpMethod.swift
//  BaseKit
//
//  Created by Sinan Özman on 3.06.2025.
//

import Foundation

/// An enumeration representing standard HTTP methods used in network requests.
///
/// This enum defines the type of operation to be performed by a given endpoint,
/// such as retrieving, creating, updating, or deleting resources.
///
/// Conforming to `RawRepresentable` via `String` allows easy integration
/// with `URLRequest` configuration (`request.httpMethod = method.rawValue`).
public enum HTTPMethod: String {

    /// Retrieves data from the server without modifying any resources.
    ///
    /// Typically used for read-only requests (e.g., fetching user info or a list).
    case get = "GET"

    /// Submits new data to the server to create a new resource.
    ///
    /// Commonly used for actions like registration, form submission, etc.
    case post = "POST"

    /// Replaces the entire resource with the provided data.
    ///
    /// Generally used for full updates of existing records.
    case put = "PUT"

    /// Removes a resource from the server.
    ///
    /// Used for delete operations, like removing a user or an item.
    case delete = "DELETE"

    /// Partially updates an existing resource with the provided changes.
    ///
    /// Useful when only a subset of fields need to be updated.
    case patch = "PATCH"
}
