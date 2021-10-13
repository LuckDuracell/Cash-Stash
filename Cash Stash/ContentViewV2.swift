//
//  ContentViewV2.swift
//  Cash Stash
//
//  Created by Luke Drushell on 10/8/21.
//

import SwiftUI

struct ContentViewV2: View {
    
    var body: some View {
        TabView {
            CashPage()
                .environment(\.tintColor, .blue)
            GiftPage()
                .environment(\.tintColor, .purple)
            SavingPage()
                .environment(\.tintColor, .orange)
        } .tabViewStyle(.page)
            .edgesIgnoringSafeArea(.all)
    }
}

struct ContentViewV2_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewV2()
    }
}
