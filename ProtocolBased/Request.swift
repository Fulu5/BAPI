//
//  Request.swift
//  ProtocolBased
//
//  Created by Guanxiong Cao  on 15/12/2016.
//  Copyright © 2016 Guanxiong Cao . All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get
    case post
}

protocol Request {
    var host: String { get }
    var path: String { get }
    var parameters: [String: Any] { get }
    var method: HTTPMethod { get }
    
    associatedtype Response
    func parse(data: Data) -> Response?
}

extension Request {
    // 在请求完成后，我们调用这个 handler 方法来通知调用者请求是否完成
    func send(handler: @escaping(Response?) -> Void) {
        let url = URL(string: host.appending(path))!
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        let task = URLSession.shared.dataTask(with: request) {
            data, _, error in
            if let data = data, let model = self.parse(data: data) {
                DispatchQueue.main.async { handler(model) }
            } else {
                DispatchQueue.main.async { handler(nil) }
            }
        }
        task.resume()
    }
}

struct UserRequest: Request {
    let name: String
    let host = "https://api.onevcat.com"
    var path: String {
        return "/users/\(name)"
    }
    let parameters: [String : Any] = [:]
    let method: HTTPMethod = .get
    
    typealias Response = User
    func parse(data: Data) -> Response? {
        return User(data: data)
    }
}

