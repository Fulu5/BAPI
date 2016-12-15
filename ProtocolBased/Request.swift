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

//Request 应该做的事情应该仅仅是定义请求入口和期望的响应类型
protocol Request {
    var host: String { get }
    var path: String { get }
    var parameters: [String: Any] { get }
    var method: HTTPMethod { get }
    
    associatedtype Response
    func parse(data: Data) -> Response?
}

//extension Request {
//    // 在请求完成后，我们调用这个 handler 方法来通知调用者请求是否完成
//    func send(handler: @escaping(Response?) -> Void) {
//        let url = URL(string: host.appending(path))!
//        var request = URLRequest(url: url)
//        request.httpMethod = method.rawValue
//        
//        let task = URLSession.shared.dataTask(with: request) {
//            data, _, error in
//            if let data = data, let model = self.parse(data: data) {
//                DispatchQueue.main.async { handler(model) }
//            } else {
//                DispatchQueue.main.async { handler(nil) }
//            }
//        }
//        task.resume()
//    }
//}


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

protocol Client {
    //Request 是含有关联类型的协议，所以它并不能作为独立的类型来使用，我们只能够将它作为类型约束，来限制输入参数 request
    func send<T: Request>(_ r: T, handler: @escaping(T.Response?) -> Void)
    var host: String { get }
}

//提取send方法, 将发送请求的部分和请求本身分离开
struct URLSessionClient: Client {
    let host = "https://api.onevcat.com"
    
    func send<T: Request>(_ r: T, handler: @escaping (T.Response?) -> Void) {
        let url = URL(string: host.appending(r.path))!
        var request = URLRequest(url: url)
        request.httpMethod = r.method.rawValue
        
        let task = URLSession.shared.dataTask(with: request) {
            data, _, error in
            if let data = data, let res = r.parse(data: data) {
                DispatchQueue.main.async { handler(res) }
            } else {
                DispatchQueue.main.async { handler(nil) }
            }
        }
        task.resume()
    }
}

