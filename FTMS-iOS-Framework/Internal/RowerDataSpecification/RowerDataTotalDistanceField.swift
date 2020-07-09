import Foundation

let rowerDataTotalDistanceField: Field = RowerDataTotalDistanceField()

private struct RowerDataTotalDistanceField: Field {

    var name = "Total Distance"
    var format: Format = .UInt24

    private let requirement = BitRequirement(bitIndex: 2, bitValue: 1)

    func isPresent(in data: Data) -> Bool {
        return requirement.check(in: data)
    }
}
