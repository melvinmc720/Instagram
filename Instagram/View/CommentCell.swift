//
//  CommentCell.swift
//  Instagram
//
//  Created by kiana mehdiof on 1/24/25.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    static let identifier:String = "CommentCell"
    // MARK: - Properties
    
    private let profileImage:UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        
        return iv
    }()
    
    
    private let commentLabel:UILabel = {
        let label = UILabel()
        
        let attributedString = NSMutableAttributedString(string: "Joke ", attributes: [.font:UIFont.boldSystemFont(ofSize: 14)])
        attributedString.append(NSAttributedString(string: "Some test comment for now ...", attributes: [.font: UIFont.systemFont(ofSize: 14)]))
        
        label.attributedText = attributedString
        
        return label
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImage)
        profileImage.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 8)
        profileImage.setDimensions(height: 40, width: 40)
        profileImage.layer.cornerRadius = 20
        profileImage.layer.masksToBounds = true
        
        addSubview(commentLabel)
        commentLabel.centerY(inView: self, leftAnchor: profileImage.rightAnchor, paddingLeft: 8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
