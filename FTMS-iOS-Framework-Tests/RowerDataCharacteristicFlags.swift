import Foundation
import XCTest

class RowerDataCharacteristicFlags {

    static func create(
        moreDataPresent: Bool = false,
        averageStrokeRatePresent: Bool = false,
        totalDistancePresent: Bool = false,
        instantaneousPacePresent: Bool = false,
        averagePacePresent: Bool = false
    ) -> Data {
        var flags: [Int: Bool] = [:]

        if !moreDataPresent {
            flags[0] = true
        }

        if averageStrokeRatePresent {
            flags[1] = true
        }

        if totalDistancePresent {
            flags[2] = true
        }

        if instantaneousPacePresent {
            flags[3] = true
        }

        if averagePacePresent {
            flags[4] = true
        }

        return CharacteristicFlags.createFlags(flags: flags)
    }
}

class RowerDataCharacteristicFlagsTest: XCTestCase {

    func test_moreData_present() {
        /* When */
        let result = RowerDataCharacteristicFlags.create(
            moreDataPresent: true
        )

        /* Then */
        XCTAssertEqual(result[0], UInt8("00000000", radix: 2))
    }

    func test_moreData_notPresent() {
        /* When */
        let result = RowerDataCharacteristicFlags.create(
            moreDataPresent: false
        )

        /* Then */
        XCTAssertEqual(result[0], UInt8("00000001", radix: 2))
    }

    func test_averageStrokeRate_present() {
        /* When */
        let result = RowerDataCharacteristicFlags.create(
            moreDataPresent: true,
            averageStrokeRatePresent: true
        )

        /* Then */
        XCTAssertEqual(result[0], UInt8("00000010", radix: 2))
    }

    func test_totalDistance_present() {
        /* When */
        let result = RowerDataCharacteristicFlags.create(
            moreDataPresent: true,
            totalDistancePresent: true
        )

        /* Then */
        XCTAssertEqual(result[0], UInt8("00000100", radix: 2))
    }

    func test_instantaneousPace_present() {
        /* When */
        let result = RowerDataCharacteristicFlags.create(
            moreDataPresent: true,
            instantaneousPacePresent: true
        )

        /* Then */
        XCTAssertEqual(result[0], UInt8("00001000", radix: 2))
    }

    func test_averagePace_present() {
        /* When */
        let result = RowerDataCharacteristicFlags.create(
            moreDataPresent: true,
            averagePacePresent: true
        )

        /* Then */
        XCTAssertEqual(result[0], UInt8("00010000", radix: 2))
    }
}
