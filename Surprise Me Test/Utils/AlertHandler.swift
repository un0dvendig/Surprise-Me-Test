//
//  AlertHandler.swift
//  Surprise Me Test
//
//  Created by Eugene Ilyin on 06.06.2020.
//  Copyright © 2020 Eugene Ilyin. All rights reserved.
//

import UIKit

/// Class that "handles" errors by showing alert controller with error message.
/// **NOTE:** Ideally this class should not exist in this implementation, since we are blocking UI.
/// Interfering user actions is bad and Apple is against such methods.
/// This class exists for the sake of saving time.
class AlertHandler {
    
    // MARK: - Properties
    
    private weak var delegate: UIViewController?
    
    // MARK: - Initialization
    
    init(delegate: UIViewController?) {
        self.delegate = delegate
    }
    
    // MARK: - Methods
    
    /// Shows UIAlertController with .alert style, using given title and message.
    func showAlertDialog(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(alertAction)
        
        delegate?.present(alertController, animated: true, completion: nil)
    }
    
}
