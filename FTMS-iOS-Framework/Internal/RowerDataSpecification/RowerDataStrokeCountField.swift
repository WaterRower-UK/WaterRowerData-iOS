import Foundation

let rowerDataStrokeCountField: Field = RowerDataStrokeCountField()

private struct RowerDataStrokeCountField: Field {

    var name = "Stroke Count"
    var format: Format = .UInt16

    private let requirement = BitRequirement(bitIndex: 0, bitValue: 0)

    func isPresent(in data: Data) -> Bool {
        return requirement.check(in: data)
    }
}
