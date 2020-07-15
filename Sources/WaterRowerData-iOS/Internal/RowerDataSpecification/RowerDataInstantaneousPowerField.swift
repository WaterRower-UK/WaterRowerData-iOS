import Foundation

let rowerDataInstantaneousPowerField: Field = RowerDataInstantaneousPowerField()

private struct RowerDataInstantaneousPowerField: Field {

    var name = "Instantaneous Power"
    var format: Format = .SInt16

    private let requirement = BitRequirement(bitIndex: 5, bitValue: 1)

    func isPresent(in data: Data) -> Bool {
        return requirement.check(in: data)
    }
}
