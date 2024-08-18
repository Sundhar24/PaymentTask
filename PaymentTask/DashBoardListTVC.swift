//
//  DashBoardListTVC.swift
//  PaymentTask
//
//  Created by Sundhar on 17/08/24.
//

import UIKit

class DashBoardListTVC: UITableViewCell {
    
    
    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var payeeListNameLbl: UILabel!
    
    @IBOutlet weak var sentOrReceiveLbl: UILabel!
    
    @IBOutlet weak var payeeAmtLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func configure(with activity: Activity) {
        payeeListNameLbl.text = activity.name
        payeeAmtLbl.text = activity.amount
        profileImg.image = UIImage(named: activity.profileImage ?? "profileImg")
            
            
            switch activity.transactionType {
            case .sent:
                sentOrReceiveLbl.text = "Sent"
                profileImg.image = UIImage(named: activity.profileImage ?? "profileImg")

            case .received:
                sentOrReceiveLbl.text = "Recevied"
                profileImg.image = UIImage(named: activity.profileImage ?? "profileImg")

            case .requested:
                sentOrReceiveLbl.text = "Requested"
                profileImg.image = UIImage(named: activity.profileImage ?? "profileImg")

            case .funded:
                sentOrReceiveLbl.text = "Funded"
                profileImg.image = UIImage(named: activity.profileImage ?? "profileImg")

            }
        }
    
}
