//
//  FeedViewController.swift
//  Instagram
//
//  Created by milad marandi on 11/14/24.
//

import UIKit


// - MARK: Collection View
class FeedViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Setup()
        fetchPosts()
        
    }
    
    private var posts = [post]()
    var Post:post?
    
    private func Setup(){
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.identifier)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        
        if Post == nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                title: "logout",
                style: .done,
                target: self,
                action: #selector(handleLogout)
            )
        }
        
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(refreshPost), for: .valueChanged)
        self.collectionView.refreshControl = refresher
    }
    
    @objc func refreshPost(){
        if let _ = self.collectionView.refreshControl?.isRefreshing{
            DispatchQueue.main.async { [self] in
                posts.removeAll()
                fetchPosts()
                collectionView.refreshControl?.endRefreshing()
            }
        }
        
    }
    
    @objc func handleLogout(){
        AuthService.signout { error in
            guard error == nil else {
                print("\(String(describing: error?.localizedDescription))")
                return
            }
            
            let vc = LogInpageController()
            vc.delegate = self.tabBarController as? MainTabController
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
    }
    // MARK: API
    func fetchPosts() {
        
        guard Post == nil else { return }
        PostService.fetchPosts { posts in
            self.posts = posts
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    

}


// MARK: - Data source
extension FeedViewController{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Post == nil ? posts.count : 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.identifier, for: indexPath) as? FeedCell else {
            return UICollectionViewCell()
        }
        
        if let post = Post {
            cell.viewModel = PostViewModel(post: post)
        }
        else {
            cell.viewModel = PostViewModel(post:posts[indexPath.row])
        }
        cell.delegate = self
       
        return cell
    }
}


// MARK: - LAYOU OUT
extension FeedViewController:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        let height = width + 8 + 40 + 8 + 110
        
        return CGSize(width: collectionView.frame.width, height: height)
    }
}


extension FeedViewController:FeedCellDelegate {
    func cell(_ cell: FeedCell, wantsToshowCommentFor post: post) {
        let commentVC = CommentController(post: post)
        
        self.navigationController?.pushViewController(commentVC, animated: true)
    }
    
    
}
