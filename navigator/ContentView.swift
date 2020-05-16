//
//  ContentView.swift
//  navigator
//
//  Created by Emmanuel  Ogbewe on 4/11/20.
//  Copyright © 2020 Emmanuel  Ogbewe. All rights reserved.
//

import SwiftUI
import UIKit

struct ItemLocatorView : View {
    
    var height : CGFloat
    @EnvironmentObject var localizer : Localizer
    @State var showLog  = false
    @State var itemData : String = ""
    @State var queryName : String = ""
    let generator = UIImpactFeedbackGenerator(style: .medium)
    
    var body : some View {
        VStack(spacing: 20.0) {
            Text("Add Item: ")
                .font(.custom("ProfontWindows", size: 18))
                .multilineTextAlignment(.leading)
                .foregroundColor(Color.white)
                .frame(maxWidth : .infinity, alignment: .leading)
            ZStack(alignment: .leading) {
                if itemData.isEmpty {
                    Text("Dir, item names")
                        .font(.custom("Profontwindows", size: 18))
                        .foregroundColor(.gray).padding([.leading,], 20) }
                HStack {
                    TextField("",text: $itemData)
                        .font(.custom("Profontwindows", size: 18))
                        .frame(height: 55)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding([.leading, .trailing], 20)
                        .background(Color.clear)
                        .cornerRadius(5.0)
                        .font(.body)
                    if !itemData.isEmpty{
                        Button(action : {
                            //log data
                            if !self.itemData.contains(","){
                                self.generator.impactOccurred()
                            } else {
                                //log
                                self.localizer.insertItem(items: self.itemData)
                                self.itemData = ""
                            }
                        }){
                            Text("Log")
                        }
                        .font(.custom("Profontwindows", size: 20))
                        .foregroundColor(self.itemData.contains(",") ? Color.blue : Color.red)
                        .padding([.trailing], 20)
                        
                    }
                }
                .overlay(RoundedRectangle(cornerRadius: 1).stroke(Color.gray))
                
            }
            .padding([.bottom], 20.0)
            Text("Query item: ")
                .font(.custom("ProfontWindows", size: 18))
                .foregroundColor(Color.white)
                .frame(maxWidth : .infinity, alignment: .leading)
            ZStack(alignment: .leading) {
                if queryName.isEmpty {
                    Text("Item name")
                        .font(.custom("Profontwindows", size: 18))
                        .foregroundColor(.gray).padding([.leading,], 20) }
                TextField("",text: $queryName)
                    .font(.custom("Profontwindows", size: 18))
                    .frame(height: 55)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding([.leading, .trailing], 20)
                    .background(Color.clear)
                    .cornerRadius(5.0)
                    .font(.body)
                    .overlay(RoundedRectangle(cornerRadius: 1).stroke(Color.gray))
            }
            .padding([.bottom], 20.0)
            Text("Output:")
                .font(.custom("ProfontWindows", size: 18))
                .foregroundColor(Color.white)
                .frame(maxWidth : .infinity, alignment: .leading)
            OutputView()

        }
        .frame(maxWidth : .infinity, maxHeight: .infinity, alignment: .top)
        .padding([.leading, .trailing], 20.0).padding([.top], height / 8 )
    }
}

struct ContentView: View {
    
    @EnvironmentObject var localizer : Localizer
    @State var showTerminal = false
    
    var body: some View {
        GeometryReader { g  in
            VStack() {
                HStack (alignment: .center) {
                    Text("LOSYNC")
                        .font(.custom("Profontwindows", size: 30))
                        .foregroundColor(Color.white)
                    Spacer()
                    Button ( action : {
                        self.showTerminal.toggle()
                    }) {
                        Text("Terminal")
                            .font(.custom("Profontwindows", size: 20))
                            .foregroundColor(Color.blue)
                    }
                }
                .padding([.trailing,.leading], 20)
                .offset(y: g.size.height / 12)
                Spacer()
                if self.showTerminal {
                    TerminalView(parentViewHeight: g.size.height)
                } else {
                    ItemLocatorView(height : g.size.height)
                }
            }
            .frame(maxWidth : .infinity, maxHeight: .infinity)
            .background(Color.init(red: 16/255, green: 16/255, blue: 16/255)).edgesIgnoringSafeArea(.vertical)
            .onAppear(){
                UITableView.appearance().separatorStyle = .none
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
