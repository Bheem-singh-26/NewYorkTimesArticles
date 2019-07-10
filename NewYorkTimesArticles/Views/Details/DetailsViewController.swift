//
//  DetailsViewController.swift
//  NewYorkTimesArticles
//
//  Created by Bheem Singh on 09/07/19.
//  Copyright © 2019 Bheem Singh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DetailsViewController: UIViewController {

    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var abstract: UILabel!
    @IBOutlet weak var publishTime: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var articleLink: UILabel!
    
    @IBOutlet weak var openLinkButton: UIButton!
    
    
    public var article : Article!
    private let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = StringConstants.detailsViewTitle
        // Do any additional setup after loading the view.
        bindData()
    }
    
    func bindData(){
        
        self.articleTitle.text = article.title
        self.author.text = article.byline
        self.abstract.text = article.abstract
        self.author.text = article.byline
        self.publishTime.text = article.published_date
        self.articleLink.text = article.url
        let multiMedia = article.multimedia
        for media in multiMedia{
            if MultiMediaType(rawValue: media.format) == MultiMediaType.mediumThreeByTwo210{
                self.coverImage.loadImage(fromURL: media.url)
            }
        }
        
        // bind open link button
        openLinkButton.rx.tap.subscribe(onNext:{[unowned self] _ in
            // perform action you want to perform
            self.openArticle()
        }).addDisposableTo(disposeBag)
        
    }
    
    func openArticle(){
        guard let url = URL(string: self.article.url) else { return }
        UIApplication.shared.open(url)
    }
    

}
