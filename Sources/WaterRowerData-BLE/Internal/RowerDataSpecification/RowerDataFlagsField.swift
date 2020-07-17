import Foundation

let rowerDataFlagsField: Field = RowerDataFlagsField()

private struct RowerDataFlagsField: Field {

    var name = "Flags"
    var format: Format = .UInt16

    func isPresent(in data: Data) -> Bool {
        return true
    }
}
