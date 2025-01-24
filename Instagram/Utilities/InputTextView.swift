//
//  InputTextView.swift
//  Instagram
//
//  Created by milad marandi on 1/10/25.
//

import UIKit

public class InputTextView: UITextView {
    
    
    var placeHolderText:String? {
        didSet{
            self.placeHolderLabel.text = placeHolderText
        }
    }
    
    var placeHolderLabel:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        addSubview(placeHolderLabel)
        placeHolderLabel.anchor(top: topAnchor , left: leftAnchor , paddingTop: 4 , paddingLeft: 8, paddingBottom: -8)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextDidChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleTextDidChange(){
        placeHolderLabel.isHidden = !self.text.isEmpty
    }
    

}
