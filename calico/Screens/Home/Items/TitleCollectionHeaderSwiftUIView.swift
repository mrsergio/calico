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
    var displaySeeAllButton: Bool
    var seeAllButtonDidTap: (() -> ())
    
    var body: some View {
        HStack {
            VStack {
                Text(title)
                    .font(Font.title3.bold())
                    .foregroundColor(Color("TextColor"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Hide description in case it is empty
                if !description.isEmpty {
                    Text(description)
                        .font(Font.footnote)
                        .foregroundColor(
                            Color("TextColor").opacity(0.75)
                        )
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            if displaySeeAllButton {
                Spacer()
                
                Button("See All") {
                    seeAllButtonDidTap()
                }
                .buttonStyle(.automatic)
            }
        }
    }
}

struct TitleCollectionHeaderSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        TitleCollectionHeaderSwiftUIView(
            title: "Must-Have Cats",
            description: "Get started with these",
            displaySeeAllButton: true,
            seeAllButtonDidTap: { }
        )
        .previewLayout(.sizeThatFits)
        .padding()
        .environment(\.colorScheme, .light)
        .previewDisplayName("Preview")
    }
}
