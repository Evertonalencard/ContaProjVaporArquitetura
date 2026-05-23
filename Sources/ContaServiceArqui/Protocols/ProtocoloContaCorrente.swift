//
//  ProtocoloContaCorrente.swift
//  ContaServiceArqui
//
//  Created by Éverton Alencar de Lima on 18/05/26.
//


import Foundation

protocol ProtocoloContaCorrente: ProtocoloConta{
    var salarioAtual: Decimal {get }
    var salarioAnterior: Decimal {get }
    func registraNovoSalario(valor: Decimal) -> Resultado
}

