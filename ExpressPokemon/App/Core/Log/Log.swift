//
//  Log.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 02/10/2023.
//

import Foundation

func logApp(_ text: String) {
#if DEBUG
    let thread = Thread.isMainThread ? "main thread" : "other thread"
    print("[\(thread)] ⭕️👀 \(text)")
#endif
}
