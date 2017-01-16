//
//  UserRequest.swift
//  ProtocolAPI
//
//  Created by Guanxiong Cao  on 16/01/2017.
//  Copyright © 2017 Guanxiong Cao . All rights reserved.
//

import Foundation

struct UserRequest: Request {
    let name: String
    var path: String {
        return "/users/\(name)"
    }
    let method: HTTPMethod = .get
    
    typealias Response = User
}


extension User: Decodable {
    static func parse(data: Data) -> User? {
        return User(data: data)
    }
}
