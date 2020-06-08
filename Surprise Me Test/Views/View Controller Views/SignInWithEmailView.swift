//
//  SignInWithEmailView.swift
//  Surprise Me Test
//
//  Created by Eugene Ilyin on 08.06.2020.
//  Copyright © 2020 Eugene Ilyin. All rights reserved.
//

import UIKit

class SignInWithEmailView: UIView {
    
    // MARK: - Properties
    
    weak var alertHandler: AlertHandler?
    
    // MARK: - Subviews
    
    lazy var signInFakeDragView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = DRAGVIEWHEIGHT / 2
        return view
    }()
    
    lazy var signInContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = CONTENTCORNERRADIUS
        return view
    }()
    
    lazy var signInShowplaceImageView: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = ADDITIONALCORNERRADIUS
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var signInShowplaceImageLoadingActivityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .gray
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    lazy var signInShowplaceNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Some Showplace:"
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    lazy var signInTourNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Some Tour"
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    lazy var signInInfoLabel: UILabel = {
        let label = UILabel()
                label.text = "Glad to see you! Sign in to have an easier access to your tours. No password needed - we'll send you authorization code 😼"
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
        
    lazy var signInUserEmailTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lightGray
        ]
        let attributedPlaceholder = NSAttributedString(string: "Your e-mail", attributes: attributes)
        textField.attributedPlaceholder = attributedPlaceholder
        textField.textAlignment = .center
        textField.font = .systemFont(ofSize: 25, weight: .regular)
        textField.textColor = .black
        textField.keyboardType = .emailAddress
        textField.delegate = self
        textField.returnKeyType = .done
        return textField
    }()
    
    lazy var signInConfirmButton: UIButton = {
        let button = UIButton(type: .system)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18),
            .foregroundColor: UIColor.white
        ]
        let attributedtitle = NSAttributedString(string: "Confirm and get link", attributes: attributes)
        button.setAttributedTitle(attributedtitle, for: .normal)
        
        button.clipsToBounds = true
        button.layer.cornerRadius = ADDITIONALCORNERRADIUS
        button.backgroundColor = UIColor.CustomColor.customBlue
        return button
    }()
    
    lazy var signInAnotherWayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        let useAnotherWayText = "use another way"
        
        let fullText = "or use \(useAnotherWayText) to sign in"
        label.text = fullText
        let anotherWayText = NSMutableAttributedString(string: fullText)
        let anotherWayTextRange = (fullText as NSString).range(of: useAnotherWayText)
        anotherWayText.addAttribute(NSMutableAttributedString.Key.foregroundColor, value: UIColor.CustomColor.customBlue, range: anotherWayTextRange)
        label.attributedText = anotherWayText
        label.isUserInteractionEnabled = true
        label.numberOfLines = 1
        label.textAlignment = .center
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
    
    func configure(with viewModel: SignInWithEmailViewModel) {
        signInShowplaceNameLabel.text = "\(viewModel.showPlaceName):"
        
        signInTourNameLabel.text = viewModel.tourName
        
        if let email = viewModel.userEmail {
            signInUserEmailTextField.text = email
        }
        
        if let url = viewModel.showPlaceImageURL {
            signInShowplaceImageView.loadImageFrom(url: url) { [weak self] (result) in
                switch result {
                case .success():
                    DispatchQueue.main.async {
                        self?.signInShowplaceImageLoadingActivityIndicator.stopAnimating()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.alertHandler?.showAlertDialog(title: error.localizedDescription, message: nil)
                        self?.signInShowplaceImageLoadingActivityIndicator.stopAnimating()
                    }
                }
            }
        } else {
            let error = CustomError.errorWithText("The view model has no image url, but should have one")
            alertHandler?.showAlertDialog(title: error.localizedDescription, message: nil)
            signInShowplaceImageLoadingActivityIndicator.stopAnimating()
        }
    }
    
    // MARK: - Private methods
    
    private func setup() {
        self.backgroundColor = .clear
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
        tapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func handleKeyboard(_ notification: Notification) {
        guard signInUserEmailTextField.isFirstResponder else {
            return
        }
        
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
    
    @objc
    private func hideKeyboard(_ tapGesture: UITapGestureRecognizer) {
        self.endEditing(true)
    }
    
    private func addSubviews() {
        self.addSubview(signInFakeDragView)
        
        self.addSubview(signInContentView)
        signInContentView.addSubview(signInShowplaceImageView)
        signInShowplaceImageView.addSubview(signInShowplaceImageLoadingActivityIndicator)
        
        signInContentView.addSubview(signInShowplaceNameLabel)
        signInContentView.addSubview(signInTourNameLabel)
        signInContentView.addSubview(signInInfoLabel)

        signInContentView.addSubview(signInUserEmailTextField)

        signInContentView.addSubview(signInConfirmButton)

        signInContentView.addSubview(signInAnotherWayLabel)
    }
    
    private func setupSubviews() {
        setupFakeDragView()
        setupContentView()
        
        setupShowplaceImageView()
        setupShowplaceLoadingActivityIndicator()
        
        setupShowplaceNameLabel()
        setupTourNameLabel()
        
        setupInfoLabel()
        
        setupUserEmailTextField()
        
        setupConfirmButton()
        
        setupAnotherWayLabel()
    }
    
    private func setupFakeDragView() {
        signInFakeDragView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInFakeDragView.heightAnchor.constraint(equalToConstant: DRAGVIEWHEIGHT),
            signInFakeDragView.widthAnchor.constraint(equalToConstant: DRAGVIEWWIDTH),
            signInFakeDragView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            signInFakeDragView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    private func setupContentView() {
        signInContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInContentView.topAnchor.constraint(equalTo: signInFakeDragView.bottomAnchor, constant: 10),
            signInContentView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            signInContentView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            signInContentView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func setupShowplaceImageView() {
        signInShowplaceImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInShowplaceImageView.topAnchor.constraint(equalTo: signInContentView.topAnchor, constant: CONTENTCORNERRADIUS),
            signInShowplaceImageView.leadingAnchor.constraint(equalTo: signInContentView.leadingAnchor, constant: CONTENTCORNERRADIUS / 2),
            signInShowplaceImageView.trailingAnchor.constraint(equalTo: signInContentView.trailingAnchor, constant: -CONTENTCORNERRADIUS / 2),
            signInShowplaceImageView.widthAnchor.constraint(equalTo: signInShowplaceImageView.heightAnchor, multiplier: 16 / 9)
        ])
    }
    
    private func setupShowplaceLoadingActivityIndicator() {
        signInShowplaceImageLoadingActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInShowplaceImageLoadingActivityIndicator.centerYAnchor.constraint(equalTo: signInShowplaceImageView.centerYAnchor),
            signInShowplaceImageLoadingActivityIndicator.centerXAnchor.constraint(equalTo: signInShowplaceImageView.centerXAnchor)
        ])
    }
    
    private func setupShowplaceNameLabel() {
        signInShowplaceNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInShowplaceNameLabel.topAnchor.constraint(equalTo: signInShowplaceImageView.bottomAnchor, constant: 20),
            signInShowplaceNameLabel.centerXAnchor.constraint(equalTo: signInContentView.centerXAnchor)
        ])
        
        signInShowplaceNameLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    
    private func setupTourNameLabel() {
        signInTourNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInTourNameLabel.topAnchor.constraint(equalTo: signInShowplaceNameLabel.bottomAnchor, constant: 5),
            signInTourNameLabel.centerXAnchor.constraint(equalTo: signInContentView.centerXAnchor),
            signInTourNameLabel.leadingAnchor.constraint(equalTo: signInContentView.leadingAnchor),
            signInTourNameLabel.trailingAnchor.constraint(equalTo: signInContentView.trailingAnchor)
        ])
        
        signInTourNameLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    
    private func setupInfoLabel() {
        signInInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInInfoLabel.topAnchor.constraint(equalTo: signInTourNameLabel.bottomAnchor, constant: 30),
            signInInfoLabel.leadingAnchor.constraint(equalTo: signInContentView.leadingAnchor, constant: CONTENTCORNERRADIUS / 2),
            signInInfoLabel.trailingAnchor.constraint(equalTo: signInContentView.trailingAnchor, constant: -CONTENTCORNERRADIUS / 2)
        ])
        
        signInInfoLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    
    private func setupUserEmailTextField() {
        signInUserEmailTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInUserEmailTextField.topAnchor.constraint(equalTo: signInInfoLabel.bottomAnchor, constant: 5),
            signInUserEmailTextField.leadingAnchor.constraint(equalTo: signInContentView.leadingAnchor, constant: 20),
            signInUserEmailTextField.trailingAnchor.constraint(equalTo: signInContentView.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupConfirmButton() {
        signInConfirmButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInConfirmButton.topAnchor.constraint(equalTo: signInUserEmailTextField.bottomAnchor, constant: 5),
            signInConfirmButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: CONTENTCORNERRADIUS / 2),
            signInConfirmButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -CONTENTCORNERRADIUS / 2),
            signInConfirmButton.heightAnchor.constraint(lessThanOrEqualToConstant: 50)
        ])
    }
    
    private func setupAnotherWayLabel() {
        signInAnotherWayLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInAnotherWayLabel.topAnchor.constraint(equalTo: signInConfirmButton.bottomAnchor, constant: 20),
            signInAnotherWayLabel.centerXAnchor.constraint(equalTo: signInContentView.centerXAnchor),
            signInAnotherWayLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

}

extension SignInWithEmailView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return false
    }
    
}
