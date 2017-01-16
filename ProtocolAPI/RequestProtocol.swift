//
//  RequestProtocol.swift
//  ProtocolAPI
//
//  Created by Guanxiong Cao  on 16/01/2017.
//  Copyright © 2017 Guanxiong Cao . All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get
    case post
}

protocol Request {

    var path: String { get }
    var method: HTTPMethod { get }
    
    associatedtype Response: Decodable
}

extension Request {
    var request: String {
        return Client().host.appending(path)
    }
}

protocol RequestSender {
    func sendRequest<T: Request>(_ r: T, handler: @escaping(T.Response?) -> Void)
}

protocol Decodable {
    static func parse(data: Data) -> Self?
}
