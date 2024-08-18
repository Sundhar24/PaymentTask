//
//  DashboardModel.swift
//  PaymentTask
//
//  Created by Sundhar on 17/08/24.
//

import Foundation


struct Activity {
    let name: String
    let date: String
    let amount: String
    let transactionType: TransactionType
    let profileImage: String? 
}

enum TransactionType {
    case sent
    case received
    case requested
    case funded
}
