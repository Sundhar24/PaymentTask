//
//  DashboardViewModel.swift
//  PaymentTask
//
//  Created by Sundhar on 17/08/24.
//

import Foundation
import UIKit


class DashboardViewModel {
   
    var groupedActivities: [String: [Activity]] = [:]
        
        func fetchActivities() {
            let activities = [
                Activity(name: "James Wayne", date: "Today, 10 August", amount: "-$1,000", transactionType: .sent, profileImage: "james_wayne"),
                Activity(name: "Samantha Reynolds", date: "Today, 10 August", amount: "+$500", transactionType: .received, profileImage: "samantha_reynolds"),
                Activity(name: "Louisa George", date: "August 8th", amount: "$400", transactionType: .requested, profileImage: "louisa_george"),
                Activity(name: "Emeka Ciroma", date: "August 8th", amount: "+$500", transactionType: .received, profileImage: "emeka_ciroma"),
                Activity(name: "Wallet funding", date: "August 8th", amount: "+$3,000", transactionType: .funded, profileImage: nil)
            ]
            
            groupedActivities = Dictionary(grouping: activities, by: { $0.date })
        }
        
        var sortedDates: [String] {
            return groupedActivities.keys.sorted(by: { $0 > $1 })
        }
    
    func createImageWithLetter(_ letter: String, size: CGSize, backgroundColor: UIColor, textColor: UIColor) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            let rect = CGRect(origin: .zero, size: size)
            context.cgContext.setFillColor(backgroundColor.cgColor)
            context.cgContext.fillEllipse(in: rect)
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: size.width / 2),
                .foregroundColor: textColor
            ]
            let textSize = letter.size(withAttributes: attributes)
            let textRect = CGRect(
                x: (size.width - textSize.width) / 2,
                y: (size.height - textSize.height) / 2,
                width: textSize.width,
                height: textSize.height
            )
            letter.draw(in: textRect, withAttributes: attributes)
        }
        return image
    }
    
}
