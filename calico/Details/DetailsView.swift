//
//  DetailsView.swift
//  calico
//
//  Created by Sergii Simakhin on 11/14/22.
//

import SwiftUI
import Kingfisher

struct DetailsView: View {
    
    @State var tap: Bool = false
    
    let url: URL?
    let quote: Quote?
    
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
                    //
                    
                    // Automatically untap the button to perform scaling animation
                    tap = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        tap = false
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.yellow)
                .foregroundColor(Color.black)
                .font(.title2)
                .scaleEffect(tap ? 0.96 : 1)
                .animation(.spring(response: 0.4, dampingFraction: 0.6), value: tap)
                
                Spacer()
                PawsView()
                Spacer()
            }
            .padding(.bottom, 32)
        }
        .frame(alignment: .top)
        .edgesIgnoringSafeArea(Edge.Set.top)
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(
            url: URL(string: "https://cataas.com/cat/Rn6xqsiHb9B7qgLw?type=square&width=1200")!,
            quote: Quote(
                title: "In ancient times cats were worshipped as gods; they have not forgotten this.",
                author: "Terry Pratchett"
            )
        )
    }
}
