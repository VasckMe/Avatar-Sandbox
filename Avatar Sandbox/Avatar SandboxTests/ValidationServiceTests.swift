//
//  ValidationServiceTests.swift
//  Avatar SandboxTests
//
//  Created by Anton Kasaryn on 29.01.24.
//

import XCTest
@testable import Avatar_Sandbox

final class ValidationServiceTests: XCTestCase {

    var sut: ValidationServiceProtocol!
    
    override func setUpWithError() throws {
        sut = ValidationService()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testIsValidAgeSuccess() {
        let result = sut.isValidAge(text: "50")
        XCTAssertTrue(result)
    }

    func testIsValidAgeFailure() {
        let result1 = sut.isValidAge(text: "abs")
        XCTAssertFalse(result1)
        
        let result2 = sut.isValidAge(text: "0")
        XCTAssertFalse(result2)
    }
}
