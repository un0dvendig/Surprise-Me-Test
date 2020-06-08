//
//  AnotherSignInOptionsViewController.swift
//  Surprise Me Test
//
//  Created by Eugene Ilyin on 08.06.2020.
//  Copyright © 2020 Eugene Ilyin. All rights reserved.
//

import UIKit

class AnotherSignInOptionsViewController: UIViewController {

    // MARK: - Properties
    
    var coordinator: SignInCoordinator?
    
    // MARK: - Private properties
    
    private var defaultFrameOriginY = CGFloat(0) /// Property for iOS < 13.0
    private var viewTranslation = CGPoint(x: 0, y: 0) /// Property for iOS < 13.0
    
    private var viewReference: AnotherSignInOptionsView?
    
    // MARK: - View life cycle
    
    override func loadView() {
        super.loadView()
        let view = AnotherSignInOptionsView()
        self.viewReference = view
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        if #available(iOS 13.0, *) {
        } else {
            setupPanGesture()
        }
    }

    // MARK: - Private methods
    
    
    private func setupView() {
        if let view = viewReference {
            view.anotherSignInOptionsWithPhoneNumberButton.addTarget(self, action: #selector(handleSignInWithButtonTapped(_:)), for: .touchUpInside)
            view.anotherSignInOptionsWithGoogleButton.addTarget(self, action: #selector(handleSignInWithButtonTapped(_:)), for: .touchUpInside)
            view.anotherSignInOptionsWithAppleButton.addTarget(self, action: #selector(handleSignInWithButtonTapped(_:)), for: .touchUpInside)
            view.anotherSignInOptionsWithFacebookButton.addTarget(self, action: #selector(handleSignInWithButtonTapped(_:)), for: .touchUpInside)
        }
    }
    
    @objc
    private func handleSignInWithButtonTapped(_ sender: UIButton) {
        guard let view = viewReference else {
            return
        }
        view.endEditing(true)
        
        switch SignInMethodButtonTag(rawValue: sender.tag) {
        case .withPhoneNumber:
            self.dismiss(animated: true) { [weak self] in
                self?.coordinator?.changeLayout(to: .phoneNumber)
            }
        case .withGoogle,
             .withApple,
             .withFacebook:
            self.dismiss(animated: true) { [weak self] in
                self?.coordinator?.didPickSomeSignInMethod()
            }
        default:
            /// Alternatively handle unknown cases in a different way
            fatalError("Did pick button without tag or that uses 0 as a tag")
            break
        }
    }
    
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
                self.view.frame.origin.y = defaultFrameOriginY
            } else {
                dismiss(animated: true)
            }
        default:
            break
            
        }
    }

}
