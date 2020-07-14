import Foundation

protocol Cancellable {

    func cancel()
}

class Cancelled: Cancellable {

    func cancel() {

    }
}
