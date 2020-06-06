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
    }
    
    /// Show get code screen.
    func getCode(for number: String) {
        guard let signInViewController = navigationController.presentedViewController as? SignInViewController else {
            return
        }
//        let 
    }
    
    /// Handle successful sign in process.
    func didFinishSignIn() {
        parentCoordinator?.childDidFinish(self)
    }
    
    // MARK: - Private methods
    
    private func didFinishChoosing(country: Country) {
        guard let signInViewController = navigationController.presentedViewController as? SignInViewController else {
            return
        }
        signInViewController.updateViewWith(country: country)
    }
    
}
