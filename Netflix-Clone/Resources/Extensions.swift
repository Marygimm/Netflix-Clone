//
//  Extensions.swift
//  Netflix-Clone
//
//  Created by Mary Moreira on 27/08/2022.
//

import Foundation
import UIKit

extension String {
    
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}


extension UIView {
    enum Anchors {
        case left
        case top
        case right
        case bottom
    }
    func setFillingConstraints(in container: UIView,
                               anchors: [Anchors] = [.left, .top, .right, .bottom],
                               margins: UIEdgeInsets = UIEdgeInsets.zero, useAutolayout: Bool = false) {
        translatesAutoresizingMaskIntoConstraints = false
        
        for anchor in anchors {
            switch anchor {
            case .left:
                if useAutolayout {
                    leadingAnchor(to: container.leadingAnchor, constant: margins.left)
                } else {
                    leftAnchor.constraint(equalTo: container.leftAnchor, constant: margins.left).isActive = true
                }
            case .top:
                topAnchor.constraint(equalTo: container.topAnchor, constant: margins.top).isActive = true
            case .right:
                if useAutolayout {
                    trailingAnchor(to: container.trailingAnchor, constant: margins.right)
                } else {
                    rightAnchor.constraint(equalTo: container.rightAnchor, constant: margins.right).isActive = true
                }
                
            case .bottom:
                bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: margins.bottom).isActive = true
            }
        }
        setNeedsUpdateConstraints()
    }
    
    func leadingAnchor(to anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) {
        leadingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
    }
    
    func trailingAnchor(to anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) {
        trailingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
    }
    
}
