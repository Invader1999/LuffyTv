//
//  TopAiringAnimeViewModel.swift
//  LuffyTV
//
//  Created by Hemanth Reddy Kareddy on 11/03/24.
//

import Foundation

enum TopListError:Error{
    case InvalidURL
    case InvalidResponse
    case InvalidData
}

@Observable
class TopAiringAnimeViewModel{
    
    var topAirAnimeDataArray:[TopAiringAnimeModel] = []
    
    
    func getTopAiringAnimeData() async throws {
            var headers = [String: String]()
            headers["X-MAL-CLIENT-ID"] = "e333019e486e544405bfbaac0f95cc13"
            headers["Content-Type"] = "application/json"

            let endpoint = "https://api.myanimelist.net/v2/anime/ranking?ranking_type=all&limit=10"
            guard let url = URL(string: endpoint) else { throw TopListError.InvalidURL }

            var request = URLRequest(url: url)
            request.allHTTPHeaderFields = headers
            request.httpMethod = "GET"
            request.cachePolicy = .useProtocolCachePolicy
            
            let (data, response) = try await URLSession.shared.data(for: request)
            print("Top Airing Data",data,response)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw TopListError.InvalidResponse
            }

            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(TopAiringAnimeModel.self, from: data)
                //print("Data received:", decodedData)
                topAirAnimeDataArray.append(decodedData)
                print("TopAirAnimeData Array",topAirAnimeDataArray)
            } catch {
                throw TopListError.InvalidData
            }
        }
}
