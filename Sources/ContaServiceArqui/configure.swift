import Vapor
import Fluent
import FluentPostgresDriver

public func configure(_ app: Application) async throws {
    
    app.migrations.add(CreateContaCorrente())
    app.migrations.add(CreateContaCorrenteInternacional())
    app.migrations.add(CreateContaPoupanca())
    try await app.autoMigrate()

    if let databaseURL = Environment.get("DATABASE_URL") {
        try app.databases.use(.postgres(url: databaseURL), as: .psql)
    } else {
        let config = SQLPostgresConfiguration(
            hostname: "localhost",
            port: SQLPostgresConfiguration.ianaPortNumber,
            username: "vapor",
            password: "ContaService123",
            database: "conta_service",
            tls: .disable
        )
        app.databases.use(
            .postgres(configuration: config),
            as: .psql
        )
    }

    
    try routes(app)
}
