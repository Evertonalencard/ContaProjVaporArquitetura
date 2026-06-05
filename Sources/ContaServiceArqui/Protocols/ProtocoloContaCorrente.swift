//
//  ProtocoloContaCorrente.swift
//  ContaServiceArqui
//
//  Created by Éverton Alencar de Lima on 18/05/26.
//


import Foundation

protocol ProtocoloContaCorrente: ProtocoloConta{
    var salarioAtual: Double {get }
    var salarioAnterior: Double {get }
    func registraNovoSalario(valor: Double) -> Resultado
}

