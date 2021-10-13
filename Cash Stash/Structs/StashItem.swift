//
//  StashItem.swift
//  Cash Stash
//
//  Created by Luke Drushell on 10/8/21.
//

import SwiftUI

struct StashItem: View {
    
    @Binding var icon: String
    @Binding var name: String
    @Binding var amount: Double
    @Binding var stashType: Int
    
    @State var highlightColor: Color = .blue
    
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
            Spacer()
            Text("$\(amount, specifier: "%.2f")")
                .padding(.trailing)
                .foregroundColor(.black)
        } .padding(10)
            .background(.white)
            .cornerRadius(10)
            .padding(.horizontal, 15)
            .onAppear(perform: {
                if stashType == 1 {
                    highlightColor = Color.blue
                } else if stashType == 2 {
                    highlightColor = Color.purple
                } else {
                    highlightColor = Color.yellow
                }
            })
    }
}
