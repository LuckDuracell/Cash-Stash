//
//  EditPage.swift
//  Cash Stash
//
//  Created by Luke Drushell on 10/8/21.
//

import SwiftUI

struct EditPage: View {
    
    @Binding var icon: String
    @Binding var name: String
    @Binding var amount: Double
    @Binding var index: Int
    
    @State private var wallet = Wallet.loadFromFile()
    @State private var wallet2 = Wallet2.loadFromFile()
    @State private var wallet3 = Wallet3.loadFromFile()
    
    @State var subscriptions = UserSubscriptions.loadFromFile()
    
    @State var type = "Cash"
    @State var types = ["Cash", "Card", "Crypto", "Stocks", "Coins"]
    @Binding var amountString: String
    
    @FocusState var showKeyboard: Bool
    
    @Binding var showSheet: Bool
    
    @Binding var stashType: Int
    
    @State var confirmDelete = false
    
    @State var highlightColor = Color.blue
    
    var body: some View {
        ZStack {
            ScrollView {
                Spacer()
                VStack {
                    HStack {
                        Text("Icon:")
                            .padding(.horizontal)
                            .foregroundColor(.gray)
                            .font(.subheadline)
                        Spacer()
                    }
                    Picker("Type", selection: $type, content: {
                        ForEach(types, id: \.self, content: { type in
                            Text(type)
                        })
                    }) .pickerStyle(.segmented)
                        .padding(.horizontal)
                    
                    HStack {
                        Text("Name:")
                            .padding(.horizontal)
                            .foregroundColor(.gray)
                            .font(.subheadline)
                        Spacer()
                    }
                    .padding(.top)
                    TextField("Name", text: $name)
                        .padding(.horizontal)
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 50, alignment: .center)
                        .background(.gray.opacity(0.16))
                        .cornerRadius(10)
                        .focused($showKeyboard)
                    
                    HStack {
                        Text("Amount:")
                            .padding(.horizontal)
                            .foregroundColor(.gray)
                            .font(.subheadline)
                        Spacer()
                    }
                    .padding(.top)
                    TextField("Amount", text: $amountString)
                        .keyboardType(.decimalPad)
                        .padding(.horizontal)
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 50, alignment: .center)
                        .background(.gray.opacity(0.16))
                        .cornerRadius(10)
                        .focused($showKeyboard)
                    Spacer()
                    
                    Button {
                        if amountString == "" || amountString == " " { amountString = "0" }
                        let expn = NSExpression(format:amountString)
                        let result = expn.expressionValue(with: nil, context: nil)
                        let stringResult = "\(result!)"
                        let amount = Double(stringResult) ?? Double(amountString) ?? 0
                        if name == "" || name == " " {
                            name = "Unnamed Stash"
                        }
                        
                        switch type {
                        case "Card":
                            icon = "creditcard.circle.fill"
                        case "Crypto":
                            icon = "bitcoinsign.circle.fill"
                        case "Stocks":
                            icon = "chart.pie.fill"
                        case "Coins":
                            icon = "centsign.circle.fill"
                        default:
                            icon = "dollarsign.circle.fill"
                        }
                        
                        switch stashType {
                        case 1:
                            wallet[index] = Wallet(name: name, icon: icon, amount: amount)
                            Wallet.saveToFile(wallet)
                        case 2:
                            wallet2[index] = Wallet2(name: name, icon: icon, amount: amount)
                            Wallet2.saveToFile(wallet2)
                        default:
                            wallet3[index] = Wallet3(name: name, icon: icon, amount: amount)
                            Wallet3.saveToFile(wallet3)
                        }
                        
                        showSheet = false
                    } label: {
                        Text("Save Stash")
                            .foregroundColor(highlightColor)
                            .padding()
                            .frame(width: 250, height: 50, alignment: .center)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(25)
                            .animation(.linear, value: 1)
                            .padding()
                    }
                    
                    Button {
                        confirmDelete = true
                    } label: {
                        Text("Delete Stash")
                            .foregroundColor(.red)
                            .padding()
                            .frame(width: 250, height: 50, alignment: .center)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(25)
                            .animation(.linear, value: 1)
                            .padding(.bottom, 50)
                    }
                    
                    
                }
                .onAppear(perform: {
                    switch icon {
                    case "creditcard.circle.fill":
                        type = "Card"
                    case "bitcoinsign.circle.fill":
                        type = "Crypto"
                    case "chart.pie.fill":
                        type = "Stocks"
                    case "centsign.circle.fill":
                        type = "Coins"
                    default:
                        type = "Cash"
                    }
                    
                    if stashType == 1 {
                        highlightColor = Color.blue
                    } else if stashType == 2 {
                        highlightColor = Color.purple
                    } else {
                        highlightColor = Color.orange
                    }

                    
                    amountString = "\(amount)"
                })
            }
            .padding(.vertical)
            .alert(isPresented: $confirmDelete, content: {
                Alert(title: Text("Confirm Delete"), message: Text("Are you sure you want to delete this?"), primaryButton: Alert.Button.destructive(Text("Delete It"), action: {
                    switch stashType {
                    case 1:
                        wallet.remove(at: index)
                        Wallet.saveToFile(wallet)
                        for i in subscriptions.indices {
                            if subscriptions[i].wallet == 1 {
                                if subscriptions[i].indexNum > index {
                                    subscriptions[i].indexNum -= 1
                                } else if subscriptions[i].indexNum < index {
                                    
                                } else {
                                    subscriptions.remove(at: i)
                                }
                            }
                        }
                        UserSubscriptions.saveToFile(subscriptions)
                    case 2:
                        wallet2.remove(at: index)
                        Wallet2.saveToFile(wallet2)
                        for i in subscriptions.indices {
                            if subscriptions[i].wallet == 2 {
                                if subscriptions[i].indexNum > index {
                                    subscriptions[i].indexNum -= 1
                                } else if subscriptions[i].indexNum < index {
                                    
                                } else {
                                    subscriptions.remove(at: i)
                                }
                            }
                        }
                        UserSubscriptions.saveToFile(subscriptions)
                    default:
                        wallet3.remove(at: index)
                        Wallet3.saveToFile(wallet3)
                        for i in subscriptions.indices {
                            if subscriptions[i].wallet == 3 {
                                if subscriptions[i].indexNum > index {
                                    subscriptions[i].indexNum -= 1
                                } else if subscriptions[i].indexNum < index {
                                    
                                } else {
                                    subscriptions.remove(at: i)
                                }
                            }
                        }
                        UserSubscriptions.saveToFile(subscriptions)
                    }
                    showSheet = false
                }), secondaryButton: Alert.Button.cancel())
            })
        }
        .padding(.top, 20)
    }
}


