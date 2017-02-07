//
//  ControllerGalery.swift
//  Comics
//
//  Created by Andrey Apet on 19.11.16.
//  Copyright © 2016 Andrey Apet. All rights reserved.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "Cell"

class ControllerGalery: UICollectionViewController {
    
    var pageViewController: UIPageViewController!
    @IBOutlet weak var collections: UICollectionView!
    
    var comics = [ComicsDB]()
    let comicsDbHelper = ComicsDBHelper()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = #imageLiteral(resourceName: "main")
        let imageView = UIImageView(image: image)
        collectionView!.backgroundView = imageView
        imageView.alpha = 1
        comics = comicsDbHelper.getComics()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        comics = comicsDbHelper.getComics()
        self.collectionView!.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comics.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Galery
        cell.imageTemplate?.image = #imageLiteral(resourceName: "CoverForComics")
        print(comics[indexPath.row]["nameComics"]!)
        cell.nameComics?.text = comics[indexPath.row]["nameComics"] as? String
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showImage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImage" {
            let indexPaths = self.collectionView!.indexPathsForSelectedItems
            let indexPath = (indexPaths?[0])! as NSIndexPath
            let vs = segue.destination as! Imagesize
            
            print(comics[indexPath.row].pages)
            vs.pagesComics = self.comics[indexPath.row].pages
            vs.width = CGFloat(self.comics[indexPath.row]["width"] as! Float)
            vs.height = CGFloat(self.comics[indexPath.row]["height"] as! Float)
            vs.comics = self.comics
            vs.currentComicsIndex = indexPath.row
        }
    }
    
    @IBAction func refreshControllerGalery(segue:UIStoryboard) {
        self.collectionView?.reloadData()
    }
}
