//
//  ContentView.swift
//  Cash Stash
//
//  Created by Luke Drushell on 7/25/21.
//

import SwiftUI
import CoreData
import Introspect

struct ContentView: View {

    var body: some View {
        TabView {
            HomePage()
            GiftcardsPage()
            SavingsPage()
            //TotalsPage()
        }
        .tabViewStyle(.page)
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
