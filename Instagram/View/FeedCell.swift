//
//  FeedCell.swift
//  Instagram
//
//  Created by milad marandi on 11/15/24.
//

import UIKit
import SDWebImage

protocol FeedCellDelegate:AnyObject {
    func cell(_ cell:FeedCell , wantsToshowCommentFor post:post)
    func cell(_ cell:FeedCell , like post:post)
}

class FeedCell: UICollectionViewCell {
    
    static let identifier:String = "FeedCell"
    
    
    weak var delegate:FeedCellDelegate?
    
    var viewModel:PostViewModel? {
        didSet{
            configure()
        }
    }
    
    private func configure(){
        guard let vm = viewModel else {return}
        DispatchQueue.main.async {[self] in 
            captionLable.text = vm.caption
            postImageView.sd_setImage(with: vm.imageURL)
            profileImageView.sd_setImage(with: vm.userProfileImage)
            usernameButton.setTitle(vm.username, for: .normal)
            LikeLable.text = vm.likesTextLabel
            LikeButton.tintColor = vm.likeButtonColor
            LikeButton.setImage(vm.likeButtonImage, for: .normal)
            
            postTimeLabel.text = vm.timeStampString
            
        }
      
    }
    
    // - MARK: profileImageView
    private var profileImageView:UIImageView = {
       
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.backgroundColor = .lightGray
        return iv
        
    }()
    
    // - MARK: usernameButton
    private lazy var usernameButton:UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(didTapUsername), for: .touchUpInside)
        return button
    }()
    
    // - MARK: postImageView
    private var  postImageView:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    

    // - MARK: commentButton
    private lazy var commentButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "comment"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapComment), for: .touchUpInside)
        return button
    }()
    
    // - MARK: LikeButton
    lazy var LikeButton:UIButton = {
       
        let button = UIButton()
        button.setImage(UIImage(named: "like_unselected"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didLikePost), for: .touchUpInside)
        return button
    }()
    
    // - MARK: shareButton
    private let shareButton:UIButton = {
       
        let button = UIButton()
        button.setImage(UIImage(named: "send2"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    
    // - MARK: LikeLable
    private let LikeLable:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    // - MARK: captionLable
    private let captionLable:UILabel = {
        let label = UILabel()
        label.text = "Some text caption for now..."
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    // - MARK: postTimeLabel
    private let postTimeLabel:UILabel = {
        let label = UILabel()
        label.text = "2 days ago"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    var stackView:UIStackView = UIStackView()
    
    // - MARK: init function
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(profileImageView)
        self.addSubview(usernameButton)
        self.addSubview(postImageView)
        self.addSubview(LikeLable)
        self.addSubview(captionLable)
        self.addSubview(postTimeLabel)
        configureActionButton()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout views
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.profileImageView.anchor(top: topAnchor, left:leftAnchor , paddingTop: 12 , paddingLeft: 12)
        self.profileImageView.setDimensions(height: 40, width: 40)
        self.profileImageView.layer.cornerRadius = 20
        self.profileImageView.layer.masksToBounds = true
        
        
        self.usernameButton.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
        
        
        postImageView.anchor(top: profileImageView.bottomAnchor , left: leftAnchor , right: rightAnchor , paddingTop: 8)
        postImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        stackView.anchor(top: postImageView.bottomAnchor , width: 120 , height: 50)
        
        LikeLable.anchor(top: LikeButton.bottomAnchor , left: leftAnchor,paddingTop: -4 , paddingLeft: 8)
        
        captionLable.anchor(top: LikeLable.bottomAnchor , left: leftAnchor,paddingTop: 8 , paddingLeft: 8)
        
        postTimeLabel.anchor(top: captionLable.bottomAnchor , left: leftAnchor ,paddingTop: 8 , paddingLeft: 8)
    }
    
    // MARK: - Actions
    @objc func didTapUsername(){
        
    }
    
    @objc func didLikePost(){
        guard let viewModel = viewModel else { return }
        delegate?.cell(self, like: viewModel.post)
    }
    
    @objc func didTapComment() {
        guard let viewModel = viewModel else {return}
        
        delegate?.cell(self, wantsToshowCommentFor: viewModel.post)
    }
    
    
    private func configureActionButton(){
        stackView = UIStackView(arrangedSubviews: [LikeButton , commentButton , shareButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
    }
    
}
