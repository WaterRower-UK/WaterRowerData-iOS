import Foundation

let rowerDataHeartRateField: Field = RowerDataHeartRateField()

private struct RowerDataHeartRateField: Field {

    var name = "Heart Rate"
    var format: Format = .UInt8

    private let requirement = BitRequirement(bitIndex: 9, bitValue: 1)

    func isPresent(in data: Data) -> Bool {
        return requirement.check(in: data)
    }
}
