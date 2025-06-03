//
//  BaseVCProtocol.swift
//  BaseKit
//
//  Created by Sinan Özman on 3.06.2025.
//

import UIKit

/// A protocol that defines the base requirements for all view controllers
/// in a modular MVVM-Coordinator architecture.
///
/// Conforming view controllers should:
/// - Provide a static `instantiates()` method for consistent creation (e.g., from storyboard or programmatically).
/// - Expose an optional `coordinator` reference for navigation and flow management.
///
/// This protocol enables consistent instantiation and navigation behavior across all feature modules.
public protocol BaseVCProtocol: UIViewController {
    
    /// Instantiates and returns a new instance of the view controller.
    ///
    /// Can be implemented to support instantiation via storyboard, nib, or programmatically.
    /// Should be used instead of direct `init()` or storyboard identifiers for better type safety.
    ///
    /// - Returns: A fully initialized view controller instance.
    static func instantiates(bundle: Bundle?) -> Self

    /// An optional reference to a Coordinator responsible for navigation and presentation logic.
    ///
    /// Allows external flow control without tightly coupling the view controller to navigation logic.
    var coordinator: (any Coordinator)? { get set }
}
