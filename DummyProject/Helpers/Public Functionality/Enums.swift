//
//  Enums.swift
//  DummyProject
//
//  Created by Vikas saini on 26/01/21.
//

import Foundation

//MARK:- ENUM FOR METHOD TYPE
enum MethodType : String {
    case Post = "POST"
    case Get = "GET"
    case Put = "PUT"
    case Patch = "PATCH"
    case Delete = "DELETE"
}

enum TextFieldsCategory: String{
    case Email = "Email"
    case Password = "Password"
}


public enum FileSelectionType : Int {
case ImageOnly = 0
case VideoOnly = 1
case ImageAndVideoBoth = 2
}
