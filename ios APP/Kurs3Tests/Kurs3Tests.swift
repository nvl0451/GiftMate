//
//  Kurs3Tests.swift
//  Kurs3Tests
//
//  Created by Андрей Королев on 03.06.2024.
//

import XCTest
@testable import Kurs3

class AuthServiceMock: AuthServiceProtocol {
    static let shared = AuthServiceMock()
    
    func performAuthRequest(url: URL, email: String, password: String, completion: @escaping (Bool, String) -> Void) {
        completion(true, "test")
    }
    
    func performRegistrationRequest(url: URL, login: String, email: String, password: String, completion: @escaping (Bool, String) -> Void) {
        completion(true, "test")
    }
}

class AuthServiceTests: XCTestCase {
    func testAuth() {
        AuthServiceMock.shared.performAuthRequest(url: URL(string: "https://www.google.com/")!, email: "email", password: "pass") { result, string in
            XCTAssertEqual(true, result)
        }
    }
    
    func testRegister() {
        AuthServiceMock.shared.performRegistrationRequest(url: URL(string: "https://www.google.com/")!, login: "login", email: "email", password: "pass") { result, string in
            XCTAssertEqual(true, result)
        }
    }
}
