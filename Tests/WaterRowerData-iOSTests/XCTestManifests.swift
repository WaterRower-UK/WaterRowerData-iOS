import XCTest

#if !canImport(ObjectiveC)
    public func allTests() -> [XCTestCaseEntry] {
        return [
            testCase(WaterRowerData_iOSTests.allTests),
        ]
    }
#endif
