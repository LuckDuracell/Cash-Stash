//
//  SubscriptionsPage.swift
//  Cash Stashes
//
//  Created by Luke Drushell on 12/27/21.
//

import SwiftUI

struct SubscriptionsPage: View {
    
    @State var subscriptions = UserSubscriptions.loadFromFile()
    @State var annual: Double = 0
    @State var annualIncome: Double = 0
    
    @State var itemIndex = 0

    @Binding var toolbarColor: Color
    
    @State var selection: UserSubscriptions = UserSubscriptions(subscriptionName: "", amount: 0, wallet: 0, indexNum: 0, frequency: "10000", updated: Date(), latestCharge: Date(), timesCharged: 0, expense: true)
    
    @State var showSheet = false
    @State var isAdding = false
    @State var showTotals = false
    
    @State var isDeleting = false
    
    @FocusState var showKeyboard: Bool
    
    @State var icons: [String] = randomIcon(count: UserSubscriptions.loadFromFile().count)
    
    var body: some View {
        ZStack {
            GradientBackground(color1: .mint, color2: .green)
                .edgesIgnoringSafeArea(.all)
            ScrollView {
                HStack() {
                   Text("Reoccuring")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    Spacer()
                    Button {
                        withAnimation {
                            showTotals.toggle()
                        }
                    } label: {
                        Text("$\(annual, specifier: "%.2f")")
                            .foregroundColor(.white)
                            .padding(6)
                            .background(.white.opacity(0.3))
                            .cornerRadius(15)
                    }
                }
                .padding()
                ForEach(subscriptions.indices, id: \.self, content: { index in
                    Button {
                        itemIndex = index
                        selection = subscriptions[index]
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
                            showSheet.toggle()
                        })
                    } label: {
                        SubscriptionItem(icon: icons[index], name: $subscriptions[index].subscriptionName, amount: $subscriptions[index].amount, expense: $subscriptions[index].expense)
                            .padding(1)
                    }
                })
            }
            .sheet(isPresented: $isAdding, onDismiss: {
                subscriptions = UserSubscriptions.loadFromFile()
                icons = randomIcon(count: UserSubscriptions.loadFromFile().count)
                calcAnnual()
            }, content: {
                NewSubPage(showKeyboard: _showKeyboard, showSheet: $isAdding)
            })
            .sheet(isPresented: $showSheet, onDismiss: {
                subscriptions[itemIndex] = selection
                //this solution is so bad that if ever written on a team then they'd issue a company wide apology
                if isDeleting == false {
                    UserSubscriptions.saveToFile(subscriptions)
                } else {
                    isDeleting = false
                }
                withAnimation {
                    subscriptions = UserSubscriptions.loadFromFile()
                }
                calcAnnual()
            }, content: {
                EditSubPage(subscriptionIndex: itemIndex, subscription: $selection, walletNum: $selection.wallet, indexNum: $selection.indexNum, name: $selection.subscriptionName, amount: $selection.amount, lastChargerd: $selection.latestCharge, expense: $selection.expense, subscriptions: subscriptions, type: $selection.frequency, showKeyboard: _showKeyboard, showSheet: $showSheet, isDeleting: $isDeleting)
            })
            .overlay(alignment: .bottom, content: {
                Button {
                    isAdding.toggle()
                } label: {
                    Text("Add Stash")
                        .foregroundColor(.green)
                        .padding()
                        .frame(width: 250, height: 50, alignment: .center)
                        .background(.white)
                        .cornerRadius(25)
                        .animation(.linear, value: 1)
                        .padding()
                }
            })
            Rectangle()
                .ignoresSafeArea(.all)
                .background(.thinMaterial)
                .opacity(showTotals ? 1 : 0)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture(perform: {
                    withAnimation{
                        showTotals = false
                    }
                })
            VStack(alignment: .leading) {
                Text("Annual Expenses: $\(annual, specifier: "%.2f")")
                    .font(.title.bold())
                    .foregroundColor(.white)
                    .padding(6)
                Text("Annual Income: $\(annualIncome, specifier: "%.2f")")
                    .font(.title.bold())
                    .foregroundColor(.white)
                    .padding(6)
                Text("Annual Net: $\(annualIncome-annual, specifier: "%.2f")")
                    .font(.title.bold())
                    .foregroundColor(.white)
                    .padding(6)
            }
            .padding()
            .background(.thinMaterial)
            .cornerRadius(15)
            .onTapGesture {
                withAnimation {
                    showTotals = false
                }
            }
            .opacity(showTotals ? 1 : 0)
            .padding(.horizontal, 40)
        }
        .onAppear(perform: {
            calcAnnual()
            toolbarColor = .green
        })
    }
    
    func calcAnnual() {
        annual = 0
        annualIncome = 0
        for subscription in subscriptions {
            if subscription.expense {
                switch subscription.frequency {
                case "Weekly":
                    annual += subscription.amount * 52
                case "Monthly":
                    annual += subscription.amount * 12
                case "Annual":
                    annual += subscription.amount
                default:
                    annual += subscription.amount * (365 / (Double(subscription.frequency) ?? 1).rounded(.down))
                }
            } else {
                switch subscription.frequency {
                case "Weekly":
                    annualIncome += subscription.amount * 52
                case "Monthly":
                    annualIncome += subscription.amount * 12
                case "Annual":
                    annualIncome += subscription.amount
                default:
                    annualIncome += subscription.amount * (365 / Double(subscription.frequency)!.rounded(.down))
                }
            }
        }
    }
    
}

func randomIcon(count: Int) -> [String] {
    var output: [String] = []
    for _ in 0...count {
        let num = Int.random(in: 0...3)
        switch num {
        case 0:
            output.append("hourglass.circle.fill")
        case 1:
            output.append("cart.circle.fill")
        case 2:
            output.append("creditcard.circle.fill")
        default:
            output.append("bag.circle.fill")
        }
    }
    return output
}
