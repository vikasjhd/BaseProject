//
//  TextfieldExtensions.swift
//  BaseProject
//
//

import Foundation
import UIKit

extension UITextField {
    
    //MARK:- SET DATE PICKER ON TEXTFEILDS
    //ADDED BY VIKAS SAINI
    
    //EDITED DATED 22 DEC 2020
    //USER CAN NOW SET MINIMUM DATE , MAXIMUM DATE AND DATEPICKERMODE ACCORDING TO REQUIREMENT  , OTHERWISE  USE AS textFeild.setInputViewDatePicker(target: self, selector: #selector(tapDoneStart)) IN VIEW DID LOAD
    
    func setInputViewDatePicker(target: Any, selector: Selector , datePickerMode : UIDatePicker.Mode? = .dateAndTime , minimumDate:Date? = Date() , MaximumDate: Date? = Calendar.current.date(byAdding: .year, value: +1, to: Date())! ) {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))//1
        datePicker.minimumDate = minimumDate
        datePicker.maximumDate = MaximumDate
        datePicker.datePickerMode = datePickerMode ?? .dateAndTime
        self.inputView = datePicker //3
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        }
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
        self.inputAccessoryView = toolBar //9
    }
    
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
    
    
    /*USE LIKE THIS IN SELECTOR METHOD
     In View Did Load :
     textFeild.setInputViewDatePicker(target: self, selector: #selector(tapDoneStart))
     #Selector Method to show usage
     @objc func tapDoneStart(){
     if let datePicker = self.tfStartTime.inputView as? UIDatePicker {
     let dateformatter = DateFormatter()
     dateformatter.dateFormat = "dd MMM, hh:mm"
     self.textFeild.text = dateformatter.string(from: datePicker.date)
     }
     self.tfStartTime.resignFirstResponder()
     }
     
     */
    
  
    // MARK:- GIVE PLACEHOLDER TEXT A COLOR
    func placeholderColor(color: UIColor) {
        let attributeString = [
            NSAttributedString.Key.foregroundColor: color,
            NSAttributedString.Key.font: self.font!
        ] as [NSAttributedString.Key : Any]
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: attributeString)
    }
    
    
    //MARK:- GIVE PADDING TO TEXT FEILDS
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
}
