//
//  ProtocoloConta.swift
//  ContaServiceArqui
//
//  Created by Éverton Alencar de Lima on 18/05/26.
//


import Foundation

protocol ProtocoloConta {
    var nome: String {get }
    var saldo : Double {get }
    var negativado : Bool {get }
    func depositar(valor: Double)->Resultado
    func sacar(valor: Double)->Resultado
    func verificarDadosCadastrais() ->String
    func saldoAtual() -> Resultado
}
