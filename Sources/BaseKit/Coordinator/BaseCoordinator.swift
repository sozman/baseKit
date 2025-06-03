//
//  BaseCoordinator.swift
//  BaseKit
//
//  Created by Sinan Özman on 3.06.2025.
//

import UIKit

/// A base class for implementing the Coordinator pattern in iOS applications.
///
/// `BaseCoordinator` is responsible for handling navigation flow using a
/// `UINavigationController`, separating routing logic from view controllers.
///
/// Subclasses should override the `start()` method to begin the navigation flow.
///
/// This base implementation also conforms to `NavigatableCoordinator`,
/// allowing standardized presentation styles across the app.
class BaseCoordinator: NavigatableCoordinator {

    // MARK: - Properties

    /// The navigation controller used to present or push view controllers.
    var navigationController: UINavigationController?

    // MARK: - Initialization

    /// Initializes the coordinator with a navigation controller.
    ///
    /// - Parameter navigationController: The navigation controller to be used for routing.
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    // MARK: - Lifecycle

    /// Starts the coordinator flow. Should be overridden in subclasses.
    ///
    /// Example:
    /// ```swift
    /// func start() {
    ///     show(HomeViewController.self, style: .setAsRoot, animated: false)
    /// }
    /// ```
    func start() {
        // override this in subclasses
    }

    // MARK: - Navigation (Generic VC Type)

    /// Shows a view controller of a given type conforming to `BaseVCProtocol`.
    ///
    /// The view controller is instantiated and displayed using the provided style.
    ///
    /// - Parameters:
    ///   - type: The type of the view controller to instantiate and show.
    ///   - style: The desired presentation style (e.g. push, present).
    ///   - animated: Whether the transition should be animated.
    func show<VC: BaseVCProtocol>(_ type: VC.Type, style: PresentationStyle, animated: Bool) {
        let viewController = type.instantiates()
        show(viewController, style: style, animated: animated)
    }

    // MARK: - Navigation (Direct VC Instance)

    /// Presents or pushes the provided view controller using the specified style.
    ///
    /// - Parameters:
    ///   - viewController: The view controller instance to display.
    ///   - style: The presentation style (e.g. push, modal).
    ///   - animated: Whether the transition should be animated.
    func show(_ viewController: UIViewController, style: PresentationStyle, animated: Bool) {
        switch style {
        case .push:
            navigationController?.pushViewController(viewController, animated: animated)
        case .present:
            navigationController?.present(viewController, animated: animated)
        case .setAsRoot:
            navigationController?.setViewControllers([viewController], animated: animated)
        case .modalFullScreen:
            viewController.modalPresentationStyle = .fullScreen
            navigationController?.present(viewController, animated: animated)
        }
    }

    // MARK: - Dismissal

    /// Dismisses the topmost presented view controller, if any.
    ///
    /// - Parameter animated: Whether the dismissal should be animated.
    func dismiss(animated: Bool) {
        navigationController?.dismiss(animated: animated)
    }
}
