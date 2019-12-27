//
//  CurrencyFormatter.swift
//  IOU
//
//  Created by Mark Debbane on 11/30/19.
//  Copyright © 2019 IOU. All rights reserved.
//

import Foundation


class CurrencyFormatter {
    private var currencyLBP: String = "LBP"
    private let formatter = NumberFormatter()
    
    init() {
        self.formatter.groupingSeparator = ","
        self.formatter.groupingSize = 3
        self.formatter.numberStyle = .decimal
    }
    
    func formatAmountToLBP(_ amount: Int) -> String {
        
        guard let formattedAmount = self.formatter.string(from: NSNumber(value: amount))
            else {
            return "Error"
        }
        
        return "\(currencyLBP) \(formattedAmount)"
    }
    deinit {}
}
