//
//  CodeViewController.swift
//  Surprise Me Test
//
//  Created by Eugene Ilyin on 06.06.2020.
//  Copyright © 2020 Eugene Ilyin. All rights reserved.
//

import UIKit
import KAPinField

class CodeViewController: UIViewController {

    // MARK: - Properties
    
    var user: User?
    var coordinator: SignInCoordinator?
    
    // MARK: - Private properties
    
    private var viewReference: CodeView?
    private var viewModel: CodeViewModel?
    
    // MARK: - View life cycle
    
    override func loadView() {
        super.loadView()
        let view = CodeView()
        self.viewReference = view
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard user != nil else {
            fatalError("User should be set at this point")
        }
        
        setupViewModel()
        setupView()
        postCodeRequest()
    }

    // MARK: - Private methods
    
    private func setupViewModel() {
        guard let user = user else {
            return
        }
        let viewModel = CodeViewModel(user: user)
        self.viewModel = viewModel
    }
    
    private func setupView() {
        if let view = viewReference,
            let viewModel = viewModel {
            view.codeEntryKAPinField.properties.delegate = self
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleSendAgain(_:)))
            view.codeSendAgainLabel.addGestureRecognizer(tap)
            
            view.configure(with: viewModel)
            _ = view.codeEntryKAPinField.becomeFirstResponder()
        }
    }
    
    
    @objc
    private func handleSendAgain(_ tap: UITapGestureRecognizer) {
        guard let view = viewReference else {
            return
        }
        guard let text = view.codeSendAgainLabel.text else {
                return
        }
        let againText = "Send again"
        let againTextRange = (text as NSString).range(of: againText)
        if tap.didTapAttributedTextInLabel(label: view.codeSendAgainLabel, inRange: againTextRange) {
            postCodeRequest()
        }
    }
    
    private func postCodeRequest() {
        guard let userPhoneNumber = viewModel?.userFullPhoneNumber,
            let userId = viewModel?.userId else {
            return
        }
        self.requestCode(forUserId: userId, andUserFullPhoneNumber: userPhoneNumber) { (result) in
            switch result {
            case .success(let code):
                self.viewModel?.currentCheckCode = code
            case .failure(let error):
                print(error)
            }
        }
    }
    
    /// Request a code for given user.
    private func requestCode(forUserId userId: String, andUserFullPhoneNumber fullPhoneNumber: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URLBuilder()
            .set(scheme: "https")
            .set(host: "webhook.site")
            .set(path: "4e88daa3-ddc5-436e-9659-993660603103")
            .build() else {
                let error = CustomError.cannotBuildURL
                completion(.failure(error))
                return
        }
        
        let parameters: [String: Any] = [
            "id": userId,
            "phone": fullPhoneNumber
        ]
        
        let postRequest = URLRequestBuilder(url: url)
            .set(httpMethod: "POST")
            .setValue("application/json", forHttpHeaderField: "accept")
            .set(parameters: parameters)
            .build()
        
        DownloadManager.shared.downloadData(from: postRequest) { (result) in
            switch result {
            case .success(let data):
                if let code = DataWorker.shared.convertDataToString(data) {
                    completion(.success(code))
                } else {
                    let error = CustomError.cannotCreateString
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}

extension CodeViewController: KAPinFieldDelegate {
    
    // MARK: - Methods
    
    func pinField(_ field: KAPinField, didFinishWith code: String) {
        guard let viewModel = viewModel else {
            return
        }
        /// Compare codes here. But since there is no code, making a silly test.
        if viewModel.currentCheckCode != nil {
            field.animateSuccess(with: "✅") {
                self.dismiss(animated: true) { [unowned self] in
                    self.coordinator?.didFinishCheckingCode()
                }
            }
        } else {
            field.animateFailure()
        }
    }
    
}
