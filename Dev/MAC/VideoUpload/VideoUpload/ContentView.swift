//
//  ContentView.swift
//  VideoUpload
//
//  Created by Tim Abraham on 26.02.20.
//  Copyright © 2020 Tim Abraham. All rights reserved.
//

import SwiftUI
import Alamofire
import CryptoKit
import AVFoundation

struct ContentView: View {
    @State var selectedURL: URL?
    // for prototyping force-unwrap to localhost
    @ObservedObject var networking = Networking(url: URL(string: "http://localhost:3000/")!)
    
    var body: some View {
        VStack {
            
            Spacer()
            
            if selectedURL != nil{
                videoSnapshot(selectedURL: selectedURL!)?.resizable()
                    .scaledToFit()
                    .frame(width: 400,height: 200)
                Button(action: selectFileButton) {
                    Text("Select file")
                }.buttonStyle(LinkButtonStyle())
                Text("Selected: \(selectedURL!.absoluteString)")
            } else {
                Button(action: selectFileButton) {
                    Text("Select file")
                }.buttonStyle(LinkButtonStyle())
                Text("No selection")
            }
            
            HStack{
                Button(action: {
                    if let selectedURL = self.selectedURL {
                        let encryption = Encryption(file: selectedURL)
                        let encryptedData = encryption.encryptFile()
                        let networking = self.networking
                        networking.uploadEncryptedData(encryptedData: encryptedData)
                        networking.sendVideoConfigurationData(key: encryption.key)
                        self.deselectFile()
                    } else {
                        print("Select File!")
                    }
                }) {
                    Text("Upload")
                }.foregroundColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(5)
                
                /// download option which is not covered in the bachelor thesis here
                //            Button(action: {
                //                self.downloadDecryptData()
                //            }) {
                //                Text("Download")
                //            }.foregroundColor(Color.white)
                //            .background(Color.blue)
                //            .cornerRadius(5)
                
                ProgressBar(value: $networking.progressValue).frame(width: 320, height: 20)
                
            }
            
            Spacer()
            
        }.frame(width: 640, height: 480)
    }
    
    func selectFileButton(){
        self.resetProgressBar()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.selectedURL = self.selectFile()
        }
    }
    
    func selectFile() -> URL?{
        let panel = NSOpenPanel()
        var url: URL?
        let result = panel.runModal()
        if result == .OK {
            url = panel.url
        }
        return url
    }
    
    func deselectFile(){
        self.selectedURL = nil
    }
    
    func videoSnapshot(selectedURL: URL) -> Image? {
        let asset = AVURLAsset(url: selectedURL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        
        let timestamp = CMTime(seconds: 1, preferredTimescale: 60)
        
        do {
            let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
            return Image(imageRef, scale: 1, label: Text("test"))
        }
        catch let error as NSError
        {
            print("Image generation failed with error \(error)")
            return nil
        }
    }
    
    func resetProgressBar() {
        networking.progressValue = 0.0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ProgressBar: View {
    @Binding var value: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.3)
                Rectangle().frame(width: min(CGFloat(self.value) * geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .animation(.linear)
            }.cornerRadius(45.0)
        }
    }
}

