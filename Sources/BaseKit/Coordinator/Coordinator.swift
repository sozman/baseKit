//
//  Coordinator.swift
//  BaseKit
//
//  Created by Sinan Özman on 3.06.2025.
//

import UIKit

/// A protocol that defines the contract for coordinators using route-based navigation.
///
/// Coordinators conforming to this protocol are responsible for:
/// - Managing view controller presentation via `UINavigationController`
/// - Starting the initial flow (`start()`)
/// - Responding to route-based navigation instructions (`handle(_:)`)
///
/// This protocol enforces a consistent interface for modular coordinators,
/// making it easier to scale navigation logic across multiple feature modules.
public protocol Coordinator: AnyObject {

    /// The type of route the coordinator is expected to handle.
    ///
    /// Routes are typically defined as enums and represent abstract navigation actions
    /// (e.g. `.goToSettings`, `.showProfile(userID: String)`).
    associatedtype R: Route
    
    /// A closure that is triggered when the current flow or screen is completed.
    ///
    /// Typically used in coordination patterns to notify the parent coordinator
    /// that the child flow can be dismissed or deallocated.
    ///
    /// You should call `onFinish?()` when the view controller or coordinator
    /// has finished its task (e.g., after login, onboarding, or form submission).
    var onFinish: (() -> Void)? { get set }

    /// The navigation controller used to manage view controller presentation.
    ///
    /// This provides the foundation for pushing, presenting, and dismissing view controllers.
    var navigation: UINavigationController { get }

    /// Starts the coordinator’s navigation flow.
    ///
    /// Typically called immediately after initialization, this method should launch
    /// the first screen in the flow (e.g. login screen, onboarding, dashboard).
    func start()

    /// Handles a navigation route defined by the associated `Route` type.
    ///
    /// This function allows decoupled navigation by interpreting abstract route instructions
    /// and translating them into concrete screen transitions.
    ///
    /// - Parameter route: The route to be handled by the coordinator.
    func handle(_ route: R)
}
