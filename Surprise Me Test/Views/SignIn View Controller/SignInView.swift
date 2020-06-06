//
//  SignInView.swift
//  Surprise Me Test
//
//  Created by Eugene Ilyin on 04.06.2020.
//  Copyright © 2020 Eugene Ilyin. All rights reserved.
//

import UIKit
import SKCountryPicker

class SignInView: UIView {

    // MARK: - Constaints
    
    // TODO: Move constants somewhere else
    let CONTENTCORENRRADIUS: CGFloat = 30
    let DRAGVIEWHEIGHT: CGFloat = 4
    let DRAGVIEWWIDTH: CGFloat = 50
    
    // MARK: - Subviews
    
    lazy var signInFakeDragView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var signInContentView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var signInShowplaceImageView: AsyncImageView = {
        let imageView = AsyncImageView()
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
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.textColor = .black
        return label
    }()
    
    lazy var signInTourNameLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.textColor = .black
        return label
    }()
    
    lazy var signInUserNameLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.textColor = .blue
        return label
    }()
    
    lazy var signInInfoLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    lazy var signInCountryButton: UIButton = {
        let button = UIButton(type: .system)
        return button
    }()
    
    lazy var signInCountryCodeLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .title2)
        label.textColor = .black
        return label
    }()
    
    lazy var signInUserPhoneNumberTextField: PastelessTextField = {
        let textField = PastelessTextField()
        textField.textAlignment = .center
        textField.font = .preferredFont(forTextStyle: .title2)
        textField.textColor = .black
        textField.keyboardType = .numberPad
        return textField
    }()
    
    lazy var signInConfirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        return button
    }()
    
    lazy var signInNotYouLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .black
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
    
    func configure(with viewModel: SignInViewModel) {
        signInShowplaceNameLabel.text = "\(viewModel.showPlaceName):"
        
        signInTourNameLabel.text = viewModel.tourName
        
        let greetings = "Hi"
        signInUserNameLabel.text = "\(greetings), \(viewModel.userName)!"
        
        if let phone = viewModel.userPhoneNumber {
            let countryCode = phone.countryCode
            signInCountryCodeLabel.text = countryCode
            
            if let country = CountryManager.shared.country(withDigitCode: countryCode) {
                signInCountryButton.setImage(country.flag?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
            
            let formattedPhoneNumber = format(phoneNumber: phone.phoneNumber, skipTextFieldHandle: true)
            signInUserPhoneNumberTextField.text = formattedPhoneNumber
        }
        
        if let url = viewModel.showPlaceImageURL {
            // TODO: Handle errors.
            signInShowplaceImageView.loadImageFrom(url: url) { [weak self] (result) in
                switch result {
                case .success():
                    DispatchQueue.main.async {
                        self?.signInShowplaceImageLoadingActivityIndicator.stopAnimating()
                    }
                case .failure(let error):
                    let title = "An error occurred while loading image"
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        self?.signInShowplaceImageLoadingActivityIndicator.stopAnimating()
                    }
                }
            }
        } else {
            signInShowplaceImageLoadingActivityIndicator.stopAnimating()
        }
    }
    
    func configure(with country: Country) {
        signInCountryCodeLabel.text = country.dialingCode
        
        signInCountryButton.setImage(country.flag?.withRenderingMode(.alwaysOriginal), for: .normal)
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
        guard signInUserPhoneNumberTextField.isFirstResponder else {
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
        signInUserPhoneNumberTextField.resignFirstResponder()
    }
    
    private func addSubviews() {
        self.addSubview(signInFakeDragView)
        
        self.addSubview(signInContentView)
        signInContentView.addSubview(signInShowplaceImageView)
        signInShowplaceImageView.addSubview(signInShowplaceImageLoadingActivityIndicator)
        
        signInContentView.addSubview(signInShowplaceNameLabel)
        signInContentView.addSubview(signInTourNameLabel)
        signInContentView.addSubview(signInUserNameLabel)
        signInContentView.addSubview(signInInfoLabel)

        signInContentView.addSubview(signInCountryButton)
        signInContentView.addSubview(signInCountryCodeLabel)
        signInContentView.addSubview(signInUserPhoneNumberTextField)

        signInContentView.addSubview(signInConfirmButton)

        signInContentView.addSubview(signInNotYouLabel)
    }
    
    private func setupSubviews() {
        setupFakeDragView()
        setupContentView()
        
        setupShowplaceImageView()
        setupShowplaceLoadingActivityIndicator()
        
        setupShowplaceNameLabel()
        setupTourNameLabel()
        
        setupUserNameLabel()
        setupInfoLabel()
        
        setupCountryButton()
        setupCountryCodeLabel()
        setupUserPhoneNumberTextField()
        
        setupConfirmButton()
        
        setupNotYouLabel()
    }
    
    private func setupFakeDragView() {
        signInFakeDragView.backgroundColor = .white
        signInFakeDragView.clipsToBounds = true
        signInFakeDragView.layer.cornerRadius = DRAGVIEWHEIGHT / 2
        
        signInFakeDragView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInFakeDragView.heightAnchor.constraint(equalToConstant: DRAGVIEWHEIGHT),
            signInFakeDragView.widthAnchor.constraint(equalToConstant: DRAGVIEWWIDTH),
            signInFakeDragView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            signInFakeDragView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    private func setupContentView() {
        signInContentView.backgroundColor = .white
        signInContentView.clipsToBounds = true
        signInContentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        signInContentView.layer.cornerRadius = CONTENTCORENRRADIUS
        
        signInContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInContentView.topAnchor.constraint(equalTo: signInFakeDragView.bottomAnchor, constant: 10),
            signInContentView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            signInContentView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            signInContentView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupShowplaceImageView() {
        signInShowplaceImageView.clipsToBounds = true
        signInShowplaceImageView.layer.cornerRadius = 10
        
        signInShowplaceImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInShowplaceImageView.topAnchor.constraint(equalTo: signInContentView.topAnchor, constant: CONTENTCORENRRADIUS),
            signInShowplaceImageView.leadingAnchor.constraint(equalTo: signInContentView.leadingAnchor, constant: CONTENTCORENRRADIUS / 2),
            signInShowplaceImageView.trailingAnchor.constraint(equalTo: signInContentView.trailingAnchor, constant: -CONTENTCORENRRADIUS / 2),
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
        signInShowplaceNameLabel.text = "Some Showplace:"
        
        signInShowplaceNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInShowplaceNameLabel.topAnchor.constraint(equalTo: signInShowplaceImageView.bottomAnchor, constant: 20),
            signInShowplaceNameLabel.centerXAnchor.constraint(equalTo: signInContentView.centerXAnchor)
        ])
        
        signInShowplaceNameLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    
    private func setupTourNameLabel() {
        signInTourNameLabel.text = "Some Tour"
        
        signInTourNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInTourNameLabel.topAnchor.constraint(equalTo: signInShowplaceNameLabel.bottomAnchor, constant: 5),
            signInTourNameLabel.centerXAnchor.constraint(equalTo: signInContentView.centerXAnchor)
        ])
        
        signInTourNameLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    
    private func setupUserNameLabel() {
        signInUserNameLabel.text = "Hi, NONAME!"
        
        signInUserNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInUserNameLabel.topAnchor.constraint(equalTo: signInTourNameLabel.bottomAnchor, constant: 20),
            signInUserNameLabel.centerXAnchor.constraint(equalTo: signInContentView.centerXAnchor)
        ])
        
        signInUserNameLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    
    private func setupInfoLabel() {
        signInInfoLabel.text = "Sign in to have an easier access to your tours and tickets. No password needed - we'll send you autorization code 😼"
        
        signInInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInInfoLabel.topAnchor.constraint(equalTo: signInUserNameLabel.bottomAnchor, constant: 10),
            signInInfoLabel.leadingAnchor.constraint(equalTo: signInContentView.leadingAnchor, constant: CONTENTCORENRRADIUS / 2),
            signInInfoLabel.trailingAnchor.constraint(equalTo: signInContentView.trailingAnchor, constant: -CONTENTCORENRRADIUS / 2)
        ])
        
        signInInfoLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    
    private func setupCountryButton() {
        if let country = CountryManager.shared.country(withDigitCode: "+1") {
            signInCountryButton.setImage(country.flag?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        signInCountryButton.clipsToBounds = true
        signInCountryButton.layer.masksToBounds = false
        signInCountryButton.layer.shadowRadius = 5
        signInCountryButton.layer.shadowOpacity = 0.8
        signInCountryButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        signInCountryButton.layer.shadowColor = UIColor.gray.cgColor
        
        signInCountryButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInCountryButton.leadingAnchor.constraint(equalTo: signInContentView.leadingAnchor, constant: CONTENTCORENRRADIUS / 2),
            signInCountryButton.centerYAnchor.constraint(equalTo: signInCountryCodeLabel.centerYAnchor),
            
            /// Aspect ration of national flags is 3:5.
            signInCountryButton.widthAnchor.constraint(equalTo: signInCountryButton.heightAnchor, multiplier: 5 / 3),
            signInCountryButton.widthAnchor.constraint(equalToConstant: 50)
        ])
        signInCountryButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private func setupCountryCodeLabel() {
        signInCountryCodeLabel.text = "+1"
        
        signInCountryCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInCountryCodeLabel.topAnchor.constraint(equalTo: signInInfoLabel.bottomAnchor, constant: 5),
            signInCountryCodeLabel.leadingAnchor.constraint(equalTo: signInCountryButton.trailingAnchor, constant: 20),
        ])
        
        signInCountryCodeLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private func setupUserPhoneNumberTextField() {
        signInUserPhoneNumberTextField.backgroundColor = .white
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lightGray
        ]
        let attributedPlaceholder = NSAttributedString(string: "(720) 505-50-00", attributes: attributes)
        signInUserPhoneNumberTextField.attributedPlaceholder = attributedPlaceholder
        signInUserPhoneNumberTextField.delegate = self
        
        signInUserPhoneNumberTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInUserPhoneNumberTextField.leadingAnchor.constraint(equalTo: signInCountryCodeLabel.trailingAnchor, constant: 20),
            signInUserPhoneNumberTextField.centerYAnchor.constraint(equalTo: signInCountryCodeLabel.centerYAnchor),
            signInUserPhoneNumberTextField.trailingAnchor.constraint(equalTo: signInContentView.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupConfirmButton() {
        signInConfirmButton.setTitle("Confirm and get code", for: .normal)
        signInConfirmButton.clipsToBounds = true
        signInConfirmButton.layer.cornerRadius = 10
        
        signInConfirmButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInConfirmButton.topAnchor.constraint(equalTo: signInCountryCodeLabel.bottomAnchor, constant: 5),
            signInConfirmButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: CONTENTCORENRRADIUS / 2),
            signInConfirmButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -CONTENTCORENRRADIUS / 2),
            signInConfirmButton.heightAnchor.constraint(lessThanOrEqualToConstant: 50)
        ])
    }
    
    private func setupNotYouLabel() {
        let asAnotherPersonText = "Sign in as another peron"
        
        let fullText = "Not you? \(asAnotherPersonText)"
        signInNotYouLabel.text = fullText
        let anotherPersonText = NSMutableAttributedString(string: fullText)
        let anotherPersonTextRange = (fullText as NSString).range(of: asAnotherPersonText)
        anotherPersonText.addAttribute(NSMutableAttributedString.Key.foregroundColor, value: UIColor.blue, range: anotherPersonTextRange)
        signInNotYouLabel.attributedText = anotherPersonText
        signInNotYouLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(test(_:)))
        signInNotYouLabel.addGestureRecognizer(tap)

        signInNotYouLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInNotYouLabel.topAnchor.constraint(equalTo: signInConfirmButton.bottomAnchor, constant: 20),
            signInNotYouLabel.centerXAnchor.constraint(equalTo: signInContentView.centerXAnchor),
            signInNotYouLabel.bottomAnchor.constraint(equalTo: signInContentView.bottomAnchor, constant: -20)
        ])
    }
    
    
    @objc
    private func test(_ tap: UITapGestureRecognizer) {
        guard let text = signInNotYouLabel.text else {
                return
        }
        let asAnotherPersonText = "Sign in as another peron"
        let anotherPersonTextRange = (text as NSString).range(of: asAnotherPersonText)
        if tap.didTapAttributedTextInLabel(label: signInNotYouLabel, inRange: anotherPersonTextRange) {
            print("YES!")
        }
    }

    
    /// Returns a new String with phone format: `(***) ***-**-**`.
    private func format(phoneNumber: String, shouldRemoveLastDigit: Bool = false, skipTextFieldHandle: Bool = false) -> String {
        guard !phoneNumber.isEmpty else { return "" }
        guard let regex = try? NSRegularExpression(pattern: "[\\s-\\(\\)]", options: .caseInsensitive) else { return "" }
        let phoneNumberRange = NSString(string: phoneNumber).range(of: phoneNumber)
        var number = regex.stringByReplacingMatches(in: phoneNumber, options: .init(rawValue: 0), range: phoneNumberRange, withTemplate: "")

        if number.count > 10 {
            let tenthDigitIndex = number.index(number.startIndex, offsetBy: 10)
            number = String(number[number.startIndex..<tenthDigitIndex])
        }

        if shouldRemoveLastDigit {
            let end = number.index(number.startIndex, offsetBy: number.count-1)
            number = String(number[number.startIndex..<end])
        }

        /// Resign first responder if user entered the 10th digit.
        if number.count == 10 && !shouldRemoveLastDigit && !skipTextFieldHandle {
            self.signInUserPhoneNumberTextField.resignFirstResponder()
        }
        
        /// Changing format to be `(***) ****...` if there are less than 7 digits in the given number.
        if number.count < 7 {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d+)", with: "($1) $2", options: .regularExpression, range: range)
            
        /// Changing format to be `(***) **-**...` if there are less than 9 digits in the given number.
        } else if number.count < 9 {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: range)
        /// Changing format to be `(***) **-**-**` if there are enough digits in the given number.
        } else {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d{2})(\\d+)", with: "($1) $2-$3-$4", options: .regularExpression, range: range)
        }

        return number
    }

}

extension SignInView: UITextFieldDelegate {
/// Original source references:
/// https://ivrodriguez.com/format-phone-numbers-in-swift/
/// and
/// https://stackoverflow.com/questions/1246439/uitextfield-for-phone-number/13227608#13227608

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        var fullString = textField.text ?? ""
        fullString.append(string)
        if range.length == 1 {
            textField.text = format(phoneNumber: fullString, shouldRemoveLastDigit: true)
        } else {
            textField.text = format(phoneNumber: fullString)
        }
        return false
    }
    
}
