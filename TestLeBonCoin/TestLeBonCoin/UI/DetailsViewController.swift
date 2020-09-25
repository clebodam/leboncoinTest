//
//  DetailsViewController.swift
//  TestLeBonCoin
//
//  Created by Damien on 24/09/2020.
//

import UIKit

class DetailsViewController: UIViewController {

    // MARK: - PROPERTIES
    private var viewModel : ItemViewModel
    private var scrollView = UIScrollView()
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
        lbl.font = UIFont.boldSystemFont(ofSize: font20)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.clipsToBounds = true
        lbl.layer.cornerRadius = cornerSize
        return lbl
    }()

    private let itemDateLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .darkGray
        lbl.font = UIFont.systemFont(ofSize: font12)
        lbl.textAlignment = .right
        lbl.numberOfLines = 0
        return lbl
    }()

    private let itemDescriptionLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: font16)
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
    // MARK: - INIT
    init(_ viewModel: ItemViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - UI CREATION

    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(itemImage)
        scrollView.addSubview(urgentImage)
        scrollView.addSubview(itemNameLabel)
        scrollView.addSubview(itemDateLabel)
        scrollView.addSubview(itemPriceLabel)
        scrollView.addSubview(itemDescriptionLabel)

        scrollView.backgroundColor = .white
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: true)
        itemImage.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: nil, right: nil, paddingTop:paddingSize, paddingLeft: paddingSize, paddingBottom: 0, paddingRight: 0, width: imageFullSize, height: imageFullSize, enableInsets: true)
        urgentImage.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft:0, paddingBottom: 0, paddingRight: 0, width: smallImageSize, height: smallImageSize, enableInsets: true)
        itemNameLabel.anchor(top: itemImage.bottomAnchor, left: itemImage.leftAnchor, bottom: nil, right: itemImage.rightAnchor, paddingTop: marginSize, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: true)
        itemDateLabel.anchor(top: itemNameLabel.bottomAnchor, left: itemImage.leftAnchor, bottom: nil, right: nil, paddingTop: marginSize, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: true)
        itemPriceLabel.anchor(top: itemNameLabel.bottomAnchor, left: nil, bottom: nil, right:  itemImage.rightAnchor, paddingTop: marginSize, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: true)
        itemDescriptionLabel.anchor(top: itemPriceLabel.bottomAnchor, left: itemImage.leftAnchor, bottom: scrollView.bottomAnchor, right:  itemImage.rightAnchor, paddingTop: marginSize, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: true)
    }
    // MARK: - UI SETUP
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
   }

    private func setupUI() {
        self.navigationController?.navigationBar.barTintColor = UIColor.randomColor(seed: viewModel.category.name)
        self.title = viewModel.category.name
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white
        itemNameLabel.text = viewModel.title
        itemNameLabel.backgroundColor = UIColor.randomColor(seed: viewModel.category.name)
        itemNameLabel.textColor = .white
        urgentImage.isHidden = !viewModel.isUrgent
        itemDescriptionLabel.text = viewModel.description
        if let url =  viewModel.largeImageUrl {
            itemImage.loadImageUsingCache(withUrl: url)
        }
        if let date =  viewModel.getCreationDate() {
            itemDateLabel.text = date
        }
        itemPriceLabel.text = "\(String(format: "%.2f",  viewModel.price)) €"
    }
}
