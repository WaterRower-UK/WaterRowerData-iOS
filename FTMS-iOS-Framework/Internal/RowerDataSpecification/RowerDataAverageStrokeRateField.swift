import Foundation

let rowerDataAverageStrokeRateField: Field = RowerDataAverageStrokeRateField()

private struct RowerDataAverageStrokeRateField: Field {

    var name = "Average Stroke Rate"
    var format: Format = .UInt8

    private let requirement = BitRequirement(bitIndex: 1, bitValue: 1)

    func isPresent(in data: Data) -> Bool {
        return requirement.check(in: data)
    }
}
