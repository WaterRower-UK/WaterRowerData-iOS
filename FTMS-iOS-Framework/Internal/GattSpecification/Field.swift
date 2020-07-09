import Foundation

protocol Field {

    var name: String { get }
    var format: Format { get }

    func isPresent(in data: Data) -> Bool
}
