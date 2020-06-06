//
//  SignInCoordinator.swift
//  Surprise Me Test
//
//  Created by Eugene Ilyin on 04.06.2020.
//  Copyright © 2020 Eugene Ilyin. All rights reserved.
//

import UIKit
import SKCountryPicker

class SignInCoordinator: Coordinator {
    
    // MARK: - Properties
    
    weak var parentCoordinator: MainCoordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    // MARK: - Initialization
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Coordinator methods
    
    func start() {
        self.navigationController.navigationBar.isHidden = true
        
        let viewController = SignInViewController()
        viewController.coordinator = self
        navigationController.present(viewController, animated: true)
    }
    
    // MARK: - Methods
    
    /// Show country picker.
    func chooseCountry() {
        guard let signInViewController = navigationController.presentedViewController as? SignInViewController else {
            return
        }
        let countryPickerController = CountryPickerWithSectionViewController.presentController(on: signInViewController) { [weak self] (country: Country) in
            
            guard let self = self else { return }
            
            self.didFinishChoosing(country: country)
        }
        countryPickerController.flagStyle = .circular
        countryPickerController.title = "Country Code"
        countryPickerController.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)]
    }
    
    /// Show get code screen.
    func getCode(for user: User) {
        guard let signInViewController = navigationController.presentedViewController as? SignInViewController else {
            return
        }

        let viewController = CodeViewController()
        viewController.coordinator = self
        viewController.user = user
        signInViewController.present(viewController, animated: true)
    }
    
    /// Handle successful sign in process.
    func didFinishSignIn() {
        parentCoordinator?.childDidFinish(self)
    }
    
    /// Handle successful code check process.
    func didFinishCheckingCode() {
        /// Do whatever you please at this point.
        /// As a placeholder just dismissing sign in view controller.
        guard let signInViewController = navigationController.presentedViewController as? SignInViewController else {
            return
        }
        signInViewController.dismiss(animated: true)
    }
    
    // MARK: - Private methods
    
    private func didFinishChoosing(country: Country) {
        guard let signInViewController = navigationController.presentedViewController as? SignInViewController else {
            return
        }
        signInViewController.updateViewWith(country: country)
    }
    
}
