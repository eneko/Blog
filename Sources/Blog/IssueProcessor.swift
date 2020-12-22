//
//  IssueProcessor.swift
//  
//
//  Created by Eneko Alonso on 12/22/20.
//

import Foundation
import struct Logging.Logger

public struct IssueProcessor {

    let logger: Logger

    public init(logger: Logger) {
        self.logger = logger
    }

    public func process(githubEvent: GitHubEvent) throws {
        logger.debug("Event: \(githubEvent)")
    }

}
