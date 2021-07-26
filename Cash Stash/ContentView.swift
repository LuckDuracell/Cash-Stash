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
//        List {
//            ForEach(items) { item in
//                Text("Item at \(item.timestamp!, formatter: itemFormatter)")
//            }
//            .onDelete(perform: deleteItems)
//        }
//        .toolbar {
//            #if os(iOS)
//            EditButton()
//            #endif
//
//            Button(action: addItem) {
//                Label("Add Item", systemImage: "plus")
//            }
//        }
        TabView {
            HomePage()
            GiftcardsPage()
            SavingsPage()
            TotalsPage()
        }.tabViewStyle(.page)
        .edgesIgnoringSafeArea(.all)
        
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
