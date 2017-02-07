//
//  SelectTemplateController.swift
//  Comics
//
//  Created by Andrey Apet on 15.11.16.
//  Copyright © 2016 Andrey Apet. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class SelectTemplateController: UICollectionViewController {
    
    var indexTemplate: Int?
    
    let images = [#imageLiteral(resourceName: "comics1"), #imageLiteral(resourceName: "comics2"), #imageLiteral(resourceName: "comics3"), #imageLiteral(resourceName: "comics4"), #imageLiteral(resourceName: "comics5"), #imageLiteral(resourceName: "comics6"), #imageLiteral(resourceName: "comics7"), #imageLiteral(resourceName: "comics8"), #imageLiteral(resourceName: "comics9"), #imageLiteral(resourceName: "comics10"),#imageLiteral(resourceName: "comics11"), #imageLiteral(resourceName: "comics12"), #imageLiteral(resourceName: "comics14"), #imageLiteral(resourceName: "comics15"), #imageLiteral(resourceName: "comics16"), #imageLiteral(resourceName: "comics17"), #imageLiteral(resourceName: "comics18"), #imageLiteral(resourceName: "Untitled-1")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let image = #imageLiteral(resourceName: "marvel")
//        let imageView = UIImageView (image: image)
//        collectionView!.backgroundView = imageView
//        imageView.alpha = 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! Templates
        cell.button.setBackgroundImage(images[indexPath.row], for: .normal)
        cell.button.tag = indexPath.row
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    @IBAction func switchTemplate(_ sender: UIButton) {
        indexTemplate = sender.tag
        performSegue(withIdentifier: "UnwindSegue", sender: sender)
    }
    
    
}
