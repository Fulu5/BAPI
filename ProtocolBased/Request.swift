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

//1.request entry and response protocol
//  Request 应该做的事情应该仅仅是定义请求入口和期望的响应类型
protocol Request {
    var path: String { get }
    var method: HTTPMethod { get }
    
    associatedtype Response: Decodable
}

//2.send request protocol
protocol Client {
    //Request 是含有关联类型的协议，所以它并不能作为独立的类型来使用，我们只能够将它作为类型约束，来限制输入参数 request
    func send<T: Request>(_ r: T, handler: @escaping(T.Response?) -> Void)
    var host: String { get }
}

//3.解析数据protocol
protocol Decodable {
    static func parse(data: Data) -> Self?
}

//4.specific request entry
struct UserRequest: Request {
    let name: String
    var path: String {
        return "/users/\(name)"
    }
    let method: HTTPMethod = .get
    
    typealias Response = User
}

//5.specific send
//提取send方法, 将发送请求的部分和请求本身分离开
struct URLSessionClient: Client {
    let host = "https://api.onevcat.com"
    func send<T : Request>(_ r: T, handler: @escaping (T.Response?) -> Void) {
        let url = URL(string: host.appending(r.path))!
        var request = URLRequest(url: url)
        request.httpMethod = r.method.rawValue
        let task = URLSession.shared.dataTask(with: request) {
            data, _, error in
            if let data = data, let res = T.Response.parse(data: data) {
                DispatchQueue.main.async {
                    handler(res)
                }
            } else {
                DispatchQueue.main.async {
                    handler(nil)
                }
            }
        }
        task.resume()
    }
}

//6.sepcific parse
extension User: Decodable {
    static func parse(data: Data) -> User? {
        return User(data: data)
    }
}

