//
//  SubscriptionItem.swift
//  Cash Stash
//
//  Created by Luke Drushell on 10/8/21.
//

import SwiftUI

struct SubscriptionItem: View {
    
    var icon: String
    @Binding var name: String
    @Binding var amount: Double
    @Binding var expense: Bool
    
    @State var highlightColor: Color = .green
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .resizable()
                .foregroundColor(highlightColor)
                .scaledToFill()
                .frame(width: 30, height: 30, alignment: .center)
                .padding(.leading, 5)
            Text(name)
                .padding(.leading, 10)
                .foregroundColor(.black)
                .lineLimit(1)
            Spacer()
            Text("$\(amount, specifier: "%.2f")")
                .padding(.trailing)
                .foregroundColor(.black)
        } .padding(10)
            .background(.white)
            .cornerRadius(10)
            .padding(.horizontal, 15)
    }
}
