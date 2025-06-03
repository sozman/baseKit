//
//  BaseViewModelProtocol.swift
//  BaseKit
//
//  Created by Sinan Özman on 3.06.2025.
//

import Foundation

/// A base protocol that defines the structure for ViewModel classes
/// within an MVVM architecture.
///
/// ViewModels conforming to this protocol are responsible for:
/// - Managing the view's state and business logic.
/// - Communicating with the View via the `output` closure.
/// - Reacting to lifecycle events such as `viewDidLoad` and `viewWillAppear`.
///
/// `Output` is a generic type that represents any state, event, or data
/// the ViewModel needs to emit to the View (e.g. via enums or structs).
public protocol BaseViewModelProtocol: AnyObject {

    /// The output closure used to notify the View of state changes or events.
    ///
    /// This should be assigned by the View layer and triggered by the ViewModel
    /// whenever something meaningful changes that the UI should react to.
    associatedtype Output
    var output: ((Output) -> Void)? { get set }

    /// Called when the ViewController’s `viewDidLoad()` is triggered.
    ///
    /// Use this method to start initial logic, such as API calls,
    /// setting up data bindings, or triggering initial output events.
    func onViewDidLoad()

    /// Called when the ViewController’s `viewWillAppear()` is triggered.
    ///
    /// Ideal for refreshing data or triggering analytics events.
    /// This method is invoked every time the view is about to appear.
    func viewWillAppear()
}
