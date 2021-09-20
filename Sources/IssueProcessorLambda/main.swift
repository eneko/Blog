//
//  PostRenderer.swift
//
//
//  Created by Eneko Alonso on 12/22/20.
//

import AWSLambdaRuntime
import AWSLambdaEvents
import Dispatch
import NIO
import Blog
import IssueParser
import _NIOConcurrency

@available(macOS 9999, iOS 9999, watchOS 9999, tvOS 9999, *)
struct Handler: AsyncLambdaHandler {
    typealias In = SQS.Event
    typealias Out = String // Response type

    let parser: IssueParser
    let processor: IssueProcessor

    /// Business logic is initialized during lambda cold start
    /// - Parameter context: Lambda initialization context, provided by AWS
    init(context: Lambda.InitializationContext) {
        parser = IssueParser(logger: context.logger)
        processor = IssueProcessor(logger: context.logger)
    }

    func handle(event: SQS.Event, context: Lambda.Context) async throws -> Out {
        for message in event.records {
            let githubContext = try parser.parseContext(json: message.body)
            try await processor.process(githubEvent: githubContext.event)
        }
        return ""
    }
}

if #available(macOS 9999, *) {
    Lambda.run(Handler.init)
}
