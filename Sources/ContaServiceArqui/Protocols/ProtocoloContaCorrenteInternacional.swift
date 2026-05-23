//
//  ProtocoloContaCorrenteInternacional.swift
//  ContaServiceArqui
//
//  Created by Éverton Alencar de Lima on 22/05/26.
//

import Foundation

protocol ProtocoloContaCorrenteInternacional:ProtocoloContaCorrente {
    var taxaIOF:Decimal {get}
    var cambioDolar:Decimal {get}
    
}
