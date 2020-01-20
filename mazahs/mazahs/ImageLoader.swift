//
//  ImageLoader.swift
//  mazahs
//
//  Created by Dave Ho on 1/18/20.
//  Copyright © 2020 Dave Ho. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class ImageLoader:ObservableObject {
    @Published var downloadImage:UIImage?
    
    func fetchImage(url:String) {
        guard let imageUrl = URL(string: url) else {
            fatalError("The url string is invalid")
        }
        
        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            guard let data = data, error == nil else {
                fatalError("error reading the image")
            }
            
            DispatchQueue.main.async {
                self.downloadImage = UIImage(data: data)
            }
        }.resume()
    }
}
