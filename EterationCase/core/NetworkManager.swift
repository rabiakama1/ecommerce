//
//  NetworkManager.swift
//  EterationCase
//
//  Created by rabiakama on 28.07.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(String)
    case unknown
}

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://5fc9346b2af77700165ae514.mockapi.io/"
    
    private init() {}

    func fetchProducts(completion: @escaping (Result<[Product], NetworkError>) -> Void) {
        let endpoint = baseURL + "products"
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(.serverError(error.localizedDescription)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(.unknown))
                    return
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(.serverError("HTTP \(httpResponse.statusCode)")))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.noData))
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    let products = try decoder.decode([Product].self, from: data)
                    completion(.success(products))
                } catch {
                    print("Decoding error: \(error)")
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
    
    func fetchProductsWithPagination(page: Int, limit: Int = 4, completion: @escaping (Result<[Product], NetworkError>) -> Void) {
        let endpoint = "\(baseURL)products?page=\(page)&limit=\(limit)"
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(.serverError(error.localizedDescription)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(.unknown))
                    return
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(.serverError("HTTP \(httpResponse.statusCode)")))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.noData))
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    let products = try decoder.decode([Product].self, from: data)
                    completion(.success(products))
                } catch {
                    print("Decoding error: \(error)")
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
}
