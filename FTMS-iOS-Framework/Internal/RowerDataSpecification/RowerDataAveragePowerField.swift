import Foundation

let rowerDataAveragePowerField: Field = RowerDataAveragePowerField()

private struct RowerDataAveragePowerField: Field {

    var name = "Average Power"
    var format: Format = .SInt16

    private let requirement = BitRequirement(bitIndex: 6, bitValue: 1)

    func isPresent(in data: Data) -> Bool {
        return requirement.check(in: data)
    }
}
