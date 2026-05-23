// Sources/ContaServiceArqui/configure.swift
import Vapor
import Fluent
import FluentMySQLDriver

public func configure(_ app: Application) async throws {

    if let databaseURL = Environment.get("DATABASE_URL") {
        // ✅ nova API para URL
        try app.databases.use(.mysql(url: databaseURL), as: .mysql)
    } else {
        // ✅ nova API para conexão manual
        app.databases.use(
            DatabaseConfigurationFactory.mysql(configuration: .init(
                hostname: "localhost",
                port:     3307,
                username: "Everton",
                password: "ContaService123",
                database: "conta_service",
                tlsConfiguration: .none  // só para dev local
            )),
            as: .mysql
        )
    }

    app.migrations.add(CreateContaCorrente())
    app.migrations.add(CreateContaCorrenteInternacional())
    app.migrations.add(CreateContaPoupanca())
    try await app.autoMigrate()
    try routes(app)
}
