//
//  TerminalView.swift
//  navigator
//
//  Created by Emmanuel  Ogbewe on 5/16/20.
//  Copyright © 2020 Emmanuel  Ogbewe. All rights reserved.
//

import SwiftUI

struct TerminalView : View {
    @EnvironmentObject var localizer : Localizer
    var parentViewHeight : CGFloat
    
    var body : some View {
        VStack(alignment: .leading) {
            Text("Live Data: ")
                .font(.custom("Profontwindows", size: 15))
                .foregroundColor(Color.white)
                .padding([.leading], 20.0)
            List(localizer.terminalData) { loc in
                Text("Long \(loc.location.coordinate.longitude) , Lat: \(loc.location.coordinate.latitude), Speed: \(loc.location.speed), time: \(self.localizer.formatTime(date: loc.location.timestamp))")
                    .font(.custom("Profontwindows", size: 15))
                    .foregroundColor(Color.white)
                    .padding([.leading], 7.0)
            }
    
        }
        .padding([.top], parentViewHeight / 12)
    }
}
