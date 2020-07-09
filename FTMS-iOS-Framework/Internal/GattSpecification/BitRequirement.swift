import Foundation

struct BitRequirement: Requirement {

    let bitIndex: Int
    let bitValue: Int

    func check(in data: Data) -> Bool {
        let flagsValue = data[0]
        return Int(flagsValue) & (bitValue << bitIndex) != 0
    }
}
