//
//  AnotherSignInOptionsView.swift
//  Surprise Me Test
//
//  Created by Eugene Ilyin on 08.06.2020.
//  Copyright © 2020 Eugene Ilyin. All rights reserved.
//

import UIKit

class AnotherSignInOptionsView: UIView {
    
    // MARK: - Subviews
    
    lazy var anotherSignInOptionsFakeDragView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = DRAGVIEWHEIGHT / 2
        return view
    }()
    
    lazy var anotherSignInOptionsContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = CONTENTCORNERRADIUS
        return view
    }()
    
    private lazy var anotherSignInOptionsButtonsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    lazy var anotherSignInOptionsWithPhoneNumberButton: LeftAlignedIconButton = {
        let button = LeftAlignedIconButton()
        button.tag = SignInMethodButtonTag.withPhoneNumber.rawValue
        let attribues: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold)
        ]
        let title = NSAttributedString(string: "Sign in with phone number", attributes: attribues)
        button.setAttributedTitle(title, for: .normal)
        button.contentHorizontalAlignment = .leading
        button.setImage(#imageLiteral(resourceName: "icons8-phone-100").withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
                button.sizeToFit()
        button.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 0)
        if let imageView = button.imageView {
            let imageWidth = imageView.bounds.width
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth / 2, bottom: 0, right: 0)
        }
        button.clipsToBounds = true
        button.layer.cornerRadius = ADDITIONALCORNERRADIUS
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        return button
    }()
    
    lazy var anotherSignInOptionsWithGoogleButton: LeftAlignedIconButton = {
        let button = LeftAlignedIconButton(type: .system)
        button.tag = SignInMethodButtonTag.withGoogle.rawValue
        let attribues: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold)
        ]
        let title = NSAttributedString(string: "Sign in with Google", attributes: attribues)
        button.setAttributedTitle(title, for: .normal)
        button.contentHorizontalAlignment = .leading
        button.setImage(#imageLiteral(resourceName: "icons8-google-96").withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
                button.sizeToFit()
        button.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 0)
        if let imageView = button.imageView {
            let imageWidth = imageView.bounds.width
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth / 2, bottom: 0, right: 0)
        }
        button.clipsToBounds = true
        button.layer.cornerRadius = ADDITIONALCORNERRADIUS
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        return button
    }()
    
    lazy var anotherSignInOptionsWithAppleButton: LeftAlignedIconButton = {
        let button = LeftAlignedIconButton(type: .system)
        button.tag = SignInMethodButtonTag.withApple.rawValue
        let attribues: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold)
        ]
        let title = NSAttributedString(string: "Sign in with Apple", attributes: attribues)
        button.setAttributedTitle(title, for: .normal)
        button.contentHorizontalAlignment = .leading
        button.setImage(#imageLiteral(resourceName: "icons8-apple-logo-100").withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
                button.sizeToFit()
        button.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 0)
        if let imageView = button.imageView {
            let imageWidth = imageView.bounds.width
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth / 2, bottom: 0, right: 0)
        }
        button.clipsToBounds = true
        button.layer.cornerRadius = ADDITIONALCORNERRADIUS
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        return button
    }()
    
    lazy var anotherSignInOptionsWithFacebookButton: LeftAlignedIconButton = {
        let button = LeftAlignedIconButton(type: .system)
        button.tag = SignInMethodButtonTag.withFacebook.rawValue
        let attribues: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold)
        ]
        let title = NSAttributedString(string: "Sign in with Facebook", attributes: attribues)
        button.setAttributedTitle(title, for: .normal)
        button.contentHorizontalAlignment = .leading
        button.setImage(#imageLiteral(resourceName: "icons8-facebook-96").withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.sizeToFit()
        button.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 0)
        if let imageView = button.imageView {
            let imageWidth = imageView.bounds.width
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth / 2, bottom: 0, right: 0)
        }
        button.clipsToBounds = true
        button.layer.cornerRadius = ADDITIONALCORNERRADIUS
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        return button
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setupSubviews()
    }
    
    @available(*, unavailable, message: "use init(frame:) instead")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func setup() {
        self.backgroundColor = .clear
    }
    
    private func addSubviews() {
        self.addSubview(anotherSignInOptionsFakeDragView)
        
        self.addSubview(anotherSignInOptionsContentView)
        anotherSignInOptionsContentView.addSubview(anotherSignInOptionsButtonsStack)
        
        anotherSignInOptionsButtonsStack.addArrangedSubview(anotherSignInOptionsWithPhoneNumberButton)
        anotherSignInOptionsButtonsStack.addArrangedSubview(anotherSignInOptionsWithGoogleButton)
        anotherSignInOptionsButtonsStack.addArrangedSubview(anotherSignInOptionsWithAppleButton)
        anotherSignInOptionsButtonsStack.addArrangedSubview(anotherSignInOptionsWithFacebookButton)
    }
    
    private func setupSubviews() {
        setupFakeDragView()
        setupContentView()
        
        setupButtonsStack()
        
        setupWithPhoneNumberButton()
        setupWithGoogleButton()
        setupWithAppleButton()
        setupWithFacebookButton()
    }
    
    private func setupFakeDragView() {
        anotherSignInOptionsFakeDragView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            anotherSignInOptionsFakeDragView.heightAnchor.constraint(equalToConstant: DRAGVIEWHEIGHT),
            anotherSignInOptionsFakeDragView.widthAnchor.constraint(equalToConstant: DRAGVIEWWIDTH),
            anotherSignInOptionsFakeDragView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    private func setupContentView() {
        anotherSignInOptionsContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            anotherSignInOptionsContentView.topAnchor.constraint(equalTo: anotherSignInOptionsFakeDragView.bottomAnchor, constant: 10),
            anotherSignInOptionsContentView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            anotherSignInOptionsContentView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            anotherSignInOptionsContentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            anotherSignInOptionsContentView.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5)
        ])
    }
    
    private func setupButtonsStack() {
        anotherSignInOptionsButtonsStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            anotherSignInOptionsButtonsStack.topAnchor.constraint(equalTo: anotherSignInOptionsContentView.topAnchor, constant: CONTENTCORNERRADIUS),
            anotherSignInOptionsButtonsStack.leadingAnchor.constraint(equalTo: anotherSignInOptionsContentView.leadingAnchor, constant: CONTENTCORNERRADIUS / 2),
            anotherSignInOptionsButtonsStack.trailingAnchor.constraint(equalTo: anotherSignInOptionsContentView.trailingAnchor, constant: -CONTENTCORNERRADIUS / 2),
            anotherSignInOptionsButtonsStack.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -CONTENTCORNERRADIUS)
        ])
    }
    
    private func setupWithPhoneNumberButton() {
        
    }
    
    private func setupWithGoogleButton() {
        
    }
    
    private func setupWithAppleButton() {
        
    }
    
    private func setupWithFacebookButton() {
        
    }
    
}
