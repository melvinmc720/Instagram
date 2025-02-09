//
//  ProfileViewController.swift
//  Instagram
//
//  Created by milad marandi on 11/14/24.
//

import UIKit

class ProfileViewController: UICollectionViewController {
    
    var user:User
    private var posts = [post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewConfiguration()
        checkIfUserIsFollowed()
        fetchUserStats()
        fetchPosts()
    }
    
    private func checkIfUserIsFollowed(){
        UserService.checkIfUserIsFollowed(uid: user.id) { isfollowed in
            self.user.isFollowed = isfollowed
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    
    private func fetchUserStats(){
        UserService.fetchUserStats(uid: user.id) { userstats in
            self.user.stats = userstats
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func fetchPosts(){
        PostService.fetchPosts(forUser: user.id) { posts in
            self.posts = posts
            self.collectionView.reloadData()
        }
    }
    
    
    
    private func collectionViewConfiguration(){
        
        self.navigationItem.backButtonTitle = "Back"
        self.collectionView
            .register(
                ProfileCellView.self,
                forCellWithReuseIdentifier: ProfileCellView.identifier
            )
        self.collectionView
            .register(
                ProfileHeaderView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: ProfileHeaderView.identifier
            )
        
        navigationItem.title = user.username
    }
    

}


// MARK: COLLECTION VIEW DATA SOURCE
extension ProfileViewController{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProfileCellView.identifier,
            for: indexPath
        ) as? ProfileCellView else {
            return UICollectionViewCell()
        }
        
        cell.viewModel = PostViewModel(post: posts[indexPath.row])
        
        return cell
    }
    
    
}

// MARK: profileHeaderDelegate
extension ProfileViewController:ProfileHeaderDelegate{
    func header(_ profileHeader: ProfileHeaderView, didTapActionButtonFor user: User) {
        
        guard let tab = self.tabBarController as? MainTabController else { return}
        guard let currentUser = tab.user else { return}
        
        
        if user.iscurrentUser{
            print("DEBUG: Current user is in Action")
        }
        if user.isFollowed{
            UserService.unfollow(uid: user.id) { error in
                guard error == nil else {
                    return
                }
                self.user.isFollowed = false
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }

            }
        }
        else{
            UserService.follow(uid: user.id) { error in
                guard error == nil else {
                    print("while following")
                    return
                }
                self.user.isFollowed = true
                NotificationService
                    .uploadNotification(toUid: user.id, type: .follow)
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    
}

// MARK: COLLECTION VIEW DELEGATE

extension ProfileViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let controller  = FeedViewController(collectionViewLayout: UICollectionViewFlowLayout())
        
        controller.Post = posts[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
}



// MARK: COLLECTION HEADER
extension ProfileViewController:UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: ProfileHeaderView.identifier,
            for: indexPath
        ) as? ProfileHeaderView else {
            return UICollectionReusableView()
        }
        
            header.headerVM = profileHeaderViewModel(user: user)
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (self.view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 240)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)
    }
    
    
}
