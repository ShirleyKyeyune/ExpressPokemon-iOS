//
//  RequestBuilder.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 02/10/2023.
//

import Foundation

protocol RequestBuilder: NetworkTarget {
    var pathAppendedURL: URL? { get }

    init(request: NetworkTarget)

    func setQueryTo(urlRequest: inout URLRequest,
                    urlEncoding: URLEncoding,
                    queryParams: [String: String])
    func encodedBody(bodyEncoding: BodyEncoding, requestBody: [String: Any]) -> Data?
    func buildURLRequest() -> URLRequest?
}
