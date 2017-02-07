//
//  PageDB.swift
//  Comics
//
//  Created by Andrey Apet on 16.11.16.
//  Copyright © 2016 Andrey Apet. All rights reserved.
//

import UIKit
import RealmSwift

class PageDb: Object {
    
    var indexOfTemplate: Int = 999
    var areas = List<Area>()
    var elements = List<Elementdb>()
}
