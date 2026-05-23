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
            .field("nome",             .string,  .required)
            .field("saldo",            .string,  .required) // Decimal vira string no Fluent
            .field("salario_atual",    .string,  .required)
            .field("salario_anterior", .string,  .required)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("contas_correntes").delete()
    }
}
