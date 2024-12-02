//
//  LogInpageController.swift
//  Instagram
//
//  Created by milad marandi on 11/23/24.
//

import UIKit

class LogInpageController: UIViewController {
    
    
    
    private var iconImage:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(named: "Instagram_logo_white")
        return iv
    }()
    
    
    private var EmailTextField:UITextField = {
       
        let textfield = CustomTextField(placeholder: "Email")
        textfield.keyboardType = .emailAddress
        return textfield
        
    }()
    
    
    private var PasswordTextField:UITextField = {
       
        let textfield = CustomTextField(placeholder: "Password")
        textfield.isSecureTextEntry = true
        return textfield
        
    }()
    
    
    private var LoginButton:UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .purple
        button.setTitleColor(UIColor(white: 1, alpha: 0.8), for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.setHeight(50)
        return button
    }()
    
    
    private var ResetPassowordButton:UIButton = {
        let button = UIButton()
        button.attributedTitle(firstPart: "Forgot your password? ", secondPart: "Get help signing in")
        return button
        
    }()
    
    
    private var SingupButton:UIButton = {
        let button = UIButton()
        button.attributedTitle(firstPart: "Don't have an account?  ", secondPart: "Sign Up")
    
        return button
    }()
    
    private var stackView:UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 80, width: 220)
        iconImage
            .anchor(top: self.view.safeAreaLayoutGuide.topAnchor , paddingTop: 32)
        stackView
            .anchor(
                top:iconImage.bottomAnchor  ,
                left:  view.leftAnchor,
                right:  view.rightAnchor,
                paddingTop: 32 ,
                paddingLeft:32 ,
                paddingRight: 32
            )
        
        SingupButton.centerX(inView: view)
        SingupButton
            .anchor(
                bottom: self.view.safeAreaLayoutGuide.bottomAnchor
            )
        
    }
    
    
    
    private func configure(){
        
        // - MARK: Navigation Controller
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.barStyle = .black
        
        // - MARK: Linear Gradiant
        let gradiant = CAGradientLayer()
        gradiant.colors = [
            UIColor.systemPurple.cgColor ,
            UIColor.systemBlue.cgColor
        ]
        
        gradiant.locations = [0 , 1]
        view.layer.addSublayer(gradiant)
        gradiant.frame = view.frame
        
        
        
        // - MARK: vertical StackView
        stackView = UIStackView(
            arrangedSubviews: [
                EmailTextField ,
                PasswordTextField ,
                LoginButton,
                ResetPassowordButton
            ]
        )
            
            stackView.axis = .vertical
            stackView.spacing = 20
        
        
        // - MARK: addSubview
           view.addSubview(iconImage)
           view.addSubview(stackView)
           view.addSubview(SingupButton)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
