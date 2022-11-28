//
//  QuoteView.swift
//  calico
//
//  Created by Sergii Simakhin on 11/14/22.
//

import SwiftUI

struct QuoteView: View {
    
    var quote: Quote
    
    var body: some View {
        Text("\"\(quote.title)\"")
            .font(Font.headline)
            .foregroundColor(Color("TextColor"))
            .padding(8)
            .frame(maxWidth: .infinity, alignment: .leading)
        
        Text(quote.author)
            .font(Font.subheadline.italic())
            .foregroundColor(Color("TextColor"))
            .padding(EdgeInsets(top: -10, leading: 0, bottom: 0, trailing: 16))
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

struct QuoteView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteView(quote: Quote(
            title: "In ancient times cats were worshipped as gods; they have not forgotten this.",
            author: "Terry Pratchett"
        ))
    }
}
