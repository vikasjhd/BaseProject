//
//  PurchasesHelper.swift
//  Chamoji Face Filter
//
//  Copyright © 2019 Cappsule. All rights reserved.
//

import Foundation
import StoreKit

class PurchaseHelper: NSObject {
    
    //MARK:- Shared Object
    static let shared = PurchaseHelper()
    
    //MARK: - Class Initializer
    private override init() {
        super.init()
        setProductIds(ids: IAPProducts.productIdentifiers)
    }
    
    //MARK:- Properties
    //MARK:- Private
    fileprivate var productIds = Set<String>()
    fileprivate var productID = ""
    fileprivate var productsRequest = SKProductsRequest()
    fileprivate var fetchProductComplition: (([SKProduct])->Void)?
    fileprivate var productToPurchase: SKProduct?
    fileprivate var purchaseProductComplition: ((PurchaseHandlerAlertTypes, SKProduct?, SKPaymentTransaction?)->Void)?
    
    var currencyCode:String?
    var price:NSDecimalNumber?
    
    //MARK:- Public
    var isLogEnabled: Bool = true
    
    //MARK:- Methods
    //Set Product Ids
    func setProductIds(ids: Set<String>) {
        self.productIds = ids
    }
    
    //MAKE PURCHASE OF A PRODUCT
    //MARK: - Method to get Purchase Capability
    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    
    //MARK: - Method to make a Purchase
    func purchase(product: SKProduct, complition: @escaping ((PurchaseHandlerAlertTypes, SKProduct?, SKPaymentTransaction?)->Void)) {
        //stop your loader here
        self.purchaseProductComplition = complition
        self.productToPurchase = product
        if self.canMakePurchases() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            log("PRODUCT TO PURCHASE: \(product.productIdentifier)")
            self.currencyCode = product.priceLocale.currency?.identifier
            self.price = product.price
            productID = product.productIdentifier
            
        }else if PurchaseHandlerAlertTypes.restored == .restored
        {
            complition(PurchaseHandlerAlertTypes.restored, nil, nil)
        }
        else  {
            complition(PurchaseHandlerAlertTypes.disabled, nil, nil)
        }
    }
    
    // RESTORE PURCHASE
    func restorePurchase(){
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    //Fetch Available IAP Products
    func fetchAvailableProducts(complition: @escaping (([SKProduct])->Void)){
        
        
        self.fetchProductComplition = complition
        // Put here your IAP Products ID's
        if self.productIds.isEmpty {
            log(PurchaseHandlerAlertTypes.setProductIds.message)
            fatalError(PurchaseHandlerAlertTypes.setProductIds.message)
        }
        else {
            print(self.productIds)
            productsRequest = SKProductsRequest(productIdentifiers: self.productIds)
            productsRequest.delegate = self
            productsRequest.start()
        }
    }
    
    //MARK:- Private
    fileprivate func log <T> (_ object: T) {
        if isLogEnabled {
            NSLog("\(object)")
        }
    }
}

//MARK:- Product Request Delegate and Payment Transaction Methods
extension PurchaseHelper: SKProductsRequestDelegate, SKPaymentTransactionObserver{
    // REQUEST IAP PRODUCTS
    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
        print(response)
        print (response.products.count);
        print(response.invalidProductIdentifiers)
        print(response.description)
        
        response.invalidProductIdentifiers.forEach { product in
            print("Invalid: \(product)")
        }
        
        response.products.forEach { product in
            print("Valid: \(product)")
            
        }
        
        if (response.products.count > 0) {
            if let complition = self.fetchProductComplition {
                complition(response.products)
            }
        }
        
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error){
        print("error: \(error.localizedDescription)")
    }
    
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        let transactionCount = queue.transactions.count
        if transactionCount == 0
        {
            print("No previous transactions found")
        }
        else
        {
            log("Product restored")
         
            if let currentVC = GetWindow()?.topViewController() {
                Toast.show(message: "Restore Product Successfully.", controller: currentVC)
            }
            if let complition = self.purchaseProductComplition {
                complition(PurchaseHandlerAlertTypes.restored, nil, nil)
            }
            
        }
    }
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        print(error.localizedDescription)
        
       
        if let currentVC = GetWindow()?.topViewController() {
            Toast.show(message: "There are no items available to restore at this time.", controller: currentVC)
        }
    }
    
    // IAP PAYMENT QUEUE
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                    log("Product purchase done")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    if let complition = self.purchaseProductComplition {
                        completeTransaction(transaction: trans)
                        complition(PurchaseHandlerAlertTypes.purchased, self.productToPurchase, trans)
                    }
                    
                    break
                case .failed:
                    log("Product purchase failed")
                    if let currentVC = GetWindow()?.topViewController() {
                        Toast.show(message: "Product purchase failed" , controller: currentVC)
                    }
                    //                    showAlert(title: "In App Purchase", message: "Product purchase failed")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                case .restored:
                    
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    
                    break
                default: break
                }
            }
        }
        
    }
    
    func completeTransaction(transaction:SKPaymentTransaction){
        let receipt:Data?
        print(Bundle.main.appStoreReceiptURL as Any)
        receipt = try? Data(contentsOf: Bundle.main.appStoreReceiptURL!)
        
        if let receiptData = receipt, let code = currencyCode, let pricee = price{
            // PlayFabManager.shared.validatePurchase(receiptData: String(data: receiptData, encoding: .utf8)!, currencyCode: code, purchasePrice: pricee)
            
            print("Receipt : \(receiptData) code : \(code) pricee : \(pricee)")
            
        }
    }
    
}
