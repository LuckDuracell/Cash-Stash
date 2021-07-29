//
//  NewSheet.swift
//  NewSheet
//
//  Created by Luke Drushell on 7/27/21.
//

import SwiftUI

struct NewSheet: View {
    
    
    @Binding var color: Color
    @Binding var icon: String
    @Binding var amount: String
    @Binding var name: String
    @Binding var editSheetIndex: Int
    @Binding var showSheet: Bool
    @Binding var wallets: [Wallet]
    
    @FocusState var showKeyboard: Bool
    
    @State var showDeleteAlert = false
    
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Type:")
                        .foregroundColor(.gray)
                        .padding(.leading)
                        .padding(.bottom, -5)
                    Spacer()
                }
                
                HStack {
                    Button {
                        icon = "dollarsign.circle.fill"
                    } label: {
                        Text("Cash")
                            .foregroundColor(color)
                            .padding(8)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .padding(5)
                    }
                    Button {
                        icon = "bitcoinsign.circle.fill"
                    } label: {
                        Text("Crypto")
                            .foregroundColor(color)
                            .padding(8)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .padding(5)
                    }
                    Button {
                        icon = "creditcard.circle.fill"
                    } label: {
                        Text("Card")
                            .foregroundColor(color)
                            .padding(8)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .padding(5)
                    }
                    Button {
                        icon = "chart.pie.fill"
                    } label: {
                        Text("Stocks")
                            .foregroundColor(color)
                            .padding(8)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .padding(5)
                    }
                }
                .frame(width: UIScreen.main.bounds.width*0.9, height: 60, alignment: .center)
                .background(.gray.opacity(0.2))
                .cornerRadius(10)
                .padding()
                
                HStack {
                    Text("Name:")
                        .foregroundColor(.gray)
                        .padding(.leading)
                        .padding(.bottom, -5)
                    Spacer()
                }

                TextField("Stash Name", text: $name)
                    .disableAutocorrection(true)
                    .focused($showKeyboard)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding()
                    
                HStack {
                    Text("Amount:")
                        .foregroundColor(.gray)
                        .padding(.leading)
                        .padding(.bottom, -5)
                    Spacer()
                }
                
                TextField("Stash Amount", text: $amount)
                    .keyboardType(.decimalPad)
                    .focused($showKeyboard)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding()
                
                Button {
                    if amount == "" || amount == " " { amount = "0" }
                    let expn = NSExpression(format:amount)
                    let result = expn.expressionValue(with: nil, context: nil)
                    let stringResult = "\(result!)"
                    let amountDouble = Double(stringResult) ?? Double(amount) ?? 0
                    if name == "" || name == " " {
                        name = "Unnamed Stash"
                    }
                    wallets.insert(Wallet(name: name, icon: icon, amount: amountDouble), at: 0)
                    //scaleButton()
                    showSheet.toggle()
                } label: {
                    Text("Add Stash")
                        .foregroundColor(color)
                        .padding()
                        .frame(width: 250, height: 50, alignment: .center)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(25)
                        .animation(.linear, value: 1)
                        .padding()
                }
            }
            .padding(.top, -100)
        }
    }
}
