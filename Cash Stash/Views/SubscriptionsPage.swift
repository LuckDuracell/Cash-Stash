//
//  SubscriptionsPage.swift
//  Cash Stashes
//
//  Created by Luke Drushell on 12/27/21.
//

import SwiftUI

struct SubscriptionsPage: View {
    
    @Binding var toolbarColor: Color
    
    @State var showSheet = false
    @State var isAdding = false
    @State var showTotals = false
    
    @State var isDeleting = false
    
    @FocusState var showKeyboard: Bool
    
    @State var subscriptions: [UserSubscriptions] = UserSubscriptions.loadFromFile()
    
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
                        Text("$\(calcAnnual().0, specifier: "%.2f")")
                            .foregroundColor(.white)
                            .padding(6)
                            .background(.white.opacity(0.3))
                            .cornerRadius(15)
                    }
                }
                .padding()
                ForEach($subscriptions, id: \.self, content: { $sub in
                        Button {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
                                showSheet.toggle()
                            })
                        } label: {
                            SubscriptionItem(sub: $sub)
                                .padding(1)
                        }
                        .sheet(isPresented: $showSheet, onDismiss: {
                            subscriptions = UserSubscriptions.loadFromFile()
                        }, content: {
                            EditSubPage(subscription: $sub, showSheet: $showSheet)
                        })
                })
            }
            .sheet(isPresented: $isAdding, onDismiss: {
                subscriptions = UserSubscriptions.loadFromFile()
            }, content: {
                NewSubPage(showKeyboard: _showKeyboard, showSheet: $isAdding)
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
                Text("Annual Expenses: $\(calcAnnual().0, specifier: "%.2f")")
                    .font(.title.bold())
                    .foregroundColor(.white)
                    .padding(6)
                Text("Annual Income: $\(calcAnnual().1, specifier: "%.2f")")
                    .font(.title.bold())
                    .foregroundColor(.white)
                    .padding(6)
                Text("Annual Net: $\(calcAnnual().1-calcAnnual().0, specifier: "%.2f")")
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
            toolbarColor = .green
        })
    }
    
    func calcAnnual() -> (Double, Double) {
        var annual: Double = 0
        var annualIncome: Double = 0
        if subscriptions != [] {
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
        return (annual, annualIncome)
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
