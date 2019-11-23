//
//  SettingsVC.swift
//  Quit
//
//  Created by Alex Tudge on 12/02/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit
import SwiftyStoreKit

class SettingsVC: QuitBaseViewController {
    
    @IBOutlet private weak var adFreeButton: RoundedButton!
    @IBOutlet private weak var purchaseStackView: UIStackView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Settings"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAdFreeOffers()
    }
    
    @IBAction private func deleteAllDataButtonPressed(_ sender: Any) {
        persistenceManager?.deleteAllData()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapAdFreeButton(_ sender: Any) {
        purchaseAdFree()
    }
    
    @IBAction private func didTapRestorePurchases(_ sender: Any) {
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                self.presentAlert(title: "Restore Failed", message: "\(results.restoreFailedPurchases)")
            } else if results.restoredPurchases.count > 0 {
                self.persistenceManager?.updateAdFreeDate(true)
                self.presentAlert(title: "💁‍♀️", message: "Restored!")
            } else {
                self.presentAlert(title: "🙆‍♀️", message: "Nothing to restore!")
            }
        }
    }
}

private extension SettingsVC {
    func getAdFreeOffers() {
        SwiftyStoreKit.retrieveProductsInfo(["adFree"]) { result in
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!
                self.adFreeButton.setTitle("Ad free: \(priceString)", for: .normal)
                self.purchaseStackView.isHidden = false
            }
        }
    }
    
    func purchaseAdFree() {
        SwiftyStoreKit.purchaseProduct("adFree", quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
                self.persistenceManager?.updateAdFreeDate(true)
            case .error(let error):
                var errorMessage: String?
                print(error.localizedDescription)
                switch error.code {
                case .unknown: errorMessage = "Unknown error. Please contact support"
                case .clientInvalid:  errorMessage = "Not allowed to make the payment"
                case .paymentCancelled: break
                case .paymentInvalid: errorMessage = "The purchase identifier was invalid"
                case .paymentNotAllowed: errorMessage = "The device is not allowed to make the payment"
                case .storeProductNotAvailable: errorMessage = "The product is not available in the current storefront"
                case .cloudServicePermissionDenied: errorMessage = "Access to cloud service information is not allowed"
                case .cloudServiceNetworkConnectionFailed: errorMessage = "Could not connect to the network"
                case .cloudServiceRevoked: errorMessage = "User has revoked permission to use this cloud service"
                default: print((error as NSError).localizedDescription)
                }
                if let errorMessage = errorMessage {
                    self.presentAlert(title: "🙅‍♀️", message: errorMessage)
                }
            }
        }
    }
}
