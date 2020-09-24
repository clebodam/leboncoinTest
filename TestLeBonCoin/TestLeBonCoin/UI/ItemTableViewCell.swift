//
//  ItemTableViewCell.swift
//  TestLeBonCoin
//
//  Created by Damien on 24/09/2020.
//

import UIKit

class ItemTableViewCell : UITableViewCell {

    var viewModel : ItemViewModel? {
        didSet {
            itemNameLabel.text = viewModel?.title
            // itemDescriptionLabel.text = viewModel?.description
            urgentImage.isHidden = !(viewModel?.isUrgent ?? false)
            if let url =  viewModel?.smallImageUrl {
                itemImage.loadImageUsingCache(withUrl: url)
            }
            if  let name = viewModel?.category.name {
                categoryLabel.text = viewModel?.category.name
                categoryLabel.backgroundColor = UIColor.randomColor(seed: name)
            }
            if let date =  viewModel?.getCreationDate() {
                itemDateLabel.text = date
            }
            if let price = viewModel?.price {
                itemPriceLabel.text = "\(String(format: "%.2f", price)) €"
            }
        }
    }

    private let itemPriceLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: font12)
        lbl.textAlignment = .right
        lbl.numberOfLines = 0
        return lbl
    }()

    private let itemNameLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: font10)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()

    private let categoryLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.boldSystemFont(ofSize: font16)
        lbl.textAlignment = .center
        lbl.numberOfLines = 1
        lbl.layer.cornerRadius = cornerSize
        lbl.clipsToBounds = true
        return lbl
    }()

    private let itemDateLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .darkGray
        lbl.font = UIFont.systemFont(ofSize: font8)
        lbl.textAlignment = .right
        lbl.numberOfLines = 0
        return lbl
    }()
    private let itemDescriptionLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: font8)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()

    private let itemImage : UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = cornerSize
        return imgView
    }()

    private let urgentImage : UIImageView = {
        let imgView = UIImageView(image: UIImage(named:"urgent"))
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        return imgView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubview(itemImage)
        addSubview(urgentImage)
        addSubview(itemNameLabel)
        addSubview(itemDateLabel)
        addSubview(itemPriceLabel)
        addSubview(itemDescriptionLabel)
        addSubview(categoryLabel)

        itemImage.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop:paddingSize, paddingLeft: paddingSize, paddingBottom: 0, paddingRight: 0, width: imageSize, height: imageSize, enableInsets: true)
        urgentImage.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft:0, paddingBottom: 0, paddingRight: 0, width: smallImageSize, height: smallImageSize, enableInsets: true)
        categoryLabel.anchor(top: topAnchor, left: itemImage.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: paddingSize, paddingLeft: paddingSize, paddingBottom: 0, paddingRight: -paddingSize, width: 0, height: 0, enableInsets: true)
        itemNameLabel.anchor(top: categoryLabel.bottomAnchor, left: itemImage.rightAnchor, bottom: nil, right: itemDateLabel.leftAnchor, paddingTop: marginSize, paddingLeft: paddingSize, paddingBottom: 0, paddingRight: marginSize, width: 0, height: 0, enableInsets: true)
        itemPriceLabel.anchor(top: nil, left: itemImage.rightAnchor, bottom: itemImage.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: paddingSize, paddingBottom: 0, paddingRight: paddingSize, width: 0, height: 0, enableInsets: true)
        itemDateLabel.anchor(top: categoryLabel.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: sizeWithRatio(10), paddingLeft: paddingSize, paddingBottom: 0, paddingRight: paddingSize, width: sizeWithRatio(40), height: 0, enableInsets: true)
        itemDescriptionLabel.anchor(top: itemPriceLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: marginSize, paddingLeft: paddingSize, paddingBottom: marginSize, paddingRight: paddingSize, width: 0 , height: 0, enableInsets: true)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
