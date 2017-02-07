//
//  ElementsTemplateController.swift
//  Comics
//
//  Created by Andrey Apet on 14.11.16.
//  Copyright © 2016 Andrey Apet. All rights reserved.
//

import Foundation
import UIKit

private let reuseIdentifier = "Cell"

class ElementsTemplateController : UICollectionViewController {
    
    var indexElement :Int?
    
    let imagesElement = [#imageLiteral(resourceName: "444"), #imageLiteral(resourceName: "555"), #imageLiteral(resourceName: "666"), #imageLiteral(resourceName: "333"), #imageLiteral(resourceName: "3"), #imageLiteral(resourceName: "4"), #imageLiteral(resourceName: "5"), #imageLiteral(resourceName: "7"), #imageLiteral(resourceName: "8"), #imageLiteral(resourceName: "111"), #imageLiteral(resourceName: "222"), #imageLiteral(resourceName: "897"), #imageLiteral(resourceName: "bam"), #imageLiteral(resourceName: "batman"), #imageLiteral(resourceName: "crunch"), #imageLiteral(resourceName: "lips"), #imageLiteral(resourceName: "love"), #imageLiteral(resourceName: "mask"), #imageLiteral(resourceName: "mdm"), #imageLiteral(resourceName: "ouch"), #imageLiteral(resourceName: "sls"), #imageLiteral(resourceName: "smail"), #imageLiteral(resourceName: "star")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let image = #imageLiteral(resourceName: "marvel")
//        let imageView = UIImageView(image: image)
//        collectionView!.backgroundView = imageView
//        imageView.alpha = 0.8
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesElement.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! Elements
        cell.Element.setBackgroundImage(imagesElement[indexPath.row], for: .normal)
        cell.Element.tag = indexPath.row
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    @IBAction func switchElement(_ sender: UIButton) {
        indexElement = sender.tag
        performSegue(withIdentifier: "ElementSegue", sender: sender)
    }
    
}
