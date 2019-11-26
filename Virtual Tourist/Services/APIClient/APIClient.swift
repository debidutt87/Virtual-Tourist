//
//  APIClient.swift
//  Virtual Tourist
//
//  Created by Debidutt Prasad on 12/11/19.
//  Copyright © 2019 Debidutt Prasad. All rights reserved.
//

import Foundation

struct APIClient: APIClientProtocol {

    var session: URLSession

    init(session: URLSession) {
        self.session = session
    }

    func makeGETDataTaskForResource(
        withURL resourceURL: URL,
        parameters: [String : String],
        headers: [String: String]?,
        andCompletionHandler handler: @escaping (APIClientProtocol.JsonData?, URLSessionTask.TaskError?) -> Void
        ) -> URLSessionDataTask {

        var components = URLComponents(url: resourceURL, resolvingAgainstBaseURL: false)!
        components.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        if let headers = headers {
            headers.forEach { key, value in
                request.addValue(value, forHTTPHeaderField: key)
            }
        } else {
            // The default headers for calling restful APIs.
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        }

        return session.dataTask(with: request) { data, response, error in
            guard error == nil, let data = data else {
                handler(nil, .connection)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                handler(nil, .serverResponse)
                return
            }

            handler(data, nil)
        }
    }
}
