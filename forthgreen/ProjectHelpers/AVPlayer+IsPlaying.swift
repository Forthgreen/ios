//
//  AVPlayer+IsPlaying.swift
//  forthgreen
//
//  Created by Keyur on 05/04/22.
//  Copyright © 2022 SukhmaniKaur. All rights reserved.
//

import Foundation
import AVFoundation

extension AVPlayer {
    
    var isPlaying: Bool {
        if (self.rate != 0 && self.error == nil) {
            return true
        } else {
            return false
        }
    }
    
}
