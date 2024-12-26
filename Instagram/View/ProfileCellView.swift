//
//  ProfileCellView.swift
//  Instagram
//
//  Created by milad marandi on 12/14/24.
//

import UIKit

class ProfileCellView: UICollectionViewCell {
    
    static let identifier:String = "ProfileCellView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .gray
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
