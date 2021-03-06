//
//  NewPage.swift
//  Cash Stash
//
//  Created by Luke Drushell on 10/8/21.
//

import SwiftUI

struct NewPage: View {
    
    @State var icon = "dollarsign.circle.fill"
    @State var name = "New Item"
    @State var amount = 0
    
    @State var subscriptions = UserSubscriptions.loadFromFile()
    
    @State private var wallet = Wallet.loadFromFile()
    @State private var wallet2 = Wallet2.loadFromFile()
    @State private var wallet3 = Wallet3.loadFromFile()
    
    @State var type = "Cash"
    @State var types = ["Cash", "Card", "Crypto", "Stocks", "Coins"]
    @State var amountString = "0.00"
    
    @FocusState var showKeyboard: Bool
    
    @Binding var showSheet: Bool
    
    @Binding var stashType: Int
    
    @State var highlightColor = Color.blue
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
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
                    if amountString == "" || amountString == " " { amountString = "0" }
                    let expn = NSExpression(format:amountString)
                    let result = expn.expressionValue(with: nil, context: nil)
                    let stringResult = "\(result!)"
                    let amount = Double(stringResult) ?? Double(amountString) ?? 0
                    if name == "" || name == " " {
                        name = "Unnamed Stash"
                    }
                    switch stashType {
                    case 1:
                        wallet.insert(Wallet(name: name, icon: icon, amount: amount), at: 0)
                        for index in subscriptions.indices {
                            if subscriptions[index].wallet == 1 {
                                subscriptions[index].indexNum += 1
                            }
                        }
                        UserSubscriptions.saveToFile(subscriptions)
                        Wallet.saveToFile(wallet)
                    case 2:
                        wallet2.insert(Wallet2(name: name, icon: icon, amount: amount), at: 0)
                        for index in subscriptions.indices {
                            if subscriptions[index].wallet == 2 {
                                subscriptions[index].indexNum += 1
                            }
                        }
                        UserSubscriptions.saveToFile(subscriptions)
                        Wallet2.saveToFile(wallet2)
                    default:
                        wallet3.insert(Wallet3(name: name, icon: icon, amount: amount), at: 0)
                        for index in subscriptions.indices {
                            if subscriptions[index].wallet == 3 {
                                subscriptions[index].indexNum += 1
                            }
                        }
                        UserSubscriptions.saveToFile(subscriptions)
                        Wallet3.saveToFile(wallet3)
                    }
                    showSheet = false
                } label: {
                    Text("Add Stash")
                        .foregroundColor(highlightColor)
                        .padding()
                        .frame(width: 250, height: 50, alignment: .center)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(25)
                        .animation(.linear, value: 1)
                        .padding()
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
    }
}
