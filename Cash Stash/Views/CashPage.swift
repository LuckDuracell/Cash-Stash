//
//  CashPage.swift
//  Cash Stash
//
//  Created by Luke Drushell on 10/8/21.
//

import SwiftUI

struct CashPage: View {
    
    @State var wallets = Wallet.loadFromFile()
    @State var selection: Wallet = Wallet(name: "", icon: "", amount: 0.0)
    @State private var showSheet = false
    @State private var isAdding = false
    @State var pageIndex = 0
    @FocusState var showKeyboard: Bool
    
    @State var amountString = "0.00"
    
    @State var reloadPage = false
    
    @State var total: Double = 0
    
    var body: some View {
        ZStack {
            GradientBackground(color1: .mint, color2: .blue)
                .edgesIgnoringSafeArea(.all)
            ScrollView {
                HStack() {
                   Text("Cash Stash")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    Spacer()
                    Text("$\(total, specifier: "%.2f")")
                        .foregroundColor(.white)
                        .padding(6)
                        .background(.white.opacity(0.3))
                        .cornerRadius(15)

                }
                .padding()
                ForEach(wallets.indices, id: \.self, content: { index in
                    Button {
                        selection = wallets[index]
                        pageIndex = index
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
                            showSheet.toggle()
                        })
                    } label: {
                        StashItem(icon: $wallets[index].icon, name: $wallets[index].name, amount: $wallets[index].amount, stashType: .constant(1))
                            .padding(1)
                    }
                })
            }
            .overlay(alignment: .bottom, content: {
                Button {
                    isAdding.toggle()
                } label: {
                    Text("Add Stash")
                        .foregroundColor(.blue)
                        .padding()
                        .frame(width: 250, height: 50, alignment: .center)
                        .background(.white)
                        .cornerRadius(25)
                        .animation(.linear, value: 1)
                        .padding()
                }
            })
            .sheet(isPresented: $isAdding, onDismiss: {
                wallets = Wallet.loadFromFile()
            }, content: {
                NewPage(showKeyboard: _showKeyboard, showSheet: $isAdding, stashType: .constant(1))
            })
        }
        .onAppear(perform: {
            total = 0
            for i in wallets.indices {
                total += wallets[i].amount
            }
        })
        .sheet(isPresented: $showSheet, onDismiss: {
            let newData = Wallet.loadFromFile()
            if newData.isEmpty == false {
//            wallets[pageIndex].amount = newData[pageIndex].amount
//            wallets[pageIndex].icon = newData[pageIndex].icon
//            wallets[pageIndex].name = newData[pageIndex].name
                wallets = newData
            } else {
                wallets = newData
                
            }
        }, content: {
            EditPage(icon: $selection.icon, name: $selection.name, amount: $selection.amount, index: $pageIndex, amountString: $amountString, showKeyboard: _showKeyboard, showSheet: $showSheet, stashType: .constant(1))
        })
            .toolbar(content: {
                ToolbarItem(placement: .keyboard, content: {
                    HStack() {
                        Button {
                            amountString = "\(amountString)+"
                            print("plus")
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(.blue)
                        }
                        Button {
                            amountString = "\(amountString)-"
                            print("minus")
                        } label: {
                            Image(systemName: "minus")
                                .foregroundColor(.blue)
                        }
                        Spacer()
                        Button {
                            showKeyboard = false
                        } label: {
                            Text("Done")
                                .multilineTextAlignment(.trailing)
                                .foregroundColor(.blue)
                        }
                    }
                })
            })
    }
}

struct CashPage_Previews: PreviewProvider {
    static var previews: some View {
        CashPage()
    }
}
