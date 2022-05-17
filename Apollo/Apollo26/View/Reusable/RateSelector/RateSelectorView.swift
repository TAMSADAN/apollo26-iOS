//
//  RateSelectorView.swift
//  Enaco
//
//  Created by 송영모 on 2022/05/11.
//

import UIKit
import Then

class RateSelectorView: UIView {
    var rateSelectorButtonStackView = UIStackView().then {
        $0.spacing = 0
        $0.distribution = .fillEqually
        $0.axis = .horizontal
    }
    
    var rateSelectorButton1 = RateSelectorButton(text: "25%")
    var rateSelectorButton2 = RateSelectorButton(text: "50%")
    var rateSelectorButton3 = RateSelectorButton(text: "75%")
    var rateSelectorButton4 = RateSelectorButton(text: "100%")
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
}

extension RateSelectorView {
    func setView() {
        rateSelectorButtonStackView.addArrangedSubview(rateSelectorButton1)
        rateSelectorButtonStackView.addArrangedSubview(rateSelectorButton2)
        rateSelectorButtonStackView.addArrangedSubview(rateSelectorButton3)
        rateSelectorButtonStackView.addArrangedSubview(rateSelectorButton4)
        
        addSubview(rateSelectorButtonStackView)
        
        rateSelectorButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            rateSelectorButtonStackView.topAnchor.constraint(equalTo: topAnchor),
            rateSelectorButtonStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            rateSelectorButtonStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            rateSelectorButtonStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
