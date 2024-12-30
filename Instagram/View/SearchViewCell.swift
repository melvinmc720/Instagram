//
//  SearchViewCell.swift
//  Instagram
//
//  Created by milad marandi on 12/29/24.
//

import UIKit
import SDWebImage
class SearchViewCell: UITableViewCell {
    
    var Viewmodel:UserCellViewModel? {
        didSet{
            guard let Viewmodel = Viewmodel else { return}
            self.profileImage
                .sd_setImage(with:URL(string: Viewmodel.profileImage))
            self.usernameLabel.text = Viewmodel.username
            self.fullNameLabel.text = Viewmodel.fullName
        }
    }

    static let identifier:String = "SearchViewCell"
    let profileImage:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.image = UIImage(named: "venom-7")
        return iv
        
    }()
    
    let usernameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Venom"
        
        return label
    }()
    let fullNameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Eddie Brock"
        label.textColor = .lightGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(profileImage)
        profileImage.setDimensions(height: 60, width: 60)
        profileImage.layer.cornerRadius = 30
        profileImage.layer.masksToBounds = true
        
        profileImage
            .centerY(
                inView: self,
                leftAnchor: leftAnchor,
                paddingLeft: 12
            )
        
       
        let stack = UIStackView(
            arrangedSubviews: [usernameLabel , fullNameLabel]
        )
        
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .leading
        stack.spacing = 4
        
        addSubview(stack)
        
        stack
            .centerY(
                inView: profileImage ,
                leftAnchor: profileImage.rightAnchor ,
                paddingLeft: 8
            )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    
}
