import Foundation

let rowerDataEnergyPerMinuteField: Field = RowerDataEnergyPerMinuteField()

private struct RowerDataEnergyPerMinuteField: Field {

    var name = "Energy Per Minute"
    var format: Format = .UInt16

    private let requirement = BitRequirement(bitIndex: 8, bitValue: 1)

    func isPresent(in data: Data) -> Bool {
        return requirement.check(in: data)
    }
}
