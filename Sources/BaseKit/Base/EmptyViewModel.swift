//
//  EmptyViewModel.swift
//  BaseKit
//
//  Created by Sinan Özman on 3.06.2025.
//

import UIKit

/// A default, no-op output type used when no meaningful output is expected from a ViewModel.
///
/// Can be used with generic MVVM classes where the ViewModel is required,
/// but you don’t actually need to emit any state or event.
///
/// It conforms to `Equatable` so it can be used in comparisons if necessary.
public enum EmptyOutput: Equatable {
    /// The only case, representing an empty or no-op state.
    case empty
}

/// A default no-op ViewModel implementation that conforms to `MVVM<EmptyOutput>`.
///
/// This is useful when you need to pass a ViewModel to a generic `BaseVC` or
/// any view infrastructure, but the screen or feature does not require any
/// actual logic or output emission.
///
/// Example use cases:
/// - Placeholder screens
/// - Static pages (e.g., Terms & Conditions, About screen)
/// - Test or Preview setups
public final class EmptyViewModel: MVVM<EmptyOutput> {

    /// Initializes the empty ViewModel with default settings.
    ///
    /// Override if you want to customize the client, middlewares, or base URL.
    override init() {
        super.init()
    }
}
