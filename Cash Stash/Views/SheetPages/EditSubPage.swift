//
//  EditSubPage.swift
//  Cash Stash
//
//  Created by Luke Drushell on 12/27/21.
//

import SwiftUI

struct EditSubPage: View {
    
    @Binding var subscription: UserSubscriptions
    @State var walletNum = 1
    @State var confirmDelete = false
    
    @State var subscriptions = UserSubscriptions.loadFromFile()
    
    @State private var wallet = Wallet.loadFromFile()
    @State private var wallet2 = Wallet2.loadFromFile()
    @State private var wallet3 = Wallet3.loadFromFile()
    
    var types = ["Weekly", "Monthly", "Annual", "Custom"]
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
                    Picker("Type", selection: $subscription.frequency, content: {
                        ForEach(types, id: \.self, content: { type in
                            Text(type)
                        })
                    }) .pickerStyle(.segmented)
                        .padding(.horizontal)
                    if subscription.frequency != "Weekly" && subscription.frequency != "Monthly" && subscription.frequency != "Annual" {
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
                    TextField("Name", text: $subscription.subscriptionName)
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
                        TextField("Amount", value: $subscription.amount, format: .number)
                            .keyboardType(.decimalPad)
                            .padding(.horizontal)
                            .frame(width: UIScreen.main.bounds.width * 0.5, height: 50, alignment: .center)
                            .background(.gray.opacity(0.16))
                            .cornerRadius(10)
                            .focused($showKeyboard)
                        Button {
                            self.subscription.expense.toggle()
                        } label: {
                            Text(subscription.expense ? "Expense" : "Income")
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
                        DatePicker("", selection: $subscription.latestCharge, displayedComponents: .date)
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
                                    self.subscription.indexNum = stashIndex
                                } label: {
                                    HStack {
                                        Image(systemName: wallet[stashIndex].icon)
                                        Text(wallet[stashIndex].name)
                                        Spacer()
                                        if walletNum == 1 && subscription.indexNum == stashIndex {
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
                                    self.subscription.indexNum = stashIndex
                                } label: {
                                    HStack {
                                        Image(systemName: wallet2[stashIndex].icon)
                                        Text(wallet2[stashIndex].name)
                                        Spacer()
                                        if walletNum == 2 && subscription.indexNum == stashIndex {
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
                                    self.subscription.indexNum = stashIndex
                                } label: {
                                    HStack {
                                        Image(systemName: wallet3[stashIndex].icon)
                                        Text(wallet3[stashIndex].name)
                                        Spacer()
                                        if walletNum == 3 && subscription.indexNum == stashIndex {
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
                Spacer()
                Button {
                    if amountString == "" || amountString == " " {
                        print("empty")
                        amountString = "0" }
                    if subscription.frequency == "" || subscription.frequency == " " { subscription.frequency = "0" }
                    if subscription.frequency == "Custom" { subscription.frequency = customType }
                    self.subscription.amount = Double(amountString) ?? 0
                    if subscription.subscriptionName == "" || subscription.subscriptionName == " " {
                        self.subscription.subscriptionName = "Unnamed Subscription"
                    }
                    showSheet = false
                } label: {
                    Text("Save Item")
                        .foregroundColor(.green)
                        .padding()
                        .frame(width: 250, height: 50, alignment: .center)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(25)
                        .animation(.linear, value: 1)
                        .padding(3)
                }
                Button {
                    confirmDelete = true
                } label: {
                    Text("Delete Item")
                        .foregroundColor(.red)
                        .padding()
                        .frame(width: 250, height: 50, alignment: .center)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(25)
                        .animation(.linear, value: 1)
                }
            }
        } .padding(.top, 20)
            .onAppear(perform: {
                amountString = "\(subscription.amount)"
                if subscription.frequency != "Weekly" && subscription.frequency != "Monthly" && subscription.frequency != "Monthly" {
                    customType = subscription.frequency
                    subscription.frequency = "Custom"
                }
            })
            .alert(isPresented: $confirmDelete, content: {
                Alert(title: Text("Confirm Delete"), message: Text("Are you sure you want to delete this?"), primaryButton: Alert.Button.destructive(Text("Delete It"), action: {
                    showSheet = false
                }), secondaryButton: Alert.Button.cancel())
            })
    }
}
