import Foundation

let rowerDataMetabolicEquivalentField: Field = RowerDataMetabolicEquivalentField()

private struct RowerDataMetabolicEquivalentField: Field {

    var name = "Metabolic Equivalent"
    var format: Format = .UInt8

    private let requirement = BitRequirement(bitIndex: 10, bitValue: 1)

    func isPresent(in data: Data) -> Bool {
        return requirement.check(in: data)
    }
}
