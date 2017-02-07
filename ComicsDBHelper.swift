//
//  ComicsDBHelper.swift
//  Comics
//
//  Created by Andrey Apet on 16.11.16.
//  Copyright © 2016 Andrey Apet. All rights reserved.
//

import UIKit
import RealmSwift

class ComicsDBHelper: Object {
    
    func saveComics (comicsDB: ComicsDB) {
        let realm = try! Realm()
        
        try! realm.write {
            print(comicsDB)
            realm.add(comicsDB)
            print ("Data saving...")
        }
    }
    
    func getComics() -> [ComicsDB] {
        let comicsResult = try! Realm().objects(ComicsDB.self)
        print(comicsResult)
        var comics = [ComicsDB]()
        if comicsResult.count>0 {
            for dbComic in comicsResult {
                let comic = dbComic as ComicsDB
                comics.append(comic)
            }
        }
        print(comics)
        return comics
    }
}
