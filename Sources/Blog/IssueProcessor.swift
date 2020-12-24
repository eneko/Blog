//
//  IssueProcessor.swift
//  
//
//  Created by Eneko Alonso on 12/22/20.
//

import Foundation
import struct Logging.Logger
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct WorkflowDispatch: Codable {
    let ref: String
    let inputs: Inputs

    struct Inputs: Codable {
        let content: String
        let filename: String
    }
}

public struct IssueProcessor {
    let endpoint = "https://api.github.com/repos/eneko/eneko.github.io/actions/workflows/4476169/dispatches"

    let logger: Logger
    let accessToken: String
    let username: String

    public init(logger: Logger) {
        self.logger = logger

        username = ProcessInfo.processInfo.environment["GITHUB_REMOTE_UPDATE_USERNAME"] ?? "[NO USER]"
        accessToken = ProcessInfo.processInfo.environment["GITHUB_REMOTE_UPDATE_TOKEN"] ?? "[NO TOKEN]"
    }

    public func process(githubEvent: GitHubEvent, completion: @escaping () -> Void) throws {
        logger.debug("Event: \(githubEvent)")

        let renderer = PostRenderer(issue: githubEvent.issue)
        let content = renderer.render()
        let filename = renderer.filename

        try triggerGitHubAction(content: content, filename: filename, completion: completion)
    }

    func triggerGitHubAction(content: String, filename: String, completion: @escaping () -> Void) throws {
        guard let url = URL(string: endpoint) else {
            fatalError("Failed to make URL")
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        request.addValue(authHeader, forHTTPHeaderField: "Authorization")
        request.httpBody = try httpBody(content: content, filename: filename)

        let dataTask = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                self.logger.error("Failed to submit workflow dispatch request to GitHub Actions")
                self.logger.error("\(error.localizedDescription)")
            } else {
                self.logger.debug("Submitted workflow dispatch request to GitHub Actions")
            }
            completion()
        }
        dataTask.resume()
    }

    var authHeader: String {
        let encoded = Data("\(username):\(accessToken)".utf8).base64EncodedString()
        return "Basic \(encoded)"
    }

    func httpBody(content: String, filename: String) throws -> Data {
        let trigger = WorkflowDispatch(ref: "main", inputs: .init(content: content, filename: filename))
        return try JSONEncoder().encode(trigger)
    }
}
