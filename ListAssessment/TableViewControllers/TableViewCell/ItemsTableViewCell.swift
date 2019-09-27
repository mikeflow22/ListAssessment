//
//  ItemsTableViewCell.swift
//  ListAssessment
//
//  Created by Michael Flowers on 9/27/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import UIKit
protocol ItemsTableViewCellDelegate: class {
    func checkmarkValueChanged(cell: ItemsTableViewCell)
}
class ItemsTableViewCell: UITableViewCell {

    weak var delegate: ItemsTableViewCellDelegate?
    var item: Item? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkmarkProperties: UIButton!
  
    @IBAction func checkMarkButtonPressed(_ sender: UIButton) {
        delegate?.checkmarkValueChanged(cell: self)
    }
    
    func updateViews(){
        guard let passedInItem = item else { return }
        nameLabel.text = passedInItem.name
        let imageName = passedInItem.isComplete ? "complete" : "incomplete"
        checkmarkProperties.setImage(UIImage(named: imageName), for: .normal)
    }
    
}
