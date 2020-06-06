//
//  CodeView.swift
//  Surprise Me Test
//
//  Created by Eugene Ilyin on 06.06.2020.
//  Copyright © 2020 Eugene Ilyin. All rights reserved.
//

import UIKit
import KAPinField

class CodeView: UIView {
    
    // MARK: - Subviews
    
    lazy var codeFakeDragView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = DRAGVIEWHEIGHT / 2
        return view
    }()
    
    lazy var codeContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = CONTENTCORENRRADIUS
        return view
    }()
    
    lazy var codeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Confirm your number"
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    lazy var codeInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Please enter 4-digit code we just sent to"
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    lazy var codePhoneNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "+1 (720) 505-50-00"
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    lazy var codeEntryKAPinField: KAPinField = {
        let textField = KAPinField()
        textField.keyboardType = .numberPad
        textField.appearance.tokenColor = UIColor.clear
        textField.appearance.tokenFocusColor = UIColor.clear
        textField.appearance.textColor = UIColor.black
        textField.appearance.font = .menlo(30)
        textField.appearance.kerning = 30
        textField.appearance.backOffset = 5
        textField.appearance.backColor = UIColor.clear
        textField.appearance.backBorderWidth = 1
        textField.appearance.backBorderColor = UIColor.black.withAlphaComponent(0.2)
        textField.appearance.backCornerRadius = 4
        textField.appearance.backFocusColor = UIColor.clear
        textField.appearance.backBorderFocusColor = UIColor.black.withAlphaComponent(0.8)
        textField.appearance.backActiveColor = UIColor.clear
        textField.appearance.backBorderActiveColor = UIColor.black
        textField.appearance.backRounded = false
        textField.properties.numberOfCharacters = 4
        return textField
    }()
    
    lazy var codeSendAgainLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        let againText = "Send again"
        
        let fullText = "Didn't get the text? \(againText)"
        label.text = fullText
        let sendAgainText = NSMutableAttributedString(string: fullText)
        let sendAgainTextRange = (fullText as NSString).range(of: againText)
        sendAgainText.addAttribute(NSMutableAttributedString.Key.foregroundColor, value: UIColor.CustomColor.customBlue, range: sendAgainTextRange)
        label.attributedText = sendAgainText
        label.isUserInteractionEnabled = true
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        addSubviews()
        setupSubviews()
    }
    
    @available(*, unavailable, message: "use init(frame:) instead")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Deinitialization
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Methods
    
    func configure(with viewModel: CodeViewModel) {
        guard let userFullPhoneNumber = viewModel.userFullPhoneNumber else {
            fatalError("User has no phone number, but should have one at this point.")
        }
        self.codePhoneNumberLabel.text = userFullPhoneNumber
    }
    
    // MARK: - Private methods
    
    private func setup() {
        self.backgroundColor = .clear
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    private func handleKeyboard(_ notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardFrame = keyboardValue.cgRectValue
        if notification.name == UIResponder.keyboardWillHideNotification {
            if self.frame.origin.y != 0 {
                self.frame.origin.y = 0
            }
        } else {
            if self.frame.origin.y == 0 {
                self.frame.origin.y -= keyboardFrame.height
            }
        }
    }
    
    private func addSubviews() {
        self.addSubview(codeFakeDragView)
        
        self.addSubview(codeContentView)
        codeContentView.addSubview(codeTitleLabel)
        codeContentView.addSubview(codeInfoLabel)
        codeContentView.addSubview(codePhoneNumberLabel)
        
        codeContentView.addSubview(codeEntryKAPinField)
        
        codeContentView.addSubview(codeSendAgainLabel)
    }
    
    private func setupSubviews() {
        setupFakeDragView()
        setupContentView()
        
        setupTitleLabel()
        setupInfoLabel()
        setupPhoneNumberLabel()
        
        setupEntryKAPinField()
        
        setupSendAgainLabel()
    }
    
    private func setupFakeDragView() {
        codeFakeDragView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            codeFakeDragView.heightAnchor.constraint(equalToConstant: DRAGVIEWHEIGHT),
            codeFakeDragView.widthAnchor.constraint(equalToConstant: DRAGVIEWWIDTH),
            codeFakeDragView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    private func setupContentView() {
        codeContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            codeContentView.topAnchor.constraint(equalTo: codeFakeDragView.bottomAnchor, constant: 10),
            codeContentView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            codeContentView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            codeContentView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            codeContentView.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5)
        ])
    }
    
    private func setupTitleLabel() {
        codeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            codeTitleLabel.centerXAnchor.constraint(equalTo: codeContentView.centerXAnchor),
            codeTitleLabel.topAnchor.constraint(equalTo: codeContentView.topAnchor, constant: CONTENTCORENRRADIUS * 1.5)
        ])
    }
    
    private func setupInfoLabel() {
        codeInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            codeInfoLabel.centerXAnchor.constraint(equalTo: codeContentView.centerXAnchor),
            codeInfoLabel.topAnchor.constraint(equalTo: codeTitleLabel.bottomAnchor, constant: 10)
        ])
    }
    
    private func setupPhoneNumberLabel() {
        codePhoneNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            codePhoneNumberLabel.centerXAnchor.constraint(equalTo: codeContentView.centerXAnchor),
            codePhoneNumberLabel.topAnchor.constraint(equalTo: codeInfoLabel.bottomAnchor, constant: 5)
        ])
    }
    
    private func setupEntryKAPinField() {
        codeEntryKAPinField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            codeEntryKAPinField.centerXAnchor.constraint(equalTo: codeContentView.centerXAnchor),
            codeEntryKAPinField.centerYAnchor.constraint(equalTo: codeContentView.centerYAnchor, constant: 50),
            codeEntryKAPinField.leadingAnchor.constraint(equalTo: codeContentView.leadingAnchor),
            codeEntryKAPinField.trailingAnchor.constraint(equalTo: codeContentView.trailingAnchor),
            codeEntryKAPinField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupSendAgainLabel(){
        codeSendAgainLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            codeSendAgainLabel.centerXAnchor.constraint(equalTo: codeContentView.centerXAnchor),
            codeSendAgainLabel.bottomAnchor.constraint(equalTo: codeContentView.bottomAnchor, constant: -20)
        ])
    }

}
