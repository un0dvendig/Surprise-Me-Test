//
//  Surprise_Me_Test_Tests.swift
//  Surprise Me Test Tests
//
//  Created by Eugene Ilyin on 07.06.2020.
//  Copyright © 2020 Eugene Ilyin. All rights reserved.
//

import XCTest
@testable import Surprise_Me_Test

class Surprise_Me_Test_Tests: XCTestCase {

    // MARK: - Models
    
    func testPersonTourModel() {
        let tour = Tour(id: 123, name: "Test Tour")
        XCTAssertNotNil(tour)
        XCTAssertEqual(tour.id, 123)
        XCTAssertEqual(tour.name, "Test Tour")
    }
    
    func testShowplaceModel() {
        let showPlace = Showplace(id: 321, name: "Test Showplace", imageURLString: nil)
        XCTAssertNotNil(showPlace)
        XCTAssertEqual(showPlace.id, 321)
        XCTAssertEqual(showPlace.name, "Test Showplace")
        XCTAssertNil(showPlace.imageURLString)
        
        let stringUrlExample = "https://example.com"
        showPlace.imageURLString = stringUrlExample
        XCTAssertNotNil(showPlace.imageURLString)
        XCTAssertEqual(showPlace.imageURLString, stringUrlExample)
    }
    
    func testPhoneNumberModel() {
        let phoneNumber = PhoneNumber(countryCode: "+1", phoneNumber: "2345678901")
        XCTAssertNotNil(phoneNumber)
        XCTAssertEqual(phoneNumber.countryCode, "+1")
        XCTAssertEqual(phoneNumber.phoneNumber, "2345678901")
        XCTAssertEqual(phoneNumber.phoneNumber.count, 10)
        XCTAssertEqual(phoneNumber.fullNumber, "+12345678901")
    }
    
    func testUserModel() {
        var user = User(id: 777, name: "Indiana", phone: nil, email: nil)
        XCTAssertNotNil(user)
        XCTAssertEqual(user.id, 777)
        XCTAssertEqual(user.name, "Indiana")
        XCTAssertNil(user.phone)
        XCTAssertNil(user.email)
        
        let phoneNumber = PhoneNumber(countryCode: "+1", phoneNumber: "0987654321")
        user.phone = phoneNumber
        XCTAssertNotNil(user.phone)
        XCTAssertEqual(user.phone?.countryCode, "+1")
        XCTAssertEqual(user.phone?.phoneNumber, "0987654321")
        XCTAssertEqual(user.phone?.phoneNumber.count, 10)
        XCTAssertEqual(user.phone?.fullNumber, "+10987654321")
        
        let emailExample = "example@test.com"
        user.email = emailExample
        XCTAssertNotNil(user.email)
        XCTAssertEqual(user.email, emailExample)
    }
    
    // MARK: - Extensions
    
    func testHasSuccessStatusCodeExtension() {
        guard let urlPlaceholder = URL(string: "https://example.com") else {
            XCTFail()
            return
        }
        
        guard var httpResponse = HTTPURLResponse(url: urlPlaceholder, statusCode: 1, httpVersion: nil, headerFields: nil) else {
            XCTFail()
            return
        }
        XCTAssertNotNil(httpResponse)
        XCTAssertFalse(httpResponse.hasSuccessStatusCode)
        
        guard let newHttpResponse = HTTPURLResponse(url: urlPlaceholder, statusCode: 100, httpVersion: nil, headerFields: nil) else {
            XCTFail()
            return
        }
        httpResponse = newHttpResponse
        XCTAssertNotNil(httpResponse)
        XCTAssertFalse(httpResponse.hasSuccessStatusCode)
        
        guard let anotherHttpResponse = HTTPURLResponse(url: urlPlaceholder, statusCode: 200, httpVersion: nil, headerFields: nil) else {
            XCTFail()
            return
        }
        httpResponse = anotherHttpResponse
        XCTAssertNotNil(httpResponse)
        XCTAssertTrue(httpResponse.hasSuccessStatusCode)
    }
    
