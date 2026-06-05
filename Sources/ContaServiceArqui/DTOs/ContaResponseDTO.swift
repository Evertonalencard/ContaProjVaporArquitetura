//
//  ContaResponseDTO.swift
//  ContaServiceArqui
//
//  Created by Éverton Alencar de Lima on 02/06/26.
//

import Vapor

enum TipoContaDTO: String, Content {
    case corrente
    case poupanca
    case internacional
}

struct ContaResponseDTO: Content {
    let id: UUID
    let nome: String
    let saldo: Double
    let tipo: String
}
