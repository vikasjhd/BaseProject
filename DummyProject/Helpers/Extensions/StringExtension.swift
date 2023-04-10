//
//  StringExtension.swift
//  BaseProject
//
//

import Foundation
import UIKit





extension String {
        
    //MARK:- VARIOUS METHODS FOR STRING
    
    
    /// EZSE: Converts String to Int
    public func toInt() -> Int? {
        if let num = NumberFormatter().number(from: self) {
            return num.intValue
        } else {
            return nil
        }
    }
    
    /// EZSE: Converts String to Double
    public func toDouble() -> Double? {
        if let num = NumberFormatter().number(from: self) {
            return num.doubleValue
        } else {
            return nil
        }
    }
    
    /// EZSE: Converts String to Float
    public func toFloat() -> Float? {
        if let num = NumberFormatter().number(from: self) {
            return num.floatValue
        } else {
            return nil
        }
    }
}


extension String {
    
    func trimmed() -> String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    var isEmail: Bool {
        return checkRegEx(for: self, regEx: "^[_A-Za-z0-9-+]+(\\.[_A-Za-z0-9-+]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*(\\.[A-Za-z‌​]{2,})$")
    }
    
    // MARK: - Private Methods
    private func checkRegEx(for string: String, regEx: String) -> Bool {
        let test = NSPredicate(format: "SELF MATCHES %@", regEx)
        return test.evaluate(with: string)
    }
    
    
    func grouping(every groupSize: Int, with separator: Character) -> String {
       let cleanedUpCopy = replacingOccurrences(of: String(separator), with: "")
       return String(cleanedUpCopy.enumerated().map() {
            $0.offset % groupSize == 0 ? [separator, $0.element] : [$0.element]
       }.joined().dropFirst())
    }
    
    /* USAGE ABOVE METHOD
     extension AddPaymentCard: UITextFieldDelegate{
         func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
             guard let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true }
             if textField == holderCardNumber {
                 if currentText.count >= 20 {
                     return false
                 }
                 textField.text = currentText.grouping(every: 4, with: " ")
                 return false
             }else {
                 return false
             }
         }
     }
     */
    
    
}
