//
//  CustomTextField.swift
//  Instagram
//
//  Created by milad marandi on 11/23/24.
//

import UIKit

class CustomTextField: UITextField {
    
    init(placeholder: String) {
        super.init(frame: .zero)
        
        let view = UIView()
        view.frame.size = CGSize(width: 12, height: self.frame.height)
        leftView = view
        leftViewMode = .always
        self.autocapitalizationType = .none
        borderStyle = .none
        textColor = .white
        keyboardAppearance = .dark
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor:UIColor(white: 1, alpha: 0.7)]
        )
        
        backgroundColor = UIColor(white: 1, alpha: 0.1)
        setHeight(50)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
