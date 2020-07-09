import Foundation

class RowerDataCharacteristic {

    static func decode(data: Data) -> RowerData {
        return RowerData(
            averageStrokeRate: averageStrokeRate(from: data),
            totalDistanceMeters: totalDistanceMeters(from: data),
            instantaneousPaceSeconds: instantaneousPaceSeconds(from: data)
        )
    }

    private static let fields: [Field] = [
        rowerDataFlagsField,
        rowerDataAverageStrokeRateField,
        rowerDataTotalDistanceField,
        rowerDataInstantaneousPaceField
    ]

    private static func averageStrokeRate(from data: Data) -> Double? {
        if !rowerDataAverageStrokeRateField.isPresent(in: data) {
            return nil
        }

        var offset = 0
        for i in 0..<fields.count {
            let field = fields[i]
            if field.name == rowerDataAverageStrokeRateField.name {
                let intValue = data.readIntValue(format: field.format, offset: offset)
                return Double(intValue) * (pow(2.0, -1.0))
            }

            if field.isPresent(in: data) {
                offset += field.format.numberOfBytes()
            }
        }

        return nil
    }

    private static func totalDistanceMeters(from data: Data) -> Int? {
        if !rowerDataTotalDistanceField.isPresent(in: data) {
            return nil
        }

        var offset = 0
        for i in 0..<fields.count {
            let field = fields[i]
            if field.name == rowerDataTotalDistanceField.name {
                let intValue = data.readIntValue(format: field.format, offset: offset)
                return intValue
            }

            if field.isPresent(in: data) {
                offset += field.format.numberOfBytes()
            }
        }

        return nil
    }

    private static func instantaneousPaceSeconds(from data: Data) -> Int? {
        if !rowerDataInstantaneousPaceField.isPresent(in: data) {
            return nil
        }

        var offset = 0
        for i in 0..<fields.count {
            let field = fields[i]
            if field.name == rowerDataInstantaneousPaceField.name {
                let intValue = data.readIntValue(format: field.format, offset: offset)
                return intValue
            }

            if field.isPresent(in: data) {
                offset += field.format.numberOfBytes()
            }
        }

        return nil
    }
}
