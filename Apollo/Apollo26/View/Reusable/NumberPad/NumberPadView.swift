//
//  NumberPadView.swift
//  Enaco
//
//  Created by 송영모 on 2022/05/11.
//

import UIKit
import Then

class NumberPadView: UIView {
    
    let numberPadTexts = ["1", "2", "3", "4", "5", "6", "7", "8", "9", ".", "0", "C"]
    var numberPadButtons: [NumberPadButton] = []
    var numberPadStackViews: [UIStackView] = []
    var totalStackView = UIStackView().then {
        $0.spacing = 20
        $0.distribution = .fillEqually
        $0.axis = .vertical
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
}

extension NumberPadView {
    func setView() {
        addSubview(totalStackView)
        
        totalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            totalStackView.topAnchor.constraint(equalTo: topAnchor),
            totalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            totalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            totalStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        for _ in 0..<numberPadTexts.count / 3 {
            let numberPadStackView = UIStackView().then {
                $0.spacing = 0
                $0.distribution = .fillEqually
            }
            totalStackView.addArrangedSubview(numberPadStackView)
            
            numberPadStackView.translatesAutoresizingMaskIntoConstraints = false
            
            numberPadStackViews.append(numberPadStackView)
            
            NSLayoutConstraint.activate([
                numberPadStackView.leadingAnchor.constraint(equalTo: totalStackView.leadingAnchor),
                numberPadStackView.trailingAnchor.constraint(equalTo: totalStackView.trailingAnchor),
            ])
        }
        
        for (i, numberPadText) in numberPadTexts.enumerated() {
            let numberPadButton = NumberPadButton(text: numberPadText)
            
            numberPadButtons.append(numberPadButton)
            numberPadStackViews[i / 3].addArrangedSubview(numberPadButton)
        }
        
    }
}
