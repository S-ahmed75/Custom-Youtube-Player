//
//  videoPlayerController.swift
//  youTube2
//
//  Created by sunny on 18/10/2018.
//  Copyright © 2018 sunny. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
import AVFoundation
import Foundation
import APESuperHUD
import YouTubePlayer


class videoPlayerController: UIViewController ,YTPlayerViewDelegate{

    @IBOutlet weak var videoPlayer: YTPlayerView!
    
    
    var playSongID = "M7lc1UVf-VE"
    
    let image = UIImage(named: "loading1")!
    let networkErr = UIImage(named: "networkError")!

    let value = UIInterfaceOrientation.landscapeLeft.rawValue
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoPlayer.delegate = self
    
        UIDevice.current.setValue(value, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
        
        APESuperHUD.show(style: .loadingIndicator(type: .standard), title: nil, message: "Loading...")
        ReachabilityManager.shared.startMonitoring()
       

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    
        
        if ReachabilityManager.shared.networkStatus == true {
           
             videoPlayer.load(withVideoId: playSongID)
            
        } else {

             APESuperHUD.show(style: .icon(image: networkErr, duration: 4.0), title: "Network Error", message: "No Netowrk!")
            
   
        }
       
    
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        
            APESuperHUD.dismissAll(animated: true)
      
    }
   
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        switch(state) {
        case YTPlayerState.unstarted:
            print("Unstarted")
            break
        case YTPlayerState.queued:
            print("Ready to play")
            break
        case YTPlayerState.playing:
            print("Video playing")
            break
        case YTPlayerState.paused:
            print("Video paused")
            break
        default:
            break
        }
        
    }
    
    func playerView(_ playerView: YTPlayerView, receivedError error: YTPlayerError) {
        print(error,"pkkk")
    }
    
    
}
