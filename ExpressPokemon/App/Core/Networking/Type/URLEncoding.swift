//
//  URLEncoding.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 02/10/2023.
//

import Foundation

public enum URLEncoding: String {
    case `default` // GET, HEAD, DELETE, CONNECT, OPTIONS
    case xWWWFormURLEncoded = "application/x-www-form-urlencoded" // POST/PUT
    case percentEncoded
}

public enum BodyEncoding: String {
    case JSON
    case xWWWFormURLEncoded = "application/x-www-form-urlencoded"
}
