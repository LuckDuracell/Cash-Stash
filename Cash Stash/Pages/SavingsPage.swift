//
//  SavingsPage.swift
//  SavingsPage
//
//  Created by Luke Drushell on 7/25/21.
//

import SwiftUI
import Introspect
import CoreData

struct SavingsPage: View {
    
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
    
    @State private var wallets = Wallet3.loadFromFile()
    @State private var buttonScaled = true
    
    @State var showDeleteAlert = false
    @State var showSheet = false
    @State var showEditSheet = false
    @State var editSheetIndex = 0
    
    @State var name = ""
    @State var icon = "dollarsign.circle.fill"
    @State var amount = ""
    
    @FocusState var showKeyboard: Bool
    
    @State var total: Double = 0
    
    fileprivate func scaleButton() {
//        withAnimation {
//            buttonScaled = false
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
//            withAnimation {
//                buttonScaled = true
//            }
//        })
    }
    
    var body: some View {
            ZStack {
                NavigationView {
                    ZStack {
                        GradientBackground(color1: .yellow, color2: .orange)
                        List {
                            ForEach(wallets.indices, id: \.self, content: { index in
                                HStack {
                                    Image(systemName: wallets[index].icon)
                                        .resizable()
                                        .foregroundColor(.orange)
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
                                Wallet3.saveToFile(wallets)
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
                    .navigationTitle("Savings Stash")
                    .toolbar(content: {
                        ToolbarItem(placement: .bottomBar) {
                            Button {
                                scaleButton()
                                showSheet.toggle()
                            } label: {
                                Text("Add Stash")
                                    .foregroundColor(.orange)
                                    .padding()
                                    .frame(width: buttonScaled ? 250 : 220, height: buttonScaled ? 50 : 44, alignment: .center)
                                    .background(Color.white)
                                    .cornerRadius(25)
                                    .animation(.linear, value: 1)
                                    .padding(.bottom, 30)
                            }
                        }
                        ToolbarItem(placement: .navigationBarLeading) {
                            Text("Total: $\(total, specifier: "%.2f")")
                                .foregroundColor(Color("opposite"))
                                .frame(width: UIScreen.main.bounds.width * 0.5, alignment: .leading)
                        }
                    })
                }
            }
            .sheet(isPresented: $showSheet, onDismiss: {
                Wallet3.saveToFile(wallets)
                name = ""
                icon = "dollarsign.circle.fill"
                amount = ""
                showEditSheet = false
                total = 0
                for i in wallets.indices {
                    total += wallets[i].amount
                }
            }, content: {
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
                                    .padding(8)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                    .padding(5)
                                    .foregroundColor(.orange)
                            }
                            Button {
                                icon = "bitcoinsign.circle.fill"
                            } label: {
                                Text("Crypto")
                                    .padding(8)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                    .padding(5)
                                    .foregroundColor(.orange)
                            }
                            Button {
                                icon = "building.columns.fill"
                            } label: {
                                Text("Bank")
                                    .padding(8)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                    .padding(5)
                                    .foregroundColor(.orange)
                            }
                            Button {
                                icon = "chart.pie.fill"
                            } label: {
                                Text("Stocks")
                                    .padding(8)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                    .padding(5)
                                    .foregroundColor(.orange)
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
                                name = "Unnamed Savings"
                            }
                            wallets.insert(Wallet3(name: name, icon: icon, amount: amountDouble), at: 0)
                            scaleButton()
                            showSheet.toggle()
                        } label: {
                            Text("Add Stash")
                                .padding()
                                .frame(width: buttonScaled ? 250 : 220, height: buttonScaled ? 50 : 44, alignment: .center)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(25)
                                .animation(.linear, value: 1)
                                .padding()
                                .foregroundColor(.orange)
                        }
                    }
                    .padding(.top, -100)
                }
            })
            .sheet(isPresented: $showEditSheet, onDismiss: {
                Wallet3.saveToFile(wallets)
                name = ""
                icon = "dollarsign.circle.fill"
                amount = ""
                showEditSheet = false
                total = 0
                for i in wallets.indices {
                    total += wallets[i].amount
                }
            }, content: {
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
                                .padding(8)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .padding(5)
                                .foregroundColor(.orange)
                        }
                        Button {
                            icon = "bitcoinsign.circle.fill"
                        } label: {
                            Text("Crypto")
                                .padding(8)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .padding(5)
                                .foregroundColor(.orange)
                        }
                        Button {
                            icon = "building.columns.fill"
                        } label: {
                            Text("Bank")
                                .padding(8)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .padding(5)
                                .foregroundColor(.orange)
                        }
                        Button {
                            icon = "chart.pie.fill"
                        } label: {
                            Text("Stocks")
                                .padding(8)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .padding(5)
                                .foregroundColor(.orange)
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
                            name = "Unnamed Savings"
                        }
                        wallets[editSheetIndex] = Wallet3(name: name, icon: icon, amount: amountDouble)
                        scaleButton()
                        showEditSheet.toggle()
                    } label: {
                        Text("Save Stash")
                            .padding()
                            .frame(width: buttonScaled ? 250 : 220, height: buttonScaled ? 50 : 44, alignment: .center)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(25)
                            .animation(.linear, value: 1)
                            .padding()
                            .foregroundColor(.orange)
                    }
                    
                    Button {
                        showDeleteAlert.toggle()
                    } label: {
                        Text("Delete Stash")
                            .foregroundColor(.red)
                            .padding()
                            .frame(width: buttonScaled ? 250 : 220, height: buttonScaled ? 50 : 44, alignment: .center)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(25)
                            .animation(.linear, value: 1)
                            .padding(.top, -10)
                    } .alert("Are you sure you want to delete this Stash?", isPresented: $showDeleteAlert) {
                        Button("Delete") {
                            wallets.remove(at: editSheetIndex)
                            showEditSheet.toggle()
                        } .foregroundColor(.red)
                    } .accentColor(.orange)
                    
                }
                .padding(.top, -100)
                }
            })
            .toolbar(content: {
                ToolbarItem(placement: .keyboard, content: {
                    HStack() {
                        Button {
                            amount = "\(amount)+"
                            print("plus")
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(.orange)
                        }
                        Button {
                            amount = "\(amount)-"
                            print("minus")
                        } label: {
                            Image(systemName: "minus")
                                .foregroundColor(.orange)
                        }
                        Spacer()
                        Button {
                            showKeyboard = false
                            print(showKeyboard)
                        } label: {
                            Text("Done")
                                .multilineTextAlignment(.trailing)
                                .foregroundColor(.orange)
                        }
                    }
                })
            })
        }
}

struct SavingsPage_Previews: PreviewProvider {
    static var previews: some View {
        SavingsPage()
    }
}
