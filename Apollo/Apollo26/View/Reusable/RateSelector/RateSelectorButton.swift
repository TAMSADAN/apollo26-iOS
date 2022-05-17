//
//  RateSelectorButton.swift
//  Enaco
//
//  Created by 송영모 on 2022/05/11.
//

import UIKit

class RateSelectorButton: UIButton {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(text: String) {
        super.init(frame: .zero)
        self.setTitle(text, for: .normal)
        self.setTitleColor(Const.Color.black, for: .normal)
        self.titleLabel?.font = Const.Font.subheadline
    }
}
