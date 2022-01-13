//
//  MainCollectionViewCell.swift
//  Dispo Take Home
//
//  Created by Davis, R. Steven on 1/9/22.
//

import UIKit
import Kingfisher

class MainCollectionViewCell: UICollectionViewCell {
    var imageView: AnimatedImageView?
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    func initialize() {
        self.backgroundColor = .gray
        
        let imageView:AnimatedImageView = AnimatedImageView(frame: CGRect(origin: .zero, size: self.contentView.frame.size))
        self.contentView.addSubview(imageView)
        self.imageView = imageView
    }
    
    override func prepareForReuse() {
        self.imageView?.image = nil
    }
    
    func loadData(gifData: GifObject) {
        let url: URL = gifData.images.fixed_height_small.url
        let animatedImageViewResource = ImageResource(downloadURL: url, cacheKey: url.absoluteString)
        imageView?.kf.setImage(with: animatedImageViewResource)
    }
}
