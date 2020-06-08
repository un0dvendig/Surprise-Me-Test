//
//  SignInWithPhoneNumberViewController.swift
//  Surprise Me Test
//
//  Created by Eugene Ilyin on 04.06.2020.
//  Copyright © 2020 Eugene Ilyin. All rights reserved.
//

import UIKit
import SKCountryPicker

class SignInWithPhoneNumberViewController: UIViewController {

    // MARK: - Properties
    
    var coordinator: SignInCoordinator?
    
    /// Potentially, should be obtained from some in-app storage.
    var currentUser: User?
    var currentTour: Tour?
    var currentShowplace: Showplace?
    
    // MARK: - Private properties
    
    private var viewTranslation = CGPoint(x: 0, y: 0) /// Property for iOS < 13.0
    
    private var alerHandler: AlertHandler?
    private var viewReference: SignInWithPhoneNumberView?
    private var viewModel: SignInWithPhoneNumberViewModel?
    
    // MARK: - View life cycle
    
    override func loadView() {
        super.loadView()

        let alertHandler = AlertHandler(delegate: self)
        self.alerHandler = alertHandler
        
        let view = SignInWithPhoneNumberView()
        view.alertHandler = alertHandler
        self.viewReference = view
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        
        if #available(iOS 13.0, *) {
        } else {
            setupPanGesture()
        }
        setupView()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator?.didFinishSignIn()
    }
    
    // MARK: - Methods
    
    func updateViewWith(country: Country) {
        guard let view = viewReference else {
            return
        }
        view.configure(with: country)
    }
    
    // MARK: - Private methods
    
    private func setupViewModel() {
        guard let user = currentUser,
            let tour = currentTour,
            let showplace = currentShowplace else {
            fatalError("User, tour and showplace should be obtained at this point. Either from outside of inside the class")
        }
        let viewModel = SignInWithPhoneNumberViewModel(user: user, tour: tour, showPlace: showplace)
        self.viewModel = viewModel
    }
    
    private func setupView() {
        guard let viewModel = viewModel else {
            return
        }
        
        /// Potentially could be place for bindings.
        guard let view = viewReference else {
            fatalError("Current view is not view with phone number, but should be one")
        }
        view.signInCountryButton.addTarget(self, action: #selector(chooseCounty), for: .touchUpInside)
        
        view.signInConfirmButton.addTarget(self, action: #selector(confirmAndGetCode), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleAsAnotherUser(_:)))
        view.signInNotYouLabel.addGestureRecognizer(tap)
        
        view.configure(with: viewModel)
    }
    
    @objc
    private func chooseCounty() {
        coordinator?.chooseCountry()
    }
    
    @objc
    private func confirmAndGetCode() {
        guard let view = viewReference else {
            return
        }
        
        guard let countryCode = view.signInCountryCodeLabel.text,
            let phoneNumber = view.signInUserPhoneNumberTextField.text,
            !phoneNumber.isEmpty else {
                view.endEditing(true)
                alerHandler?.showAlertDialog(title: "Phone number is empty", message: "Please fill in the phone number")
                return
        }
        let clearPhoneNumber = phoneNumber.filter("0123456789".contains)
        guard clearPhoneNumber.count == 10 else {
            view.endEditing(true)
            alerHandler?.showAlertDialog(title: "Phone number is not complete", message: "Please fill in the phone number")
            return
        }
        
        
        guard var user = self.currentUser else {
            fatalError("There is no current user!")
        }
        /// Potentially, place to save info about the user.
        user.phone = PhoneNumber(countryCode: countryCode, phoneNumber: clearPhoneNumber)
        self.currentUser = user
        
        coordinator?.getCode(for: user)
    }
    
    @objc
    private func handleAsAnotherUser(_ tap: UITapGestureRecognizer) {
        guard let view = viewReference else {
             return
        }
        
        guard let text = view.signInNotYouLabel.text else {
                return
        }
        let asAnotherPersonText = "Sign in as another person"
        let anotherPersonTextRange = (text as NSString).range(of: asAnotherPersonText)
        if tap.didTapAttributedTextInLabel(label: view.signInNotYouLabel, inRange: anotherPersonTextRange) {
            coordinator?.changeLayout(to: .email)
        }
    }
    
    /// Mimics drag to dismiss
    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.view.addGestureRecognizer(panGesture)
    }
    
    @objc
    private func handlePan(_ pan: UIPanGestureRecognizer) {
        guard pan.translation(in: self.view).y > 0 else {
            return
        }
        switch pan.state {
        case .changed:
            viewTranslation = pan.translation(in: self.view)
            self.view.frame.origin.y = viewTranslation.y
        case .ended:
            if viewTranslation.y < 200 {
                self.view.frame.origin.y = 0
            } else {
                dismiss(animated: true)
            }
        default:
            break
            
        }
    }

}
