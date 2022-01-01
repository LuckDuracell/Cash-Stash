//
//  NewSubPage.swift
//  Cash Stash
//
//  Created by Luke Drushell on 12/27/21.
//

import SwiftUI

struct NewSubPage: View {
    
    @State var icon = "hourglass"
    @State var name = "New Item"
    @State var amount: Double = 0
    @State var walletNum = 1
    @State var indexNum = 0
    @State var lastChargerd = Date()
    @State var expense = true
    
    @State var subscriptions = UserSubscriptions.loadFromFile()
    
    @State private var wallet = Wallet.loadFromFile()
    @State private var wallet2 = Wallet2.loadFromFile()
    @State private var wallet3 = Wallet3.loadFromFile()
    
    @State var type = "Monthly"
    @State var types = ["Weekly", "Monthly", "Annual", "Custom"]
    @State var amountString = "0.00"
    
    @State var customType = ""
    
    @FocusState var showKeyboard: Bool
    
    @Binding var showSheet: Bool
    
    @State var showWallets = false
    
    var body: some View {
        ZStack {
            ScrollView {
                Spacer()
                VStack {
                    HStack {
                        Text("Renewal Frequency:")
                            .padding(.horizontal)
                            .foregroundColor(.gray)
                            .font(.subheadline)
                            .padding(.top, 30)
                        Spacer()
                    }
                    Picker("Type", selection: $type, content: {
                        ForEach(types, id: \.self, content: { type in
                            Text(type)
                        })
                    }) .pickerStyle(.segmented)
                        .padding(.horizontal)
                    if type != "Weekly" && type != "Monthly" && type != "Annual" {
                        HStack {
                            Text("Days Between Renewal:")
                                .padding(.horizontal)
                                .foregroundColor(.gray)
                                .font(.subheadline)
                                .padding(.top)
                            Spacer()
                        }
                        TextField("Frequency (Days)", text: $customType)
                            .keyboardType(.numberPad)
                            .padding(.horizontal)
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: 50, alignment: .center)
                            .background(.gray.opacity(0.16))
                            .cornerRadius(10)
                            .focused($showKeyboard)
                    }
                }
                VStack {
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
                }
                VStack {
                    HStack {
                        Text("Amount:")
                            .padding(.horizontal)
                            .foregroundColor(.gray)
                            .font(.subheadline)
                        Spacer()
                    }
                    .padding(.top)
                    HStack {
                        TextField("Amount", text: $amountString)
                            .keyboardType(.decimalPad)
                            .padding(.horizontal)
                            .frame(width: UIScreen.main.bounds.width * 0.5, height: 50, alignment: .center)
                            .background(.gray.opacity(0.16))
                            .cornerRadius(10)
                            .focused($showKeyboard)
                        Button {
                            expense.toggle()
                        } label: {
                            Text(expense ? "Expense" : "Income")
                                .foregroundColor(.green)
                                .padding(.horizontal)
                                .frame(width: UIScreen.main.bounds.width * 0.38, height: 50, alignment: .center)
                                .background(.gray.opacity(0.16))
                                .cornerRadius(10)
                        }
                    }
                    //.padding(.horizontal, 30)
                }
                VStack {
                    HStack {
                        Text("Last Transaction:")
                            .padding(.horizontal)
                            .foregroundColor(.gray)
                            .font(.subheadline)
                        Spacer()
                        DatePicker("", selection: $lastChargerd, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .accentColor(.green)
                            .padding()
                    }
                }
                VStack {
                    HStack {
                        Text("Stash:")
                            .padding(.horizontal)
                            .foregroundColor(.gray)
                            .font(.subheadline)
                        Spacer()
                        Button {
                            withAnimation {
                                showWallets.toggle()
                            }
                        } label: {
                            Image(systemName: "chevron.down")
                                .rotationEffect(showWallets ? Angle(degrees: 180) : Angle(degrees: 0))
                                .foregroundColor(.green)
                        } .padding(.horizontal, 30)
                    }
                    if showWallets {
                        VStack {
                        ForEach(wallet.indices, id: \.self, content: { stashIndex in
                            Button {
                                walletNum = 1
                                indexNum = stashIndex
                            } label: {
                                HStack {
                                    Image(systemName: wallet[stashIndex].icon)
                                    Text(wallet[stashIndex].name)
                                    Spacer()
                                    if walletNum == 1 && indexNum == stashIndex {
                                        Image(systemName: "checkmark")
                                    }
                                } .padding(.trailing, 10)
                                .foregroundColor(.green)
                            }
                            Divider()
                        })
                        ForEach(wallet2.indices, id: \.self, content: { stashIndex in
                            Button {
                                walletNum = 2
                                indexNum = stashIndex
                            } label: {
                                HStack {
                                    Image(systemName: wallet2[stashIndex].icon)
                                    Text(wallet2[stashIndex].name)
                                    Spacer()
                                    if walletNum == 2 && indexNum == stashIndex {
                                        Image(systemName: "checkmark")
                                    }
                                } .padding(.trailing, 10)
                                .foregroundColor(.green)
                            }
                            Divider()
                        })
                        ForEach(wallet3.indices, id: \.self, content: { stashIndex in
                            Button {
                                walletNum = 3
                                indexNum = stashIndex
                            } label: {
                                HStack {
                                    Image(systemName: wallet3[stashIndex].icon)
                                    Text(wallet3[stashIndex].name)
                                    Spacer()
                                    if walletNum == 3 && indexNum == stashIndex {
                                        Image(systemName: "checkmark")
                                    }
                                } .padding(.trailing, 10)
                                .foregroundColor(.green)
                            }
                            if stashIndex < wallet3.count - 1 {
                                Divider()
                            }
                        })
                        } .padding()
                            .background(.gray.opacity(0.16))
                            .cornerRadius(10)
                            .padding(.top, 5)
                            .padding(.horizontal)
                    }
                }
                Spacer()
                Button {
                    if amountString == "" || amountString == " " { amountString = "0" }
                    if type == "" || type == " " { type = "0" }
                    if type == "Custom" { type = customType }
                    amount = Double(amountString) ?? 0
                    if name == "" || name == " " {
                        name = "Unnamed Subscription"
                    }
                    subscriptions.insert(UserSubscriptions(subscriptionName: name, amount: amount, wallet: walletNum, indexNum: indexNum, frequency: type, updated: Date(), latestCharge: lastChargerd, timesCharged: 0, expense: expense), at: 0)
                    UserSubscriptions.saveToFile(subscriptions)
                    showSheet = false
                } label: {
                    Text("Add Item")
                        .foregroundColor(.green)
                        .padding()
                        .frame(width: 250, height: 50, alignment: .center)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(25)
                        .animation(.linear, value: 1)
                        .padding()
                        .padding(.bottom, 50)
                }
            }
        } .padding(.top, 20)
    }
}
