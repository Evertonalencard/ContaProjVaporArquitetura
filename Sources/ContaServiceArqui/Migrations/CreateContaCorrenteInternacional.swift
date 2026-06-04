//
//  CreateContaCorrenteInternacional.swift
//  ContaServiceArqui
//
//  Created by Éverton Alencar de Lima on 23/05/26.
//

// Sources/ContaServiceArqui/Migrations/CreateContaCorrenteInternacional.swift
import Fluent

struct CreateContaCorrenteInternacional: AsyncMigration {
    
    func prepare(on database: any Database) async throws {
        try await database.schema("contas_correntes_internacionais")
            .id()
            .field("nome", .string, .required)
            .field("saldo", .double, .required)
            .field("salario_atual", .double, .required)
            .field("salario_anterior", .double, .required)
            .field("taxa_iof",         .double, .required)
            .field("cambio_dolar",     .double, .required)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("contas_correntes_internacionais").delete()
    }
}
