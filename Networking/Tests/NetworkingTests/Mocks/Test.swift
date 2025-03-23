//
//  Test.swift
//  Networking
//
//  Created by Miguel Alcantara on 23/03/2025.
//

@testable import Networking
import Testing

struct HTTPMethodTests {

    @Test(
        "Method rawValue is always uppercased",
        arguments: [
            (HTTPMethod.get, "GET"),
            (HTTPMethod.post, "POST"),
            (HTTPMethod.put, "PUT"),
            (HTTPMethod.delete, "DELETE")
        ]
    )
    func rawValue_isUppercased(method: HTTPMethod, result: String) async throws {
        #expect(method.rawValue == result)
    }

}
