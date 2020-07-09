import Foundation

struct BitRequirement: Requirement {

    let bitIndex: Int
    let bitValue: Int

    func check(in data: Data) -> Bool {
        let flagsValue = Int(data[0])
        return flagsValue & (1 << bitIndex) == (bitValue << bitIndex)
    }
}
