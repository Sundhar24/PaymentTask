//
//  PaymentAmountVC.swift
//  PaymentTask
//
//  Created by Sundhar on 17/08/24.
//

import UIKit
import Combine

class PaymentAmountVC: UIViewController {
    
    
    @IBOutlet weak var balanceView: UIView!
    @IBOutlet weak var balanceAmtLbl: UILabel!
    
    @IBOutlet weak var enterAmtLbl: UILabel!
    
    @IBOutlet weak var oneBtn: UIButton!
    @IBOutlet weak var twoBtn: UIButton!
    @IBOutlet weak var threeBtn: UIButton!
    @IBOutlet weak var fourBtn: UIButton!
    @IBOutlet weak var fiveBtn: UIButton!
    @IBOutlet weak var sixBtn: UIButton!
    @IBOutlet weak var sevenBtn: UIButton!
    @IBOutlet weak var eightBtn: UIButton!
    @IBOutlet weak var nineBtn: UIButton!
    @IBOutlet weak var dotBtn: UIButton!
    @IBOutlet weak var zeroBtn: UIButton!
    
    @IBOutlet weak var earseBtn: UIButton!
    
    @IBOutlet weak var confirmBtn: UIButton!
    
    @IBOutlet weak var showPinView: UIView!
    
    
    @IBOutlet weak var firstPinLbl: UILabel!
    @IBOutlet weak var secondPinLbl: UILabel!
    @IBOutlet weak var thirdPinLbl: UILabel!
    @IBOutlet weak var fourPinLbl: UILabel!
    
    
    private var paymentViewModel: PaymentAmountViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    var showPin:Bool = false
    var payeeName:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        sizeOfCall()
        showPinEnter()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        sizeOfCall()
    }
    
    func registerCell(){
        if let value = UserDefaults.standard.string(forKey: "defaultAmount") {
            let cleanedString = value
                .replacingOccurrences(of: "$", with: "")
                .replacingOccurrences(of: "\u{00A0}", with: "")
                .replacingOccurrences(of: ",", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            if let doubleValue = Double(cleanedString) {
                paymentViewModel = PaymentAmountViewModel(balance: doubleValue)
            }
        }
        setupBindings()
        setupButtonActions()
    }
    
    func sizeOfCall(){
        self.balanceView.layer.cornerRadius = 10
        self.confirmBtn.layer.cornerRadius = 10
        
        self.firstPinLbl.layer.cornerRadius = 10
        self.firstPinLbl.clipsToBounds = true
        self.secondPinLbl.layer.cornerRadius = 10
        self.secondPinLbl.clipsToBounds = true
        self.thirdPinLbl.layer.cornerRadius = 10
        self.thirdPinLbl.clipsToBounds = true
        self.fourPinLbl.layer.cornerRadius = 10
        self.fourPinLbl.clipsToBounds = true
        
    }
    
    func showPinEnter(){
        
        if showPin == true{
            self.showPinView.isHidden = false
            self.dotBtn.setTitle("", for: .normal)
            
        }else{
            self.showPinView.isHidden = true
            self.dotBtn.setTitle(".", for: .normal)
        }
        
    }

    private func setupBindings() {
        paymentViewModel.$balance
            .receive(on: RunLoop.main)
            .assign(to: \.text!, on: balanceAmtLbl)
            .store(in: &cancellables)
        
        paymentViewModel.$amountToSend
            .receive(on: RunLoop.main)
            .assign(to: \.text!, on: enterAmtLbl)
            .store(in: &cancellables)
        
        paymentViewModel.$isConfirmEnabled
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: confirmBtn)
            .store(in: &cancellables)
        
        paymentViewModel.$shouldShowConfirmButton
            .receive(on: RunLoop.main)
            .sink { [weak self] shouldShow in
                self?.confirmBtn.isHidden = !shouldShow
            }
            .store(in: &cancellables)
        
        paymentViewModel.$enteredPin
            .receive(on: RunLoop.main)
            .sink { [weak self] enteredPin in
                self?.updatePinLabels(enteredPin)
            }
            .store(in: &cancellables)
    }

    private func updatePinLabels(_ pin: String) {
        let pinArray = Array(pin)
        firstPinLbl.text = pinArray.count > 0 ? "•" : ""
        secondPinLbl.text = pinArray.count > 1 ? "•" : ""
        thirdPinLbl.text = pinArray.count > 2 ? "•" : ""
        fourPinLbl.text = pinArray.count > 3 ? "•" : ""
    }

    @objc func numberTapped(_ sender: UIButton) {
        guard let numberString = sender.titleLabel?.text else { return }
        
        if showPin {
            paymentViewModel.updatePin(with: numberString)
        } else {
            paymentViewModel.updateAmount(with: numberString)
        }
    }

    @objc func backspaceTapped(_ sender: UIButton) {
        if showPin {
            paymentViewModel.removeLastPinDigit()
        } else {
            paymentViewModel.removeLastDigit()
        }
    }

    
    private func setupButtonActions() {
        oneBtn.addTarget(self, action: #selector(numberTapped(_:)), for: .touchUpInside)
        twoBtn.addTarget(self, action: #selector(numberTapped(_:)), for: .touchUpInside)
        threeBtn.addTarget(self, action: #selector(numberTapped(_:)), for: .touchUpInside)
        fourBtn.addTarget(self, action: #selector(numberTapped(_:)), for: .touchUpInside)
        fiveBtn.addTarget(self, action: #selector(numberTapped(_:)), for: .touchUpInside)
        sixBtn.addTarget(self, action: #selector(numberTapped(_:)), for: .touchUpInside)
        sevenBtn.addTarget(self, action: #selector(numberTapped(_:)), for: .touchUpInside)
        eightBtn.addTarget(self, action: #selector(numberTapped(_:)), for: .touchUpInside)
        nineBtn.addTarget(self, action: #selector(numberTapped(_:)), for: .touchUpInside)
        zeroBtn.addTarget(self, action: #selector(numberTapped(_:)), for: .touchUpInside)
        dotBtn.addTarget(self, action: #selector(numberTapped(_:)), for: .touchUpInside)
        earseBtn.addTarget(self, action: #selector(backspaceTapped(_:)), for: .touchUpInside)
        confirmBtn.addTarget(self, action: #selector(confirmTapped(_:)), for: .touchUpInside)
    }
    
    
    @objc func confirmTapped(_ sender: UIButton) {
        print("Amount to send: \(UserDefaults.standard.object(forKey: "amountToSend") ?? "0.00")")
        
        if showPin {
                print("Amount to send: \(paymentViewModel.amountToSend)")
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc: PaymentSuccessVC = mainStoryboard.instantiateViewController(withIdentifier: "PaymentSuccessVC") as! PaymentSuccessVC
                vc.modalPresentationStyle = .fullScreen
            vc.payeeAmt = "\(UserDefaults.standard.object(forKey: "amountToSend") ?? "0.00")"
                vc.payeeName = payeeName
                self.present(vc, animated: true, completion: nil)
            } else {
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc: PaymentContactVC = mainStoryboard.instantiateViewController(withIdentifier: "PaymentContactVC") as! PaymentContactVC
                vc.modalPresentationStyle = .fullScreen
                vc.payeeAmt = paymentViewModel.amountToSend
                UserDefaults.standard.set(paymentViewModel.amountToSend, forKey: "amountToSend")
                self.present(vc, animated: true, completion: nil)
            }
    }
}
