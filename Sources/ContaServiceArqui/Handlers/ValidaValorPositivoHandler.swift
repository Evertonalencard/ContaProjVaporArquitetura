//
//  ValidaValorPositivoHandler.swift
//  ContaServiceArqui
//
//  Created by Éverton Alencar de Lima on 18/05/26.
//

import Foundation

class ValidaValorPositivoHandler: SaqueHandlerBase {
    override func handle(request: SaqueRequest) -> Resultado {
        guard request.valor > 0 else {
            return .falha(erro: "Valor de saque inválido. Deve ser maior que zero.")
        }
        return super.handle(request: request)
    }
}
