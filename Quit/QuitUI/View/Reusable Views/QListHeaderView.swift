//
//  QListHeaderView.swift
//  Quit
//
//  Created by Alex Tudge on 26/12/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QListHeaderView: View {
    
    @State var sectionHeader: String
    
    var body: some View {
        HStack {
            Text(sectionHeader)
                .font(.headline)
                .padding()
            Spacer()
        }
        .padding(EdgeInsets(.zero))
        .background(Color(.systemBackground))
        .listRowInsets(EdgeInsets(.zero))
    }
}

struct QListHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        QListHeaderView(sectionHeader: "Test")
    }
}
