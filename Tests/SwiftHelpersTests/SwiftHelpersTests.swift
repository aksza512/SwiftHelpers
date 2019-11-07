import XCTest
@testable import SwiftHelpers

final class SwiftHelpersTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SwiftHelpers().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
