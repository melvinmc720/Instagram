//
//  CommentController.swift
//  Instagram
//
//  Created by milad marandi on 1/24/25.
//

import UIKit

class CommentController: UICollectionViewController {
    
    //MARK: - Properties
    private let post:post
    private var comments = [Comment]()
    
    private lazy var commentInputView:CommentInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let cv = CommentInputAccessoryView(frame: frame)
        cv.delegate = self
        return cv
    }()
    
    //MARK: LifeCycle
    
    init(post:post){
        self.post = post
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        fetchComments()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override var inputAccessoryView: UIView? {
        get { return commentInputView }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    private func configuration(){
        
        self.title = "Comments"
        self.collectionView.register(CommentCell.self, forCellWithReuseIdentifier: CommentCell.identifier)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        
        self.navigationItem.backButtonTitle = ""
    }
    
    // MARK: - API
    
    func fetchComments(){
        CommentService.fetchComments(forPost: post.postID) { comments in
            self.comments = comments
            self.collectionView.reloadData()
        }
    }

}



// MARK: - UICOLLECTION DATA SOURCE

extension CommentController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.comments.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCell.identifier, for: indexPath) as? CommentCell else {return UICollectionViewCell()}
        
        cell.viewModel = CommentViewModel(comment: comments[indexPath.row])
        return cell
    }
}

extension CommentController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let uid = comments[indexPath.row].uid
        UserService.fetchUser(withUId: uid) { user in
            let controller = ProfileViewController(user: user)
            self.navigationController?.pushViewController(controller , animated: true)
        }
    }
}


// MARK: UIcollectionview delegate layout
extension CommentController:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let viewModel = CommentViewModel(comment: comments[indexPath.row])
        let height = viewModel.size(forWidth: self.view.frame.width).height + 32
        return CGSize(width: self.view.frame.width, height: height)
    }
    
}

// MARK: - CommentInputAccessoryViewDelegate
extension CommentController: CommentInputAccessoryViewDelegate {
    func inputView(_ inputView: CommentInputAccessoryView, wantToUploadComment comment: String) {
        
        guard let tab = self.tabBarController as? MainTabController else {return}
        guard let currentUser = tab.user else {return}
        
        self.showLoader(true)
        
        CommentService.uploadComment(comment: comment, postID: post.postID, user: currentUser) { errro in
            guard errro == nil else {
                return
            }
            self.showLoader(false)
            inputView.clearCommentTextView()
            NotificationService
                .uploadNotification(
                    toUid: self.post.ownerID,
                    type: .comment ,
                    post: self.post
                )
        }
    }
    
    
}
