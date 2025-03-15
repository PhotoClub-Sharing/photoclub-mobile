import XCTest
import OSLog
import Foundation
@testable import PhotoClub

let logger: Logger = Logger(subsystem: "PhotoClub", category: "Tests")

@available(macOS 13, *)
final class PhotoClubTests: XCTestCase {

    func testPhotoClub() throws {
        logger.log("running testPhotoClub")
        XCTAssertEqual(1 + 2, 3, "basic test")
    }

    func testDecodeType() throws {
        // load the TestData.json file from the Resources folder and decode it into a struct
        let resourceURL: URL = try XCTUnwrap(Bundle.module.url(forResource: "TestData", withExtension: "json"))
        let testData = try JSONDecoder().decode(TestData.self, from: Data(contentsOf: resourceURL))
        XCTAssertEqual("PhotoClub", testData.testModuleName)
    }

}

struct TestData : Codable, Hashable {
    var testModuleName: String
}
