//
//  SaqueHandlerBase.swift
//  ContaServiceArqui
//
//  Created by Éverton Alencar de Lima on 18/05/26.
//

import Foundation

class SaqueHandlerBase: SaqueHandler {
    var proximo: (any SaqueHandler)?

    func handle(request: SaqueRequest) -> Resultado {
        return proximo?.handle(request: request)
            ?? .falha(erro: "Nenhum handler processou a requisição.")
    }
}
