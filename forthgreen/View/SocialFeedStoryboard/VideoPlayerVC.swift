//
//  VideoPlayerVC.swift
//  forthgreen
//
//  Created by Keyur on 05/04/22.
//  Copyright © 2022 SukhmaniKaur. All rights reserved.
//

import UIKit
import AVKit

class VideoPlayerVC: UIViewController {

    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var closeBtn: UIButton!
    
    var selectedVideo = UploadImageInfo.init()
    
    var moviePlayer = AVPlayer.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        closeBtn.sainiCornerRadius(radius: 16)
        
        moviePlayer = AVPlayer(url: selectedVideo.url!)
        let playerLayer = AVPlayerLayer(player: moviePlayer)
        playerLayer.frame.size.width = SCREEN.WIDTH
        playerLayer.frame.size.height = videoView.bounds.height
        videoView.layer.addSublayer(playerLayer)
        moviePlayer.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if moviePlayer.isPlaying {
            moviePlayer.pause()
        }
    }
    
    //MARK: - Button Click
    @IBAction func clicKToBack(_ sender: UIButton) {
        self.dismiss(animated: true) {
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
