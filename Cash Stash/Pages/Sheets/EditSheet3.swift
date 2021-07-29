//
//  EditSheet2.swift
//  EditSheet2
//
//  Created by Luke Drushell on 7/27/21.
//

import SwiftUI

struct EditSheet3: View {
    
    @Binding var color: Color
    @Binding var icon: String
    @Binding var amount: String
    @Binding var name: String
    @Binding var editSheetIndex: Int
    @Binding var showEditSheet: Bool
    @Binding var wallets: [Wallet3]
    
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
                .frame(width: UIScreen.main.bounds.width*0.9, height: 60, alignment: .center)
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
                .frame(width: UIScreen.main.bounds.width*0.9, height: 60, alignment: .center)
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
                wallets[editSheetIndex] = Wallet3(name: name, icon: icon, amount: amountDouble)
                //scaleButton()
                showEditSheet.toggle()
            } label: {
                Text("Save Stash")
                    .foregroundColor(color)
                    .padding()
                    .frame(width: 250, height: 50, alignment: .center)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(25)
                    .animation(.linear, value: 1)
                    .padding()
            }
            
            Button {
                showDeleteAlert.toggle()
            } label: {
                Text("Delete Stash")
                    .foregroundColor(.red)
                    .padding()
                    .frame(width: 250, height: 50, alignment: .center)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(25)
                    .animation(.linear, value: 1)
                    .padding(.top, -10)
            } .alert("Are you sure you want to delete this Stash?", isPresented: $showDeleteAlert) {
                Button("Delete") {
                    wallets.remove(at: editSheetIndex)
                    showEditSheet.toggle()
                } .foregroundColor(.red)
            } .accentColor(.blue)
            
        }
        .padding(.top, -100)
        }
    }
}
