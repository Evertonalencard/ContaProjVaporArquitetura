//
//  SaqueHandler.swift
//  ContaServiceArqui
//
//  Created by Éverton Alencar de Lima on 18/05/26.
//

import Foundation

protocol SaqueHandler: AnyObject {
    var proximo: (any SaqueHandler)? { get set }
    func handle(request: SaqueRequest) -> Resultado
}
