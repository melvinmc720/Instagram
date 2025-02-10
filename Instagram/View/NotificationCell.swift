//
//  NotificationCell.swift
//  Instagram
//
//  Created by milad marandi on 2/7/25.
//

import UIKit

protocol NotificationDelegate:AnyObject {
    func cell(_ cell:NotificationCell , wantstoFollow uid:String)
    func cell(_ cell:NotificationCell , wantstoUnFollow uid:String)
    func cell(_ cell:NotificationCell , wantsToViewPost postID:String)
}

class NotificationCell: UITableViewCell {
    
    static let identifier:String = "NotificationCell"
    
    // MARK: - Properties
    
    weak var delegate:NotificationDelegate?
    
    var viewModel:NotificationViewModel? {
        didSet{
            configure()
        }
    }
    private lazy var profileImageView:UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "venom-7")
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(gesture)
        return iv
        
    }()
    
    private let infoLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var postImageView:UIImageView = {
        
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(handlePostTapped)
        )
        iv.backgroundColor = .gray
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        iv.clipsToBounds = true
        
        return iv
    }()
    
    private lazy var followButton:UIButton = {
        let button = UIButton()
        button.setTitle("Loading", for: .normal)
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button
            .addTarget(
                self,
                action: #selector(handleFollowTapped),
                for: .touchUpInside
            )
        return button
    }()
    
    // MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(profileImageView)
        self.profileImageView
            .anchor(
                top:topAnchor ,
                left: leftAnchor ,
                paddingTop: 16 ,
                paddingLeft: 12
            )
        
        self.profileImageView.setDimensions(height: 48 , width: 48)
        self.profileImageView.layer.cornerRadius = 48 / 2
        
        
        contentView.addSubview(followButton)
        self.followButton.centerY(inView: self)
        self.followButton
            .anchor(
                right: rightAnchor ,
                paddingRight: 12 ,
                width: 80 ,
                height: 32
            )
        
        contentView.addSubview(postImageView)
        self.postImageView.centerY(inView: self)
        self.postImageView
            .anchor(
                right: rightAnchor ,
                paddingRight: 12 ,
                width: 40 ,
                height: 40
            )
        
        contentView.addSubview(infoLabel)
        self.infoLabel
            .centerY(
                inView: profileImageView ,
                leftAnchor: profileImageView.rightAnchor
                , paddingLeft: 8)
        
        self.infoLabel.anchor(right: followButton.rightAnchor)
        
        
        self.followButton.isHidden = true
        
    }
    
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc func handleFollowTapped(){
        guard let vm = viewModel else { return}
        
        if vm.notification.userIsFollowed {
            delegate?.cell(self, wantstoUnFollow: vm.notification.uid)
        }
        else {
            delegate?.cell(self, wantstoFollow: vm.notification.uid)
        }
    }
    
    @objc func handlePostTapped(){
        guard let vm = viewModel else { return}
        delegate?.cell(self, wantsToViewPost: vm.notification.postId ?? "")
    }
    
    @objc func handleProfileImageTapped(){

    }
    
    // MARK: - Helpers
    func configure(){
        guard let vm  = viewModel else { return}
        profileImageView.sd_setImage(with: vm.profileImageUrl)
        postImageView.sd_setImage(with: vm.postImageUrl)
        
        infoLabel.attributedText = vm.notificationMessage
        
        followButton.isHidden = !vm.shouldHidePostImage
        postImageView.isHidden = vm.shouldHidePostImage
        
        followButton.setTitle(vm.followButtonText, for: .normal)
        followButton.backgroundColor = vm.followButtonBackgroundColor
        followButton.setTitleColor(vm.followButtonTextColor, for: .normal)
        
    }
    
}
