import Foundation
import XCTest

class RowerDataCharacteristicFlags {

    static func create(
        averageStrokeRatePresent: Bool = false,
        totalDistancePresent: Bool = false
    ) -> Data {
        var flags: [Int: Bool] = [:]

        if averageStrokeRatePresent {
            flags[1] = true
        }

        if totalDistancePresent {
            flags[2] = true
        }

        return CharacteristicFlags.createFlags(flags: flags)
    }
}

class RowerDataCharacteristicFlagsTest: XCTestCase {

    func test_averageStrokeRate_present() {
        /* When */
        let result = RowerDataCharacteristicFlags.create(
            averageStrokeRatePresent: true
        )

        /* Then */
        XCTAssertEqual(result[0], UInt8("00000010", radix: 2))
    }
}
