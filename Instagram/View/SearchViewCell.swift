//
//  SearchViewCell.swift
//  Instagram
//
//  Created by milad marandi on 12/29/24.
//

import UIKit

class SearchViewCell: UITableViewCell {

    
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
        label.text = "usernameLabel"
        label.textColor = .black
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    let fullNameLabel:UILabel = {
        let label = UILabel()
        label.text = "fullNameLabel"
        label.textColor = .lightGray
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
