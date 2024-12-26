//
//  RegistrationController.swift
//  Instagram
//
//  Created by milad marandi on 11/23/24.
//

import UIKit

class RegistrationController: UIViewController {
    
    private let ImageButton:UIButton = {
        let button = UIButton()
        button
            .setImage(
                UIImage(named:"plus_photo")?
                    .withTintColor(.white, renderingMode: .alwaysOriginal),
                for: .normal
            )
        button.tintColor = .white
        button.clipsToBounds = true
        button
            .addTarget(
                self,
                action: #selector(openGallery),
                for: .touchUpInside
            )
        return button
    }()
    
    var profileImage:UIImage?
    
    
    
    private var EmailTextField:UITextField = {
       
        let textfield = CustomTextField(placeholder: "Email")
        textfield.keyboardType = .emailAddress
        return textfield
        
    }()
    
    private var passwordTextField:UITextField = {
       
        let textfield = CustomTextField(placeholder: "password")
        textfield.keyboardType = .default
        return textfield
        
    }()
    
    
    private var FullnameTextField:UITextField = {
       
        let textfield = CustomTextField(placeholder: "Fullname")
        textfield.keyboardType = .default
        return textfield
        
    }()
    
    private var UsernameTextField:UITextField = {
       
        let textfield = CustomTextField(placeholder: "Username")
        textfield.keyboardType = .default
        return textfield
        
    }()
    
    private var SignUpButton:UIButton = {
        let button = UIButton()
        button.setTitle("Sign up", for: .normal)
        button.backgroundColor = .systemPink.withAlphaComponent(0.5)
        button.setTitleColor(UIColor(white: 1, alpha: 0.5), for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(signUP), for: .touchUpInside)
        button.setHeight(50)
        return button
    }()
    
    private var AlreadyHaveAnaccount:UIButton = {
        let button = UIButton()
        button.attributedTitle(firstPart: "Already have an account?  ", secondPart: "Log In")
        button.addTarget(self, action: #selector(handleShowlogin), for: .touchUpInside)
        return button
    }()
    
    
    
    private var stackView:UIStackView!
    private var ViewModel = RegisterationViewModel()

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
        passwordTextField.addTarget(
            self,
            action: #selector(didtextChange),
            for: .editingChanged
        )
        
        UsernameTextField.addTarget(
            self,
            action: #selector(didtextChange),
            for: .editingChanged
        )
        
        FullnameTextField.addTarget(
            self,
            action: #selector(didtextChange),
            for: .editingChanged
        )
    }
    
    @objc func openGallery(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        self.present(vc, animated: true)
    }
    
    @objc func signUP(){
        guard let email = ViewModel.EmailAddressText , let password = ViewModel.PasswordText , let username = ViewModel.UsernameText , let fullname = ViewModel.FullNameText , let image = self.profileImage else {
            return
        }
        
        AuthService.Signup(with: singupFormModel(
            email: email,
            password: password,
            username: username,
            fullName: fullname,
            image: image
        )) {
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc func didtextChange(sender:UITextField) {
        
        switch sender {
        case EmailTextField:
            ViewModel.EmailAddressText = sender.text
        case passwordTextField:
            ViewModel.PasswordText = sender.text
        case UsernameTextField:
            ViewModel.UsernameText = sender.text
        case FullnameTextField:
            ViewModel.FullNameText = sender.text
        default:
            updateView()
        }
        
        updateView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // - MARK: Navigation Controller
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.barStyle = .black
    }
    
    @objc func handleShowlogin(){
        self.navigationController?.popViewController(animated: true)
    }
    
    private func configure(){
        
        
        // - MARK: Linear Gradiant
        configureGradientLayer()
        
        view.addSubview(ImageButton)
        ImageButton.centerX(inView: view)
        ImageButton.setDimensions(height: 140, width: 140)
        ImageButton
            .anchor(top: view.safeAreaLayoutGuide.topAnchor , paddingTop: 32)
        ImageButton.layer.cornerRadius = ImageButton.frame.height / 2
        ImageButton.layer.masksToBounds = true
        
        
        // - MARK: vertical StackView
        stackView = UIStackView(
            arrangedSubviews: [
                EmailTextField ,
                passwordTextField ,
                FullnameTextField,
                UsernameTextField,
                SignUpButton
            ]
        )
            
            stackView.axis = .vertical
            stackView.spacing = 20
        
        
        // - MARK: addSubview
           view.addSubview(stackView)
           
        
        stackView
            .anchor(
                top: ImageButton.bottomAnchor,
                left: view.leftAnchor,
                right: view.rightAnchor,
                paddingTop: 32 ,
                paddingLeft: 32 , paddingRight: 32
            )
        
        view.addSubview(AlreadyHaveAnaccount)
        AlreadyHaveAnaccount.centerX(inView: view)
        AlreadyHaveAnaccount
            .anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)

    }
    

}

extension RegistrationController:FormUpdateView , UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    func updateView() {
        
        SignUpButton.isEnabled = ViewModel.isFormValid
        SignUpButton.backgroundColor = ViewModel.isFormValid ? .systemPurple : .systemPink
            .withAlphaComponent(0.5)
        SignUpButton
            .setTitleColor(
                ViewModel.isFormValid ? .white : .white.withAlphaComponent(0.5),
                for: .normal
            )
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        DispatchQueue.main.async {
            self.ImageButton.setImage(image, for: .normal)
            self.profileImage = image
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    
}
