//
//  ProfileCellView.swift
//  Instagram
//
//  Created by milad marandi on 12/14/24.
//

import UIKit

class ProfileCellView: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier:String = "ProfileCellView"
    
    private let postImageView:UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "venom-7")
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .lightGray
        
        addSubview(postImageView)
        postImageView.fillSuperview()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
