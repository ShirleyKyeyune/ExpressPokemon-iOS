//
//  HTTPMethod.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 02/10/2023.
//

public enum HTTPMethod: Equatable {
    /** The GET method is utilized to retrieve data from a specified resource.
        It should solely be used for data retrieval, without causing any side-effects. */
    case get

    /**
        The POST method is employed to send data to a server to create/update a resource.
        It often results in a change in the server's state or side-effects.
    */
    case post

    /**
        The PUT method is employed to update a current resource with new data,
        replacing all existing representations of the resource with the provided data.
    */
    case put

    /**
        The DELETE method is used to remove a specified resource from the server.
    */
    case delete

    /// Property to obtain the string representation of the HTTP method.
    var name: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        case .delete:
            return "DELETE"
        }
    }
}
