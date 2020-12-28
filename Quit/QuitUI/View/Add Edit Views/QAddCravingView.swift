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
    @State private var category: String = ""
    @State private var newCategory = ""
    @State private var diaryEntry = ""
    private var categories: [String] {
        Array(Set(cravings.compactMap { $0.cravingCatagory }))
    }
    
    var body: some View {
        Form {
            Toggle("Did you smoke", isOn: $smoked)
            if !categories.isEmpty {
                Picker(selection: $category, label: Text("Existing trigger")) {
                    ForEach(categories, id: \.self) { category in
                        Text(category)
                    }
                }
            }
            TextField("New trigger", text: $newCategory)
            if profile.isPro {
                Section(header: Text("Diary")) {
                    TextEditor(text: $diaryEntry)
                }
            } else {
                NavigationLink(destination: QPurchaseProView(profile: profile)) {
                   Text("Go pro to add diary entries")
                    .font(.caption)
                    .foregroundColor(.secondary)
               }
            }
            Button("Save craving", action: {
                saveCraving()
                if let daysSmokeFree = profile.daysSmokeFree,
                   daysSmokeFree > 3 {
                    SKStoreReviewController.requestReview()
                }
            })
            .buttonStyle(QButtonStyle())
        }
        .navigationTitle("Add a craving")
    }
}

private extension QAddCravingView {
    func saveCraving() {
        let craving = Craving(context: managedObjectContext)
        craving.cravingCatagory = !newCategory.isEmpty ? newCategory : category
        craving.cravingDate = Date()
        craving.cravingSmoked = smoked
        craving.diaryEntry = diaryEntry.isEmpty ? nil : diaryEntry
        try? managedObjectContext.save()
        presentationMode.wrappedValue.dismiss()
    }
}

struct QAddCravingView_Previews: PreviewProvider {
    static var previews: some View {
        QAddCravingView(profile: Profile())
    }
}
