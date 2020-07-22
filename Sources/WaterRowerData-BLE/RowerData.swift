import Foundation

/**
 A struct that contains decoded Rower Data.
 */
public struct RowerData {

    /**
     The instantaneous stroke rate in strokes/minute.
     */
    public let strokeRate: Double?

    /**
     The total number of strokes since the beginning of the training session.
     */
    public let strokeCount: Int?

    /**
     The average stroke rate since the beginning of the training session, in
     strokes/minute.
     */
    public let averageStrokeRate: Double?

    /**
     The total distance since the beginning of the training session, in meters.
     */
    public let totalDistanceMeters: Int?

    /**
     The value of the pace (time per 500 meters) of the user while exercising,
     in seconds.
     */
    public let instantaneousPaceSeconds: Int?

    /**
     The value of the average pace (time per 500 meters) since the beginning of
     the training session, in seconds.
     */
    public let averagePaceSeconds: Int?

    /**
     The value of the instantaneous power in Watts.
     */
    public let instantaneousPowerWatts: Int?

    /**
     The value of the average power since the beginning of the training session,
     in Watts.
     */
    public let averagePowerWatts: Int?

    /**
     The current value of the resistance level.
     */
    public let resistanceLevel: Int?

    /**
     The total expended energy of a user since the training session has started,
     in Kilocalories.
     */
    public let totalEnergyKiloCalories: Int?

    /**
     The average expended energy of a user during a period of one hour, in
     Kilocalories.
     */
    public let energyPerHourKiloCalories: Int?

    /**
     The average expended energy of a user during a period of one minute, in
     Kilocalories.
     */
    public let energyPerMinuteKiloCalories: Int?

    /**
     The current heart rate value of the user, in beats per minute.
     */
    public let heartRate: Int?

    /**
     The metabolic equivalent of the user.
     */
    public let metabolicEquivalent: Double?

    /**
     The elapsed time of a training session since the training session has
     started, in seconds.
     */
    public let elapsedTimeSeconds: Int?

    /**
     The remaining time of a selected training session, in seconds.
     */
    public let remainingTimeSeconds: Int?
}
