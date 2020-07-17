import Foundation
import XCTest

/**
    A helper class for tests to construct flag bytes.
 */
class CharacteristicFlags {

    /**
     Creates a 16 bit data buffer, by putting a `1` on each indicated index:
     
     [0: true] becomes 0000 0000 0000 0001
     [7: true] becomes 0000 0000 1000 0000
     */
    static func createFlags(
        flags: [Int: Bool]
    ) -> Data {
        var result = Data(count: 2)

        let flagsValue = flags.enumerated()
            .reduce(UInt16(0)) { (accumulation, item) -> UInt16 in
                if item.element.value {
                    return accumulation + UInt16(1 << item.element.key)
                }

                return accumulation
            }

        result[0] = UInt8(clamping: flagsValue & 0xFF)
        result[1] = UInt8(clamping: (flagsValue >> 8) & 0xFF)

        return result
    }
}

class CharacteristicFlagsTest: XCTestCase {

    func test_no_active_flags() {
        /* When */
        let result = CharacteristicFlags.createFlags(flags: [:])

        /* Then */
        XCTAssertEqual(result[0], UInt8("00000000", radix: 2))
        XCTAssertEqual(result[1], UInt8("00000000", radix: 2))
    }

    func test_active_flag_on_0th_index() {
        /* When */
        let result = CharacteristicFlags.createFlags(flags: [0: true])

        /* Then */
        XCTAssertEqual(result[0], UInt8("00000001", radix: 2))
        XCTAssertEqual(result[1], UInt8("00000000", radix: 2))
    }

    func test_active_flag_on_7th_index() {
        /* When */
        let result = CharacteristicFlags.createFlags(flags: [7: true])

        /* Then */
        XCTAssertEqual(result[0], UInt8("10000000", radix: 2))
        XCTAssertEqual(result[1], UInt8("00000000", radix: 2))
    }

    func test_active_flag_on_8th_index() {
        /* When */
        let result = CharacteristicFlags.createFlags(flags: [8: true])

        /* Then */
        XCTAssertEqual(result[0], UInt8("00000000", radix: 2))
        XCTAssertEqual(result[1], UInt8("00000001", radix: 2))
    }

    func test_active_flag_on_15th_index() {
        /* When */
        let result = CharacteristicFlags.createFlags(flags: [15: true])

        /* Then */
        XCTAssertEqual(result[0], UInt8("00000000", radix: 2))
        XCTAssertEqual(result[1], UInt8("10000000", radix: 2))
    }

    func test_all_active_flags() {
        /* Given */
        let flags = [
            0: true,
            1: true,
            2: true,
            3: true,
            4: true,
            5: true,
            6: true,
            7: true,
            8: true,
            9: true,
            10: true,
            11: true,
            12: true,
            13: true,
            14: true,
            15: true
        ]

        /* When */
        let result = CharacteristicFlags.createFlags(flags: flags)

        /* Then */
        XCTAssertEqual(result[0], UInt8("11111111", radix: 2))
        XCTAssertEqual(result[1], UInt8("11111111", radix: 2))
    }
}
