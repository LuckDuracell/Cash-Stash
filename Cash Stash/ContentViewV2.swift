//
//  ContentViewV2.swift
//  Cash Stash
//
//  Created by Luke Drushell on 10/8/21.
//

import SwiftUI

struct ContentViewV2: View {
    
    @FocusState var showKeyboard: Bool
    @State var amountString = "0.00"
    @State var toolbarColor = Color.blue
    
    @State var subscriptions = UserSubscriptions.loadFromFile()
    @State var wallet1 = Wallet.loadFromFile()
    @State var wallet2 = Wallet2.loadFromFile()
    @State var wallet3 = Wallet3.loadFromFile()
    
    @State private var selection = 1
    
    var body: some View {
        TabView(selection: $selection) {
            SubscriptionsPage(toolbarColor: $toolbarColor , showKeyboard: _showKeyboard)
                .environment(\.tintColor, .green)
                .tag(0)
            CashPage(showKeyboard: _showKeyboard, amountString: $amountString, toolbarColor: $toolbarColor)
                .environment(\.tintColor, .blue)
                .tag(1)
            GiftPage(showKeyboard: _showKeyboard, amountString: $amountString, toolbarColor: $toolbarColor)
                .environment(\.tintColor, .purple)
                .tag(2)
            SavingPage(showKeyboard: _showKeyboard, amountString: $amountString, toolbarColor: $toolbarColor)
                .environment(\.tintColor, .orange)
                .tag(3)
        } .tabViewStyle(.page)
            .edgesIgnoringSafeArea(.all)
            .onAppear(perform: {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                    switch selection {
                    case 0:
                        toolbarColor = .green
                    case 1:
                        toolbarColor = .blue
                    case 2:
                        toolbarColor = .purple
                    default:
                        toolbarColor = .orange
                    }
                }
                if subscriptions.isEmpty {
                    subscriptions = []
                }
                var latestChargeArray: [Date] = []
                for subscription in subscriptions {
                    let distance = Calendar.current.dateComponents([.second, .day, .month, .year], from: subscription.latestCharge, to: Date())
                    var latest = Calendar.current.dateComponents([.day, .month, .year], from: subscription.latestCharge)
                    print("DISTANCE HERE ->   \(distance)")
                    var removalAmount: Double = 0
                    var addititonAmount: Double = 0
                    switch subscription.frequency {
                    case "Weekly":
                        let weekRemainer = Int(Double(distance.day! / 7).rounded(.down))
                        if weekRemainer != 0 {
                            print("mod -> \(weekRemainer)")
                            latest.day! += (7 * weekRemainer)
                        }
                        if subscription.expense {
                            removalAmount = subscription.amount * Double(weekRemainer)
                        } else {
                            addititonAmount = subscription.amount * Double(weekRemainer)
                        }
                    case "Monthly":
                        if distance.month! != 0 {
                            latest.month! += distance.month!
                        }
                        if subscription.expense {
                            removalAmount = subscription.amount * Double(distance.month!)
                        } else {
                            addititonAmount = subscription.amount * Double(distance.month!)
                        }
                    case "Annual":
                        if distance.year! != 0 {
                            latest.year! += distance.year!
                        }
                        if subscription.expense {
                            removalAmount = subscription.amount * Double(distance.year!)
                        } else {
                            addititonAmount = subscription.amount * Double(distance.year!)
                        }
                    default:
                        if distance.day! != 0 {
                            latest.day! += distance.day!
                        }
                        if subscription.expense {
                            removalAmount = subscription.amount * Double(distance.day! % (Int(subscription.frequency) ?? 1))
                        } else {
                            addititonAmount = subscription.amount * Double(distance.day! % (Int(subscription.frequency) ?? 1))
                        }
                    }
                    let date = Calendar.current.date(from: latest)
                    latestChargeArray.append(date!)
                    switch subscription.wallet {
                    case 1:
                        wallet1[subscription.indexNum].amount -= removalAmount
                        wallet1[subscription.indexNum].amount += addititonAmount
                        Wallet.saveToFile(wallet1)
                    case 2:
                        wallet2[subscription.indexNum].amount -= removalAmount
                        wallet2[subscription.indexNum].amount += addititonAmount
                        Wallet2.saveToFile(wallet2)
                    case 3:
                        wallet3[subscription.indexNum].amount -= removalAmount
                        wallet3[subscription.indexNum].amount += addititonAmount
                        Wallet3.saveToFile(wallet3)
                    default:
                        print("error, wallet not found")
                    }
                }
                for i in subscriptions.indices {
                    subscriptions[i].updated = Date()
                    subscriptions[i].latestCharge = latestChargeArray[i]
                    print(subscriptions[i])
                }
                UserSubscriptions.saveToFile(subscriptions)
            })
            .toolbar(content: {
                ToolbarItem(placement: .keyboard, content: {
                    HStack() {
                        Button {
                            amountString = "\(amountString)+"
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(toolbarColor)
                        }
                        Button {
                            amountString = "\(amountString)-"
                        } label: {
                            Image(systemName: "minus")
                                .foregroundColor(toolbarColor)
                        }
                        Spacer()
                        Button {
                            showKeyboard = false
                        } label: {
                            Text("Done")
                                .multilineTextAlignment(.trailing)
                                .foregroundColor(toolbarColor)
                        }
                    }
                })
            })
        
    }
}

struct ContentViewV2_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewV2()
    }
}
