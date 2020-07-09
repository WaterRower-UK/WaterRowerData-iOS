import Foundation

extension Data {

    func readIntValue(format: Format, offset: Int) -> Int {
        switch format {
            case .UInt8:
                return unsignedByteToInt(self[offset])
            case .UInt16:
                return unsignedBytesToInt(self[offset], self[offset + 1])
            case .UInt24:
                return unsignedBytesToInt(self[offset], self[offset + 1], self[offset + 2])
            case .SInt16:
                return unsignedToSigned(unsignedBytesToInt(self[offset], self[offset + 1]), size: 16)
        }
    }

    private func unsignedByteToInt(_ b: UInt8) -> Int {
        return Int(b) & 0xFF
    }

    private func unsignedBytesToInt(_ b0: UInt8, _ b1: UInt8) -> Int {
        return unsignedByteToInt(b0) + (unsignedByteToInt(b1) << 8)
    }

    private func unsignedBytesToInt(_ b0: UInt8, _ b1: UInt8, _ b2: UInt8) -> Int {
        return unsignedByteToInt(b0) + (unsignedByteToInt(b1) << 8) + (unsignedByteToInt(b2) << 16)
    }

    private func unsignedBytesToInt(_ b0: UInt8, _ b1: UInt8, _ b2: UInt8, _ b3: UInt8) -> Int {
        return unsignedByteToInt(b0) +
            (unsignedByteToInt(b1) << 8) +
            (unsignedByteToInt(b2) << 16) +
            (unsignedByteToInt(b3) << 24)
    }

    /**
     Convert an unsigned integer value to a two's-complement encoded
     signed value.
     */
    private func unsignedToSigned(_ unsigned: Int, size: Int) -> Int {
        if unsigned & (1 << (size - 1)) == 0 {
            return unsigned
        }

        let a = 1 << size - 1
        return -1 * (a - (unsigned & (a - 1)))
    }
}
