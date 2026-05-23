//
//  ProtocoloConta.swift
//  ContaServiceArqui
//
//  Created by Éverton Alencar de Lima on 18/05/26.
//


import Foundation

protocol ProtocoloConta {
    var nome: String {get }
    var saldo : Decimal {get }
    var negativado : Bool {get }
    func depositar(valor: Decimal)->Resultado
    func sacar(valor: Decimal)->Resultado
    func verificarDadosCadastrais() ->String
    func saldoAtual() -> Resultado
}
