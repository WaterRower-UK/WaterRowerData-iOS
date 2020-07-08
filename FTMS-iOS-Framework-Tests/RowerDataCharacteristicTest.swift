import XCTest

@testable import FTMS_iOS_Framework

class RowerDataCharacteristicTest: XCTestCase {

    func test_decoding_empty_data_returns_nil() {
        /* When */
        let result = RowerDataCharacteristic.decode(data: Data())

        /* Then */
        XCTAssertNil(result)
    }
}
