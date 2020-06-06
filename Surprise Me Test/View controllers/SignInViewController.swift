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
    
    private var viewReference: SignInView?
    private var viewModel: SignInViewModel?
    
    // MARK: - View life cycle
    
    override func loadView() {
        super.loadView()
        let view = SignInView()
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
        let tour = Tour(id: 11, name: "Fast-Track and Audio Tour")
        let showPlace = Showplace(id: 111, name: "Sagrada Familia", imageURLString: nil)
        
        let viewModel = SignInViewModel(user: user, tour: tour, showPlace: showPlace)
        self.viewModel = viewModel
    }
    
    private func setupView() {
        /// Potentially could be place for bindings.
        if let view = viewReference,
            let viewModel = viewModel {
            view.configure(with: viewModel)
            
            view.signInCountryButton.addTarget(self, action: #selector(chooseCounty), for: .touchUpInside)
            
            view.signInConfirmButton.addTarget(self, action: #selector(confirmAndGetCode), for: .touchUpInside)
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
        
        // TODO: Handle error
        guard let countryCode = view.signInCountryCodeLabel.text,
            let phoneNumber = view.signInUserPhoneNumberTextField.text,
            !phoneNumber.isEmpty else {
                print("Phone number is not valid!")
                return
        }
        let clearPhoneNumber = phoneNumber.filter("0123456789".contains)
        let fullPhoneNumber = countryCode+clearPhoneNumber
        
        coordinator?.getCode(for: fullPhoneNumber)
    }

}
