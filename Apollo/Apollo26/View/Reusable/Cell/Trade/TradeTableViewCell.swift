//
//  TradeTableViewCell.swift
//  Enaco
//
//  Created by 송영모 on 2022/05/14.
//

import UIKit

class TradeTableViewCell: UITableViewCell {
    static let identifier = "TradeTableViewCell"
    
    var trade = Trade()
    var product = Product()
    
    var tradeImageBackgroundView = UIView().then {
        $0.backgroundColor = Const.Color.systemGray6
        $0.layer.cornerRadius = 18
    }
    var tradeImageView = UIImageView()
    var nameLabel = UILabel().then {
        $0.text = ""
        $0.textColor = Const.Color.black
        $0.font = Const.Font.itemTitle
    }
    var countLabel = UILabel().then {
        $0.text = ""
        $0.textColor = Const.Color.systemGray
        $0.font = Const.Font.itemBody
    }
    var priceLabel = UILabel().then {
        $0.text = "0.0원"
        $0.textColor = Const.Color.black
        $0.font = Const.Font.itemTitle
    }
    var percentLabel = UILabel().then {
        $0.text = "+0.000%"
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
    
    func updateTrade(trade: Trade) {
        nameLabel.text = trade.name
        countLabel.text = String(trade.count) + trade.symbol.uppercased()
        if self.trade.imageSrc != trade.imageSrc {
            Log("이미지가 다시 로드되었습니다.")
            tradeImageView.downloaded(from: trade.imageSrc)
        }
        self.trade = trade
        
    }
    
    func updateProduct(product: Product) {
        priceLabel.text = String(ceil(product.price * self.trade.count * 100) / 100).insertComma + "원"
        let percent = ceil((product.price - self.trade.price) / self.trade.price * 1000) / 1000
        if percent > 0 {
            percentLabel.text = "+" + String(percent) + "%"
            percentLabel.textColor = Const.Color.green
        } else if percent < 0 {
            percentLabel.text = String(percent) + "%"
            percentLabel.textColor = Const.Color.pink
        } else {
            percentLabel.text = String(percent) + "%"
            percentLabel.textColor = Const.Color.black
        }
        self.product = product
    }
}

extension TradeTableViewCell {
    func setView() {
        let leftGuide = UILayoutGuide()
        let rightGuide = UILayoutGuide()
        
        addLayoutGuide(leftGuide)
        addLayoutGuide(rightGuide)
        addSubview(tradeImageBackgroundView)
        addSubview(tradeImageView)
        addSubview(nameLabel)
        addSubview(countLabel)
        addSubview(priceLabel)
        addSubview(percentLabel)
        
        tradeImageBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        tradeImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tradeImageBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            tradeImageBackgroundView.centerYAnchor.constraint(equalTo: centerYAnchor),
            tradeImageBackgroundView.widthAnchor.constraint(equalToConstant: 36),
            tradeImageBackgroundView.heightAnchor.constraint(equalToConstant: 36),
            
            tradeImageView.topAnchor.constraint(equalTo: tradeImageBackgroundView.topAnchor, constant: 3),
            tradeImageView.leadingAnchor.constraint(equalTo: tradeImageBackgroundView.leadingAnchor, constant: 3),
            tradeImageView.trailingAnchor.constraint(equalTo: tradeImageBackgroundView.trailingAnchor, constant: -3),
            tradeImageView.bottomAnchor.constraint(equalTo: tradeImageBackgroundView.bottomAnchor, constant: -3),
            
            leftGuide.leadingAnchor.constraint(equalTo: tradeImageBackgroundView.trailingAnchor, constant: 5),
            leftGuide.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: leftGuide.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: leftGuide.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: leftGuide.trailingAnchor),
            
            countLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            countLabel.leadingAnchor.constraint(equalTo: leftGuide.leadingAnchor),
            countLabel.trailingAnchor.constraint(equalTo: leftGuide.trailingAnchor),
            countLabel.bottomAnchor.constraint(equalTo: leftGuide.bottomAnchor),
            
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
