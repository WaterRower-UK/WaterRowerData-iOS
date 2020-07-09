import XCTest

@testable import FTMS_iOS_Framework

class RowerDataCharacteristicTest: XCTestCase {

    // MARK: Stroke Rate

    func test_strokeRate_notPresent_resultsIn_nilValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(moreDataPresent: false)
        let data = CharacteristicData.create(flags: flags)

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertNil(result.strokeRate)
    }

    func test_strokeRate_present_resultsIn_uint8Value_withBinaryExponentMinusOne() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(moreDataPresent: true)
        let data = CharacteristicData.create(
            flags: flags,
            values: 7, // Stroke rate of 3.5
            0, // Stroke count value
            0
        )

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.strokeRate, 3.5)
    }

    // MARK: Stroke Count

    func test_strokeCount_notPresent_resultsIn_nilValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(moreDataPresent: false)
        let data = CharacteristicData.create(flags: flags)

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertNil(result.strokeCount)
    }

    func test_strokeCount_present_resultsIn_uint16Value_lowValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(moreDataPresent: true)
        let data = CharacteristicData.create(
            flags: flags,
            values: 0, // Stroke Rate
            1, // Stroke count of 1
            0
        )

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.strokeCount, 1)
    }

    func test_strokeCount_present_resultsIn_uint16Value_highValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(moreDataPresent: true)
        let data = CharacteristicData.create(
            flags: flags,
            values: 0, // Stroke Rate
            1, // Stroke count of 1 + 256
            1
        )

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.strokeCount, 257)
    }

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

    // MARK: Instantaneous Pace

    func test_instantaneousPace_notPresent_resultsIn_nilValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(instantaneousPacePresent: false)
        let data = CharacteristicData.create(flags: flags)

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertNil(result.instantaneousPaceSeconds)
    }

    func test_instantaneousPace_notPresent_resultsIn_uint16Value_forLowValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(instantaneousPacePresent: true)
        let data = CharacteristicData.create(flags: flags, values: 1, 0)

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.instantaneousPaceSeconds, 1)
    }

    func test_instantaneousPace_notPresent_resultsIn_uint16Value_forHighValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(instantaneousPacePresent: true)
        let data = CharacteristicData.create(flags: flags, values: 1, 2) // 1 + 512

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.instantaneousPaceSeconds, 513)
    }

    // MARK: Multiple properties present

    func test_multiplePropertiesPresent_properlyOffsetsValues_forAverageStrokeRateAndTotalDistance() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(
            averageStrokeRatePresent: true,
            totalDistancePresent: true
        )
        let data = CharacteristicData.create(
            flags: flags,
            values: 7, // Average stroke rate of 3.5
            16, // Total distance of 16
            0,
            0
        )

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.averageStrokeRate, 3.5)
        XCTAssertEqual(result.totalDistanceMeters, 16)
    }

    func test_multiplePropertiesPresent_properlyOffsetsValues_forAverageStrokeRateAndInstantaneousPace() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(
            averageStrokeRatePresent: true,
            instantaneousPacePresent: true
        )
        let data = CharacteristicData.create(
            flags: flags,
            values: 7, // Average stroke rate of 3.5
            16, // Instantaneous pace of 16
            0
        )

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.averageStrokeRate, 3.5)
        XCTAssertEqual(result.instantaneousPaceSeconds, 16)
    }

    func test_multiplePropertiesPresent_properlyOffsetsValues_forTotalDistanceAndInstantaneousPace() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(
            totalDistancePresent: true,
            instantaneousPacePresent: true
        )
        let data = CharacteristicData.create(
            flags: flags,
            values: 32, // Total distance of 32
            0,
            0,
            16, // Instantaneous pace of 16
            0
        )

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.totalDistanceMeters, 32)
        XCTAssertEqual(result.instantaneousPaceSeconds, 16)
    }
}
