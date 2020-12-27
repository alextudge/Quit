//
//  QPurchaseHelper.swift
//  Quit
//
//  Created by Alex Tudge on 27/12/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import StoreKit
import Combine
import SwiftUI

class QPurchaseHelper: NSObject, ObservableObject {
    
    private let productIdentifiers = Set(["com.Alex.Quit.pro"])
    private var productsRequest: SKProductsRequest?
    @Published var availableProducts = [SKProduct]()
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Profile.entity(), sortDescriptors: []) var profiles: FetchedResults<Profile>
    var canMakePayments: Bool {
        SKPaymentQueue.canMakePayments()
    }
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
        requestProducts()
    }
    
    func buyProduct() {
        if let pro = availableProducts.first {
            let payment = SKPayment(product: pro)
            SKPaymentQueue.default().add(payment)
        }
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

extension QPurchaseHelper: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async { [weak self] in
            self?.availableProducts = response.products
            self?.productsRequest = nil
            self?.availableProducts.forEach {
                print($0)
            }
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print(error)
        DispatchQueue.main.async { [weak self] in
            self?.availableProducts = []
            self?.productsRequest = nil
        }
    }
}

extension QPurchaseHelper: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach {
            switch $0.transactionState {
            case .purchased:
                complete(transaction: $0)
                break
            case .failed:
                fail(transaction: $0)
                break
            case .restored:
                restore(transaction: $0)
                break
            case .deferred:
                break
            case .purchasing:
                break
            @unknown default:
                return
            }
        }
    }
}

private extension QPurchaseHelper {
    func requestProducts() {
        productsRequest?.cancel()
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest?.delegate = self
        productsRequest?.start()
    }
    
    func complete(transaction: SKPaymentTransaction) {
        markProAsPurchased()
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    func restore(transaction: SKPaymentTransaction) {
        markProAsPurchased()
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    func fail(transaction: SKPaymentTransaction) {
        if let transactionError = transaction.error as NSError?,
           let localizedDescription = transaction.error?.localizedDescription,
           transactionError.code != SKError.paymentCancelled.rawValue {
            print("Transaction Error: \(localizedDescription)")
        }
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    func markProAsPurchased() {
        profiles.first?.isPro = true
        try? managedObjectContext.save()
    }
}

extension SKProduct: Identifiable {}
