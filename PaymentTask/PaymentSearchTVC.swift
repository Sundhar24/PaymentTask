//
//  PaymentSearchTVC.swift
//  PaymentTask
//
//  Created by Sundhar on 17/08/24.
//

import UIKit

class PaymentSearchTVC: UITableViewCell {

    @IBOutlet weak var searchTxtView: UIView!
    
    @IBOutlet weak var searchTxt: UITextField!
    
    @IBOutlet weak var scanQRBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func sizeCell(){
        
        self.searchTxtView.layer.cornerRadius = 10
        self.scanQRBtn.layer.cornerRadius = 10
    }
}
