//
//  Lyrics.swift
//  mazahs
//
//  Created by Dave Ho on 1/18/20.
//  Copyright © 2020 Dave Ho. All rights reserved.
//

import SwiftUI

struct Lyrics: View {
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                
                Text("LYRICS")
                    .font(Font.system(size: 30))
                    .fontWeight(.bold)
                    .padding(.all)
                    .foregroundColor(.white)
                    .border(/*@START_MENU_TOKEN@*/Color.white/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/3/*@END_MENU_TOKEN@*/)
            }
        }
    }
}

struct Lyrics_Previews: PreviewProvider {
    static var previews: some View {
        Lyrics()
    }
}
