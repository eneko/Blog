import XCTest
import Blog
import IssueParser
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
        let payload = try parser.parseContext(json: gitHubIssueEvent)
        XCTAssertEqual(payload.eventName, "issues")
        XCTAssertEqual(payload.event.action, "opened")
    }

    func testRenderer() throws {
        let logger = Logger(label: "parser-test")
        let parser = IssueParser(logger: logger)
        let payload = try parser.parseContext(json: gitHubIssueEvent)
        let post = PostRenderer(issue: payload.event.issue).render()
        XCTAssertTrue(post.contains("https://github.com/eneko/Blog/issues/4"))
    }

    func testRendererFilename() throws {
        let logger = Logger(label: "parser-test")
        let parser = IssueParser(logger: logger)
        let payload = try parser.parseContext(json: gitHubIssueEvent)
        let filename = PostRenderer(issue: payload.event.issue).filename
        XCTAssertEqual(filename, "_posts/2020-12-22-issue-4.md")
    }
}
