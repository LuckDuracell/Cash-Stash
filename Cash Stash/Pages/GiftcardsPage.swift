//
//  GiftcardsPage.swift
//  GiftcardsPage
//
//  Created by Luke Drushell on 7/25/21.
//

import SwiftUI

import CoreData

struct GiftcardsPage: View {
    
    init() {
        //Make "Cash Stash title into white text"
        let whiteNavColor = UINavigationBarAppearance()
        whiteNavColor.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = whiteNavColor
        
        //Moves Header to the right side of toolbar when scrolling
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 72

        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor.purple,
            .paragraphStyle: paragraphStyle
        ]
        
        //Clear List Background
        UITableView.appearance().backgroundColor = .clear
    }
    
    @State private var wallets = Wallet2.loadFromFile()
    
    @State var showDeleteAlert = false
    @State var showSheet = false
    @State var showEditSheet = false
    @State var editSheetIndex = 0
    
    @State var color: Color = Color.purple
    
    @State var name = ""
    @State var icon = "cart.circle.fill"
    @State var amount = ""
    
    @FocusState var showKeyboard: Bool
    
    @State var total: Double = 0
    
    var body: some View {
            NavigationView {
                ZStack {
                    GradientBackground(color1: .pink, color2: .purple)
                    List {
                        ForEach(wallets.indices, id: \.self, content: { index in
                            HStack {
                                Image(systemName: wallets[index].icon)
                                    .resizable()
                                    .foregroundColor(.purple)
                                    .scaledToFill()
                                    .frame(width: 30, height: 30, alignment: .center)
                                    .padding(.leading, 5)
                                Text(wallets[index].name)
                                    .padding(.leading, 10)
                                    .foregroundColor(.black)
                                Spacer()
                                Text("$\(wallets[index].amount, specifier: "%.2f")")
                                    .padding(.trailing)
                                    .foregroundColor(.black)
                            }
                            .listRowBackground(Color.white)
                            .onTapGesture(perform: {
                                showEditSheet = true
                                editSheetIndex = index
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                                    name = wallets[index].name
                                    amount = "\(wallets[index].amount)"
                                    icon = wallets[index].icon
                                })
                            })
                        })
                        .onDelete(perform: { index in
                            wallets.remove(atOffsets: index)
                            Wallet2.saveToFile(wallets)
                            total = 0
                            for i in wallets.indices {
                                total += wallets[i].amount
                            }
                        })
                    }
                    .onAppear(perform: {
                        total = 0
                        for i in wallets.indices {
                            total += wallets[i].amount
                        }
                    })
                }
                .navigationTitle("Giftcards Stash")
                .overlay(
                    Button {
                        showSheet.toggle()
                    } label: {
                        Text("Add Stash")
                            .foregroundColor(.purple)
                            .padding()
                            .frame(width: 250, height: 50, alignment: .center)
                            .background(Color.white)
                            .cornerRadius(25)
                            .animation(.linear, value: 1)
                            .padding(.bottom, 30)
                    } .shadow(color: .black.opacity(0.5), radius: 35), alignment: .bottom)
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("Total: $\(total, specifier: "%.2f")")
                            .foregroundColor(Color("opposite"))
                            .frame(width: UIScreen.main.bounds.width * 0.5, alignment: .leading)
                    }
                })
            }
        .sheet(isPresented: $showSheet, onDismiss: {
            Wallet2.saveToFile(wallets)
            name = ""
            icon = "cart.circle.fill"
            amount = ""
            showEditSheet = false
            total = 0
            for i in wallets.indices {
                total += wallets[i].amount
            }
        }, content: {
            NewSheet2(color: $color, icon: $icon, amount: $amount, name: $name, editSheetIndex: $editSheetIndex, showSheet: $showSheet, wallets: $wallets, showKeyboard: _showKeyboard)
        })
        .sheet(isPresented: $showEditSheet, onDismiss: {
            Wallet2.saveToFile(wallets)
            name = ""
            icon = "cart.circle.fill"
            amount = ""
            showEditSheet = false
            total = 0
            for i in wallets.indices {
                total += wallets[i].amount
            }
        }, content: {
            EditSheet2(color: $color, icon: $icon, amount: $amount, name: $name, editSheetIndex: $editSheetIndex, showEditSheet: $showEditSheet, wallets: $wallets, showKeyboard: _showKeyboard)
        })
        .toolbar(content: {
            ToolbarItem(placement: .keyboard, content: {
                HStack() {
                    Button {
                        amount = "\(amount)+"
                        print("plus")
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.purple)
                    }
                    Button {
                        amount = "\(amount)-"
                        print("minus")
                    } label: {
                        Image(systemName: "minus")
                            .foregroundColor(.purple)
                    }
                    Spacer()
                    Button {
                        showKeyboard = false
                        print(showKeyboard)
                    } label: {
                        Text("Done")
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.purple)
                    }
                }
            })
        })
    }
}

struct GiftcardsPage_Previews: PreviewProvider {
    static var previews: some View {
        GiftcardsPage()
    }
}
