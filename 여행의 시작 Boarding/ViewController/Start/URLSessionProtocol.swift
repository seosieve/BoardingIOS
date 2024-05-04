//
//  URLSessionProtocol.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 5/4/24.
//

import Foundation

typealias DataTaskCompletionHandler = (Data?, URLResponse?, Error?) -> Void

protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping DataTaskCompletionHandler) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol { }
