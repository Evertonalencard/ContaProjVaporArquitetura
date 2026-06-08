import Vapor
import Fluent
import FluentPostgresDriver
import NIOSSL

public func configure(_ app: Application) async throws {

    if let databaseURL = Environment.get("DATABASE_URL"),
       let url = URL(string: databaseURL) {

        let username = url.user ?? "vapor"
        let password = url.password ?? ""
        let hostname = url.host ?? "localhost"
        let port = url.port ?? 5432
        let database = url.path.replacingOccurrences(of: "/", with: "")

        app.databases.use(
            .postgres(
                hostname: hostname,
                port: port,
                username: username,
                password: password,
                database: database,
                tlsConfiguration: .forClient(certificateVerification: .none)
            ),
            as: .psql
        )

    } else {
        app.databases.use(
            .postgres(
                hostname: "localhost",
                port: 5432,
                username: "vapor",
                password: "ContaService123",
                database: "conta_service",
                tlsConfiguration: nil
            ),
            as: .psql
        )
    }

    app.migrations.add(CreateContaCorrente())
    app.migrations.add(CreateContaCorrenteInternacional())
    app.migrations.add(CreateContaPoupanca())
    app.migrations.add(AddSalarioToContaCorrente())
    app.migrations.add(AddSalarioToContaCorrenteInternacional())

    try await app.autoMigrate()
    try routes(app)
}
