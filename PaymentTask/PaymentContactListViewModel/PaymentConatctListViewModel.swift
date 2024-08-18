//
//  PaymentConatctListViewModel.swift
//  PaymentTask
//
//  Created by Sundhar on 17/08/24.
//
//PaymentConatctListViewModel.swift

import Foundation
import UIKit

class PaymentConatctListViewModel {
    
    private var contacts: [Contact] = []
    var filteredContacts: [String: [Contact]] = [:]
    var sectionTitles: [String] = []

    var allContacts: [Contact] {
        return contacts
    }
    
    func loadContacts() {
        contacts = [
            Contact(name: "Ademola Odeku", phoneNumber: "+971 55 432 5382"),
            Contact(name: "Amaka Uzor", phoneNumber: "+971 56 632 5385"),
            Contact(name: "Astor Regem", phoneNumber: "+971 57 937 6383"),
            Contact(name: "Bolaji Jackson", phoneNumber: "+971 54 232 5367"),
            Contact(name: "Bossman", phoneNumber: "+971 56 632 5385"),
            Contact(name: "Carmara Williams", phoneNumber: "+971 54 232 5367"),
            Contact(name: "Caro Mofetoluwa", phoneNumber: "+971 56 632 5385"),
            Contact(name: "James", phoneNumber: "+971 55 432 5382"),
            Contact(name: "Jhon", phoneNumber: "+971 67 943 8778"),
            Contact(name: "Oreoluwa", phoneNumber: "+971 57 937 6383")         
        ]
        filterContacts()
    }

    func filterContacts(query: String? = nil) {
        filteredContacts.removeAll()
        
        for contact in contacts {
            let key = contact.name?.prefix(1).uppercased() ?? ""
            if filteredContacts[key] == nil {
                filteredContacts[key] = []
            }
            if let query = query, !query.isEmpty {
                if contact.name?.lowercased().contains(query.lowercased()) ?? false {
                    filteredContacts[key]?.append(contact)
                }
            } else {
                filteredContacts[key]?.append(contact)
            }
        }
        sectionTitles = filteredContacts.keys.sorted()
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

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}

