import Foundation

let rowerDataResistanceLevelField: Field = RowerDataResistanceLevelField()

private struct RowerDataResistanceLevelField: Field {

    var name = "Resistance Level"
    var format: Format = .SInt16

    private let requirement = BitRequirement(bitIndex: 7, bitValue: 1)

    func isPresent(in data: Data) -> Bool {
        return requirement.check(in: data)
    }
}
