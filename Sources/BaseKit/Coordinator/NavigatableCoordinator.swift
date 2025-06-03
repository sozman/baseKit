//
//  NavigatableCoordinator.swift
//  BaseKit
//
//  Created by Sinan Özman on 3.06.2025.
//

import UIKit

/// An extended coordinator protocol that adds navigation capabilities on top of the base `Coordinator`.
///
/// `NavigatableCoordinator` provides a standardized way to:
/// - Present or push view controllers using a specified presentation style.
/// - Navigate using generic view controller types conforming to `BaseVCProtocol`.
/// - Dismiss currently presented view controllers.
///
/// This protocol is typically implemented by classes like `BaseCoordinator`.
public protocol NavigatableCoordinator: Coordinator {

    /// Instantiates and displays a view controller of the specified type
    /// using the provided presentation style.
    ///
    /// - Parameters:
    ///   - type: A view controller type conforming to `BaseVCProtocol`.
    ///   - style: The desired presentation style (e.g., push, present).
    ///   - animated: Whether the transition should be animated.
    func show<VC: BaseVCProtocol>(_ type: VC.Type, style: PresentationStyle, animated: Bool)

    /// Displays the given view controller instance using the specified style.
    ///
    /// - Parameters:
    ///   - viewController: The instance to be displayed.
    ///   - style: Presentation style (e.g., push, modal, fullScreen).
    ///   - animated: Whether the transition should be animated.
    func show(_ viewController: UIViewController, style: PresentationStyle, animated: Bool)

    /// Dismisses the topmost presented view controller, if any.
    ///
    /// - Parameter animated: Whether the dismissal should be animated.
    func dismiss(animated: Bool)
}
