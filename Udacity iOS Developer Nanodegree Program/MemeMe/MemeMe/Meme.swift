//
//  Meme.swift
//  MemeMe
//
//  Created by Tongyu on 8/16/16.
//  Copyright © 2016 Tongyu Yang. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    
    var topTextField : String?
    var bottomTextField : String?
    var image : UIImage?
    var memeImage : UIImage?
    
    init(topText : String?, bottomText : String?, image : UIImage?, memeImage : UIImage?){
        self.topTextField = topText
        self.bottomTextField = bottomText
        self.image = image
        self.memeImage = memeImage
    }
    
}