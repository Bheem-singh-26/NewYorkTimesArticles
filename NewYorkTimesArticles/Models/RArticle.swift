//
//  RArticle.swift
//  NewYorkTimesArticles
//
//  Created by Bheem Singh on 10/07/19.
//  Copyright © 2019 Bheem Singh. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class RArticle: Object {
    
    @objc dynamic var title = ""
    @objc dynamic var abstract = ""
    @objc dynamic var url = ""
    @objc dynamic var byline = ""
    @objc dynamic var item_type = ""
    @objc dynamic var published_date = ""
    @objc dynamic var created_date = ""
    @objc dynamic var section = ""
    var multimedia = List<RMultiMedia>()
    
    override static func primaryKey() -> String? {
        return "title"
    }
    
    
    // to save colection of article into database
    static func save(collecton forCollection:[Article]){
        let rArticles = self.mapRealmArticleFrom(articles: forCollection)
        print(rArticles[0])
        let realm = try! Realm()
        do {
            try! realm.write {
                realm.add(rArticles, update: .modified)
            }
        }catch{
            // handle error
            print("issue is not saved in database")
        }
    }
    
    //Tto save a article into database
    static func save(article forArticle:JSON){
        uiRealm.create(RArticle.self, value: forArticle, update: .modified)
    }
    
    class func mapRealmArticleFrom(articles:[Article]) -> [RArticle]{
        
        // clean Db before adding fresh data
        
        var aArticles = [RArticle]()
        for article in articles{
            let rArticle = RArticle()
            rArticle.title = article.title
            rArticle.abstract = article.abstract
            rArticle.byline = article.byline
            rArticle.item_type = article.item_type
            rArticle.published_date = article.published_date
            rArticle.created_date = article.created_date
            rArticle.section = article.section
            var multiMedia = List<RMultiMedia>()
            for media in article.multimedia{
                let rMedia = RMultiMedia()
                rMedia.url = media.url
                rMedia.format = media.format
                rMedia.type = media.type
                rMedia.caption = media.caption
                rMedia.height = media.height
                rMedia.width = media.width
                multiMedia.append(rMedia)
            }
            rArticle.multimedia = multiMedia
            aArticles.append(rArticle)
        }
        return aArticles
    }
    
}


class RMultiMedia: Object {
    
    @objc dynamic var url = ""
    @objc dynamic var format = ""
    @objc dynamic var type = ""
    @objc dynamic var caption = ""
    @objc dynamic var height = 0
    @objc dynamic var width = 0
    
}
