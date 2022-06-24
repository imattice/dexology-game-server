//
//  IndexSelectJob.swift
//  
//
//  Created by Ike Mattice on 6/23/22.
//

import Vapor
import Queues

public struct IndexSelectJob: ScheduledJob {
    public func run(context: QueueContext) -> EventLoopFuture<Void> {
        GameManager.generateDaily()

        return context.eventLoop.makeSucceededVoidFuture()
    }
}
