//
//  RegularButton.swift
//  Enaco
//
//  Created by 송영모 on 2022/05/11.
//

import UIKit

class ConfirmButton: UIButton {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(text: String) {
        super.init(frame: .zero)
        self.layer.cornerRadius = 10
        self.setTitle(text, for: .normal)
        self.titleLabel?.font = Const.Font.headline
        self.titleLabel?.textColor = Const.Color.white
        self.backgroundColor = Const.Color.blue
    }
}
