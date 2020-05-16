//
//  OutputView.swift
//  navigator
//
//  Created by Emmanuel  Ogbewe on 5/16/20.
//  Copyright © 2020 Emmanuel  Ogbewe. All rights reserved.
//

import SwiftUI

struct OutputView : View {
    @EnvironmentObject var localizer : Localizer
    
    init () {
        UITableView.appearance().separatorStyle = .none
        UITableViewCell.appearance().backgroundColor = .clear
        UITableView.appearance().backgroundColor = .clear
    }
    var body : some View {
        VStack(alignment: .leading) {
            List(localizer.liveOutput) { item in
                Text("Item \(item.itemName) , Time logged: \(self.localizer.formatTime(date: item.location.location.timestamp))")
                    .font(.custom("Profontwindows", size: 15))
                    .foregroundColor(Color.white)
                    .padding([.leading], 7.0)
                    .listRowBackground(Color.red)
            }
        }
    }
}

