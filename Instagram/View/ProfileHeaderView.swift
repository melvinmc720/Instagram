//
//  ProfileHeaderView.swift
//  Instagram
//
//  Created by milad marandi on 12/14/24.
//

import UIKit
import SDWebImage

protocol ProfileHeaderDelegate:AnyObject {
    func header(_ profileHeader:ProfileHeaderView , didTapActionButtonFor user:User)

}

class ProfileHeaderView: UICollectionReusableView {
    
    // MARK: - Properties
    static let identifier:String = "ProfileHeaderView"
    
    weak var delegate:ProfileHeaderDelegate?
    
    var headerVM:profileHeaderViewModel? {
        didSet{
            configure()
        }
    }
    
    
    private let profileImageView:UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .gray
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
        
    }()
    
    private let nameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button
            .addTarget(
                self,
                action: #selector(handleEditProfileFollowTapped),
                for: .touchUpInside
            )
        return button
    }()
    
    
    private lazy var postLable:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.attributedText = attributedStatText(value: 5, label: "Posts")
        return label
    }()
    
    
    private lazy var followerLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.attributedText = attributedStatText(value: 1, label: "Follower")
        return label
    }()
    
    private lazy var followingLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.attributedText = attributedStatText(value: 1, label: "Following")
        return label
    }()
    
    let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "grid"), for: .normal)
        return button
    }()
    
    let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    
    private func configure(){
        guard let viewmodel = headerVM else {
            return
        }
        
        self.profileImageView.sd_setImage(with: viewmodel.profileImageURL)
        self.nameLabel.text = viewmodel.username
        self.editProfileFollowButton.setTitle(viewmodel.followdButtonText, for: .normal)
        self.editProfileFollowButton.setTitleColor(viewmodel.followButtonTextColor, for: .normal)
        self.editProfileFollowButton.backgroundColor = viewmodel.followButtonBackgroundColor
        
        
        self.followerLabel.attributedText = viewmodel.numberOfFollowers
        self.followingLabel.attributedText = viewmodel.numberOfFollowing
        self.postLable.attributedText = viewmodel.numberOfposts
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView
            .anchor(
                top:topAnchor ,
                left: leftAnchor ,
                paddingTop: 16 ,
                paddingLeft: 12
            )
        
        profileImageView.setDimensions(height: 80 , width: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        
        addSubview(nameLabel)
        nameLabel
            .anchor(
                top: profileImageView.bottomAnchor ,
                left: leftAnchor ,
                paddingTop: 12 , paddingLeft: 12
            )
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton
            .anchor(
                top: nameLabel.bottomAnchor ,
                left: leftAnchor ,
                right: rightAnchor
                , paddingTop: 16 , paddingLeft: 24 , paddingRight: 24)
        
        let stack = UIStackView(
            arrangedSubviews: [postLable , followerLabel , followingLabel]
        )
        
        stack.distribution = .fillEqually
        addSubview(stack)
        
        stack.centerY(inView: profileImageView)
        stack
            .anchor(
                left: profileImageView.rightAnchor ,
                right: rightAnchor ,
                paddingLeft: 12 , paddingRight: 12 , height: 50
            )
        
        let topDevider = UIView()
        
        topDevider.backgroundColor = .lightGray
        
        let bottomDevider = UIView()
        bottomDevider.backgroundColor = .lightGray
        let buttonStack = UIStackView(
            arrangedSubviews: [gridButton , listButton , bookmarkButton]
        )
        buttonStack.distribution = .fillEqually
        addSubview(buttonStack)
        addSubview(topDevider)
        addSubview(bottomDevider)
        
        buttonStack
            .anchor(
                left: leftAnchor ,
                bottom: bottomAnchor ,
                right: rightAnchor
                , height: 50)
        
        topDevider
            .anchor(
                top: buttonStack.topAnchor ,
                left: leftAnchor ,
                right: rightAnchor
                , height: 0.5)
        
        bottomDevider
            .anchor(
                top: buttonStack.bottomAnchor ,
                left: leftAnchor ,
                right: rightAnchor
                , height: 0.5)
        
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func handleEditProfileFollowTapped() {
        guard let headerVM = headerVM else {
            return
        }
        delegate?.header(self, didTapActionButtonFor: headerVM.user)
    }
    
    // MARK: Helper
    
    func attributedStatText(value:Int , label:String) -> NSAttributedString {
        
        let attributedText = NSMutableAttributedString(
            string: "\(value)\n",
            attributes: [
                .font: UIFont.systemFont(ofSize: 14) ,
                .foregroundColor
                :UIColor.black]
        )
        
        attributedText
            .append(
                NSAttributedString(
                    string: label,
                    attributes: [
                        .font:UIFont.systemFont(ofSize: 14) ,
                        .foregroundColor
                        :UIColor.lightGray]
                )
            )
        
        return attributedText
        
    }
        
}
