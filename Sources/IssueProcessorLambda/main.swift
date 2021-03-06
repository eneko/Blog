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

struct Handler: LambdaHandler {
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

    func handle(context: Lambda.Context, event: In, callback: @escaping (Result<Out, Error>) -> Void) {
        do {
            let group = DispatchGroup()
            for message in event.records {
                group.enter()
                let githubContext = try parser.parseContext(json: message.body)
                try processor.process(githubEvent: githubContext.event) {
                    group.leave()
                }
            }
            group.wait()
            callback(.success(""))
        }
        catch {
            callback(.failure(error))
        }
    }
}

Lambda.run(Handler.init)
