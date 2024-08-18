//
//  DashboardVC.swift
//  PaymentTask
//
//  Created by Sundhar on 17/08/24.
//

import UIKit

class DashboardVC: UIViewController {

    
    @IBOutlet weak var payeeNameLbl: UILabel!
    
    @IBOutlet weak var availableBalanceLbl: UILabel!
    
    @IBOutlet weak var addAmountBtn: UIButton!
    
    @IBOutlet weak var amtSendBtn: UIButton!
    
    @IBOutlet weak var amtRecevieBtn: UIButton!
    
    @IBOutlet weak var payeeListTableView: UITableView!
    
    let dashboardViewModel = DashboardViewModel()
    var paymentcontactViewModel: PaymentConatctListViewModel!
    var updateAmt:String = "0.0"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CallandSize()
        RegisterCell()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func RegisterCell() {
        self.dashboardViewModel.fetchActivities()
        if let stringAmount = UserDefaults.standard.string(forKey: "defaultAmount"), !stringAmount.isEmpty {
            let stringAmountWithCommas = updateAmt.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Remove dollar sign and any non-breaking spaces
            let cleanedString = stringAmountWithCommas
                .replacingOccurrences(of: "$", with: "")
                .replacingOccurrences(of: "\u{00A0}", with: "")
                .replacingOccurrences(of: ",", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            
            if let doubleAmount = Double(cleanedString) {
                print("The double value is: \(doubleAmount)")
                self.updateAvailableBalance(by: doubleAmount)
            } else {
                print("Invalid string for conversion: \(cleanedString)")
            }
        } else {
            UserDefaults.standard.setValue("14,000", forKey: "defaultAmount")
            availableBalanceLbl.text = UserDefaults.standard.string(forKey: "defaultAmount")
        }
            
        
        self.payeeListTableView.dataSource = self
        self.payeeListTableView.delegate = self
        payeeListTableView.showsVerticalScrollIndicator = false
        self.payeeListTableView.register(UINib(nibName: "DashBoardListTVC", bundle: nil), forCellReuseIdentifier: "DashBoardListTVC")
    }

    func updateAvailableBalance(by updateAmt: Double) {
        guard let currentText = UserDefaults.standard.string(forKey: "defaultAmount") else {
            print("Label text is nil")
            return
        }
        
        // Remove commas and convert to Double
        let cleanedText = currentText
            .replacingOccurrences(of: "$", with: "")
            .replacingOccurrences(of: "\u{00A0}", with: "")
            .replacingOccurrences(of: ",", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let currentBalance = Double(cleanedText) else {
            print("Cannot convert label text to a Double")
            return
        }
        
        let newBalance = currentBalance - updateAmt
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        guard let formattedBalance = numberFormatter.string(from: NSNumber(value: newBalance)) else {
            print("Cannot format the new balance")
            return
        }
        
        UserDefaults.standard.setValue(formattedBalance, forKey: "defaultAmount")
        availableBalanceLbl.text = formattedBalance
    }

    
    func CallandSize(){
        
        self.amtSendBtn.layer.cornerRadius = 10
        self.amtRecevieBtn.layer.cornerRadius = 10
        self.addAmountBtn.layer.cornerRadius = 10
        
        self.amtSendBtn.addTarget(self, action: #selector(SendTapped), for: .touchUpInside)
        
        
    }
    
    @objc func SendTapped(){
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: PaymentAmountVC = mainStoryboard.instantiateViewController(withIdentifier: "PaymentAmountVC") as! PaymentAmountVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
    }


}

extension DashboardVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dashboardViewModel.sortedDates.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let date = dashboardViewModel.sortedDates[section]
        return dashboardViewModel.groupedActivities[date]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DashBoardListTVC", for: indexPath) as! DashBoardListTVC
                let date = dashboardViewModel.sortedDates[indexPath.section]
                if let activities = dashboardViewModel.groupedActivities[date] {
                    let activity = activities[indexPath.row]
                    cell.configure(with: activity)
                    if let firstLetter = activity.name.first {
                        cell.profileImg.image = dashboardViewModel.createImageWithLetter(
                            String(firstLetter),
                            size: cell.profileImg.bounds.size,
                            backgroundColor: .lightGray,
                            textColor: .white
                        )
                    } else {
                        cell.profileImg.image = nil
                    }
        }
                
       return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dashboardViewModel.sortedDates[section]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .white

        let headerLabel = UILabel()
        headerLabel.text = dashboardViewModel.sortedDates[section]
        headerLabel.font = UIFont.systemFont(ofSize: 12)
        headerLabel.textColor = .lightGray
        headerLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
        headerView.addSubview(headerLabel)
        
        return headerView
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Payee List TableView Cell Tapped...!" )
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
