//
//  ContaCorrenteInternacional.swift
//  ContaServiceArqui
//
//  Created by Éverton Alencar de Lima on 18/05/26.
//

import Foundation
import Vapor
import Fluent

final class ContaCorrenteInternacional: Model, Content, ProtocoloContaCorrenteInternacional, @unchecked Sendable {
    static let schema = "contas_correntes_internacionais"

    // MARK: - Propriedades Fluent (substituem as private(set) anteriores)
    @ID(key: .id)              var id: UUID?
    @Field(key: "nome")        var nome: String
    @Field(key: "saldo")       var saldo: Decimal
    @Field(key: "salario_atual")    var salarioAtual: Decimal
    @Field(key: "salario_anterior") var salarioAnterior: Decimal
    @Field(key: "Taxa_iof") var taxaIOF: Decimal
    @Field(key: "cambio_dolar") var cambioDolar: Decimal

    var negativado: Bool { saldo < 0 }
    
    // MARK: - Init obrigatório pelo Fluent (vazio)
    init() { }

    // MARK: - Init de uso normal
    public init(nome: String) {
        self.nome = nome
        self.saldo = 0.0
        self.salarioAtual = 0
        self.salarioAnterior = 0
        self.cambioDolar = 5.50
        self.taxaIOF = 0.038
    }
    
    public func registraNovoSalario(valor: Decimal) -> Resultado {
        self.salarioAnterior = self.salarioAtual
        self.salarioAtual = valor
        print("Seu novo salario é de: \(valor) USD")
        return .sucesso(novoValor: salarioAtual)
    }
    
    public func verificarDadosCadastrais()->String{
        return "Seus dados são, nome: \(nome)..."
    }
    
    public func depositar(valor: Decimal) -> Resultado {
        guard valor > 0 else {
            return .falha(erro: "Valor de depósito inválido. Deve ser maior que zero.")
        }
        print("Depositando em dolar")
        
        saldo += valor
        print("Depósito de R$ \(valor) realizado. Novo saldo: $\(saldo)")
        return .sucesso(novoValor: saldo)
    }
    
    public func sacar(valor: Decimal) -> Resultado {
        
        let valorIOF = valor * taxaIOF
        let totalDebitado = valor + valorIOF
        
        print("Iniciando saque em Dólares (IOF de \(valorIOF) será aplicado)...")
        
        saldo -= totalDebitado
        return .sucesso(novoValor: saldo)
        
    }
    
    public func saldoAtual()->Resultado{
        print("saldo atual é\(saldo)usd")
        
        return .sucesso(novoValor: saldo)
    }
}
