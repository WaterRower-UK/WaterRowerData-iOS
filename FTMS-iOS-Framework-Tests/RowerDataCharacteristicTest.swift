import XCTest

@testable import FTMS_iOS_Framework

class RowerDataCharacteristicTest: XCTestCase {

    // MARK: Average Stroke Rate

    func test_averageStrokeRate_not_present_results_in_nil_value() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(averageStrokeRatePresent: false)
        let data = CharacteristicData.create(flags: flags)

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertNil(result.averageStrokeRate)
    }

    func test_averageStrokeRate_present_results_in_uint8_value_with_binary_exponent_minusone() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(averageStrokeRatePresent: true)
        let data = CharacteristicData.create(flags: flags, values: 7)

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.averageStrokeRate, 3.5)
    }
}
