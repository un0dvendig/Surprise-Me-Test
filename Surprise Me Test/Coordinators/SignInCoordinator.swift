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
    
    // MARK: - Private properties
    
    private var isChangingLayout: Bool = false
    
    /// Should be obtained properly
    private let user = User(id: 1, name: "Anitta", phone: nil, email: nil)
    private let tour = Tour(id: 11, name: "Fast-Track and Audio Tour")
    private let showPlace = Showplace(id: 111, name: "Sagrada Familia", imageURLString: nil)
    
    // MARK: - Initialization
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Coordinator methods
    
    func start() {
        self.navigationController.navigationBar.isHidden = true
        
        /// Setting default view controller (could be the email one)
        let viewController = createViewController(for: .phoneNumber)
        navigationController.present(viewController, animated: true)
    }
    
    // MARK: - Methods
    
    /// Change layout if the sign in screen to SignInLayout variation.
    func changeLayout(to layout: SignInLayout) {
        guard let window = UIApplication.shared.windows.first else {
            return
        }
        self.isChangingLayout = true
        var somePresentedViewController: UIViewController?
        var someViewController: UIViewController?
        var animationOption: UIView.AnimationOptions = .transitionCrossDissolve
        
        switch layout {
        case .phoneNumber:
            someViewController = createViewController(for: .phoneNumber)
            animationOption = .transitionFlipFromRight
            somePresentedViewController = navigationController.presentedViewController as? SignInWithEmailViewController
            
        case .email:
            someViewController = createViewController(for: .email)
            animationOption = .transitionFlipFromLeft
            somePresentedViewController = navigationController.presentedViewController as? SignInWithPhoneNumberViewController
        }
        
        guard let presentedViewController = somePresentedViewController,
            let viewController = someViewController else {
            return
        }
        
        UIView.transition(with: window,
                          duration: 0.5,
                          options: animationOption,
                          animations: {
                            presentedViewController.dismiss(animated: false)
                            self.navigationController.present(viewController, animated: false)
                          },
                          completion: { (_) in
                            self.isChangingLayout = false
        })
    }
    
    /// Handle successful sign in process.
    func didFinishSignIn() {
        guard !isChangingLayout else {
            return
        }
        parentCoordinator?.childDidFinish(self)
    }
    
    // MARK: - Email layout methods
    
    /// Show get link screen or just handle email link sending here or do anything else....
    /// Probably can show code screen again if the code should be sent to email.
    func getLink(for user: User) {
//        guard let signInViewController = navigationController.presentedViewController as? SignInWithEmailViewController else {
//            return
//        }
        /// Uncomment code and proceed here...
    }
    
    /// Show screen with another sign in options
    func showAnotherSignInOptions() {
        guard let signInViewController = navigationController.presentedViewController as? SignInWithEmailViewController else {
            return
        }
        
        let viewController = AnotherSignInOptionsViewController()
        viewController.coordinator = self
        if #available(iOS 13.0, *) {
        } else {
            /// Removes black background
            viewController.modalPresentationStyle = .overCurrentContext
        }
        signInViewController.present(viewController, animated: true)
    }
    
    /// Handle picking sign in method
    func didPickSomeSignInMethod() {
        /// Proceed...
    }
    
    // MARK: - Phone number layout methods
    
    /// Show country picker.
    func chooseCountry() {
        guard let signInViewController = navigationController.presentedViewController as? SignInWithPhoneNumberViewController else {
            return
        }
        let countryPickerController = CountryPickerWithSectionViewController.presentController(on: signInViewController) { [weak self] (country: Country) in
            
            guard let self = self else { return }
            
            self.didFinishChoosing(country: country)
        }
        CountryManager.shared.addFilter(.countryDialCode)
        countryPickerController.flagStyle = .circular
        countryPickerController.title = "Country Code"
        countryPickerController.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)]
    }
    
    /// Show get code screen.
    func getCode(for user: User) {
        guard let signInViewController = navigationController.presentedViewController as? SignInWithPhoneNumberViewController else {
            return
        }

        let viewController = CodeViewController()
        viewController.coordinator = self
        viewController.user = user
        signInViewController.present(viewController, animated: true)
    }
    
    /// Handle successful code check process.
    func didFinishCheckingCode() {
        /// Do whatever you please at this point.
        /// As a placeholder just dismissing sign in view controller.
        guard let signInViewController = navigationController.presentedViewController as? SignInWithPhoneNumberViewController else {
            return
        }
        signInViewController.dismiss(animated: true)
    }
    
    // MARK: - Private methods
    
    private func createViewController(for layout: SignInLayout) -> UIViewController {
        switch layout {
        case .phoneNumber:
            let viewController = SignInWithPhoneNumberViewController()
            /// Setting "obtained" info
            viewController.currentUser = user
            viewController.currentTour = tour
            viewController.currentShowplace = showPlace
            
            viewController.coordinator = self
            if #available(iOS 13.0, *) {
            } else {
                /// Removes black background
                viewController.modalPresentationStyle = .overCurrentContext
            }
            return viewController
        case .email:
            let viewController = SignInWithEmailViewController()
            /// Setting "obtained" info
            viewController.currentUser = user
            viewController.currentTour = tour
            viewController.currentShowplace = showPlace
            
            viewController.coordinator = self
            if #available(iOS 13.0, *) {
            } else {
                /// Removes black background
                viewController.modalPresentationStyle = .overCurrentContext
            }
            return viewController
        }
    }
    
    private func didFinishChoosing(country: Country) {
        guard let signInViewController = navigationController.presentedViewController as? SignInWithPhoneNumberViewController else {
            return
        }
        signInViewController.updateViewWith(country: country)
    }
    
}
