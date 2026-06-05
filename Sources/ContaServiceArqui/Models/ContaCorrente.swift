//
//  ContaCorrente.swift
//  ContaServiceArqui
//
//  Created by Éverton Alencar de Lima on 18/05/26.
//

import Foundation
import Fluent
import Vapor

final class ContaCorrente: Model, Content, ProtocoloContaCorrente, @unchecked Sendable {

    static let schema = "contas_correntes"

    // MARK: - Propriedades Fluent (substituem as private(set) anteriores)
    @ID(key: .id)              var id: UUID?
    @Field(key: "nome")        var nome: String
    @Field(key: "saldo") var saldo: Double
    @Field(key: "salario_atual") var salarioAtual: Double
    @Field(key: "salario_anterior") var salarioAnterior: Double

    var negativado: Bool { saldo < 0 }

    // MARK: - Init obrigatório pelo Fluent (vazio)
    init() { }

    // MARK: - Init de uso normal
    public init(nome: String) {
        self.nome = nome
        self.saldo = 0.0
        self.salarioAtual = 0
        self.salarioAnterior = 0
    }

    // MARK: - Lógica de domínio (igual ao monolito)
    public func registraNovoSalario(valor: Double) -> Resultado {
        self.salarioAnterior = self.salarioAtual
        self.salarioAtual = valor
        print("Seu novo salario é de: \(valor)")
        return .sucesso(novoValor: salarioAtual)
    }

    public func depositar(valor: Double) -> Resultado {
        guard valor > 0 else {
            return .falha(erro: "Valor de depósito inválido. Deve ser maior que zero.")
        }
        saldo += valor
        print("Depósito de R$ \(valor) realizado. Novo saldo: R$ \(saldo)")
        return .sucesso(novoValor: saldo)
    }

    public func sacar(valor: Double) -> Resultado {
        saldo -= valor
        print("Saque de R$ \(valor) realizado. Novo saldo: R$ \(saldo)")
        return .sucesso(novoValor: saldo)
    }

    public func verificarDadosCadastrais() -> String {
        return "Seus dados são, nome: \(nome)..."
    }

    public func saldoAtual() -> Resultado {
        print("Seu saldo é de: \(saldo)")
        return .sucesso(novoValor: saldo)
    }
}
