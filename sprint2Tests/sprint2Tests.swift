//
//  sprint2Tests.swift
//  sprint2Tests
//
//  Created by Capgemini-DA164 on 9/21/22.
//

import XCTest
@testable import sprint2

class sprint2Tests: XCTestCase {

    var loginVC : LoginViewController!
    var signUoVC : SignUpPageViewController!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        loginVC = LoginViewController.getVC()
        loginVC.loadViewIfNeeded()
        signUoVC = SignUpPageViewController.getSignUpVC()
        signUoVC.loadViewIfNeeded()
        
        
    }

    func test_outlet() throws {
        XCTAssertNotNil(loginVC.emailTxt, "No Outlet connection")
        XCTAssertNotNil(loginVC.passwordTxt, "No Outlet connection")
        XCTAssertNotNil(signUoVC.emailTxt, "no Outlet connection")
        XCTAssertNotNil(signUoVC.passwordTxt, "no Outlet connection")
        XCTAssertNotNil(signUoVC.mobileTxt, "no outlet connection")
        XCTAssertNotNil(signUoVC.nameTxt, "no outlet connection")
    }
    
    func test_loginButton() throws {
        let login : UIButton = try XCTUnwrap(loginVC.loginOutlet, "Button has no outlet")
        
        let loginAction = try XCTUnwrap(login.actions(forTarget: loginVC ,forControlEvent: .touchUpInside), "Button has no action")
        
        XCTAssertEqual(loginAction.count, 1)
        XCTAssertEqual(loginAction.first, "loginClick:", "there is no action")
    }
   
    func test_textField() throws {
        XCTAssertEqual("email", loginVC.emailTxt.placeholder)
        XCTAssertEqual("password", loginVC.passwordTxt.placeholder)
        XCTAssertEqual("name", signUoVC.nameTxt.placeholder)
        XCTAssertEqual("Mobile", signUoVC.mobileTxt.placeholder)
        XCTAssertEqual("Password", signUoVC.passwordTxt.placeholder)
        XCTAssertEqual("conform Password", signUoVC.conformPasswordTxt.placeholder)
    }
    
    func test_emailExist() throws {
        XCTAssertTrue(loginVC.entityExists(email: "shruti@gmail.com"), "email not exists in core data")
        XCTAssertTrue(signUoVC.entityExists(email: "shruti@gmail.com"), "email not exists")
    }
    
    func test_validation() throws {
        XCTAssertTrue(loginVC.validEmailId(emailId: "prama@gmail.com"), "not a valid email")
        XCTAssertTrue(loginVC.validPassword(password: "Prama123"), "not a valid password")
        XCTAssertTrue(signUoVC.validMobile(mobile: "9878765467"), "not a vlid mobile no")
        XCTAssertTrue(signUoVC.validConfirmPassword(password: "Prama123", confirmPassword: "Prama123") ,"password not same")
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
