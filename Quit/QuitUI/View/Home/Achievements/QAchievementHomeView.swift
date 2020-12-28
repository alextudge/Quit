//
//  QAchievementHomeView.swift
//  Quit
//
//  Created by Alex Tudge on 13/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QAchievementHomeView: View {
    
    @ObservedObject var profile: Profile
    private var achievementsAchieved: Int {
        QAchievements.allCases.filter {
            $0.resultsText(profile: profile).passed
        }.count
    }
    
    var body: some View {
        ZStack {
            NavigationLink(destination: QViewAchievementsView(profile: profile)) {
                EmptyView()
            }.hidden()
            VStack(alignment: .leading, spacing: 5) {
                Text("\(achievementsAchieved) achieved!")
                    .font(.headline)
                    .foregroundColor(.white)
                Text("Tap here to see them all.")
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color("section4"))
            .cornerRadius(5)
            .shadow(radius: 4)
            .padding(.horizontal)
        }
    }
}

struct QAchievementHomeView_Previews: PreviewProvider {
    static var previews: some View {
        QAchievementHomeView(profile: Profile())
    }
}
