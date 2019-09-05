//
//  ArticleViewCell.swift
//  MyNews
//
//  Created by Надежда Морозова on 04/09/2019.
//  Copyright © 2019 Надежда Морозова. All rights reserved.
//

import UIKit

class ArticleViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var TextLabel: UILabel!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var datePublic: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func config(article: Article) {
        self.titleLabel.text = article.title
        self.TextLabel.text = article.desc
        self.datePublic.text = article.datePublic
        self.photoImage.loadImage(article.image)
      
    }
}
