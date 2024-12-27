//
//  ProfileViewController.swift
//  Instagram
//
//  Created by milad marandi on 11/14/24.
//

import UIKit

class ProfileViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewConfiguration()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserService.fetchUser { user in
            self.user = user
        }
    }
    
    
    var user:User? {
        didSet {
            navigationItem.title = user?.username
            self.collectionView.reloadData()
        }
    }
    
    private func collectionViewConfiguration(){
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
    }
    

}


// MARK: COLLECTION VIEW DATA SOURCE
extension ProfileViewController{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProfileCellView.identifier,
            for: indexPath
        ) as? ProfileCellView else {
            return UICollectionViewCell()
        }
        
        return cell
    }
    
    
}

// MARK: COLLECTION VIEW DELEGATE

extension ProfileViewController {
    
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
        
        if let user = user {
            header.headerVM = profileHeaderViewModel(user: user)
        }
        
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
