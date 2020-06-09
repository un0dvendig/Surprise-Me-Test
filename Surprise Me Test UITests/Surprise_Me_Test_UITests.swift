//
//  Surprise_Me_Test_UITests.swift
//  Surprise Me Test UITests
//
//  Created by Eugene Ilyin on 07.06.2020.
//  Copyright © 2020 Eugene Ilyin. All rights reserved.
//

import XCTest
@testable import Surprise_Me_Test

class Surprise_Me_Test_UITests: XCTestCase {

    // MARK: - Properties
    
    var application: XCUIApplication!
    
    // MARK: - XCTestCase preparations
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        application = XCUIApplication()
        application.launch()
    }

    // MARK: - Tests

    func testPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func testInitialStateIsCorrect() {
        /// Initially there is only 1 button.
        XCTAssertEqual(application.buttons.count, 1)
        
        let signInButton = application.buttons["Sign In"]
        XCTAssertNotNil(signInButton)
        XCTAssertFalse(signInButton.isSelected)
    }
    
    func testUserTapsSignIn() {
        XCTAssertEqual(application.buttons.count, 1)
        XCTAssertEqual(application.textFields.count, 0)
        
        let signInButton = application.buttons["Sign In"]
        let confirmButton = application.buttons["Confirm and get code"]
        XCTAssertFalse(confirmButton.exists)
        
        signInButton.tap()
        
        /// Label with gesture recognizer counts as a button.
        /// So there are 4 buttons:
        /// sign in button, country picker button, confirm button and label with tap gesture.
        XCTAssertEqual(application.buttons.count, 4)
        
        XCTAssertTrue(confirmButton.exists)
        
        XCTAssertEqual(application.textFields.count, 1)
        let phoneNumberTextField = application.textFields.element
        XCTAssertEqual(phoneNumberTextField.placeholderValue, "(720) 505-50-00")
    }
    
    /// TODO: Split this test into smaller tests
    func testUserPhoneNumberTextField() {
        let signInButton = application.buttons["Sign In"]
        signInButton.tap()
        
        /// Checking keyboard appearance
        let phoneNumberTextField = application.textFields.element
        XCTAssertEqual(application.keyboards.count, 0)
        phoneNumberTextField.tap()
        XCTAssertEqual(application.keyboards.count, 1)
        
        /// Tapping on some label to test keyboard hiding
        let randomLabel = application.staticTexts.firstMatch
        randomLabel.tap()
        XCTAssertEqual(application.keyboards.count, 0)
        
        /// Checking alert presence if textfield is empty
        let alertEmptyPhoneNumber = application.alerts["Phone number is empty"]
        let confirmButton = application.buttons["Confirm and get code"]
        XCTAssertEqual(application.alerts.count, 0)
        XCTAssertFalse(alertEmptyPhoneNumber.exists)
        confirmButton.tap()
        XCTAssertEqual(application.alerts.count, 1)
        XCTAssertTrue(alertEmptyPhoneNumber.exists)
        
        /// Checking alert hiding
        var okButton = alertEmptyPhoneNumber.buttons["OK"]
        XCTAssertTrue(okButton.exists)
        okButton.tap()
        XCTAssertEqual(application.alerts.count, 0)
        
        /// Checking alert presence if textfield is not complete
        let alertPhoneNumberNotComplete = application.alerts["Phone number is not complete"]
        XCTAssertFalse(alertPhoneNumberNotComplete.exists)
        phoneNumberTextField.tap()
        phoneNumberTextField.typeText("72")
        XCTAssertEqual(phoneNumberTextField.value as! String, "72")
        confirmButton.tap()
        XCTAssertEqual(application.alerts.count, 1)
        XCTAssertTrue(alertPhoneNumberNotComplete.exists)
        
        /// Checking alert hiding
        okButton = alertPhoneNumberNotComplete.buttons["OK"]
        XCTAssertTrue(okButton.exists)
        okButton.tap()
        XCTAssertEqual(application.alerts.count, 0)
        
        /// Checking that entering full number hides the keyboard
        phoneNumberTextField.tap()
        XCTAssertEqual(phoneNumberTextField.value as! String, "72")
        /// Clearing the textfield
        phoneNumberTextField.typeText("0")
        let deleteKey = application/*@START_MENU_TOKEN@*/.keys["Delete"]/*[[".keyboards.keys[\"Delete\"]",".keys[\"Delete\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        /// For some reason placeholder value and value are the same
        XCTAssertEqual(phoneNumberTextField.value as! String, "(720) 505-50-00")
        phoneNumberTextField.typeText("720505500")
        XCTAssertEqual(application.keyboards.count, 1)
        /// Entering last digit
        phoneNumberTextField.typeText("0")
        XCTAssertEqual(application.keyboards.count, 0)
    }
    
    func testCountryPicker() {
        let signInButton = application.buttons["Sign In"]
        signInButton.tap()
        
        /// Checking presence of new view controlelr with navigation bar and table view
        XCTAssertEqual(application.navigationBars.count, 0)
        let countryPickerButton = application.buttons["CA"] /// By default has Canada flag image with name "CA"
        countryPickerButton.tap()
        XCTAssertEqual(application.navigationBars.count, 1)
        let title = application.staticTexts["Country Code"]
        XCTAssertTrue(title.exists)
        XCTAssertEqual(application.tables.count, 1)
        
        /// Checking that tapping "X" button in navigation bar hides country picker
        application.navigationBars["Country Code"].buttons["Stop"].tap()
        XCTAssertEqual(application.navigationBars.count, 0)
        
        /// Checking that searching works
        countryPickerButton.tap()
        
        let defaultNumberOfCells = 250 /// By default country picker has 250 cells
        let countryTableView = application.tables.element
        XCTAssertEqual(countryTableView.cells.count, defaultNumberOfCells)
        
        let searchField = application.searchFields.element
        XCTAssertTrue(searchField.exists)
        searchField.tap()
        searchField.typeText("R")  // 126 countries out of 250 have "r" in their names
        XCTAssertEqual(countryTableView.cells.count, 126)
        searchField.typeText("u") // 9 countries out of 250 have "ru" in their names
        XCTAssertEqual(countryTableView.cells.count, 9)
        searchField.typeText("s") // 3 countries out of 250 have "rus" in their names
        XCTAssertEqual(countryTableView.cells.count, 3)
        searchField.typeText("s") // 1 country out of 250 has "russ" in its name
        XCTAssertEqual(countryTableView.cells.count, 1)
        
        /// Clear search bar
        searchField.doubleTap()
        let deleteKey = application.keys["delete"]
        deleteKey.tap()
        XCTAssertEqual(countryTableView.cells.count, 250)
        
        /// Checking that searching with country codes is working
        searchField.typeText("7") // 54 countries out of 250 have "7" in their phone codes
        XCTAssertEqual(countryTableView.cells.count, 54)
        searchField.typeText("9") // 2 countries out of 250 have "79" in their phone codes
        XCTAssertEqual(countryTableView.cells.count, 2)
        /// Closing country picker
        application.navigationBars["Country Code"].buttons["Cancel"].tap()
        application.navigationBars["Country Code"].buttons["Stop"].tap()
        
        /// Checking that country picker changes country in sign in screen
        let countryCodeLabel = application.staticTexts["+1"]
        XCTAssertTrue(countryCodeLabel.exists) /// By default should have "+1"
        XCTAssertTrue(countryPickerButton.exists) /// Country picker button should have "CA" flag by default
        countryPickerButton.tap()
        countryTableView.cells.firstMatch.tap() /// Choosing first cell with Afganistan info
        XCTAssertFalse(countryPickerButton.exists) /// Country picker button should have another flag at this point
        XCTAssertFalse(countryCodeLabel.exists)
        let newCountryPickerButton = application.buttons["AF"] /// Country picker button with "AF" flag
        XCTAssertTrue(newCountryPickerButton.exists)
        let newCountryCodeLabel = application.staticTexts["+93"] /// Afganistan phone country code
        XCTAssertTrue(newCountryCodeLabel.exists)
    }
    
    func testNumberConfirmation() {
        let title = application.staticTexts["Confirm your number"]
        
        /// Open number confirmation screen
        let signInButton = application.buttons["Sign In"]
        signInButton.tap()
        let phoneNumberTextField = application.textFields.element
        _ = phoneNumberTextField.waitForExistence(timeout: 1)
        phoneNumberTextField.tap()
        phoneNumberTextField.typeText("5522255552")
        let confirmButton = application.buttons["Confirm and get code"]
        XCTAssertFalse(title.exists)
        confirmButton.tap()
        XCTAssertTrue(title.exists)
        
        /// Checking that after presenting the screen keyboard is active
        XCTAssertEqual(application.keyboards.count, 1)
        let zeroKey = application.keyboards.element.keys["0"] /// Workaround since UI tests do no detect keyboard focus for some reason
        zeroKey.tap()
        zeroKey.tap()
        zeroKey.tap()
        zeroKey.tap() /// Mocking entering 4-digit code
        
        /// Using workaround with loop that will end in 2 seconds
        let testExpectation = expectation(description: "Checking that whole sign in screen dismissed")
        while application.buttons.count != 1 { }
        testExpectation.fulfill()
        waitForExpectations(timeout: 2) { (error) in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
            XCTAssertTrue(self.application.buttons.count == 1)
        }
    }
    
    func testLayoutChangeToEmail() {
        let signInButton = application.buttons["Sign In"]
        signInButton.tap()
        
        /// Checking that there is only 1 text field and it is the phone number one
        XCTAssertEqual(application.textFields.count, 1)
        let phoneTextField = application.textFields.element
        XCTAssertEqual(phoneTextField.placeholderValue, "(720) 505-50-00")
        
        let notYouButton = application.buttons["Not you? Sign in as another person"]
        XCTAssertTrue(notYouButton.exists)
        notYouButton.tap()
        
        /// Checking that there is still only 1 text field and it is the email one
        XCTAssertEqual(application.textFields.count, 1)
        let emailTextField = application.textFields.element
        XCTAssertEqual(emailTextField.placeholderValue, "Your e-mail")
    }
    
    func testAnotherSignInMethodsScreen() {
        let signInButton = application.buttons["Sign In"]
        signInButton.tap()
        let notYouButton = application.buttons["Not you? Sign in as another person"]
        notYouButton.tap()
        
        /// Checking that these sign in buttons do not exist
        let signInWithPhoneNumberButton = application.buttons["Sign in with phone number"]
        let signInWithGoogleButton = application.buttons["Sign in with Google"]
        let signInWithAppleButton = application.buttons["Sign in with Apple"]
        let signInWithFacebookButton = application.buttons["Sign in with Facebook"]
        XCTAssertFalse(signInWithPhoneNumberButton.exists)
        XCTAssertFalse(signInWithGoogleButton.exists)
        XCTAssertFalse(signInWithAppleButton.exists)
        XCTAssertFalse(signInWithFacebookButton.exists)
        
        let useAnotherWayButton = application.buttons["or use another way to sign in"]
        XCTAssertTrue(useAnotherWayButton.exists)
        useAnotherWayButton.tap()
        
        /// Checking that sign in buttons have appeared on the screen
        XCTAssertTrue(signInWithPhoneNumberButton.exists)
        XCTAssertTrue(signInWithGoogleButton.exists)
        XCTAssertTrue(signInWithAppleButton.exists)
        XCTAssertTrue(signInWithFacebookButton.exists)
        
        /// Checking that tapping any button except the phone number one dismisses the screen
        signInWithGoogleButton.tap()
        XCTAssertFalse(signInWithPhoneNumberButton.exists)
        XCTAssertFalse(signInWithGoogleButton.exists)
        XCTAssertFalse(signInWithAppleButton.exists)
        XCTAssertFalse(signInWithFacebookButton.exists)
        useAnotherWayButton.tap()
        XCTAssertTrue(signInWithPhoneNumberButton.exists)
        XCTAssertTrue(signInWithGoogleButton.exists)
        XCTAssertTrue(signInWithAppleButton.exists)
        XCTAssertTrue(signInWithFacebookButton.exists)
        
        signInWithAppleButton.tap()
        XCTAssertFalse(signInWithPhoneNumberButton.exists)
        XCTAssertFalse(signInWithGoogleButton.exists)
        XCTAssertFalse(signInWithAppleButton.exists)
        XCTAssertFalse(signInWithFacebookButton.exists)
        useAnotherWayButton.tap()
        XCTAssertTrue(signInWithPhoneNumberButton.exists)
        XCTAssertTrue(signInWithGoogleButton.exists)
        XCTAssertTrue(signInWithAppleButton.exists)
        XCTAssertTrue(signInWithFacebookButton.exists)
        
        signInWithFacebookButton.tap()
        XCTAssertFalse(signInWithPhoneNumberButton.exists)
        XCTAssertFalse(signInWithGoogleButton.exists)
        XCTAssertFalse(signInWithAppleButton.exists)
        XCTAssertFalse(signInWithFacebookButton.exists)
        useAnotherWayButton.tap()
        XCTAssertTrue(signInWithPhoneNumberButton.exists)
        XCTAssertTrue(signInWithGoogleButton.exists)
        XCTAssertTrue(signInWithAppleButton.exists)
        XCTAssertTrue(signInWithFacebookButton.exists)
    }
    
    func testLayoutChangeToPhoneNumber() {
        let signInButton = application.buttons["Sign In"]
        signInButton.tap()
        
        /// Checking that there is only 1 text field and it is the phone number one
        XCTAssertEqual(application.textFields.count, 1)
        let phoneTextField = application.textFields.element
        XCTAssertEqual(phoneTextField.placeholderValue, "(720) 505-50-00")
        
        let useAnotherWayButton = application.buttons["or use another way to sign in"]
        XCTAssertFalse(useAnotherWayButton.exists)
        let notYouButton = application.buttons["Not you? Sign in as another person"]
        XCTAssertTrue(notYouButton.exists)
        notYouButton.tap()
        
        /// Checking that there is still only 1 text field and it is the email one
        XCTAssertEqual(application.textFields.count, 1)
        let emailTextField = application.textFields.element
        XCTAssertEqual(emailTextField.placeholderValue, "Your e-mail")
        
        let signInWithPhoneNumberButton = application.buttons["Sign in with phone number"]
        XCTAssertFalse(signInWithPhoneNumberButton.exists)
        useAnotherWayButton.tap()
        XCTAssertTrue(signInWithPhoneNumberButton.exists)
        
        /// Checking that tapping phone number button dissmisses the screen and changes layout
        signInWithPhoneNumberButton.tap()
        XCTAssertFalse(signInWithPhoneNumberButton.exists)
        XCTAssertTrue(useAnotherWayButton.exists)
        XCTAssertFalse(notYouButton.exists)
        if !notYouButton.waitForExistence(timeout: 2) {
            XCTFail("Layout has not been changed")
        }
        XCTAssertEqual(application.textFields.count, 1)
        let currentTextField = application.textFields.element
        XCTAssertNotEqual(currentTextField.placeholderValue, "Your e-mail")
        XCTAssertEqual(currentTextField.placeholderValue, "(720) 505-50-00")
    }
    
    /// TODO: Split this test into smaller tests
    func testUserEmailTextField() {
        let signInButton = application.buttons["Sign In"]
        signInButton.tap()
        let notYouButton = application.buttons["Not you? Sign in as another person"]
        let confirmButton = application.buttons["Confirm and get link"]
        XCTAssertFalse(confirmButton.exists)
        notYouButton.tap()
        if !confirmButton.waitForExistence(timeout: 2) {
            XCTFail("Layout has not been changed")
        }
        let emailTextField = application.textFields.element
        XCTAssertEqual(emailTextField.placeholderValue, "Your e-mail")
        XCTAssertEqual(emailTextField.value as! String, "Your e-mail") /// UI tests return placeholder value as value if text has not been set in text field
        XCTAssertTrue(confirmButton.exists)
        
        /// Checking alert presence if textfield is empty
        let alertEmptyEmail = application.alerts["Email is empty"]
        XCTAssertEqual(application.alerts.count, 0)
        XCTAssertFalse(alertEmptyEmail.exists)
        confirmButton.tap()
        XCTAssertEqual(application.alerts.count, 1)
        XCTAssertTrue(alertEmptyEmail.exists)
        
        /// Checking alert hiding
        var okButton = alertEmptyEmail.buttons["OK"]
        XCTAssertTrue(okButton.exists)
        okButton.tap()
        XCTAssertEqual(application.alerts.count, 0)
        
        /// Checking alert presence if entered email is not valid
        let alertEmailNotValid = application.alerts["Email is not valid"]
        XCTAssertFalse(alertEmailNotValid.exists)
        emailTextField.tap()
        emailTextField.typeText("email")
        XCTAssertEqual(emailTextField.value as! String, "email")
        confirmButton.tap()
        XCTAssertEqual(application.alerts.count, 1)
        XCTAssertTrue(alertEmailNotValid.exists)
        /// Checking alert hiding
        okButton = alertEmailNotValid.buttons["OK"]
        XCTAssertTrue(okButton.exists)
        okButton.tap()
        XCTAssertEqual(application.alerts.count, 0)
        
        /// Checking that pressing "done" button hides the keyboard
        XCTAssertEqual(application.keyboards.count, 0)
        emailTextField.tap()
        XCTAssertEqual(application.keyboards.count, 1)
        let doneButton = application.keyboards.buttons["Done"]
        XCTAssertTrue(doneButton.exists)
        doneButton.tap()
        XCTAssertEqual(application.keyboards.count, 0)
    }
}
