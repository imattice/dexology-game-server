//
//  IndexSelectJob.swift
//  
//
//  Created by Ike Mattice on 6/23/22.
//

import Vapor
import Queues

public struct IndexSelectJob: AsyncScheduledJob {
    public func run(context: QueueContext) async throws {
        await GameManager.generateDaily(on: context.application.db)
    }
}
