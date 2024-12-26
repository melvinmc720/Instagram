//
//  ProfileHeaderView.swift
//  Instagram
//
//  Created by milad marandi on 12/14/24.
//

import UIKit

class ProfileHeaderView: UICollectionReusableView {
    
    static let identifier:String = "ProfileHeaderView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemRed
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}
