//
//  ArticlesViewModel.swift
//  NewYorkTimesArticles
//
//  Created by Bheem Singh on 09/07/19.
//  Copyright © 2019 Bheem Singh. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift
import SwiftyJSON


class ArticlesViewModel {
    
    public enum HomeError {
        case internetError(String)
        case serverMessage(String)
    }
    
    public let articles : PublishSubject<[RArticle]> = PublishSubject()
    public let error : PublishSubject<HomeError> = PublishSubject()
    
    public let isRefreshing : PublishSubject<Bool> = PublishSubject()
    
    public var articleSection: String!{
        didSet{
            requestData()
        }
    }
    private let disposeBag = DisposeBag()
    
    let realmManager = RealmManager()
    
    public func requestData(){
        
        if self.realmManager.isDatabaseEmptyFor(section: self.articleSection){
            self.articles.onNext(self.realmManager.retrieveArticleListFor(section: self.articleSection))
        }else{
            self.fetchDataFromServer()
        }
        
    }
    
    public func fetchDataFromServer(){
        
        APIManager.requestData(url: Constants.storiesUrlFor(section: articleSection), method: .get, parameters: nil, completion: { (result) in
            
            switch result {
            case .success(let responseJson) :
                
                var articles = responseJson["results"].arrayValue.compactMap{ return Article(data: try!$0.rawData())}
                
                // Ordering issues list by recent updated
                articles = articles.sorted(by: { $0.published_date > $1.published_date })
                articles = articles.filter({ $0.section == self.articleSection.capitalized})
                
                let rArticle =  RArticle.mapRealmArticleFrom(articles: articles)
                self.articles.onNext(rArticle)
                
                // save Articles to database
                RArticle.save(collecton: articles)
                
                self.isRefreshing.onNext(false)
                
            case .failure(let failure) :
                switch failure {
                case .connectionError:
                    self.error.onNext(.internetError(StringConstants.checkInternet))
                case .authorizationError(let errorJson):
                    self.error.onNext(.serverMessage(errorJson["message"].stringValue))
                default:
                    self.error.onNext(.serverMessage(StringConstants.unknownError))
                }
                
            }
        })
        
    }
    
}

