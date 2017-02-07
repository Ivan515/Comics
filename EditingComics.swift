//
//  EditingComics.swift
//  Comics
//
//  Created by Andrey Apet on 19.11.16.
//  Copyright © 2016 Andrey Apet. All rights reserved.
//

import UIKit

class EditingComics: UICollectionViewCell {

    @IBOutlet weak var imageEditing: UIImageView!
    
    var isMoving: Bool = false {
        didSet {
            self.isHidden = isMoving
        }
    }
    
    var snapshot: UIView {
        let snapshot: UIView = self.snapshotView(afterScreenUpdates: true)!
        let layer: CALayer = snapshot.layer
        layer.masksToBounds = false
        layer.shadowRadius = 4.0
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -4.0, height: 0.0)
        
        return snapshot
    }
}
