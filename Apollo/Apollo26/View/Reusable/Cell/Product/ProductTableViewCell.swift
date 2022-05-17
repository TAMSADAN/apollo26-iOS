//
//  StoreTableViewCell.swift
//  Enaco
//
//  Created by 송영모 on 2022/05/10.
//

import UIKit
import Then

class ProductTableViewCell: UITableViewCell {
    static let identifier = "CoinTableViewCell"
    
    var product = Product()
    
    var productImageBackgroundView = UIView().then {
        $0.backgroundColor = Const.Color.systemGray6
        $0.layer.cornerRadius = 18
    }
    var productImageView = UIImageView()
    var nameLabel = UILabel().then {
        $0.text = "BTC"
        $0.textColor = Const.Color.black
        $0.font = Const.Font.itemTitle
    }
    var symbolLabel = UILabel().then {
        $0.text = "12개"
        $0.textColor = Const.Color.systemGray
        $0.font = Const.Font.itemBody
    }
    var priceLabel = UILabel().then {
        $0.text = "124,598.00원"
        $0.textColor = Const.Color.black
        $0.font = Const.Font.itemTitle
    }
    var percentLabel = UILabel().then {
        $0.text = "+12.00%"
        $0.textColor = Const.Color.green
        $0.font = Const.Font.itemHeadline
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setView()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setView()
    }
    
    func update(product: Product) {
        self.product = product
        
        if let img = UIImage(named: product.symbol.lowercased()) {
            productImageView.image = img
        }
        nameLabel.text = product.name
        symbolLabel.text = product.symbol.uppercased()
        priceLabel.text = String(ceil(product.price * 100) / 100).insertComma + "원"
        percentLabel.text = String(ceil(product.percent * 100) / 100).insertComma + "%"
        if product.percent > 0 {
            percentLabel.textColor = Const.Color.green
        } else if product.percent < 0 {
            percentLabel.textColor = Const.Color.pink
        } else {
            percentLabel.textColor = Const.Color.black
        }
    }
}

extension ProductTableViewCell {
    func setView() {
        let leftGuide = UILayoutGuide()
        let rightGuide = UILayoutGuide()
        
        addLayoutGuide(leftGuide)
        addLayoutGuide(rightGuide)
        addSubview(productImageBackgroundView)
        addSubview(productImageView)
        addSubview(nameLabel)
        addSubview(symbolLabel)
        addSubview(priceLabel)
        addSubview(percentLabel)
        
        productImageBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        symbolLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productImageBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            productImageBackgroundView.centerYAnchor.constraint(equalTo: centerYAnchor),
            productImageBackgroundView.widthAnchor.constraint(equalToConstant: 36),
            productImageBackgroundView.heightAnchor.constraint(equalToConstant: 36),
            
            productImageView.topAnchor.constraint(equalTo: productImageBackgroundView.topAnchor, constant: 3),
            productImageView.leadingAnchor.constraint(equalTo: productImageBackgroundView.leadingAnchor, constant: 3),
            productImageView.trailingAnchor.constraint(equalTo: productImageBackgroundView.trailingAnchor, constant: -3),
            productImageView.bottomAnchor.constraint(equalTo: productImageBackgroundView.bottomAnchor, constant: -3),
            
            leftGuide.leadingAnchor.constraint(equalTo: productImageBackgroundView.trailingAnchor, constant: 5),
            leftGuide.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: leftGuide.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: leftGuide.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: leftGuide.trailingAnchor),
            
            symbolLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            symbolLabel.leadingAnchor.constraint(equalTo: leftGuide.leadingAnchor),
            symbolLabel.trailingAnchor.constraint(equalTo: leftGuide.trailingAnchor),
            symbolLabel.bottomAnchor.constraint(equalTo: leftGuide.bottomAnchor),
            
            rightGuide.leadingAnchor.constraint(equalTo: leftGuide.trailingAnchor),
            rightGuide.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            rightGuide.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: rightGuide.topAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: rightGuide.trailingAnchor),
            
            percentLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor),
            percentLabel.trailingAnchor.constraint(equalTo: rightGuide.trailingAnchor),
            percentLabel.bottomAnchor.constraint(equalTo: rightGuide.bottomAnchor),
        ])
    }
}
