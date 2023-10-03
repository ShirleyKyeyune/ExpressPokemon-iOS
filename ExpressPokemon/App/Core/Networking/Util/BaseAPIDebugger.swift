//
//  BaseAPIDebugger.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 02/10/2023.
//

import Foundation

struct BaseAPIDebugger {
    func log(request: URLRequest?, error: Error?) {
        printDivider(title: "Request Log Starts")

        if let request = request {
            logRequest(request)
        }

        if let error = error as NSError? {
            logError(error)
        }

        printDivider(title: "Request Log Ends")
    }

    private func printDivider(title: String) {
        debugPrint("--------------- \(title) ---------------\n")
    }

    private func logRequest(_ request: URLRequest) {
        if let url = request.url {
            debugPrint("Request URL - \(url)\n")
        }
        if let body = request.httpBody, let json = body.printableJSON {
            debugPrint("Request Body -\n\(json)\n")
        }
        printDivider(title: "Request Headers")
        request.allHTTPHeaderFields?.forEach { key, value in
            debugPrint("\(key) - \(value)")
        }
        debugPrint("\n")
    }

    private func logError(_ error: NSError) {
        printDivider(title: "Error")
        debugPrint("Error Code - \(error.code)\n")
        debugPrint("Error Domain - \(error.domain)\n")
        debugPrint("Error UserInfo - \(error.userInfo)\n")
    }
}
