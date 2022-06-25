//
//  JobManager.swift
//  
//
//  Created by Ike Mattice on 6/25/22.
//

import Vapor

public enum JobManager {
    private static let redisUrl: String = "redis://127.0.0.1:6379"

    public static func setUp(for app: Application) throws {
        // Set up queues
        try app.queues.use(.redis(url: redisUrl))

        queueJobs(for: app)

        try app.queues.startScheduledJobs()
    }

    private static func queueJobs(for app: Application) {
        let indexSelectJob = IndexSelectJob()
        app.queues.schedule(indexSelectJob).everySecond() //.minutely().at(0)
    }
}
