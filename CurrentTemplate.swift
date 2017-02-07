//
//  CurrentTemplate.swift
//  Comics
//
//  Created by Andrey Apet on 15.11.16.
//  Copyright © 2016 Andrey Apet. All rights reserved.
//

import UIKit
import AVKit

class CurrentTemplate: NSObject {
    
    var imageViewArr = [UIImageView]()
    var scrollViewArr = [UIScrollView]()
    var filtersOfImage = [Int:Array<UIImage?>]()
    var originalImageInImageView = [Int:UIImage]()
    var CurrentFilterForImageArr = [Int:Int]()
    var videoViewArr = [AVPlayerViewController]()
    var urlOfVideo = [Int: Any]()
    var imageViewOfElementsArr = [UIImageView]()
    var numberOfElements: Int?
    var indexOfTemplate: Int?
    var numberAreasInTemplate: Int?
}
