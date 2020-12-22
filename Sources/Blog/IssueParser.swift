//
//  IssueParser.swift
//  
//
//  Created by Eneko Alonso on 12/22/20.
//

import Foundation
import struct Logging.Logger

public struct IssueParser {
    let logger: Logger
    let decoder: JSONDecoder
    let dateFormatter: DateFormatter

    public init(logger: Logger) {
        self.logger = logger

        dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
    }

    public func parse(eventPayload: String) throws -> GitHubContext {
        return try decoder.decode(GitHubContext.self, from: Data(eventPayload.utf8))
    }
}
