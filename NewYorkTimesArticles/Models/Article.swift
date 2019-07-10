//
//  Article.swift
//  NewYorkTimesArticles
//
//  Created by Bheem Singh on 09/07/19.
//  Copyright © 2019 Bheem Singh. All rights reserved.
//

import Foundation

enum MultiMediaType: String {
    case standardThumbnail = "Standard Thumbnail"
    case thumbLarge = "thumbLarge"
    case normal = "Normal"
    case mediumThreeByTwo210 = "mediumThreeByTwo210"
    case superJumbo = "superJumbo"
}

enum ArticleSection: String{
    case science = "science"
    case technology = "technology"
    case business = "business"
    case world = "world"
    case movies = "movies"
    case travel = "travel"
}

struct Article: Codable {
    
    
    let section, title, abstract, url, byline, item_type, published_date, created_date : String
    
    
    struct multimedia:Codable {
        
        let url, format, type, caption, copyright: String
        let height, width:Int
        
        enum CodingKeys: String, CodingKey {
            case url
            case format
            case type
            case caption
            case copyright
            case height
            case width
        }
    }
    
    let multimedia: [multimedia]
    
    enum CodingKeys: String, CodingKey {
        case section
        case title
        case multimedia
        case abstract
        case byline
        case item_type
        case published_date
        case created_date
        case url
    }
    
    
}

extension Article {
    
    init?(data: Data) {
        do {
            let me = try JSONDecoder().decode(Article.self, from: data)
            self = me
        }catch {
            print(error)
            return nil
        }
    }
    
}
