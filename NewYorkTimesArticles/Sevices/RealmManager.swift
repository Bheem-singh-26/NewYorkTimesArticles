//
//  RealmManager.swift
//  NewYorkTimesArticles
//
//  Created by Bheem Singh on 10/07/19.
//  Copyright © 2019 Bheem Singh. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager{
    
    static func dbMigration(){
        
        // Inside your application(application:didFinishLaunchingWithOptions:)
        
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 2,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
        //let realm = try! Realm()
        
    }
    
    func retrieveArticleListFor(section forSection: String) -> [RArticle]{
        var rArticles = [RArticle]()
       let predicate =  NSPredicate(format:"section = %@",forSection.capitalized)
        let articles = uiRealm.objects(RArticle.self).filter(predicate)
        for article in articles{
            rArticles.append(article)
        }
        
        return rArticles
    }
    
    func isDatabaseEmptyFor(section: String) -> Bool {
        let articles = retrieveArticleListFor(section: section)
        if articles.count != 0{
            return true
        }
        return false
    }
    
}
