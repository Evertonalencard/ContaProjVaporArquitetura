//
//  CreateContaCorrente.swift
//  ContaServiceArqui
//
//  Created by Éverton Alencar de Lima on 23/05/26.
//

import Fluent

struct CreateContaCorrente: AsyncMigration {

    func prepare(on database: any Database) async throws {
        try await database.schema("contas_correntes")
            .id()
            .field("nome", .string, .required)
            .field("saldo", .double, .required)
            .field("salario_atual", .double, .required)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("contas_correntes").delete()
    }
}
