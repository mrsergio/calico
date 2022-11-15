//
//  DetailsView.swift
//  calico
//
//  Created by Sergii Simakhin on 11/14/22.
//

import SwiftUI
import Kingfisher

struct DetailsView: View {
    
    let url: URL?
    let quote: Quote?
    var shareButtonDidTap: (() -> ())
    
    var body: some View {
        VStack {
            KFImage(url)
                .placeholder {
                    Image("PlaceholderImage")
                        .resizable()
                        .scaledToFit()
                }
                .retry(
                    DelayRetryStrategy(
                        maxRetryCount: 3,
                        retryInterval: .seconds(2)
                    )
                )
                .fade(duration: 0.25)
                .resizable()
                .scaledToFit()
            
            if let quote {
                QuoteView(quote: quote)
            }
            
            Spacer()
            
            // 2 layers of paws
            VStack {
                HStack {
                    Spacer()
                    PawsView()
                    Spacer()
                    PawsView()
                    Spacer()
                }
                HStack {
                    PawsView()
                    Spacer()
                    PawsView()
                    Spacer()
                    PawsView()
                }
            }
            
            // Share button with paws around
            HStack {
                Spacer()
                PawsView()
                Spacer()

                Button("Share") {
                    shareButtonDidTap()
                }
                .buttonStyle(GradientButtonStyle())
                .font(.title2)
                
                Spacer()
                PawsView()
                Spacer()
            }
            .padding(.bottom, 32)
        }
        .background(Color("Background"))
        .frame(alignment: .top)
        .edgesIgnoringSafeArea(.top)
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(
            url: URL(string: "https://cataas.com/cat/OQW6RVeKZQ4iIPnQ")!,
            quote: Quote(
                title: "In ancient times cats were worshipped as gods; they have not forgotten this.",
                author: "Terry Pratchett"
            ),
            shareButtonDidTap: { }
        )
    }
}
