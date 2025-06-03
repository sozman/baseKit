//
//  BaseMVVM.swift
//  BaseKit
//
//  Created by Sinan Özman on 3.06.2025.
//

import Foundation

/// A generic base class for implementing the ViewModel in the MVVM architecture.
///
/// `MVVM` is intended to be subclassed in feature-specific modules. It provides
/// basic lifecycle hooks, a configurable network client, and a generic output handler
/// to communicate with the View layer.
///
/// - Parameters:
///   - Output: The output type used to notify the View of state changes or events.
open class MVVM<Output>: NSObject, BaseViewModelProtocol {

    // MARK: - Private Properties

    /// Cached instance of the network client, lazily instantiated.
    private var _client: NetworkClient?

    /// Internal output callback storage. Wrapped in a thread-safe public setter.
    private var _output: ((Output) -> Void)?

    // MARK: - Public Properties

    /// Callback for sending outputs (e.g., UI updates, states, navigation signals).
    /// Automatically ensures execution on the main thread.
    public var output: ((Output) -> Void)? {
        get { _output }
        set {
            _output = { outputValue in
                if Thread.isMainThread {
                    newValue?(outputValue)
                } else {
                    DispatchQueue.main.async {
                        newValue?(outputValue)
                    }
                }
            }
        }
    }

    /// The network client used for API requests.
    /// Lazily initialized using `createClient()`.
    public var client: NetworkClient {
        if let existing = _client {
            return existing
        } else {
            let created = createClient()
            _client = created
            return created
        }
    }

    // MARK: - Lifecycle Methods

    /// Called when the View is loaded. Subclasses should override to trigger initial logic.
    open func onViewDidLoad() {
        // To be overridden by subclass
    }

    /// Called when the View is about to appear. Use for pre-display preparation.
    open func viewWillAppear() {
        // To be overridden by subclass
    }

    // MARK: - Configuration Methods

    /// Provides the base URL for networking.
    /// Subclasses must override to specify endpoint.
    ///
    /// - Returns: A valid `URL` object used as the base URL for the client.
    open func baseURL() -> URL {
        return URL(string: "")! // Must be overridden by subclass with a real endpoint
    }

    /// Provides an array of middleware used in the network client.
    /// Default implementation includes logging.
    ///
    /// - Returns: An array of `Middleware` instances to be applied to the client.
    open func middlewares() -> [Middleware] {
        return [LoggingMiddleware()]
    }

    // MARK: - Internal Utilities

    /// Creates and returns a new instance of the network client configured
    /// with the `baseURL()` and `middlewares()` defined above.
    ///
    /// - Returns: A fully initialized `NetworkClient`.
    public func createClient() -> NetworkClient {
        return NetworkClient(baseURL: baseURL(), middlewares: middlewares())
    }
}
