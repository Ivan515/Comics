//
//  JSONHelper.swift
//  Comics
//
//  Created by Andrey Apet on 16.11.16.
//  Copyright © 2016 Andrey Apet. All rights reserved.
//

import UIKit
import SwiftyJSON
import Foundation

class JSONHelper: NSObject {
    
    func GetJsonFromFile(filename:String) ->JSON {
        let file = Bundle.main.path(forResource: filename, ofType: "json")
        let data = NSData(contentsOfFile: file!) as NSData!
        let json = JSON(data: data! as Data, options: JSONSerialization.ReadingOptions.mutableContainers , error: nil)
        
        return json
    }
    
    func getInfoOfTemplateFromJson(indexTemplate: Int) -> [Int:[String:Float]] {
        
        let json = GetJsonFromFile(filename: "TopApps")
        var param = [Int:[String:Float]]()
        let numberOfElements = json["template\(indexTemplate)"].count
        
        for i in 0..<numberOfElements {
            param[i] = ["x":json["template\(indexTemplate)"]["\(i)"]["x"].floatValue]
            param[i]!["y"] = json["template\(indexTemplate)"]["\(i)"]["y"].floatValue
            param[i]!["width"] = json["template\(indexTemplate)"]["\(i)"]["width"].floatValue
            param[i]!["height"] = json["template\(indexTemplate)"]["\(i)"]["height"].floatValue
        }
        return param
    }
}
