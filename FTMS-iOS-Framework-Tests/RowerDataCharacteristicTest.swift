import XCTest

@testable import FTMS_iOS_Framework

class RowerDataCharacteristicTest: XCTestCase {

    // MARK: Average Stroke Rate

    func test_averageStrokeRate_notPresent_resultsIn_nilValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(averageStrokeRatePresent: false)
        let data = CharacteristicData.create(flags: flags)

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertNil(result.averageStrokeRate)
    }

    func test_averageStrokeRate_present_resultsIn_uint8Value_withBinaryExponentMinusOne() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(averageStrokeRatePresent: true)
        let data = CharacteristicData.create(flags: flags, values: 7)

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.averageStrokeRate, 3.5)
    }

    // MARK: Total Distance

    func test_totalDistance_notPresent_resultsIn_nilValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(totalDistancePresent: false)
        let data = CharacteristicData.create(flags: flags)

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertNil(result.totalDistanceMeters)
    }

    func test_totalDistance_present_resultsIn_uint24Value_forLowValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(totalDistancePresent: true)
        let data = CharacteristicData.create(flags: flags, values: 1, 0, 0)

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.totalDistanceMeters, 1)
    }

    func test_totalDistance_present_resultsIn_uint24Value_forMediumValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(totalDistancePresent: true)
        let data = CharacteristicData.create(flags: flags, values: 1, 2, 0) // 1 + 512

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.totalDistanceMeters, 513)
    }

    func test_totalDistance_present_resultsIn_uint24Value_forHighValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(totalDistancePresent: true)
        let data = CharacteristicData.create(flags: flags, values: 1, 2, 4) // 1 + 512 + 262144

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.totalDistanceMeters, 262657)
    }
}
