import XCTest

@testable import FTMS_iOS_Framework

class ExampleTest: XCTestCase {

    func testExample() {
        XCTAssertEqual(2 + 3, 5)
        XCTAssertEqual(Example().foo(), 3)
    }
}
