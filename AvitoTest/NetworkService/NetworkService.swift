//
//  NetworkService.swift
//  AvitoTest
//
//  Created by Шарап Бамматов on 17.10.2022.
//
/*
 guard
     let data = data,
     error == nil,
     let response = response as? HTTPURLResponse,
     response.statusCode >= 200 && response.statusCode < 300
 else {
     completion(nil)
     return
 }
 */

import Foundation

protocol NetworkServiceProtocol {
    func getEmployees(completion: @escaping (Result<[Employee], Error>) -> Void )
}

class NetworkService: NetworkServiceProtocol {
    func getEmployees(completion: @escaping (Result<[Employee], Error>) -> Void) {
        guard let url = URL(string: API.baseUrl) else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            
            guard let
                data = data,
                error == nil,
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300
            else {
                print(error.debugDescription)
                return
            }
            
            do {
                let results = try JSONDecoder().decode(CompanyResponse.self, from: data)
                completion(.success(results.company.employees))
            }
            catch{
                completion(.failure(error))
            }
            
        }
        task.resume()
    }
}
