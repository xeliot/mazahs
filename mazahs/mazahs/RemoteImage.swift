//
//  RemoteImage.swift
//  mazahs
//
//  Created by Dave Ho on 1/18/20.
//  Copyright © 2020 Dave Ho. All rights reserved.
//

import SwiftUI

struct RemoteImage: View {
    @ObservedObject var imageLoader = ImageLoader()
    
    var placeholder:Image
    
    init(url: String, placeholder:Image = Image("placeholder")) {
        self.placeholder = placeholder
        imageLoader.fetchImage(url: url)
    }
    
    var body: some View {
        if let image = self.imageLoader.downloadImage {
            return Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200.0, height: 200.0)
                .border(/*@START_MENU_TOKEN@*/Color.white/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/3/*@END_MENU_TOKEN@*/)
        }
        return placeholder
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 200.0, height: 200.0)
            .border(Color.white, width: /*@START_MENU_TOKEN@*/3/*@END_MENU_TOKEN@*/)
    }
}

struct RemoteImage_Previews: PreviewProvider {
    static var previews: some View {
        RemoteImage(url: "")
    }
}
