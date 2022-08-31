//
//  Movie.swift
//  Netflix-Clone
//
//  Created by Mary Moreira on 24/08/2022.
//

import Foundation

struct TrendingTitleResponse: Codable {
    let results: [Title]
}

struct Title: Codable {
    let id: Int?
    let original_name, original_title, overview: String?
    let poster_path, media_type: String?
    let release_date: String?
    let vote_average: Double?
    let vote_count: Int?
}
