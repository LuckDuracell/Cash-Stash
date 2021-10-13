//
//  LoadingScreen.swift
//  Cash Stash
//
//  Created by Luke Drushell on 9/24/21.
//

import SwiftUI

struct LoadingScreen: View {
    
    @State private var loading = true
    
    var body: some View {
        if loading {
            Text("Loading....")
                .onAppear(perform: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                        loading = false
                    })
                })
        } else {
           ContentView()
        }
    }
}

struct LoadingScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoadingScreen()
    }
}
