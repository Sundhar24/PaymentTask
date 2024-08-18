//
//  PaymentSendPinVC.swift
//  PaymentTask
//
//  Created by Sundhar on 17/08/24.
//

import UIKit

class PaymentSendPinVC: UIViewController {
    
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactPhoneLabel: UILabel!
    @IBOutlet weak var contactImg: UIImageView!
    
    @IBOutlet weak var sendingAmtLbl: UILabel!
    @IBOutlet weak var addMessageTxt: UITextView!
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var proceedBtn: UIButton!
    
    @IBOutlet weak var payeeView: UIView!
    var contact: Contact?
    var paymentcontactViewModel = PaymentConatctListViewModel()
    var payeeAmt:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerDetails()
    }
    
    func registerDetails(){
        self.addMessageTxt.delegate = self
        self.sendingAmtLbl.text = "Sending \(payeeAmt)"
        self.proceedBtn.layer.cornerRadius = 10
        self.payeeView.layer.cornerRadius = 10
        
        if let borderColor = UIColor(hex: "#83D9BB") {
            self.payeeView.layer.borderColor = borderColor.cgColor
            self.payeeView.layer.borderWidth = 1.0
                }
        if let contact = contact {
            contactNameLabel.text = contact.name
            contactPhoneLabel.text = contact.phoneNumber
            if let firstLetter = contact.name?.first {
                self.contactImg.image = paymentcontactViewModel.createImageWithLetter(
                    String(firstLetter),
                    size: self.contactImg.bounds.size,
                    backgroundColor: .lightGray,
                    textColor: .white
                )
            } else {
                self.contactImg.image = nil
            }
        }
        self.proceedBtn.addTarget(self, action: #selector(ProceedTapped), for: .touchUpInside)
        self.backBtn.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
    }
    
    @objc func backTapped(){
        dismiss(animated: true)
    }
    
    @objc func ProceedTapped(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let PaymentAmountVC = storyboard.instantiateViewController(withIdentifier: "PaymentAmountVC") as? PaymentAmountVC {
            PaymentAmountVC.showPin = true
            PaymentAmountVC.payeeName = "\(contact?.name ?? "No Contact...!")"
            self.present(PaymentAmountVC, animated: true)
        }
    }

}

extension PaymentSendPinVC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        let allowedCharacterSet = CharacterSet.letters.union(.whitespaces)
        let characterSet = CharacterSet(charactersIn: text)
        if !allowedCharacterSet.isSuperset(of: characterSet) {
            return false
        }
        
        let currentText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return currentText.count <= 70
    }

}
