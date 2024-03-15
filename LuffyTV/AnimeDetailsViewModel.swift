//
//  AnimeDetailsViewModel.swift
//  LuffyTV
//
//  Created by Hemanth Reddy Kareddy on 14/03/24.
//

import Foundation

enum AnimeDetailsError:Error{
    case InvalidURL
    case InvalidResponse
    case InvalidData
}

@Observable
class AnimeDetailsViewModel{
    
    var animeDetailDataArray:[AnimeDetailModel] = []
    
    
    func getAnimeDetailsData(id:String) async throws {
            var headers = [String: String]()
            headers["X-MAL-CLIENT-ID"] = "e333019e486e544405bfbaac0f95cc13"
            headers["Content-Type"] = "application/json"

            let endpoint = "https://api.myanimelist.net/v2/anime/\(id)?fields=id,title,main_picture,alternative_titles,start_date,end_date,synopsis,mean,rank,popularity,num_list_users,num_scoring_users,nsfw,created_at,updated_at,media_type,status,genres,my_list_status,num_episodes,start_season,broadcast,source,average_episode_duration,rating,pictures,background,related_anime,related_manga,recommendations,studios,statistics"
            guard let url = URL(string: endpoint) else { throw AnimeDetailsError.InvalidURL }

            var request = URLRequest(url: url)
            request.allHTTPHeaderFields = headers
            request.httpMethod = "GET"
            request.cachePolicy = .useProtocolCachePolicy
            
            let (data, response) = try await URLSession.shared.data(for: request)
            //print("Anime Detail Data",data,response)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw AnimeDetailsError.InvalidResponse
            }

            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(AnimeDetailModel.self, from: data)
                //print("Data received:", decodedData)
                animeDetailDataArray.append(decodedData)

            } catch {
                print(error)
                throw AnimeDetailsError.InvalidData
            }
            print(animeDetailDataArray)
        }
}
