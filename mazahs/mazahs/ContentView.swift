//
//  ContentView.swift
//  mazahs
//
//  Created by Dave Ho on 1/18/20.
//  Copyright © 2020 Dave Ho. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    let buttons = [
        ["LISTEN", "HUM"],
        ["TYPE", "LYRICS"]
    ]
    
    var body: some View {
        NavigationView{
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                VStack {
                    
                    Text("MAZAHS")
                        .font(Font.system(size: 28))
                        .fontWeight(.bold)
                        .padding(.all)
                        .foregroundColor(.white)
                        .border(/*@START_MENU_TOKEN@*/Color.white/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/3/*@END_MENU_TOKEN@*/)
                    
                    HStack {
                        NavigationLink(destination: Listen()){
                            Text("LISTEN")
                            .font(Font.system(size: 16))
                            .fontWeight(.bold)
                            .frame(width:160, height:160)
                            .foregroundColor(.white)
                        }
                        NavigationLink(destination: Hum()){
                            Text("HUM")
                            .font(Font.system(size: 16))
                            .fontWeight(.bold)
                            .frame(width:160, height:160)
                            .foregroundColor(.white)
                        }
                    }
                    HStack {
                        NavigationLink(destination: Type()){
                            Text("TYPE")
                            .font(Font.system(size: 16))
                            .fontWeight(.bold)
                            .frame(width:160, height:160)
                            .foregroundColor(.white)
                        }
                        NavigationLink(destination: Lyrics()){
                            Text("LYRICS")
                            .font(Font.system(size: 16))
                            .fontWeight(.bold)
                            .frame(width:160, height:160)
                            .foregroundColor(.white)
                        }
                    }
                }
            }
        }
        .accentColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
