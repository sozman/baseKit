//
//  UIViewController+Extension.swift
//  BaseKit
//
//  Created by Sinan Özman on 3.06.2025.
//

import UIKit
import os

/// Private logger for debugging instantiation issues.
private let log = Logger(subsystem: "com.baseKit.viewController", category: "extension")

public extension UIViewController {
    
    /// Instantiates a view controller from a storyboard that shares the same name as its class.
    ///
    /// This method expects:
    /// - The storyboard file (.storyboard) to have the **same name** as the view controller class.
    /// - The view controller within the storyboard to have the **same storyboard ID** as its class name.
    ///
    /// If these conditions are not met, a runtime crash (`fatalError`) will occur with a helpful log message.
    ///
    /// - Returns: An instance of the view controller.
    static func instantiate(bundle: Bundle? = nil) -> Self {
        
        /// Inner helper function to handle the generic instantiation.
        func instantiateFromStoryboard<T: UIViewController>() -> T {
            let name = String(describing: self) // e.g., "HomeViewController"
            let identifier = name // storyboard ID must match class name
            
            let storyboard = UIStoryboard(name: name, bundle: bundle)
            
            guard let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
                let message: String = "❌ ViewController with ID: \(identifier) not found in storyboard \(name)"
                log.error("\(message)")
                fatalError(message)
            }
            
            return viewController
        }

        return instantiateFromStoryboard()
    }
}
