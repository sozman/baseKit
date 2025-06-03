//
//  BaseVC.swift
//  BaseKit
//
//  Created by Sinan Özman on 3.06.2025.
//

import UIKit
import os

#if canImport(SwiftUI)
import SwiftUI
#endif

/// A generic base UIViewController class that provides common MVVM features,
/// including lifecycle hooks, UI setup, ViewModel binding, and coordinator navigation.
///
/// This class is designed to be subclassed within modular architectures.
/// It integrates with SwiftUI previewing support when available.
open class BaseVC<ViewModel: BaseViewModelProtocol & NSObject>: UIViewController, BaseViewProtocol, PreviewableVC, BaseVCProtocol {

    // MARK: - Typealiases & Properties

    /// Typealias to clarify the associated ViewModel type.
    typealias ViewModelType = ViewModel

    /// Instantiates the view controller using a storyboard or programmatic method.
    /// Assumes conforming types implement the required instantiation logic.
    open class func instantiates(bundle: Bundle? = nil) -> Self {
        Self.instantiate(bundle: bundle)
    }

    /// System logger for BaseVC using the unified logging system (os_log).
    let log = Logger(subsystem: "com.baseKit.BaseVC", category: "BaseVC")

    /// Strong reference to the ViewModel instance. Initialized by default.
    public let viewModel: ViewModel = ViewModel()

    // MARK: - Lifecycle Methods

    /// Called after the controller’s view is loaded into memory.
    /// Subclasses should override `setupUI()` and `bindViewModel()` for setup logic.
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.onViewDidLoad()
    }

    /// Notifies the view controller that its view is about to be added to a view hierarchy.
    /// Useful for refreshing UI or triggering analytics events.
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
        viewModel.viewWillAppear()
    }

    // MARK: - ViewModel Binding

    /// Called during `viewDidLoad` to bind the ViewModel outputs to the View.
    /// Override this method to setup your output listeners and UI updates.
    open func bindViewModel() {
        log.info("View Model binding")
    }

    // MARK: - UI Setup Hooks

    /// Called during `viewDidLoad` for initial UI setup.
    /// Subclasses should override to configure layout, styles, and subviews.
    open func setupUI() {}

    /// Called during `viewWillAppear` to refresh UI or data.
    /// Can be used to update dynamic views or localized content.
    open func updateUI() {}
}

#if canImport(SwiftUI) && DEBUG

/// A protocol that enables UIViewControllers to be previewed inside SwiftUI.
/// Must implement `instantiates()` for preview rendering.
protocol PreviewableVC: UIViewController {
    static func instantiates(bundle: Bundle?) -> Self
}

/// A SwiftUI wrapper that renders a UIViewController inside the canvas.
struct VCPreview<VC: PreviewableVC>: UIViewRepresentable {
    let builder: () -> VC

    func makeUIView(context: Context) -> UIView {
        let viewController = builder()
        viewController.loadViewIfNeeded()
        return viewController.view
    }

    func updateUIView(_ uiView: UIView, context: Context) { }
}

/// Default implementations for creating SwiftUI previews.
extension PreviewableVC {

    /// Previews the view controller with a configuration block.
    ///
    /// - Parameter configure: Optional configuration for customizing the instance before rendering.
    /// - Returns: A SwiftUI View preview of the controller.
    static func preview(configure: @escaping (Self) -> Void) -> some View {
        VCPreview {
            let viewController = Self.instantiate()
            viewController.loadViewIfNeeded()
            configure(viewController)
            return viewController
        }
    }

    /// Basic preview with default configuration.
    ///
    /// - Returns: A SwiftUI View preview of the controller.
    static func preview() -> some View {
        preview { _ in }
    }
}

#endif
