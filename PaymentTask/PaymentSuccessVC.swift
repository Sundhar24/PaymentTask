//
//  PaymentSuccessVC.swift
//  PaymentTask
//
//  Created by Sundhar on 17/08/24.
//

import UIKit

class PaymentSuccessVC: UIViewController {

    @IBOutlet weak var successImg: UIImageView!
    
    @IBOutlet weak var amtLbl: UILabel!
    
    @IBOutlet weak var sendNameLbl: UILabel!
    
    @IBOutlet weak var doneBtn: UIButton!
    
    var payeeName:String = ""
    var payeeAmt:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        callDetails()
    }

    func callDetails(){
        self.doneBtn.layer.cornerRadius = 10
        self.amtLbl.text = "\(UserDefaults.standard.object(forKey: "amountToSend") ?? "")"
        self.sendNameLbl.text = "Sent to \(payeeName)"
        self.doneBtn.addTarget(self, action: #selector(DoneTapped), for: .touchUpInside)
    }
    
    @objc func DoneTapped(){
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: DashboardVC = mainStoryboard.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
        vc.modalPresentationStyle = .fullScreen
        vc.updateAmt = "\(UserDefaults.standard.object(forKey: "amountToSend") ?? "0.00")"
        self.present(vc, animated: true, completion: nil)
        
    }
}
