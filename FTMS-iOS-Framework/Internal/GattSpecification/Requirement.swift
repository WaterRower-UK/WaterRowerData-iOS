import Foundation

protocol Requirement {

    func check(in data: Data) -> Bool
}
