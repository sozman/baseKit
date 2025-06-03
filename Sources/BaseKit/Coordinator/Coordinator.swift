//
//  Coordinator.swift
//  BaseKit
//
//  Created by Sinan Özman on 3.06.2025.
//

import UIKit

/// A base protocol that defines the core responsibilities of a Coordinator
/// in the Coordinator design pattern.
///
/// Coordinators are responsible for:
/// - Managing navigation flow
/// - Creating and displaying view controllers
/// - Decoupling view controllers from navigation logic
///
/// All Coordinators should hold a reference to a `UINavigationController`
/// and implement the `start()` method to initiate their navigation flow.
public protocol Coordinator: AnyObject {

    /// The navigation controller used to present or push view controllers.
    ///
    /// It is the central component through which the Coordinator performs routing.
    var navigationController: UINavigationController? { get set }

    /// Starts the navigation flow for the coordinator.
    ///
    /// This method should be overridden by conforming types to launch
    /// the initial screen or view controller for their feature or flow.
    func start()
}
