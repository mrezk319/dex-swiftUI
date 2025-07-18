//
//  FetchPockemon.swift
//  dex
//
//  Created by Muhammed Rezk Rajab on 13/07/2025.
//

import Foundation
struct FetchPockemon {
    let url = URL(string:"https://pokeapi.co/api/v2/pokemon")
     
    func fetch(id: Int) async throws -> PockemonModel {
        let urlFetch = url?.appendingPathComponent(String(id))
        let (data,response) = try await URLSession.shared.data(for: URLRequest(url: urlFetch!))
        guard let res = response as? HTTPURLResponse, res.statusCode == 200 else {
             throw URLError(.badServerResponse)
        }
        let decodedData = try JSONDecoder().decode(PockemonModel.self, from: data)
        
        return decodedData
    }
}
