import Foundation

let rowerDataRemainingTimeField: Field = RowerDataRemainingTimeField()

private struct RowerDataRemainingTimeField: Field {

    var name = "Remaining Time"
    var format: Format = .UInt16

    private let requirement = BitRequirement(bitIndex: 12, bitValue: 1)

    func isPresent(in data: Data) -> Bool {
        return requirement.check(in: data)
    }
}
