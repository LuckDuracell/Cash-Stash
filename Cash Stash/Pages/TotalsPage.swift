//
//  TotalsPage.swift
//  TotalsPage
//
//  Created by Luke Drushell on 7/26/21.
//

import SwiftUI

struct TotalsPage: View {
    
    @State var wallet = Wallet.loadFromFile()
    @State var wallet2 = Wallet2.loadFromFile()
    @State var wallet3 = Wallet3.loadFromFile()
    
    
    init() {
        //Make "Cash Stash title into white text"
        let whiteNavColor = UINavigationBarAppearance()
        whiteNavColor.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = whiteNavColor
        
        //Clear List Background
        UITableView.appearance().backgroundColor = .clear
    }
    
    @State var total: Double = 0
    
    @State var total1: Double = 0
    @State var total2: Double = 0
    @State var total3: Double = 0
    
    var body: some View {
        ZStack {
            GradientBackground(color1: .cyan, color2: .green)
            NavigationView {
                ZStack {
                    GradientBackground(color1: .cyan, color2: .green)
                    ScrollView {
                        Text("$\(total, specifier: "%.2f")")
                            .font(.system(size: 40, weight: .bold, design: .default))
                            .padding()
                        
                        Divider()
                            .padding(.leading)
                            .padding(.trailing)
                        
                        Text("Cash: $\(total1, specifier: "%.2f")")
                            .font(.system(size: 20, weight: .medium, design: .default))
                            .padding(7)
                        
                        Text("Giftcards: $\(total2, specifier: "%.2f")")
                            .font(.system(size: 20, weight: .medium, design: .default))
                            .padding(7)
                        
                        Text("Savings: $\(total3, specifier: "%.2f")")
                            .font(.system(size: 20, weight: .medium, design: .default))
                            .padding(7)
                        
                        Spacer()
                    }
                } .navigationTitle("Total Stash")
                    .onAppear {
                        total = 0
                        for i in wallet.indices {
                            total += wallet[i].amount
                        }
                        for i in wallet2.indices {
                            total += wallet2[i].amount
                        }
                        for i in wallet3.indices {
                            total += wallet3[i].amount
                        }
                        
                        total1 = 0
                        total2 = 0
                        total3 = 0
                        for i in wallet.indices {
                            total1 += wallet[i].amount
                        }
                        for i in wallet2.indices {
                            total2 += wallet2[i].amount
                        }
                        for i in wallet3.indices {
                            total3 += wallet3[i].amount
                        }
                        
                        
                    }
            }
        }
    }
}

struct TotalsPage_Previews: PreviewProvider {
    static var previews: some View {
        TotalsPage()
    }
}
