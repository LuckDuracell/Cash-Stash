//
//  SavingPage.swift
//  Cash Stash
//
//  Created by Luke Drushell on 10/8/21.
//

import SwiftUI

struct SavingPage: View {
    
    @State var wallets = Wallet3.loadFromFile()
    @State var selection: Wallet3 = Wallet3(name: "", icon: "", amount: 0.0)
    @State private var showSheet = false
    @State private var isAdding = false
    @State var pageIndex = 0
    @FocusState var showKeyboard: Bool
    
    @Binding var amountString: String
    
    @State var reloadPage = false
    
    @State var total: Double = 0
    
    @Binding var toolbarColor: Color
    
    @State var showTotals = false
    
    var body: some View {
        ZStack {
            GradientBackground(color1: .yellow, color2: .orange)
                .edgesIgnoringSafeArea(.all)
            ScrollView {
                HStack() {
                   Text("Savings Stash")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    Spacer()
                    Button {
                        withAnimation {
                            showTotals.toggle()
                        }
                    } label: {
                        Text("$\(total, specifier: "%.2f")")
                            .foregroundColor(.white)
                            .padding(6)
                            .background(.white.opacity(0.3))
                            .cornerRadius(15)
                    }
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
                        StashItem(icon: $wallets[index].icon, name: $wallets[index].name, amount: $wallets[index].amount, stashType: .constant(3))
                            .padding(1)
                    }
                })
            }
            .overlay(alignment: .bottom, content: {
                Button {
                    isAdding.toggle()
                } label: {
                    Text("Add Stash")
                        .foregroundColor(.orange)
                        .padding()
                        .frame(width: 250, height: 50, alignment: .center)
                        .background(.white)
                        .cornerRadius(25)
                        .animation(.linear, value: 1)
                        .padding()
                }
            })
            .sheet(isPresented: $isAdding, onDismiss: {
                wallets = Wallet3.loadFromFile()
                total = 0
                for i in wallets.indices {
                    total += wallets[i].amount
                }
            }, content: {
                NewPage(showKeyboard: _showKeyboard, showSheet: $isAdding, stashType: .constant(3))
            })
            Rectangle()
                .ignoresSafeArea(.all)
                .background(.thinMaterial)
                .opacity(showTotals ? 1 : 0)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture(perform: {
                    withAnimation{
                        showTotals = false
                    }
                })
            VStack(alignment: .leading) {
                Text("Total: $\(total, specifier: "%.2f")")
                    .font(.title.bold())
                    .foregroundColor(.white)
                    .padding(6)
            }
            .padding()
            .background(.thinMaterial)
            .cornerRadius(15)
            .onTapGesture {
                withAnimation {
                    showTotals = false
                }
            }
            .opacity(showTotals ? 1 : 0)
            .padding(.horizontal, 40)
        }
        .onAppear(perform: {
            toolbarColor = .orange
            amountString = "0.00"
            total = 0
            for i in wallets.indices {
                total += wallets[i].amount
            }
        })
        .sheet(isPresented: $showSheet, onDismiss: {
            let newData = Wallet3.loadFromFile()
            if newData.isEmpty == false {
//            wallets[pageIndex].amount = newData[pageIndex].amount
//            wallets[pageIndex].icon = newData[pageIndex].icon
//            wallets[pageIndex].name = newData[pageIndex].name
                wallets = newData
                total = 0
                for i in wallets.indices {
                    total += wallets[i].amount
                }
            } else {
                wallets = newData
                total = 0
                for i in wallets.indices {
                    total += wallets[i].amount
                }
            }
        }, content: {
            EditPage(icon: $selection.icon, name: $selection.name, amount: $selection.amount, index: $pageIndex, amountString: $amountString, showKeyboard: _showKeyboard, showSheet: $showSheet, stashType: .constant(3))
        })
    }
}

//struct SavingPage_Previews: PreviewProvider {
//    static var previews: some View {
//        SavingPage()
//    }
//}
