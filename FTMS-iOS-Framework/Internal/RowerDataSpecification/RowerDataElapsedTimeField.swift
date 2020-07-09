import Foundation

let rowerDataElapsedTimeField: Field = RowerDataElapsedTimeField()

private struct RowerDataElapsedTimeField: Field {

    var name = "Elapsed Time"
    var format: Format = .UInt16

    private let requirement = BitRequirement(bitIndex: 11, bitValue: 1)

    func isPresent(in data: Data) -> Bool {
        return requirement.check(in: data)
    }
}
