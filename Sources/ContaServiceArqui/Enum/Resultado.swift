//
//  Resultado.swift
//  ContaServiceArqui
//
//  Created by Éverton Alencar de Lima on 22/05/26.
//
import Foundation
enum Resultado {
    case sucesso(novoValor: Decimal)
    case falha(erro: String)
}
