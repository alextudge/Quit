//
//  QBankNoteView.swift
//  Quit
//
//  Created by Alex Tudge on 04/10/2020.
//  Copyright © 2020 Alex Tudge. All rights reserved.
//

import SwiftUI

struct QBankNoteView: View {
    
    var progress: Double
    private var correctedProgress: Double {
        if progress > 1 {
            return 1
        } else if progress < 0 {
            return 0
        }
        return progress
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                GeometryReader { subGeo in
                    Text("£")
                        .font(.largeTitle)
                        .padding()
                        .foregroundColor(.white)
                        .scaledToFit()
                    Rectangle()
                        .fill(Color.white)
                        .cornerRadius(5)
                        .frame(height: subGeo.size.height * CGFloat(correctedProgress))
                        .offset(y: subGeo.size.height - subGeo.size.height * CGFloat(correctedProgress))
                    Rectangle()
                        .fill(Color.clear)
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.white, lineWidth: 2)
                        )
                }
            }
            .frame(width: geo.size.width, height: ((geo.size.width * 0.5) < geo.size.height) ? (geo.size.width * 0.5) : geo.size.height)
            .clipped()
        }
    }
}

struct QBankNoteView_Previews: PreviewProvider {
    static var previews: some View {
        QBankNoteView(progress: 0.5)
    }
}
