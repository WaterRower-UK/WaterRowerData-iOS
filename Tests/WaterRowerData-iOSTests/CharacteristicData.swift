import Foundation
import XCTest

class CharacteristicData {

    static func create(
        flags: Data,
        values: UInt8...
    ) -> Data {
        var result = Data(count: flags.count + values.count)
        var i = 0

        flags.forEach { (value) in
            result[i] = value
            i += 1
        }

        values.forEach { (value) in
            result[i] = value
            i += 1
        }

        return result
    }
}

class CharacteristicDataTest: XCTestCase {

    func test_create_without_flags_or_values() {
        /* Given */
        let flags = CharacteristicFlags.createFlags(flags: [:])

        /* When */
        let result = CharacteristicData.create(flags: flags)

        /* Then */
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0], UInt8("00000000", radix: 2))
        XCTAssertEqual(result[1], UInt8("00000000", radix: 2))
    }

    func test_create_with_flags_without_values() {
        /* Given */
        let flags = CharacteristicFlags.createFlags(flags: [1: true])

        /* When */
        let result = CharacteristicData.create(flags: flags)

        /* Then */
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0], UInt8("00000010", radix: 2))
        XCTAssertEqual(result[1], UInt8("00000000", radix: 2))
    }

    func test_create_with_flags_with_single_value() {
        /* Given */
        let flags = CharacteristicFlags.createFlags(flags: [1: true])

        /* When */
        let result = CharacteristicData.create(flags: flags, values: 3)

        /* Then */
        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(result[0], UInt8("00000010", radix: 2))
        XCTAssertEqual(result[1], UInt8("00000000", radix: 2))
        XCTAssertEqual(result[2], 3)
    }

    func test_create_with_flags_with_multiple_values() {
        /* Given */
        let flags = CharacteristicFlags.createFlags(flags: [1: true])

        /* When */
        let result = CharacteristicData.create(flags: flags, values: 3, 5)

        /* Then */
        XCTAssertEqual(result.count, 4)
        XCTAssertEqual(result[0], UInt8("00000010", radix: 2))
        XCTAssertEqual(result[1], UInt8("00000000", radix: 2))
        XCTAssertEqual(result[2], 3)
        XCTAssertEqual(result[3], 5)
    }
}
