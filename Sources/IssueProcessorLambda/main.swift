import AWSLambdaRuntime
import AWSLambdaEvents
import NIO
import Blog

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
            for message in event.records {
                let githubContext = try parser.parse(eventPayload: message.body)
                try processor.process(githubEvent: githubContext.event)
            }
            callback(.success(""))
        }
        catch {
            callback(.failure(error))
        }
    }
}

Lambda.run(Handler.init)