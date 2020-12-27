//
//  QAddLocationBasedNotificationView.swift
//  Quit
//
//  Created by Alex Tudge on 13/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI
import MapKit

struct QAddLocationNotificationView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State private var title = ""
    @State private var message = ""
    @State private var showingAlert = false
    @State private var showingLocationAlert = false
    
    var body: some View {
        GeometryReader { geo in
            Form {
                Text("Center the map on the location you would like this trigger to be activated on.")
                ZStack {
                    QMapView(centerCoordinate: $centerCoordinate)
                        .cornerRadius(5)
                        .frame(height: geo.size.height * 0.4)
                    Circle()
                        .fill(Color.blue)
                        .opacity(0.3)
                        .frame(width: 32, height: 32)
                }
                TextField("Give your notification a title", text: $title)
                TextField("Give your notification a message", text: $message)
                Button("Save", action: {
                    if title.isEmpty || message.isEmpty {
                        showingAlert = true
                    } else {
                        save()
                    }
                })
                .buttonStyle(QButtonStyle())
                Text("For this type of notification to work, you need to allow Quit always access to your location. This can be done in your phones settings. Quit does not use your location for any other purpose, and the monitoring is handled by Apple.")
                    .font(.footnote)
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("🤕"), message: Text("Both text fields are required."), dismissButton: .default(Text("Got it!")))
        }
        .alert(isPresented: $showingLocationAlert) {
            Alert(title: Text("🤕"), message: Text("We can't currently add location based alerts to mac devices."), dismissButton: .default(Text("Got it!")))
        }
        .navigationTitle("Add a notifications")
    }
}

private extension QAddLocationNotificationView {
    func save() {
        #if targetEnvironment(macCatalyst)
        showingLocationAlert.toggle()
        #else
        let region = CLCircularRegion(center: centerCoordinate, radius: 20.0, identifier: "\(centerCoordinate.latitude).\(centerCoordinate.longitude)")
        region.notifyOnEntry = true
        region.notifyOnExit = false
        let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
        let content = UNMutableNotificationContent()
        content.body = message
        content.title = title
        let locationNotification = UNNotificationRequest(identifier: "customLocation\(centerCoordinate.latitude).\(centerCoordinate.longitude)", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(locationNotification) { _ in
            DispatchQueue.main.async {
                presentationMode.wrappedValue.dismiss()
            }
        }
        #endif
    }
}

struct QAddLocationBasedNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        QAddLocationNotificationView()
    }
}
