//
//  Listen.swift
//  mazahs
//
//  Created by Dave Ho on 1/18/20.
//  Copyright © 2020 Dave Ho. All rights reserved.
//

import SwiftUI
import AVFoundation
import Alamofire

struct LyricView: View {
    //var lyrics: String
    var lyrics: String
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            ScrollView(showsIndicators: false){
                Text(lyrics)
                    .frame(width: 300)
                    .lineLimit(nil)
                    .font(Font.system(size: 12))
                    .foregroundColor(.white)
                    .padding(.all)
            }
        }
    }
}

struct Listen: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var recordingSession:AVAudioSession!
    @State var audioRecorder: AVAudioRecorder!
    @State var audioPlayer: AVAudioPlayer!
    @State var recording = false
    @State var imageUrl = "https://pbs.twimg.com/profile_images/792021404061278208/jXjoU4tA_400x400.jpg"
    @State var titleText = "~ . ~"
    @State var albumText = "~ . ~"
    @State var artistText = "~ . ~"
    @State var spotifyLink = ""
    @State var lyrics = ""
    
    @State private var isShowingDetails = false
    @State private var showingLyrics = false
    
    //@State private var isSpotifyAvailable = false
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                Button(action: {
                    withAnimation {
                        self.isShowingDetails = false
                    }
                    if self.audioRecorder == nil{
                        let filename = self.getDirectory().appendingPathComponent("recording.m4a")
                        print(filename)
                        let settings = [
                            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                            AVSampleRateKey: 12000,
                            AVNumberOfChannelsKey: 1,
                            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                        ]
                        do{
                            self.audioRecorder = try AVAudioRecorder(url: filename, settings: settings)
                            self.audioRecorder.record()
                            self.recording = true
                        }catch{
                            print("recording failed")
                        }
                    }else{
                        self.audioRecorder.stop()
                        self.audioRecorder = nil
                        self.recording = false
                        
                        do{
                            let path = self.getDirectory().appendingPathComponent("recording.m4a")
                            print(valueForAPIKey(named: "API_CLIENT_ID"))
                            AF.upload(multipartFormData: { multipartFormData in
                                multipartFormData.append(path, withName: "file", fileName: "recording.m4a", mimeType: "audio/m4a")
                                multipartFormData.append(Data("timecode,lyrics,spotify".utf8), withName: "return")
                                multipartFormData.append(Data(valueForAPIKey(named: "API_CLIENT_ID").utf8), withName: "api_token")
                            }, to: "https://api.audd.io/")
                                .responseJSON { response in
                                    switch response.result {
                                    case .success(let value):
                                        do{
                                            print(value as! NSDictionary)
                                            let dic = value as! NSDictionary
                                            let status = dic["status"] as! String
                                            if(status != "error"){
                                                let result = dic["result"] as! NSDictionary
                                                let album = result["album"] as! String
                                                let title = result["title"] as! String
                                                let artist = result["artist"] as! String
                                                var lyrics = "LYRICS NOT AVAILABLE :("
                                                if result["lyrics"] != nil{
                                                    lyrics = (result["lyrics"] as! NSDictionary)["lyrics"] as! String
                                                }
                                                self.titleText = "~ " + title.uppercased() + " ~"
                                                self.albumText = "~ " + album.uppercased() + " ~"
                                                self.artistText = "~ " + artist.uppercased() + " ~"
                                                self.lyrics = lyrics
                                                // check if spotify exists
                                                if result["spotify"] != nil{
                                                    let spotify = result["spotify"] as! NSDictionary
                                                    let spotify_album = spotify["album"] as! NSDictionary
                                                    let images = spotify_album["images"] as! NSArray
                                                    let image = images[0] as! NSDictionary
                                                    let image_url = image["url"] as! String
                                                    let spotify_external_urls = spotify["external_urls"] as! NSDictionary
                                                    let spotify_url = spotify_external_urls["spotify"] as! String
                                                    self.imageUrl = image_url
                                                    self.spotifyLink = spotify_url
                                                }else{
                                                    self.imageUrl = "https://pbs.twimg.com/profile_images/792021404061278208/jXjoU4tA_400x400.jpg"
                                                    self.spotifyLink = ""
                                                }
                                                withAnimation {
                                                    self.isShowingDetails.toggle()
                                                }
                                            }
                                        }catch{
                                            
                                        }
                                    case .failure(let error):
                                        print("can't detect song")
                                        print(error)
                                        break
                                    }
                                }
                        }catch{
                            //some error
                            print("problem uploading")
                        }
                    }
                }){
                    Text(self.recording ? "STOP" : "LISTEN")
                    .font(Font.system(size: 28))
                    .fontWeight(.bold)
                    .padding(.all)
                    .foregroundColor(.white)
                    .border(/*@START_MENU_TOKEN@*/Color.white/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/3/*@END_MENU_TOKEN@*/)
                }
                if self.isShowingDetails {
                    Button(action: {
                        /*
                        if(self.spotifyLink != ""){
                            if let url = URL(string: self.spotifyLink) {
                                UIApplication.shared.open(url)
                            }
                        }
                        */
                        self.showingLyrics.toggle() 
                    }){
                        RemoteImage(url: self.imageUrl)
                        }.buttonStyle(PlainButtonStyle()).transition(.opacity)
                        .sheet(isPresented: $showingLyrics){LyricView(lyrics: self.lyrics)}
                    Text(self.titleText)
                        .font(Font.system(size: 16))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.top)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .transition(.opacity)
                    Text(self.albumText)
                        .font(Font.system(size: 16))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.top)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .transition(.opacity)
                    Text(self.artistText)
                        .font(Font.system(size: 16))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.top)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .transition(.opacity)
                    Button(action: {
                        if(self.spotifyLink != ""){
                            if let url = URL(string: self.spotifyLink) {
                                UIApplication.shared.open(url)
                            }
                        }
                    }){
                        Image("spotify")
                            .resizable()
                            .aspectRatio(contentMode: ContentMode.fit)
                            .frame(width: 32, height: 32)
                    }.buttonStyle(PlainButtonStyle()).padding(.top).transition(.opacity)
                }
            }
        }.onAppear {
            self.recordingSession = AVAudioSession.sharedInstance()
            do{
                try self.recordingSession.setCategory(.playAndRecord, mode: .default, options: .mixWithOthers)
                try self.recordingSession.setActive(true)
                self.recordingSession.requestRecordPermission { granted in
                    if granted {
                        
                    } else {
                        print("did not grant")
                    }
                }
            }catch{
                print("something wrong has happened")
            }
        }
    }

    /*
    func record_stop(state) {
        
    }
     */
    
    func getDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

struct Listen_Previews: PreviewProvider {
    static var previews: some View {
        Listen()
    }
}
