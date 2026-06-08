//
//  AddSalarioToContaCorrenteInternacional.swift
//  ContaServiceArqui
//
//  Created by Éverton Alencar de Lima on 07/06/26.
//

import Fluent

struct AddSalarioToContaCorrenteInternacional: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("contas_correntes_internacionais")
            .field("salario_atual", .double, .required, .sql(.default(0)))
            .field("salario_anterior", .double, .required, .sql(.default(0)))
            .update()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("contas_correntes_internacionais")
            .deleteField("salario_atual")
            .deleteField("salario_anterior")
            .update()
    }
}
