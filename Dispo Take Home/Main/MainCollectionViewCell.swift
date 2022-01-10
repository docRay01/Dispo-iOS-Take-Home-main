//
//  MainCollectionViewCell.swift
//  Dispo Take Home
//
//  Created by Davis, R. Steven on 1/9/22.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
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
    }
}
