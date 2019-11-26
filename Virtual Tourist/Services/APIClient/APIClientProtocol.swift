//
//  APIClientProtocol.swift
//  Virtual Tourist
//
//  Created by Debidutt Prasad on 12/11/19.
//  Copyright © 2019 Debidutt Prasad. All rights reserved.
//

import Foundation

extension URLSessionTask {

    enum TaskError: Error {
        case connection
        case serverResponse
        case malformedJsonResponse
        case unexpectedResource
    }
}

protocol APIClientProtocol {

    typealias JsonData = Data

    var session: URLSession { get }

    init(session: URLSession)
    
    func makeGETDataTaskForResource(
        withURL resourceURL: URL,
        parameters: [String: String],
        headers: [String: String]?,
        andCompletionHandler handler: @escaping (JsonData?, URLSessionTask.TaskError?) -> Void
    ) -> URLSessionDataTask
}
