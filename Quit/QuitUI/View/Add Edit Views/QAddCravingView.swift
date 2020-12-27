//
//  QAddCravingView.swift
//  Quit
//
//  Created by Alex Tudge on 09/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QAddCravingView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @FetchRequest(
        entity: Craving.entity(),
        sortDescriptors: []
    ) var cravings: FetchedResults<Craving>
    @State private var smoked = false
    @State private var category: String = ""
    @State private var newCategory = ""
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
            Button("Save craving", action: {
                saveCraving()
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
        try? managedObjectContext.save()
        presentationMode.wrappedValue.dismiss()
    }
}

struct QAddCravingView_Previews: PreviewProvider {
    static var previews: some View {
        QAddCravingView()
    }
}
