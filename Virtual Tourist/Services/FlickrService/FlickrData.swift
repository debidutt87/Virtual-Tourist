//
//  FlickrData.swift
//  Virtual Tourist
//
//  Created by Debidutt Prasad on 22/11/19.
//  Copyright © 2019 Debidutt Prasad. All rights reserved.
//

import Foundation

struct FlickrSearchResponseData: Codable {
    let data: FlickrSarchData
    let status: String

    enum CodingKeys: String, CodingKey {
        case data = "photos"
        case status = "stat"
    }
}

struct FlickrSarchData: Codable {
    let page: Int
    let pages: Int
    let perPage: Int
    let photos: [FlickrImage]

    enum CodingKeys: String, CodingKey {
        case page
        case pages

        case perPage = "perpage"
        case photos = "photo"
    }
}

struct FlickrImage: Codable {
    let id: String
    let title: String
    let mediumUrl: String

    enum CodingKeys: String, CodingKey {
        case id
        case title

        case mediumUrl = "url_m"
    }
}
