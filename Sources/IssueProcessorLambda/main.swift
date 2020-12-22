import AWSLambdaRuntime
import AWSLambdaEvents
import NIO

struct Handler: EventLoopLambdaHandler {
    typealias In = SQS.Event
    typealias Out = String // Response type

    func handle(context: Lambda.Context, event: In) -> EventLoopFuture<Out> {
        let response = """
        Hello world
        \(event)

        """
        context.logger.debug("\(response)")
        return context.eventLoop.makeSucceededFuture(response)
    }
}

Lambda.run(Handler())
