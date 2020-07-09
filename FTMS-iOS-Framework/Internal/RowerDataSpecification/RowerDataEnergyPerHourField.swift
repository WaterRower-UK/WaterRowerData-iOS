import Foundation

let rowerDataEnergyPerHourField: Field = RowerDataEnergyPerHourField()

private struct RowerDataEnergyPerHourField: Field {

    var name = "Energy Per Hour"
    var format: Format = .UInt16

    private let requirement = BitRequirement(bitIndex: 8, bitValue: 1)

    func isPresent(in data: Data) -> Bool {
        return requirement.check(in: data)
    }
}
