//
//  ContentViewV2.swift
//  Cash Stash
//
//  Created by Luke Drushell on 10/8/21.
//

import SwiftUI

struct ContentViewV2: View {
    
    @FocusState var showKeyboard: Bool
    @State var amountString = "0.00"
    @State var toolbarColor = Color.blue
    
    var body: some View {
        TabView {
            CashPage(showKeyboard: _showKeyboard, amountString: $amountString, toolbarColor: $toolbarColor)
                .environment(\.tintColor, .blue)
            GiftPage(showKeyboard: _showKeyboard, amountString: $amountString, toolbarColor: $toolbarColor)
                .environment(\.tintColor, .purple)
            SavingPage(showKeyboard: _showKeyboard, amountString: $amountString, toolbarColor: $toolbarColor)
                .environment(\.tintColor, .orange)
        } .tabViewStyle(.page)
            .edgesIgnoringSafeArea(.all)
            .toolbar(content: {
                ToolbarItem(placement: .keyboard, content: {
                    HStack() {
                        Button {
                            amountString = "\(amountString)+"
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(toolbarColor)
                        }
                        Button {
                            amountString = "\(amountString)-"
                        } label: {
                            Image(systemName: "minus")
                                .foregroundColor(toolbarColor)
                        }
                        Spacer()
                        Button {
                            showKeyboard = false
                        } label: {
                            Text("Done")
                                .multilineTextAlignment(.trailing)
                                .foregroundColor(toolbarColor)
                        }
                    }
                })
            })
    }
}

struct ContentViewV2_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewV2()
    }
}
