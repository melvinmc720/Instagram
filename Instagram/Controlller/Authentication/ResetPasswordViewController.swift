//
//  ResetPasswordViewController.swift
//  Instagram
//
//  Created by milad marandi on 2/13/25.
//

import UIKit

protocol ResetPasswordControllerDelegate : AnyObject {
    func controllerDidSendResetPasswordLink(_ controller:ResetPasswordViewController)
}

class ResetPasswordViewController: UIViewController {

    // MARK: - Properties
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    private let iconImageView = UIImageView(image: UIImage(named: "Instagram_logo_white"))
    
    weak var delegate:ResetPasswordControllerDelegate?
    var email:String?
    
    private var viewModel = ResetPasswordViewModel()
    
    private lazy var resetPasswordButton:UIButton = {
        let button = UIButton()
        button.setTitle("Reset Password", for: .normal)
        button.backgroundColor = .systemPink
            .withAlphaComponent(0.5)
        button.setTitleColor(UIColor(white: 1, alpha: 0.5), for: .normal)
        button.isEnabled = false
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleResetPassword), for: .touchUpInside)
        button.setHeight(50)
        return button
    }()
    
    private lazy var backButton:UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        emailTextField.text = email
        viewModel.EmailAddressText = email
        updateView()
        
        emailTextField.addTarget(self, action: #selector(didtextChange), for: .editingChanged)
        
        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor , paddingTop: 16 ,paddingLeft: 16)
        
        
        view.addSubview(iconImageView)
        
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.centerX(inView: view)
        iconImageView.setDimensions(height: 80, width: 220)
        iconImageView
            .anchor(top: self.view.safeAreaLayoutGuide.topAnchor , paddingTop: 32)
        
        let stackView = UIStackView(
            arrangedSubviews: [
                emailTextField ,
                resetPasswordButton
            ]
        )
            
            stackView.axis = .vertical
            stackView.spacing = 20
        
        view.addSubview(stackView)
        
        stackView
            .anchor(
                top:iconImageView.bottomAnchor  ,
                left:  view.leftAnchor,
                right:  view.rightAnchor,
                paddingTop: 32 ,
                paddingLeft:32 ,
                paddingRight: 32
            )

    }
    
    
    private func configure(){
        
        configureGradientLayer()
    }
    
    @objc func handleResetPassword() {
        guard let email = emailTextField.text else { return }
        showLoader(true)
        
        AuthService.resetPassword(withEmail: email) { error in
            guard error == nil else {
                self.showLoader(false)
                self.showMessage(withTitle: "Error", message: error!.localizedDescription)
                return}
            
            self.delegate?.controllerDidSendResetPasswordLink(self)
            self.showLoader(false)
        }
        
    }
    
    @objc func handleDismissal(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didtextChange(sender:UITextField) {
        if sender == emailTextField {
            viewModel.EmailAddressText = sender.text
        }
        
        updateView()
    }



}

extension ResetPasswordViewController:FormUpdateView {
    
    func updateView() {
        
        resetPasswordButton.isEnabled = viewModel.isFormValid
        resetPasswordButton.backgroundColor = viewModel.isFormValid ? .systemPurple : .systemPink
            .withAlphaComponent(0.5)
        resetPasswordButton
            .setTitleColor(
                viewModel.isFormValid ? .white : .white.withAlphaComponent(0.5),
                for: .normal
            )
    }

    
}

