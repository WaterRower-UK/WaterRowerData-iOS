enum Format {

    case UInt8
    case UInt16
    case UInt24
    case SInt16
}

extension Format {

    func numberOfBytes() -> Int {
        switch self {
            case .UInt8:
                return 1
            case .UInt16:
                return 2
            case .UInt24:
                return 3
            case .SInt16:
                return 2
        }
    }
}
