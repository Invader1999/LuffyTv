//
//  TopAiringAnimeModel.swift
//  LuffyTV
//
//  Created by Hemanth Reddy Kareddy on 11/03/24.
//

import Foundation

struct TopAiringAnimeModel: Codable {
    var id :UUID? = UUID()
    let data: [Datum]
    let paging: Paging
}

struct Datum: Codable {
    let node: Node
    let ranking: Ranking
}

struct Node: Codable {
    let id: Int
    let title: String
    let mainPicture: MainPicture

    enum CodingKeys: String, CodingKey {
        case id, title
        case mainPicture = "main_picture"
    }
}

struct MainPicture: Codable {
    let medium, large: String
}

struct Ranking: Codable {
    let rank: Int
}

struct Paging: Codable {
    let next: String
}
