import XCTest
import Blog
import struct Logging.Logger

func loadJSON<T: Codable>(json: String) throws -> T {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    decoder.dateDecodingStrategy = .iso8601
    return try decoder.decode(T.self, from: Data(json.utf8))
}

final class BlogTests: XCTestCase {

    func testPayload() throws {
        let payload = try loadJSON(json: gitHubIssueEvent) as GitHubContext
        XCTAssertEqual(payload.eventName, "issues")
        XCTAssertEqual(payload.event.action, "opened")
    }

    func testParser() throws {
        let logger = Logger(label: "parser-test")
        let parser = IssueParser(logger: logger)
        let payload = try parser.parse(eventPayload: gitHubIssueEvent)
        XCTAssertEqual(payload.eventName, "issues")
        XCTAssertEqual(payload.event.action, "opened")
    }

    func testRenderer() throws {
        let logger = Logger(label: "parser-test")
        let parser = IssueParser(logger: logger)
        let payload = try parser.parse(eventPayload: gitHubIssueEvent)
        let post = PostRenderer().render(issue: payload.event.issue)
        print(post)
    }
}
