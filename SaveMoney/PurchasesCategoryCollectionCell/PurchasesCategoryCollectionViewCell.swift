//
//  PurchasesCategoryCollectionViewCell.swift
//  SaveMoney
//
//  Created by Кирилл Крамар on 28.06.2020.
//  Copyright © 2020 Кирилл Крамар. All rights reserved.
//

import UIKit

class PurchasesCategoryCollectionViewCell: UICollectionViewCell {
    
    //MARK : - Static Property
    static let identifier = "PurchasesCategoryCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "PurchasesCategoryCollectionViewCell",
                     bundle: nil)
    }
    
    var viewModel: PurchasesCategoryCollectionViewCellViewModelProtocol! {
        didSet {
            nameCategoryLabel.text = viewModel.getCategoryName()
            moneyCountLabel.text = viewModel.getMoneyCount()
            categoryImageView.image = UIImage(named: viewModel.getImageName())
        }
    }
    //MARK: - IB Outlets
    @IBOutlet var colorView: UIView!
    @IBOutlet var categoryImageView: UIImageView!
    @IBOutlet var nameCategoryLabel: UILabel!
    @IBOutlet var moneyCountLabel: UILabel!

    // MARK : - Override Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        colorView.layer.cornerRadius = colorView.frame.width/2
    }
}