    func testPercentEncodedExtension() {
        let firstParametersStringToCompareWith = "parameter1=123"
        let firstParameters: [String: Any] = [
            "parameter1": 123
        ]
        XCTAssertNotNil(firstParameters.percentEncoded())
        
        guard let firstParametersData = firstParameters.percentEncoded(),
            let firstTestString = String(data: firstParametersData, encoding: .utf8) else {
            XCTFail()
            return
        }
        XCTAssertEqual(firstTestString, firstParametersStringToCompareWith)
        
        // -- //
        
        let secondParametersStringToCompareWith = "parameter2=test%20value"
        let secondParameters: [String: Any] = [
            "parameter2": "test value"
        ]
        XCTAssertNotNil(secondParameters.percentEncoded())
        
        guard let secondParametersData = secondParameters.percentEncoded(),
            let secondTestString = String(data: secondParametersData, encoding: .utf8) else {
            XCTFail()
            return
        }
        XCTAssertEqual(secondTestString, secondParametersStringToCompareWith)
        
        // -- //
        
        let thirdParametersStringToCompareWith = "parameter3=another%23value"
        let thirdParameters: [String: Any] = [
            "parameter3": "another#value"
        ]
        XCTAssertNotNil(thirdParameters.percentEncoded())
        
        guard let thirdParametersData = thirdParameters.percentEncoded(),
            let thirdTestString = String(data: thirdParametersData, encoding: .utf8) else {
            XCTFail()
            return
        }
        XCTAssertEqual(thirdTestString, thirdParametersStringToCompareWith)
        
        // -- //
        
        let fourthParametersStringToCompareWith = "parameter4=new%2Fvalue"
        let fourthParameters: [String: Any] = [
            "parameter4": "new/value"
        ]
        XCTAssertNotNil(fourthParameters.percentEncoded())
        
        guard let fourthParametersData = fourthParameters.percentEncoded(),
            let fourthTestString = String(data: fourthParametersData, encoding: .utf8) else {
            XCTFail()
            return
        }
        XCTAssertEqual(fourthTestString, fourthParametersStringToCompareWith)
    }
    
    // MARK: - Utils
    
