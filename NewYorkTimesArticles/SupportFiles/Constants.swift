//
//  Constants.swift
//  NewYorkTimesArticles
//
//  Created by Bheem Singh on 09/07/19.
//  Copyright © 2019 Bheem Singh. All rights reserved.
//

import Foundation

let API_KEY = "6NoxJ73GY5sAiT5qH6LSWEhZzIDK4iLN"

struct Constants {
    
    // apis url constants
    static func storiesUrlFor(section forSection: String) -> String{
        return "https://api.nytimes.com/svc/topstories/v2/\(forSection).json?api-key=\(API_KEY)"
    }
    
    
}


struct StoryboardId{
    
    // storyboard constants
    static let articles = "ArticlesViewController"
    static let details = "DetailsViewController"
    
}


struct StringConstants {
    // error messages
    static let noComment = "No comments"
    static let commentsNotAvailable = "Comments not available"
    static let unknownError = "Unknown Error"
    static let checkInternet = "Check your Internet connection"
    static let fetchDataFailed = "Feching data failed"
    
    static let changeSection = "Change Section"
    static let refreshing = "Refreshing..."
    
    // view titles
    static let articleViewTitle = "Articles"
    static let detailsViewTitle = "Details"
    
}

