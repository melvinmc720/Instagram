//
//  ProfileCellView.swift
//  Instagram
//
//  Created by milad marandi on 12/14/24.
//

import UIKit
import SDWebImage

class ProfileCellView: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier:String = "ProfileCellView"
    
    var viewModel:PostViewModel? {
        didSet{
            guard let vm = viewModel else {
                return
            }
            configure(vm: vm)
        }
    }
    
    private let postImageView:UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "venom-7")
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .lightGray
        
        addSubview(postImageView)
        postImageView.fillSuperview()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(vm:PostViewModel){
        postImageView.sd_setImage(with: vm.imageURL)
    }
    
}
