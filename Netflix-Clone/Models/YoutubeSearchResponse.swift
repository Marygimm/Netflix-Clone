//
//  YoutubeSearchResponse.swift
//  Netflix-Clone
//
//  Created by Mary Moreira on 31/08/2022.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: idVideoElement
}

struct idVideoElement: Codable {
    let kind: String?
    let videoId: String?
}
