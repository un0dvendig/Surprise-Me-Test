//
//  LoginViewController.swift
//  Surprise Me Test
//
//  Created by Eugene Ilyin on 04.06.2020.
//  Copyright © 2020 Eugene Ilyin. All rights reserved.
//

import UIKit
import SKCountryPicker

class SignInViewController: UIViewController {

    // MARK: - Properties
    
    var coordinator: SignInCoordinator?
    
    // MARK: - Private properties
    
    private var alerHandler: AlertHandler?
    private var currentUser: User? // Potentially, should be obtained from some in-app storage.
    private var viewReference: SignInView?
    private var viewModel: SignInViewModel?
    
    // MARK: - View life cycle
    
    override func loadView() {
        super.loadView()
        
        let alertHandler = AlertHandler(delegate: self)
        self.alerHandler = alertHandler
        
        let view = SignInView()
        view.alertHandler = alertHandler
        self.viewReference = view
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupViewModel()
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
        let user = User(id: 1, name: "Anitta", phone: nil, email: nil)
        self.currentUser = user
        let tour = Tour(id: 11, name: "Fast-Track and Audio Tour")
        let showPlace = Showplace(id: 111, name: "Sagrada Familia", imageURLString: nil)
        
        let viewModel = SignInViewModel(user: user, tour: tour, showPlace: showPlace)
        self.viewModel = viewModel
    }
    
    private func setupView() {
        /// Potentially could be place for bindings.
        if let view = viewReference,
            let viewModel = viewModel {
            view.signInCountryButton.addTarget(self, action: #selector(chooseCounty), for: .touchUpInside)
            
            view.signInConfirmButton.addTarget(self, action: #selector(confirmAndGetCode), for: .touchUpInside)
            
            view.configure(with: viewModel)
        }
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
                view.signInUserPhoneNumberTextField.resignFirstResponder()
                alerHandler?.showAlertDialog(title: "Phone number is empty", message: "Please fill in the phone number")
                return
        }
        let clearPhoneNumber = phoneNumber.filter("0123456789".contains)
        guard clearPhoneNumber.count == 10 else {
            view.signInUserPhoneNumberTextField.resignFirstResponder()
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

}
