//
//  SignInWithEmailViewController.swift
//  Surprise Me Test
//
//  Created by Eugene Ilyin on 08.06.2020.
//  Copyright © 2020 Eugene Ilyin. All rights reserved.
//

import UIKit
import SKCountryPicker

class SignInWithEmailViewController: UIViewController {

    // MARK: - Properties
    
    var coordinator: SignInCoordinator?
    
    /// Potentially, should be obtained from some in-app storage.
    var currentUser: User?
    var currentTour: Tour?
    var currentShowplace: Showplace?
    
    // MARK: - Private properties
    
    private var viewTranslation = CGPoint(x: 0, y: 0) /// Property for iOS < 13.0
    
    private var alerHandler: AlertHandler?
    private var viewReference: SignInWithEmailView?
    private var viewModel: SignInWithEmailViewModel?
    
    // MARK: - View life cycle
    
    override func loadView() {
        super.loadView()

        let alertHandler = AlertHandler(delegate: self)
        self.alerHandler = alertHandler
        
        let view = SignInWithEmailView()
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
    
    // MARK: - Private methods
    
    private func setupViewModel() {
        guard let user = currentUser,
            let tour = currentTour,
            let showplace = currentShowplace else {
            fatalError("User, tour and showplace should be obtained at this point. Either from outside of inside the class")
        }
        let viewModel = SignInWithEmailViewModel(user: user, tour: tour, showPlace: showplace)
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
        
        view.signInConfirmButton.addTarget(self, action: #selector(confirmAndGetLink), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleUseAnotherWay(_:)))
        view.signInAnotherWayLabel.addGestureRecognizer(tap)
        
        view.configure(with: viewModel)
    }
        
    @objc
    private func confirmAndGetLink() {
        guard let view = viewReference else {
            return
        }
        
        guard let email = view.signInUserEmailTextField.text,
            !email.isEmpty else {
                view.endEditing(true)
                alerHandler?.showAlertDialog(title: "Email is empty", message: "Please fill in the email")
                return
        }
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        
        guard emailPredicate.evaluate(with: email) else {
            view.endEditing(true)
            alerHandler?.showAlertDialog(title: "Email is not valid", message: "Please fill in proper email")
            return
        }
        
        guard var user = self.currentUser else {
            fatalError("There is no current user!")
        }
        /// Potentially, place to save info about the user.
        user.email = email
        self.currentUser = user
        
        view.endEditing(true)
        coordinator?.getLink(for: user)
    }
    
    @objc
    private func handleUseAnotherWay(_ tap: UITapGestureRecognizer) {
        guard let view = viewReference else {
             return
        }
        
        guard let text = view.signInAnotherWayLabel.text else {
                return
        }
        let asAnotherPersonText = "use another way"
        let anotherPersonTextRange = (text as NSString).range(of: asAnotherPersonText)
        if tap.didTapAttributedTextInLabel(label: view.signInAnotherWayLabel, inRange: anotherPersonTextRange) {
            coordinator?.showAnotherSignInOptions()
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
