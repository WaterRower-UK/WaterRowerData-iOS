import Foundation

let rowerDataAveragePaceField: Field = RowerDataAveragePaceField()

private struct RowerDataAveragePaceField: Field {

    var name = "Average Pace"
    var format: Format = .UInt16

    private let requirement = BitRequirement(bitIndex: 4, bitValue: 1)

    func isPresent(in data: Data) -> Bool {
        return requirement.check(in: data)
    }
}
