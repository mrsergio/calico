//
//  NoNetworkConnectionView.swift
//  calico
//
//  Created by Sergii Simakhin on 11/15/22.
//

import SwiftUI

struct NoNetworkConnectionView: View {
    var body: some View {
        VStack {
            Image(systemName: "wifi.exclamationmark")
                .resizable()
                .frame(width: 120, height: 90, alignment: .center)
            
            Spacer(minLength: 16)
            
            Text("No network connection found 😔")
                .font(.headline)
                .foregroundColor(Color("TextColor"))
        }
    }
}

struct NoNetworkConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        NoNetworkConnectionView()
    }
}
