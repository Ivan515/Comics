//
//  ComicsDB.swift
//  Comics
//
//  Created by Andrey Apet on 16.11.16.
//  Copyright © 2016 Andrey Apet. All rights reserved.
//

import UIKit
import RealmSwift

class ComicsDB: Object {
    
    var pages = List<PageDb>()
    var nameComics: String?
    var width: Float = 0.0
    var height: Float = 0.0
}
