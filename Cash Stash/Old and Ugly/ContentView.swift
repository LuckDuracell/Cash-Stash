//
//  ContentView.swift
//  Cash Stash
//
//  Created by Luke Drushell on 7/25/21.
//

import SwiftUI
import CoreData




struct ContentView: View {

    @State var showWelcome = false
    @Environment(\.presentationMode) var presentationMode
    @State var pageView = 1
    
    @State var typePages = false
    
    init() {
        let tabAppearance = UITabBar.appearance()
        tabAppearance.backgroundImage = UIImage(named: "backgroundTab")
    }
    
    var body: some View {
        ZStack {
            TabView {
                HomePage()
                    .environment(\.tintColor, Color.blue)
                    .tabItem {
                        Label("Cash", systemImage: "dollarsign.circle.fill")
                    }
                GiftcardsPage()
                    .environment(\.tintColor, Color.purple)
                    .tabItem {
                        Label("Giftcards", systemImage: "giftcard.fill")
                    }
                SavingsPage()
                    .environment(\.tintColor, Color.orange)
                    .tabItem {
                        Label("Savings", systemImage: "building.columns.fill")
                    }
            }
            .onAppear(perform: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                    typePages = true
                })
            })
        }
            //.tabViewStyle(.page)
            .onAppear(perform: {
                if isFirstTimeOpening() {
                    showWelcome = true
                }
            })
            .sheet(isPresented: $showWelcome, onDismiss: {
            }, content: {
                VStack {
                    VStack {
                        Image(systemName: "dollarsign.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 105, height: 105, alignment: .center)
                            .foregroundColor(.teal)
                        Text("Welcome to Cash Stash")
                            .foregroundColor(.teal)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                    }
                    HStack {
                        //Icon
                        Image(systemName: "archivebox.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 35, height: 35, alignment: .center)
                            .foregroundColor(.teal)
                        VStack {
                            HStack {
                                Text("Organize")
                                    .foregroundColor(.primary)
                                    .font(.system(size: 14, weight: .medium, design: .default))
                                    .multilineTextAlignment(.leading)
                                Spacer()
                            }
                            Text("Keep track of your finances in a simple app by grouping your cash in Stashes such as a Wallet Stash, a Debit Card Stash, Stocks Stash, and more!")
                                .foregroundColor(.gray)
                                .font(.system(size: 12, weight: .medium, design: .default))
                                .multilineTextAlignment(.leading)
                        }
                        .padding(.leading, 10)
                    } .padding(20)
                    HStack {
                        //Icon
                        Image(systemName: "bolt.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 35, height: 35, alignment: .center)
                            .foregroundColor(.teal)
                        VStack {
                            HStack {
                                Text("Simple")
                                    .foregroundColor(.primary)
                                    .font(.system(size: 14, weight: .medium, design: .default))
                                    .multilineTextAlignment(.leading)
                                Spacer()
                            }
                            Text("The intuitive UI creates a lightning fast experience that anyone can use with ease. Despite being filled with tons of features, such as math operators, it still maintains a beautifully simple design!")
                                .foregroundColor(.gray)
                                .font(.system(size: 12, weight: .medium, design: .default))
                                .multilineTextAlignment(.leading)
                        }
                        .padding(.leading, 10)
                    } .padding(20)
                    HStack {
                        //Icon
                        Image(systemName: "rectangle.split.3x1.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 35, height: 35, alignment: .center)
                            .foregroundColor(.teal)
                        VStack {
                            HStack {
                                Text("Pages")
                                    .foregroundColor(.primary)
                                    .font(.system(size: 14, weight: .medium, design: .default))
                                    .multilineTextAlignment(.leading)
                                Spacer()
                            }
                            Text("Keep track of your various stashes through the seperate pages: Cash, Giftcards, and Savings. Now with unique icons for each page!")
                                .foregroundColor(.gray)
                                .font(.system(size: 12, weight: .medium, design: .default))
                                .multilineTextAlignment(.leading)
                        }
                        .padding(.leading, 10)
                    } .padding(20)
                    
                    Spacer()
                    
                    Button {
                        showWelcome = false
                    } label: {
                        Text("Get Started")
                            .foregroundColor(.teal)
                            .frame(width: 250, height: 50, alignment: .center)
                            .background(.gray.opacity(0.2))
                            .cornerRadius(25)
                            .padding()
                    }
                }
                    .padding(.horizontal, 10)
                .interactiveDismissDisabled(true)
            })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func isFirstTimeOpening() -> Bool {
  let defaults = UserDefaults.standard

  if(defaults.integer(forKey: "hasRun") == 0) {
      defaults.set(1, forKey: "hasRun")
      return true
  }
  return false

}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}


private struct TintKey: EnvironmentKey {
    static let defaultValue: Color = Color.blue
}

extension EnvironmentValues {
    var tintColor: Color {
        get { self[TintKey.self] }
        set { self[TintKey.self] = newValue }
    }
}
