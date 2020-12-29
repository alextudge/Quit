//
//  QViewCravingsView.swift
//  Quit
//
//  Created by Alex Tudge on 12/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QViewCravingsView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @FetchRequest(
        entity: Craving.entity(),
        sortDescriptors: [NSSortDescriptor(key: "cravingDate", ascending: false)]
    ) var cravings: FetchedResults<Craving>
    
    var body: some View {
        List {
            ForEach(cravings, id: \.self) { craving in
                VStack(alignment: .leading, spacing: 10) {
                    Text("\(standardisedDate(date: craving.cravingDate ?? Date()))")
                        .foregroundColor(craving.cravingSmoked ? .orange : .primary)
                        .font(.title2)
                    Text("Trigger: \(craving.cravingCatagory ?? "")")
                    if let diary = craving.diaryEntry {
                        Text("Diary: \(diary)")
                    }
                }
            }
            .onDelete(perform: delete)
        }
        .navigationBarItems(trailing: EditButton())
        .navigationTitle("Cravings")
    }
}

private extension QViewCravingsView {
    func delete(at offsets: IndexSet) {
        offsets.forEach {
            managedObjectContext.delete(cravings[$0])
        }
        DispatchQueue.main.async {
            try? managedObjectContext.save()
        }
    }
    
    func standardisedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

struct QViewCravingsView_Previews: PreviewProvider {
    static var previews: some View {
        QViewCravingsView()
    }
}
