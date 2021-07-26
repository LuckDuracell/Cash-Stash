//
//  GiftcardsPage.swift
//  GiftcardsPage
//
//  Created by Luke Drushell on 7/25/21.
//

import SwiftUI
import Introspect
import CoreData

struct GiftcardsPage: View {
    
    init() {
        //Make "Cash Stash title into white text"
        let whiteNavColor = UINavigationBarAppearance()
        whiteNavColor.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = whiteNavColor
        
        
        //Clear List Background
        UITableView.appearance().backgroundColor = .clear
    }
    
    @State private var wallets = Wallet2.loadFromFile()
    @State private var buttonScaled = true
    
    @State var showSheet = false
    @State var showEditSheet = false
    @State var editSheetIndex = 0
    
    @State var name = ""
    @State var icon = ""
    @State var amount = ""
    @State var amountNum = ""
    
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
                    .toolbar(content: {
                        ToolbarItem(placement: .bottomBar) {
                            Button {
                                scaleButton()
                                showSheet.toggle()
                            } label: {
                                Text("Add Stash")
                                    .foregroundColor(.blue)
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
                                .foregroundColor(.white)
                                .frame(width: UIScreen.main.bounds.width * 0.95, alignment: .leading)
                        }
                    })
                }
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
                                icon = "fork.knife.circle.fill"
                            } label: {
                                Text("Food")
                                    .padding(8)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                    .padding(5)
                            }
                            Button {
                                icon = "cart.circle.fill"
                            } label: {
                                Text("Shop")
                                    .padding(8)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                    .padding(5)
                            }
                            Button {
                                icon = "wifi.circle.fill"
                            } label: {
                                Text("Games")
                                    .padding(8)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                    .padding(5)
                            }
                            Button {
                                icon = "film.circle.fill"
                            } label: {
                                Text("Movies")
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
                        
                        Spacer()
                        Button {
                            let expn = NSExpression(format:amount)
                            let result = expn.expressionValue(with: nil, context: nil)
                            let stringResult = "\(result!)"
                            let amountDouble = Double(stringResult) ?? Double(amount) ?? 0
                            if name == "" || name == " " {
                                name = "Unnamed Giftcard"
                            }
                            wallets.insert(Wallet2(name: name, icon: icon, amount: amountDouble), at: 0)
                            scaleButton()
                            showSheet.toggle()
                        } label: {
                            Text("Add Stash")
                                .foregroundColor(.blue)
                                .padding()
                                .frame(width: buttonScaled ? 250 : 220, height: buttonScaled ? 50 : 44, alignment: .center)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(25)
                                .animation(.linear, value: 1)
                                .padding()
                        }
                    } .padding(.top, 100)
                }
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
                            icon = "fork.knife.circle.fill"
                        } label: {
                            Text("Food")
                                .padding(8)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .padding(5)
                        }
                        Button {
                            icon = "cart.circle.fill"
                        } label: {
                            Text("Shop")
                                .padding(8)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .padding(5)
                        }
                        Button {
                            icon = "wifi.circle.fill"
                        } label: {
                            Text("Games")
                                .padding(8)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .padding(5)
                        }
                        Button {
                            icon = "film.circle.fill"
                        } label: {
                            Text("Movies")
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
                    
                    Spacer()
                    Button {
                        let expn = NSExpression(format:amount)
                        let result = expn.expressionValue(with: nil, context: nil)
                        let stringResult = "\(result!)"
                        let amountDouble = Double(stringResult) ?? Double(amount) ?? 0
                        if name == "" || name == " " {
                            name = "Unnamed Giftcard"
                        }
                        wallets[editSheetIndex] = Wallet2(name: name, icon: icon, amount: amountDouble)
                        scaleButton()
                        showEditSheet.toggle()
                    } label: {
                        Text("Save Stash")
                            .foregroundColor(.blue)
                            .padding()
                            .frame(width: buttonScaled ? 250 : 220, height: buttonScaled ? 50 : 44, alignment: .center)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(25)
                            .animation(.linear, value: 1)
                            .padding()
                    }
                }
                .padding(.top, 100)
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
                                .foregroundColor(.blue)
                        }
                        Button {
                            amount = "\(amount)-"
                            print("minus")
                        } label: {
                            Image(systemName: "minus")
                                .foregroundColor(.blue)
                        }
                        Spacer()
                        Button {
                            showKeyboard = false
                            print(showKeyboard)
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

struct GiftcardsPage_Previews: PreviewProvider {
    static var previews: some View {
        GiftcardsPage()
    }
}
