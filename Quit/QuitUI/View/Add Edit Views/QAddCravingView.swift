//
//  QAddCravingView.swift
//  Quit
//
//  Created by Alex Tudge on 09/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI
import StoreKit

struct QAddCravingView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @FetchRequest(
        entity: Craving.entity(),
        sortDescriptors: []
    ) var cravings: FetchedResults<Craving>
    @ObservedObject var profile: Profile
    @State private var smoked = false
    @State private var category: String?
    @State private var newCategory = ""
    @State private var diaryEntry = ""
    @State private var showingResetAlert = false
    private var categories: [String] {
        Array(Set(cravings.compactMap { $0.cravingCatagory }))
    }
    
    var body: some View {
        Form {
            Toggle("Did you smoke", isOn: $smoked)
            Section(header: Text("Add a craving trigger"), footer: Text("New triggers will be preferred if added")) {
                if !categories.isEmpty {
                    Picker(selection: $category, label: Text("Existing trigger")) {
                        ForEach(categories, id: \.self) { category in
                            Text(category)
                        }
                    }
                }
                TextField("New trigger", text: $newCategory)
            }
            Section(header: Text("Diary")) {
                if profile.isPro {
                    TextEditor(text: $diaryEntry)
                } else {
                    NavigationLink(destination: QPurchaseProView(profile: profile)) {
                        Text("Go pro to add diary entries")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            Button("Save craving", action: {
                saveCraving()
                requestAReview()
            })
            .buttonStyle(QButtonStyle())
        }
        .navigationTitle("Add a craving")
        .alert(isPresented: $showingResetAlert) {
            Alert(title: Text("🤦‍♀️"), message: Text("Don't worry - it takes most people loads of attempts to get it right. Keep trying!\n\n We'll reset your quit date."), dismissButton: .default(Text("Got it!")))
        }
        .onChange(of: smoked, perform: { value in
            if value {
                showingResetAlert = true
            }
        })
    }
}

private extension QAddCravingView {
    func saveCraving() {
        let craving = Craving(context: managedObjectContext)
        craving.cravingCatagory = !newCategory.isEmpty ? newCategory : category
        craving.cravingDate = Date()
        craving.cravingSmoked = smoked
        craving.diaryEntry = diaryEntry.isEmpty ? nil : diaryEntry
        if smoked {
            if let quitDate = profile.quitDate,
               profile.notificationsEnabled {
                QNotificationManager().setupHealthNotifications(quitDate: quitDate)
            }
            profile.quitDate = Date()
        }
        try? managedObjectContext.save()
        presentationMode.wrappedValue.dismiss()
    }
    
    func requestAReview() {
        if let daysSmokeFree = profile.daysSmokeFree,
           daysSmokeFree > 3 {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        }
    }
}

struct QAddCravingView_Previews: PreviewProvider {
    static var previews: some View {
        QAddCravingView(profile: Profile())
    }
}
