//
//  BaseCoordinator.swift
//  BaseKit
//
//  Created by Sinan Özman on 3.06.2025.
//

import UIKit

/// A generic base class for implementing route-driven coordinators in an MVVM-Coordinator architecture.
///
/// `BaseCoordinator` provides a foundation for coordinators that respond to high-level navigation actions (routes)
/// defined via a `Route` type. It handles navigation via an injected `UINavigationController` and delegates
/// actual routing logic to subclasses.
///
/// - Note: Subclasses must override `start()` to define their initial screen flow.
/// - Tip: Use the `handle(_:)` method to navigate based on `enum`-based route definitions.
open class BaseCoordinator<R: Route>: Coordinator {

    // MARK: - Properties

    /// The navigation controller used by this coordinator to manage view controller presentation.
    public let navigation: UINavigationController

    // MARK: - Initialization

    /// Initializes the coordinator with a navigation controller.
    ///
    /// - Parameter navigation: The UINavigationController that this coordinator will manage.
    public init(navigation: UINavigationController) {
        self.navigation = navigation
    }

    // MARK: - Template Methods

    /// Starts the coordinator flow.
    ///
    /// Subclasses **must** override this method to set up their initial screen or root flow.
    /// Calling this method without overriding will result in a runtime crash.
    open func start() {
        fatalError("Subclasses must override start()")
    }

    /// Handles a high-level navigation action defined by the `Route` enum or type.
    ///
    /// This is a hook method for subclasses to override and implement custom routing logic.
    /// The base implementation is a no-op and can safely be ignored if not used.
    ///
    /// - Parameter route: The navigation action to perform.
    open func handle(_ route: R) {
        // default no-op
    }
}
