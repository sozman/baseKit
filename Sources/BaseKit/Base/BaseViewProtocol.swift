//
//  BaseViewProtocol.swift
//  BaseKit
//
//  Created by Sinan Özman on 3.06.2025.
//

import Foundation

/// A base protocol that defines the contract for Views (usually ViewControllers)
/// to bind and interact with their associated ViewModel in an MVVM architecture.
///
/// Conforming Views are expected to:
/// - Define their specific `ViewModelType`
/// - Expose the ViewModel instance
/// - Implement the binding logic in `bindViewModel()`
///
/// This protocol promotes consistency in how Views observe and respond to
/// ViewModel output, especially in reusable or modular codebases.
protocol BaseViewProtocol: AnyObject {

    /// The associated ViewModel type for the view.
    ///
    /// Must conform to `BaseViewModelProtocol` and inherit from `NSObject`
    /// (typically for compatibility with UIKit lifecycle or KVO if needed).
    associatedtype ViewModelType: BaseViewModelProtocol & NSObject

    /// The ViewModel instance owned by the View.
    ///
    /// Provides business logic and state, which the View observes and reacts to.
    var viewModel: ViewModelType { get }

    /// A method where the View should subscribe to the ViewModel's outputs
    /// and perform any state or UI bindings.
    ///
    /// This is typically called in `viewDidLoad()` or similar lifecycle events.
    func bindViewModel()
}