    func testDownloadManager() {
        var realDataToTest: Data? // Real avatar image data that should be downloaded
        let realDataExpectation = expectation(description: "Checking that image data is downloaded")
        /// URL example from: https://jsonplaceholder.typicode.com
        guard let realImageURL = URL(string: "https://via.placeholder.com/600/92c950") else {
            XCTFail()
            return
        }
        
        var anotherRealDataToTest: Data? // Another avatar image data that should be downloaded
        let anotherRealDataExpectation = expectation(description: "Checking that another image data is downloaded")
        guard let anotherRealImageURL = URL(string: "https://via.placeholder.com/800/af29z0") else {
            XCTFail()
            return
        }
        
        var noDataToTest: Data? // Data that should not be downloaded
        let noDataExpectation = expectation(description: "Checking that data is not downloaded")
        guard let wrongImageURL = URL(string: "https://viaaa.placeh0lder.com/600/92c950/1?yes=no") else {
            XCTFail()
            return
        }
        
        let downloadManager = DownloadManager.shared
        downloadManager.downloadData(from: realImageURL) { (result) in
            switch result {
            case .success(let data):
                realDataToTest = data
                realDataExpectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        downloadManager.downloadData(from: anotherRealImageURL) { (result) in
            switch result {
            case .success(let data):
                anotherRealDataToTest = data
                anotherRealDataExpectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        downloadManager.downloadData(from: wrongImageURL) { (result) in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(_):
                noDataToTest = nil
                noDataExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 2) { (error) in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
            XCTAssertNotNil(realDataToTest)
            XCTAssertNotNil(anotherRealDataToTest)
            XCTAssertNil(noDataToTest)
            XCTAssertNotEqual(realDataToTest, anotherRealDataToTest)
        }
    }
    
    func testDataWorkerImageConvertion() {
        var testImage: UIImage?
        let testExpectation = expectation(description: "Checking that downloaded data is properly converted to UIImage")
        /// URL example from: https://jsonplaceholder.typicode.com
        guard let testImageURL = URL(string: "https://via.placeholder.com/600/92c950") else {
            XCTFail()
            return
        }
        
        DownloadManager.shared.downloadData(from: testImageURL) { (result) in
            switch result {
            case .success(let data):
                if let image = DataWorker.shared.convertDataToUIImage(data) {
                    testImage = image
                    testExpectation.fulfill()
                } else {
                    let error = CustomError.cannotCreateUIImage
                    XCTFail(error.localizedDescription)
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        waitForExpectations(timeout: 2) { (error) in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
            XCTAssertNotNil(testImage)
        }
    }
    
    func testDataWorkerStringConvertion() {
        var testString: String?
        let testExpectation = expectation(description: "Checking that downloaded data is properly converted to String")
        /// URL example from: https://jsonplaceholder.typicode.com
        guard let testImageURL = URL(string: "https://jsonplaceholder.typicode.com/todos/1") else {
            XCTFail()
            return
        }
        
        DownloadManager.shared.downloadData(from: testImageURL) { (result) in
            switch result {
            case .success(let data):
                if let string = DataWorker.shared.convertDataToString(data) {
                    testString = string
                    testExpectation.fulfill()
                } else {
                    let error = CustomError.cannotCreateString
                    XCTFail(error.localizedDescription)
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        waitForExpectations(timeout: 2) { (error) in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
            XCTAssertNotNil(testString)
        }
    }
    
    func testImageCache() {
        let imageCache = ImageCache.shared
        
        var firstTestImage: UIImage?
        let firstTestExpectation = expectation(description: "Checking that downloaded image is properly loaded from cache")
        /// URL example from: https://jsonplaceholder.typicode.com
        guard let firstTestImageURL = URL(string: "https://via.placeholder.com/600/92c950") else {
            XCTFail()
            return
        }
        DownloadManager.shared.downloadData(from: firstTestImageURL) { (result) in
            switch result {
            case .success(let data):
                if let image = DataWorker.shared.convertDataToUIImage(data) {
                    imageCache.save(image, forKey: firstTestImageURL.absoluteString)
                    
                    if let firstImageFromCache = imageCache.getImage(forKey: firstTestImageURL.absoluteString) {
                        firstTestImage = firstImageFromCache
                        firstTestExpectation.fulfill()
                    }
                } else {
                    let error = CustomError.cannotCreateUIImage
                    XCTFail(error.localizedDescription)
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        var secondTestImage: UIImage?
        let secondTestExpectation = expectation(description: "CChecking that downloaded image is properly loaded from cache")
        guard let secondTestImageURL = URL(string: "https://via.placeholder.com/900/af29z0") else {
            XCTFail()
            return
        }
        DownloadManager.shared.downloadData(from: secondTestImageURL) { (result) in
            switch result {
            case .success(let data):
                if let image = DataWorker.shared.convertDataToUIImage(data) {
                    imageCache.save(image, forKey: secondTestImageURL.absoluteString)
                    
                    if let secondImageFromCache = imageCache.getImage(forKey: secondTestImageURL.absoluteString) {
                        secondTestImage = secondImageFromCache
                        secondTestExpectation.fulfill()
                    }
                } else {
                    let error = CustomError.cannotCreateUIImage
                    XCTFail(error.localizedDescription)
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        waitForExpectations(timeout: 2) { (error) in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
            XCTAssertNotNil(firstTestImage)
            XCTAssertNotNil(secondTestImage)
            
            XCTAssertNotEqual(firstTestImage, secondTestImage)
        }
    }
    
    func testURLBuilder() {
        guard let properURLToCompareWith = URL(string: "https://surprizeme.ru") else {
            XCTFail()
            return
        }
        guard let urlToTest = URLBuilder()
            .set(scheme: "https")
            .set(host: "surprizeme.ru")
            .build() else {
                XCTFail()
                return
        }
        XCTAssertEqual(urlToTest, properURLToCompareWith)
        
        /// URL example from: https://jsonplaceholder.typicode.com
        guard let anotherProperURLToCompareWith = URL(string: "https://jsonplaceholder.typicode.com/posts?userId=1") else {
            XCTFail()
            return
        }
        guard let anotherUrlToTest = URLBuilder()
            .set(scheme: "https")
            .set(host: "jsonplaceholder.typicode.com")
            .set(path: "posts")
            .addQueryItem(name: "userId", value: "1")
            .build() else {
                XCTFail()
                return
        }
        XCTAssertEqual(anotherUrlToTest, anotherProperURLToCompareWith)
    }
    
    func testURLRequestBuilder() {
        guard let properURLToCompareWith = URL(string: "https://surprizeme.ru") else {
            XCTFail()
            return
        }
        let properURLRequestToCompareWith = URLRequest(url: properURLToCompareWith)
        guard let urlToTest = URLBuilder()
            .set(scheme: "https")
            .set(host: "surprizeme.ru")
            .build() else {
                XCTFail()
                return
        }
        let urlRequestToTest = URLRequestBuilder(url: urlToTest).build()
        XCTAssertEqual(urlRequestToTest, properURLRequestToCompareWith)
        
        /// URL example from: https://jsonplaceholder.typicode.com
        guard let anotherProperURLToCompareWith = URL(string: "https://jsonplaceholder.typicode.com/posts?userId=1") else {
            XCTFail()
            return
        }
        var anotherProperURLRequestToCompareWith = URLRequest(url: anotherProperURLToCompareWith)
        anotherProperURLRequestToCompareWith.httpMethod = "POST"
        anotherProperURLRequestToCompareWith.setValue("application/json", forHTTPHeaderField: "accept")
        guard let anotherUrlToTest = URLBuilder()
            .set(scheme: "https")
            .set(host: "jsonplaceholder.typicode.com")
            .set(path: "posts")
            .addQueryItem(name: "userId", value: "1")
            .build() else {
                XCTFail()
                return
        }
        let anotherUrlRequestToTest = URLRequestBuilder(url: anotherUrlToTest)
            .set(httpMethod: "POST")
            .setValue("application/json", forHttpHeaderField: "accept")
            .build()
        XCTAssertEqual(anotherUrlRequestToTest, anotherProperURLRequestToCompareWith)
    }

    // MARK: - View models
    
    func testSignInViewModel() {
        let phone = PhoneNumber(countryCode: "+1", phoneNumber: "2345678901")
        let email = "e@mail.net"
        let user = User(id: 123, name: "Chewbacca", phone: phone, email: email)
        let tour = Tour(id: 1, name: "Test tour")
        let showPlace = Showplace(id: 3, name: "Test showplace", imageURLString: nil)
        let viewModel = SignInViewModel(user: user, tour: tour, showPlace: showPlace)
        XCTAssertEqual(viewModel.userName, user.name)
        XCTAssertEqual(viewModel.userPhoneNumber, phone)
        XCTAssertEqual(viewModel.userEmail, email)
        XCTAssertEqual(viewModel.showPlaceName, showPlace.name)
        XCTAssertEqual(viewModel.tourName, tour.name)
        XCTAssertNotNil(viewModel.showPlaceImageURL) /// Even if the showplace has no image, view model should return random URL
    }
    
    func testCodeViewModel() {
        let phone = PhoneNumber(countryCode: "+1", phoneNumber: "2345678901")
        let email = "mail@e.net"
        let user = User(id: 123, name: "Yoda", phone: phone, email: email)
        var viewModel = CodeViewModel(user: user)
        XCTAssertNil(viewModel.currentCheckCode)
        XCTAssertEqual(viewModel.userId, String(user.id))
        
        let startIndex = phone.phoneNumber.index(phone.phoneNumber.startIndex, offsetBy: 3)
        let endIndex = phone.phoneNumber.index(phone.phoneNumber.startIndex, offsetBy: 3+3)
        
        let sIndex = phone.phoneNumber.index(phone.phoneNumber.endIndex, offsetBy: -4)
        let eIndex = phone.phoneNumber.index(phone.phoneNumber.endIndex, offsetBy: -4+2)
        
        let letFormattedPhoneNumber = "\(phone.countryCode) (\(phone.phoneNumber.prefix(3))) \(phone.phoneNumber[startIndex..<endIndex])-\(phone.phoneNumber[sIndex..<eIndex])-\(phone.phoneNumber.suffix(2))"
        XCTAssertEqual(viewModel.userFullPhoneNumber, letFormattedPhoneNumber)
        
        viewModel.currentCheckCode = "0000"
         XCTAssertNotNil(viewModel.currentCheckCode)
         XCTAssertEqual(viewModel.currentCheckCode, "0000")
    }
    
    // MARK: - Views
    
    func testAsyncImageView() {
        let asyncImageView = AsyncImageView()
        XCTAssertNil(asyncImageView.image)
        
        let imageDownloadExpectation = expectation(description: "Checking that image is downloaded")
        /// URL example from: https://jsonplaceholder.typicode.com
        guard let imageURL = URL(string: "https://via.placeholder.com/600/92c950") else {
            XCTFail()
            return
        }
        
        asyncImageView.loadImageFrom(url: imageURL) { (result) in
            switch result {
            case .success():
                imageDownloadExpectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        waitForExpectations(timeout: 2) { (error) in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
            XCTAssertNotNil(asyncImageView.image)
        }
    }
    
}
