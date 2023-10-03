//
//  Dictionary+Encoding+Extension.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 02/10/2023.
//

import Foundation

extension Dictionary where Key == String, Value == String {
    /// Encodes query parameters into a URL-encoded string.
    func urlEncodedQueryParams() -> String {
        map { key, value in
            guard let encodedValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryParameterAllowed) else { return nil }
            return "\(key)=\(encodedValue)"
        }
        .compactMap { $0 }
        .joined(separator: "&")
    }
}

extension Dictionary where Key == String, Value == Any {
    /// Encodes the request body into a URL-encoded data object.
    func urlEncodedBody() throws -> Data {
        let bodyString = map { key, value in
            "\(key)=\(value)"
        }
        .joined(separator: "&")

        guard let bodyData = bodyString.data(using: .utf8) else {
            throw APIError.unknown
        }

        return bodyData
    }
}

extension CharacterSet {
    /// A character set containing the URL query parameter-allowed characters.
    static let urlQueryParameterAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // Excluding "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        let encodableDelimiters = CharacterSet(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return CharacterSet.urlQueryAllowed.subtracting(encodableDelimiters)
    }()
}

extension URL {
    var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems else {
            return nil
        }

        return queryItems.reduce(into: [String: String]()) { result, item in
            result[item.name] = item.value
        }
    }
}
