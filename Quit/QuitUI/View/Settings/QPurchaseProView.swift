//
//  QPurchaseProView.swift
//  Quit
//
//  Created by Alex Tudge on 27/12/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QPurchaseProView: View {
    
    @ObservedObject var purchaseHelper = QPurchaseHelper()
    
    var body: some View {
        List {
            ForEach(QProFeatures.allCases) { feature in
                VStack(alignment: .leading, spacing: 10) {
                    Text(feature.title)
                        .font(.title)
                        .foregroundColor(.white)
                    Text(feature.message)
                        .font(.title2)
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color("section1"))
                .shadow(radius: 4)
                .cornerRadius(5)
            }
            Button("Confirm purchase", action: {
                purchaseHelper.buyProduct()
            })
            .disabled(purchaseHelper.availableProducts.isEmpty)
            .buttonStyle(QButtonStyle())
        }
        .navigationTitle("Go pro")
    }
}

struct QPurchaseProView_Previews: PreviewProvider {
    static var previews: some View {
        QPurchaseProView()
    }
}