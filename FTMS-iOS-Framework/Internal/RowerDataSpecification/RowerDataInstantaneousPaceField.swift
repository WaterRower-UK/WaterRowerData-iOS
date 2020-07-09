import Foundation

let rowerDataInstantaneousPaceField: Field = RowerDataInstantaneousPaceField()

private struct RowerDataInstantaneousPaceField: Field {

    var name = "Instantaneous Pace"
    var format: Format = .UInt16

    private let requirement = BitRequirement(bitIndex: 3, bitValue: 1)

    func isPresent(in data: Data) -> Bool {
        return requirement.check(in: data)
    }
}
