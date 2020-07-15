import Foundation

struct BitRequirement: Requirement {

    let bitIndex: Int
    let bitValue: Int

    func check(in data: Data) -> Bool {
        let flagsValue = data.readIntValue(format: .UInt16, offset: 0)
        return flagsValue & (1 << bitIndex) == (bitValue << bitIndex)
    }
}
