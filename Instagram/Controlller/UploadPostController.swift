//
//  UploadPostController.swift
//  Instagram
//
//  Created by kiana mehdiof on 1/10/25.
//

import UIKit
protocol uploadPostControllerDelegate:AnyObject {
    func controllerdidfinishUploadingPhoto(_ controller:UploadPostController)
}
class UploadPostController: UIViewController {
    
    var selectedImage:UIImage? {
        didSet {
            DispatchQueue.main.async {
                self.photoImageView.image = self.selectedImage
            }
        }
    }
    
    var user:User? {
        didSet{
            
        }
    }
    
    weak var delegate:uploadPostControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()

    }
    
    private let photoImageView:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
        
    }()
    
    private lazy var captionTextView:InputTextView = {
        let textView = InputTextView()
        textView.placeHolderText = "Enter caption.."
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        
        return textView
    }()
    
    
    private let characterCountLabel:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14)
        label.text = "0/100"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func checkMaxLength(_ textView:UITextView) {
        if textView.text.count > 100{
            textView.deleteBackward()
        }
    }
    
    @objc func didCancel(){
        self.dismiss(animated: true)
    }
    
    @objc func didTapDone() {
        guard let image = selectedImage else {return}
        guard let caption = captionTextView.text else { return}
        guard let user = user else { return }
        
        self.showLoader(true)
        PostService.UploadPost(caption: caption, image: image, user: user) { error in
            self.showLoader(false)
            guard error == nil else{
                print("DEBUG: Failed to upload the post, try again")
                return
            }
            self.delegate?.controllerdidfinishUploadingPhoto(self)
        }
    }
    
    func configureUI() {
        self.navigationItem.title = "Upload Post"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(didTapDone))
        
        view.addSubview(photoImageView)
        photoImageView.setDimensions(height: 180, width: 180)
        photoImageView.anchor(top: self.view.safeAreaLayoutGuide.topAnchor , paddingTop: 8)
        photoImageView.centerX(inView: self.view)
        photoImageView.layer.cornerRadius = 10
        photoImageView.layer.masksToBounds = true
        
        view.addSubview(captionTextView)
        captionTextView.anchor(top: photoImageView.bottomAnchor , left: view.leftAnchor , right: view.rightAnchor , paddingTop: 16 , paddingLeft: 12 ,paddingRight: 12 , height: 64)

        view.addSubview(characterCountLabel)
        characterCountLabel.anchor(bottom: captionTextView.bottomAnchor , right: view.rightAnchor , paddingRight: 12)
    }

}

extension UploadPostController:UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        checkMaxLength(textView)
        let count = textView.text.count
        characterCountLabel.text = "\(count)/100"
    }
}
