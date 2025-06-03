//
//  PresentationStyle.swift
//  BaseKit
//
//  Created by Sinan Özman on 3.06.2025.
//

import Foundation

/// An enumeration that defines various ways to present a view controller
/// within a navigation flow.
///
/// This enum is commonly used by Coordinators to abstract away UIKit-specific
/// presentation logic, allowing a unified interface for routing decisions.
public enum PresentationStyle {

    /// Pushes the view controller onto the navigation stack.
    ///
    /// Requires an existing `UINavigationController` and is commonly used
    /// for drill-down navigation.
    case push

    /// Presents the view controller modally using the default presentation style.
    ///
    /// Suitable for presenting dialogs or modals over the current screen.
    case present

    /// Replaces the entire navigation stack with the given view controller as root.
    ///
    /// Commonly used for resetting the flow, such as after login or onboarding.
    case setAsRoot

    /// Presents the view controller modally in full screen mode.
    ///
    /// Ensures that the presented view covers the entire screen regardless of environment.
    case modalFullScreen
}
