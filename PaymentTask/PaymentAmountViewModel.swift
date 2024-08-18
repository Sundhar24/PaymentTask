//
//  PaymentAmountViewModel.swift
//  PaymentTask
//
//  Created by Sundhar on 17/08/24.
//

import Foundation
import UIKit


class PaymentAmountViewModel: ObservableObject {
    
    @Published var balance: String
    @Published var amountToSend: String = "$0"
    @Published var isConfirmEnabled: Bool = false
    @Published var confirmButtonColor: UIColor = .gray
    @Published var shouldShowConfirmButton: Bool = false
    @Published var enteredPin: String = ""
    
    private var model: PaymentModel
    private let numberFormatter: NumberFormatter
    
    init(balance: Double) {
        self.model = PaymentModel(balance: balance, amountToSend: 0)
        self.numberFormatter = NumberFormatter()
        self.numberFormatter.numberStyle = .currency
        self.numberFormatter.currencySymbol = "$"
        self.numberFormatter.groupingSeparator = ","
        self.balance = numberFormatter.string(from: NSNumber(value: balance)) ?? "$0"
        self.shouldShowConfirmButton = false
    }
    
    func updateAmount(with number: String) {
        guard let numberValue = Double(number) else { return }
        
        model.amountToSend = model.amountToSend * 10 + numberValue
        amountToSend = numberFormatter.string(from: NSNumber(value: model.amountToSend)) ?? "$0"
        
        validateAmount()

    }
    
    func removeLastDigit() {
        model.amountToSend = floor(model.amountToSend / 10)
        amountToSend = model.amountToSend > 0 ? numberFormatter.string(from: NSNumber(value: model.amountToSend)) ?? "$0" : "$0"
        validateAmount()

    }
    
    private func validateAmount() {
        shouldShowConfirmButton = model.amountToSend > 0 && model.amountToSend <= model.balance
        
        if model.amountToSend == 0 || model.amountToSend > model.balance {
            isConfirmEnabled = false
            confirmButtonColor = .gray
        } else {
            isConfirmEnabled = true
            confirmButtonColor = .systemGreen
        }
    }
    
    func updatePin(with digit: String) {
        guard enteredPin.count < 4 else { return }
        enteredPin.append(digit)
        
        if enteredPin.count == 4 {
            validatePin()
        }
    }

    func removeLastPinDigit() {
        if !enteredPin.isEmpty {
            enteredPin.removeLast()
        }
    }

    private func validatePin() {
        if enteredPin == "1234" {  // Replace with your actual PIN logic
            shouldShowConfirmButton = true
            isConfirmEnabled = true
            confirmButtonColor = .systemGreen
        } else {
            shouldShowConfirmButton = false
            isConfirmEnabled = false
            confirmButtonColor = .gray
        }
    }
}
