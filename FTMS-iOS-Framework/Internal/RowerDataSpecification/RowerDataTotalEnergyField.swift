import Foundation

let rowerDataTotalEnergyField: Field = RowerDataTotalEnergyField()

private struct RowerDataTotalEnergyField: Field {

    var name = "Total Energy"
    var format: Format = .UInt16

    private let requirement = BitRequirement(bitIndex: 8, bitValue: 1)

    func isPresent(in data: Data) -> Bool {
        return requirement.check(in: data)
    }
}
