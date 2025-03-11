//
//  NetworkManager.swift
//  VocaBoost
//
//  Created by Nguyễn Công Thư on 28/2/25.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    func request(url: String, method: RequestMethod = .get, body: [String: Any]? = nil, headers: [String: String]? = nil) async throws -> Data {
        guard let url = URL(string: url) else {
            throw NSError(domain: "Invalid URL", code: 400, userInfo: nil)
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        if let body = body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "Invalid response", code: 500, userInfo: nil)
        }

        return data
    }
}

