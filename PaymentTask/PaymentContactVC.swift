//
//  PaymentContactVC.swift
//  PaymentTask
//
//  Created by Sundhar on 17/08/24.
//

import UIKit

class PaymentContactVC: UIViewController{
    
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var contactListTableView: UITableView!
    
    var payeeAmt: String = ""
    
    var paymentcontactViewModel = PaymentConatctListViewModel()
    
    var cachedImages: [String: UIImage] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        paymentcontactViewModel.loadContacts()
        registerContactCell()
    }
    
    func registerContactCell() {
        self.backBtn.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        self.contactListTableView.delegate = self
        self.contactListTableView.dataSource = self
        self.contactListTableView.register(UINib(nibName: "PaymentSearchTVC", bundle: nil), forCellReuseIdentifier: "PaymentSearchTVC")
        self.contactListTableView.register(UINib(nibName: "PaymentRecentTVC", bundle: nil), forCellReuseIdentifier: "PaymentRecentTVC")
        self.contactListTableView.register(UINib(nibName: "PaymentListTVC", bundle: nil), forCellReuseIdentifier: "PaymentListTVC")
        
    }
    
    @objc func backTapped(){
        dismiss(animated: true)
    }
    
   
}

extension PaymentContactVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return paymentcontactViewModel.sectionTitles.count + 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            let key = paymentcontactViewModel.sectionTitles[section - 2]
            return paymentcontactViewModel.filteredContacts[key]?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentSearchTVC", for: indexPath) as! PaymentSearchTVC
            cell.searchTxt.delegate = self
            cell.searchTxtView.layer.cornerRadius = 10
            cell.scanQRBtn.layer.cornerRadius = 10
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentRecentTVC", for: indexPath) as! PaymentRecentTVC
            let contactName = paymentcontactViewModel.allContacts[indexPath.row].name
            cell.selectionStyle = .none
            cell.contactNameLbl.text = contactName
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentListTVC", for: indexPath) as! PaymentListTVC
            let key = paymentcontactViewModel.sectionTitles[indexPath.section - 2]
            let contact = paymentcontactViewModel.filteredContacts[key]?[indexPath.row]
            cell.selectionStyle = .none
            cell.payeeNameLbl.text = contact?.name
            cell.payeeContactLbl.text = contact?.phoneNumber
            
            if let contactName = contact?.name, !contactName.isEmpty {
                if let cachedImage = cachedImages[contactName] {
                    cell.payeeImg.image = cachedImage
                } else {
                    let image = paymentcontactViewModel.createImageWithLetter(
                        String(contactName.first!),
                        size: cell.payeeImg.bounds.size,
                        backgroundColor: .lightGray,
                        textColor: .white
                    )
                    cachedImages[contactName] = image
                    cell.payeeImg.image = image
                }
            } else {
                cell.payeeImg.image = nil
            }
            
            return cell
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return paymentcontactViewModel.sectionTitles
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section >= 2 {
            let key = paymentcontactViewModel.sectionTitles[indexPath.section - 2]
            let selectedContact = paymentcontactViewModel.filteredContacts[key]?[indexPath.row]
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let contactDetailVC = storyboard.instantiateViewController(withIdentifier: "PaymentSendPinVC") as? PaymentSendPinVC {
                contactDetailVC.modalPresentationStyle = .fullScreen
                contactDetailVC.contact = selectedContact
                contactDetailVC.payeeAmt = "\(UserDefaults.standard.object(forKey: "amountToSend") ?? "0.00")"
                self.present(contactDetailVC, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 65
        case 1:
            return 160
        default:
            return 70
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section >= 2 {
               let index = section - 2
               if index >= 0 && index < paymentcontactViewModel.sectionTitles.count {
                   return paymentcontactViewModel.sectionTitles[index]
               }
           }
           return nil
    }
}

extension PaymentContactVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
          print("Current search query: \(currentText)")
          paymentcontactViewModel.filterContacts(query: currentText)
          contactListTableView.reloadSections(IndexSet(integersIn: 2..<contactListTableView.numberOfSections), with: .automatic)
          return true
    }
}
