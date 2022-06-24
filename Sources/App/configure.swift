import Vapor
import Queues
import QueuesRedisDriver

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // Set up queues
    try app.queues.use(.redis(url: "redis://127.0.0.1:6379"))
    let indexSelectJob = IndexSelectJob()
    app.queues.schedule(indexSelectJob).everySecond() //.minutely().at(0)
//    app.queues.schedule(indexSelectJob).daily().at(.midnight)

//    try app.queues.startInProcessJobs(on: .default)
    try app.queues.startScheduledJobs()


    // register routes
    try routes(app)
}
