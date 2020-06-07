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
    
    func testUserEntersPhoneNumber() {
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
        let alertPhoneNumberNoComplete = application.alerts["Phone number is not complete"]
        XCTAssertFalse(alertPhoneNumberNoComplete.exists)
        phoneNumberTextField.tap()
        phoneNumberTextField.typeText("72")
        XCTAssertEqual(phoneNumberTextField.value as! String, "72")
        confirmButton.tap()
        XCTAssertEqual(application.alerts.count, 1)
        XCTAssertTrue(alertPhoneNumberNoComplete.exists)
        
        /// Checking alert hiding
        okButton = alertPhoneNumberNoComplete.buttons["OK"]
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
}
