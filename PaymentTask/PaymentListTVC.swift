//
//  PaymentListTVC.swift
//  PaymentTask
//
//  Created by Sundhar on 17/08/24.
//

import UIKit

class PaymentListTVC: UITableViewCell {
    
    
    @IBOutlet weak var payeeImg: UIImageView!
    
    @IBOutlet weak var payeeNameLbl: UILabel!
    
    @IBOutlet weak var payeeContactLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
