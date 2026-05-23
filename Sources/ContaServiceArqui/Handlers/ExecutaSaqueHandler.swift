//
//  ExecutaSaqueHandler.swift
//  ContaServiceArqui
//
//  Created by Éverton Alencar de Lima on 18/05/26.
//


import Foundation

class ExecutaSaqueHandler: SaqueHandlerBase {
    override func handle(request: SaqueRequest) -> Resultado {
        return request.conta.sacar(valor: request.valor)
    }
}
