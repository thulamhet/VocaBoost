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

    func request(url: String) async throws -> Data {
        guard let url = URL(string: url) else {
            throw NSError(domain: "Invalid URL", code: 400, userInfo: nil)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "Invalid response", code: 500, userInfo: nil)
        }

        return data
    }
}
