//
//  ArticleTableViewCell.swift
//  NewYorkTimesArticles
//
//  Created by Bheem Singh on 09/07/19.
//  Copyright © 2019 Bheem Singh. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var author: UILabel!
    
    
    static let identifier = "ArticleTableViewCell"
    
    var article : Article! {
        didSet {
            self.title.text = self.article.title
            self.author.text = self.article.byline
            let multiMedia = article.multimedia
            for media in multiMedia{
                if MultiMediaType(rawValue: media.format) == MultiMediaType.standardThumbnail{
                    self.thumbnail.loadImage(fromURL: media.url)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
