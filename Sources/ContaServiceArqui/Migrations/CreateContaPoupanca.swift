//
//  CreateConta.swift
//  ContaServiceArqui
//
//  Created by Éverton Alencar de Lima on 18/05/26.
//

import Fluent

struct CreateContaPoupanca: AsyncMigration {

    func prepare(on database: any Database) async throws {
        try await database.schema("contas_poupancas")
            .id()
            .field("nome",  .string, .required)
            .field("saldo", .string, .required)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("contas_poupancas").delete()
    }
}
