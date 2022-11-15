//
//  TitleCollectionHeaderSwiftUIView.swift
//  calico
//
//  Created by Sergii Simakhin on 11/12/22.
//

import SwiftUI

struct TitleCollectionHeaderSwiftUIView: View {
    
    static let elementKind: String = "section-header-element-kind"
    
    var title: String
    var description: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(Font.title3.bold())
                .foregroundColor(Color.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Hide description in case it is empty
            if !description.isEmpty {
                Text(description)
                    .font(Font.footnote)
                    .foregroundColor(Color.black.opacity(0.75))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

struct TitleCollectionHeaderSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        TitleCollectionHeaderSwiftUIView(
            title: "Must-Have Cats",
            description: "Get started with these"
        )
        .previewLayout(.sizeThatFits)
        .padding()
        .environment(\.colorScheme, .light)
        .previewDisplayName("Preview")
    }
}
