//
//  SaqueRequest.swift
//  ContaServiceArqui
//
//  Created by Éverton Alencar de Lima on 18/05/26.
//

import Foundation

struct SaqueRequest {
    let valor: Decimal
    let conta: any ProtocoloConta
}
