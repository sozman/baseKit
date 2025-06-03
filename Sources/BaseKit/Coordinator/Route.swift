//
//  Route.swift
//  BaseKit
//
//  Created by Sinan Özman on 3.06.2025.
//

import Foundation

/// A marker protocol that represents a navigation route or intent.
///
/// `Route` types are typically enums that define high-level navigation
/// actions within a feature or flow. These actions are then interpreted
/// by a `Coordinator` to present the appropriate view controller.
///
/// This protocol itself has no requirements, allowing maximum flexibility
/// while enforcing a common type for coordinator-based navigation.
///
/// ### Example
/// ```swift
/// enum SettingsRoute: Route {
///     case profile
///     case security
///     case about
/// }
/// ```
///
/// The coordinator can then switch over this enum to decide which screen to present.
public protocol Route { }


