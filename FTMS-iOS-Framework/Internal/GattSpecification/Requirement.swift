import Foundation

internal protocol Requirement {

    func check(in data: Data) -> Bool
}
