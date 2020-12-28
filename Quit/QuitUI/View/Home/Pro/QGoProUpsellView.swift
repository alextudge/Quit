//
//  QGoProUpsellView.swift
//  Quit
//
//  Created by Alex Tudge on 28/12/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QGoProUpsellView: View {
    
    @ObservedObject var profile: Profile
    
    var body: some View {
        ZStack {
            NavigationLink(destination: QPurchaseProView(profile: profile)) {
                EmptyView()
            }.hidden()
            VStack(alignment: .leading) {
                Text("Learn about Quit pro!")
                    .font(.subheadline)
                    .foregroundColor(.white)
                Text("Tap to dismiss")
                    .font(.caption)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color.green)
            .cornerRadius(5)
            .shadow(radius: 4)
            .padding(.horizontal)
        }
    }
}

struct QGoProUpsellView_Previews: PreviewProvider {
    static var previews: some View {
        QGoProUpsellView(profile: Profile())
    }
}
