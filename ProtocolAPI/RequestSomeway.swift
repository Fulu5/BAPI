//
//  RequestSomeway.swift
//  ProtocolAPI
//
//  Created by Guanxiong Cao  on 16/01/2017.
//  Copyright © 2017 Guanxiong Cao . All rights reserved.
//

import Foundation

struct RequestSomeway: RequestSender {
    
    func sendRequest<T : Request>(_ r: T, handler: @escaping (T.Response?) -> Void) {
        
        let url = URL(string: r.request)!
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

