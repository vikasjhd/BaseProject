//
//  IAPProducts.swift
//
//  Copyright © 2019 Cappsule. All rights reserved.
//

import Foundation


//MARK:- IN APP PURCHASES

public struct IAPProducts{
    
    //MARK: - All Products Ids registered in apple connect
    
    //SET THE NAMES OF YOUR OWN PLANS AND GIVE THEIR IDENTIFIERS
    //THESE CAN BE ONE OR MORE THAN ONE
    public static let oneMonthSubscriptionPlan = ""
    public static let twelveMonthsSubscriptionPlan = ""
    public static let addFreeSubscriptionPlan = ""
    
    //APPEND ALL THESE PLANS HERE IN THE ARRAY
    public static let productIdentifiers:Set<String> = [IAPProducts.addFreeSubscriptionPlan]
    
}

func resourceNameForProductIdentifier(_ productIdentifier:String) ->String{
    return productIdentifier.components(separatedBy: ".").last!
}


//==================  USAGE: ===================//


/*
PurchaseHelper.shared.fetchAvailableProducts { [weak self](products)   in
    guard let sSelf = self else {return}
    sSelf.productsArray = products
    sSelf.tableView.reloadData() //reload you table or collection view
}


//RESTORE PURCHASED SUBCSRIPTION
 //PurchaseHelper.shared.restorePurchase()

MAKE PURCHASE :
   //start your loader here
   PurchaseHelper.shared.purchase(product: self.productsArray[index]) { (alert, product, transaction) in
    if let tran = transaction, let prod = product {
                 //use transaction details and purchased product as you want
                 print(prod.price)
                 print(tran.original as Any)
    }
}

*/
