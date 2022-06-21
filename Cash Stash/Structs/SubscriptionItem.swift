//
//  SubscriptionItem.swift
//  Cash Stash
//
//  Created by Luke Drushell on 10/8/21.
//

import SwiftUI

struct SubscriptionItem: View {
    
    @Binding var sub: UserSubscriptions
    
    var body: some View {
        HStack {
            Image(systemName: sub.icon)
                .resizable()
                .foregroundColor(.green)
                .scaledToFill()
                .frame(width: 30, height: 30, alignment: .center)
                .padding(.leading, 5)
            Text(sub.subscriptionName)
                .padding(.leading, 10)
                .foregroundColor(.black)
                .lineLimit(1)
            Spacer()
            Text("$\(sub.amount, specifier: "%.2f")")
                .padding(.trailing)
                .foregroundColor(sub.expense ? .red : .green)
        } .padding(10)
            .background(.white)
            .cornerRadius(10)
            .padding(.horizontal, 15)
    }
}
