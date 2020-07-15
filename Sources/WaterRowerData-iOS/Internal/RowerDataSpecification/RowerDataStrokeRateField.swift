import Foundation

let rowerDataStrokeRateField: Field = RowerDataStrokeRateField()

private struct RowerDataStrokeRateField: Field {

    var name = "Stroke Rate"
    var format: Format = .UInt8

    private let requirement = BitRequirement(bitIndex: 0, bitValue: 0)

    func isPresent(in data: Data) -> Bool {
        return requirement.check(in: data)
    }
}
