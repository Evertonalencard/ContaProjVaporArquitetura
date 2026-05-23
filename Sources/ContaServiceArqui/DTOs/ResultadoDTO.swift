//
//  ResultadoDTO.swift
//  ContaServiceArqui
//
//  Created by Éverton Alencar de Lima on 22/05/26.
//
import Foundation
import Vapor

struct ResultadoDTO: Content {
    let sucesso: Bool
    let id: UUID?
    let novoValor: Decimal?
    let erro: String?

    // converte o enum interno para o DTO que vai pela rede
    init(from resultado: Resultado) {
            switch resultado {
            case .sucesso(let v):
                self.sucesso = true; self.id = nil; self.novoValor = v; self.erro = nil
            case .falha(let e):
                self.sucesso = false; self.id = nil; self.novoValor = nil; self.erro = e
            }
        }
    
    // ✅ novo init direto — para usar no criarContaCorrente
    init(sucesso: Bool, id:UUID? = nil, novoValor: Decimal?, erro: String?) {
        self.sucesso = sucesso
        self.id = id
        self.novoValor = novoValor
        self.erro = erro
    }
}
