//
//  LogInpageController.swift
//  Instagram
//
//  Created by milad marandi on 11/23/24.
//

import UIKit

class LogInpageController: UIViewController {
    
    
    private var ViewModel = LogInViewModel()
    weak var delegate:MainTabBarcontrollerDelegate?
    
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
    
    
    private lazy var LoginButton:UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .systemPink
            .withAlphaComponent(0.5)
        button.setTitleColor(UIColor(white: 1, alpha: 0.5), for: .normal)
        button.isEnabled = false
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        button.setHeight(50)
        return button
    }()
    
    
    private lazy var ResetPassowordButton:UIButton = {
        let button = UIButton()
        button.attributedTitle(firstPart: "Forgot your password? ", secondPart: "Get help signing in")
        button.addTarget(self, action: #selector(handleShowResetPassword), for: .touchUpInside)
        return button
        
    }()
    
    
    private lazy var SingupButton:UIButton = {
        let button = UIButton()
        button.attributedTitle(firstPart: "Don't have an account?  ", secondPart: "Sign Up")
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    private var stackView:UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureTextFieldsActions()
    }
    
    func configureTextFieldsActions(){
        EmailTextField
            .addTarget(
                self,
                action: #selector(didtextChange),
                for: .editingChanged
            )
        PasswordTextField.addTarget(
            self,
            action: #selector(didtextChange),
            for: .editingChanged
        )
    }
    
    @objc func signIn(button:UIButton){
        guard let email = ViewModel.EmailAddressText , let password = ViewModel.PasswordText else {
            return
        }
        
        let credential = signInModel(email: email, password: password)
        AuthService.SignIn(with: credential) {
            self.delegate?.loginAuthentication()
            
            UIView
                .transition(
with: self.view.window!,
 duration: 0.5,
options: .transitionFlipFromRight,
animations: {
    // Set the new root view controller
    self.view.window?.rootViewController = MainTabController()
                },
 completion: nil)
        }
    }
    
    @objc func didtextChange(sender:UITextField) {
        if sender == EmailTextField {
            ViewModel.EmailAddressText = sender.text
        }
        else{
            ViewModel.PasswordText = sender.text
        }
        
        updateView()
    }
    
    @objc func handleShowResetPassword(){
        let controller = ResetPasswordViewController()
        controller.delegate = self
        controller.email = EmailTextField.text
        self.navigationController?.pushViewController(controller, animated: true)
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
    
    @objc func handleSignUp(){
        let vc = RegistrationController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension LogInpageController:FormUpdateView {
    
    func updateView() {
        
        LoginButton.isEnabled = ViewModel.isFormValid
        LoginButton.backgroundColor = ViewModel.isFormValid ? .systemPurple : .systemPink
            .withAlphaComponent(0.5)
        LoginButton
            .setTitleColor(
                ViewModel.isFormValid ? .white : .white.withAlphaComponent(0.5),
                for: .normal
            )
    }

    
}

extension LogInpageController:ResetPasswordControllerDelegate{
    func controllerDidSendResetPasswordLink(_ controller: ResetPasswordViewController) {
        controller.navigationController?.popViewController(animated: true)
        self.showMessage(withTitle: "Success", message: "we sent a link to your email to reset your password")
    }
    
    
    
}

