//
//  EditingComicsController.swift
//  Comics
//
//  Created by Andrey Apet on 23.11.16.
//  Copyright © 2016 Andrey Apet. All rights reserved.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "Cell"

class EditingComicsController: UICollectionViewController {
    
    var comics = [ComicsDB]()
    var images = [UIImage]()
    var pageArr = List<PageDb>()
    var currentComicsIndex: Int?
    var currentDragAndDropIndexPath: NSIndexPath?
    var currentDragAndDropSnapShot: UIView?
    var longpress: UILongPressGestureRecognizer?
    var doubleTap: UITapGestureRecognizer?
    let realm = try! Realm()
    
    @IBOutlet private var textFieldName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = #imageLiteral(resourceName: "dTjnnHe-1")
        let imageView = UIImageView(image: image)
        collectionView!.backgroundColor = UIColor.white //imageView
        imageView.alpha = 0.8
        textFieldName.text = comics[currentComicsIndex!]["nameComics"] as? String
        doubleTap = UITapGestureRecognizer(target: self, action: #selector(EditingComicsController.deletePage(sender:)))
        doubleTap!.numberOfTapsRequired = 2

        longpress = UILongPressGestureRecognizer(target: self, action: #selector(EditingComicsController.longPressGestureRecognizer(sender:)))
        self.collectionView?.addGestureRecognizer(doubleTap!)
        self.collectionView?.addGestureRecognizer(longpress!)
    }
    
    func longPressGestureRecognizer(sender: UIGestureRecognizer) {
        let currentLocation = sender.location(in: self.collectionView)
        let indexPathForLocation: NSIndexPath? = self.collectionView!.indexPathForItem(at: currentLocation) as NSIndexPath?
        switch sender.state {
        case .began:
            if indexPathForLocation != nil {
                self.currentDragAndDropIndexPath = indexPathForLocation
                let cell: EditingComics? = self.collectionView!.cellForItem(at: indexPathForLocation! as IndexPath) as? EditingComics
                self.currentDragAndDropSnapShot = cell!.snapshot
                self.updateDragAndDropSnapShotView(alpha: 0.0, center: cell!.center, transform: CGAffineTransform.identity)
                self.collectionView!.addSubview(self.currentDragAndDropSnapShot!)
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.updateDragAndDropSnapShotView(alpha: 0.95, center: cell!.center, transform: __CGAffineTransformMake(1.05, 1.05, 0, 0, 0, 0))
                    cell?.isMoving = true
            })
        }
        case .changed:
            self.currentDragAndDropSnapShot!.center = currentLocation
            if indexPathForLocation != nil {
                let comic = self.comics[currentComicsIndex!]
                let currentComics = comic.pages[self.currentDragAndDropIndexPath!.row]
                try! realm.write {
                    comics[self.currentComicsIndex!].pages.remove(at: currentDragAndDropIndexPath!.row)
                    comics[self.currentComicsIndex!].pages.insert(currentComics, at: indexPathForLocation!.row)
                }
                self.collectionView!.moveItem(at: self.currentDragAndDropIndexPath! as IndexPath, to: indexPathForLocation as! IndexPath)
                self.currentDragAndDropIndexPath = indexPathForLocation
            }
        default:
            if indexPathForLocation != nil {
                let cell: EditingComics? = self.collectionView!.cellForItem(at: indexPathForLocation! as IndexPath) as? EditingComics
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.updateDragAndDropSnapShotView(alpha: 0.0, center: cell!.center, transform: CGAffineTransform.identity)
                    cell?.isMoving = false
                }, completion: { (finished: Bool) -> Void in
                    self.currentDragAndDropSnapShot?.removeFromSuperview()
                    self.currentDragAndDropSnapShot = nil
                })
            }
            else {
                let cell: EditingComics? = self.collectionView!.cellForItem(at: currentDragAndDropIndexPath! as IndexPath) as? EditingComics
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.updateDragAndDropSnapShotView(alpha: 0.0, center: cell!.center, transform: CGAffineTransform.identity)
                    cell?.isMoving = false
                }, completion: { (finished: Bool) -> Void in
                    self.currentDragAndDropSnapShot?.removeFromSuperview()
                    self.currentDragAndDropSnapShot = nil
                })
                
            }
            
            
            
//            if indexPathForLocation != nil {
//                let cell: EditingComics? = self.collectionView!.cellForItem(at: (currentDragAndDropIndexPath as! IndexPath)) as?  EditingComics
//                UIView.animate(withDuration: 0.25, animations: { () -> Void in
//                self.updateDragAndDropSnapShotView(alpha: 0.0, center: cell!.center, transform: CGAffineTransform.identity)
//                    cell?.isMoving = false
//                })
//                self.currentDragAndDropSnapShot = nil
//            }
        }
    }
    
    func updateDragAndDropSnapShotView(alpha: CGFloat, center: CGPoint, transform:CGAffineTransform) {
        if self.currentDragAndDropSnapShot != nil {
            self.currentDragAndDropSnapShot?.alpha = alpha
            self.currentDragAndDropSnapShot?.center = center
            self.currentDragAndDropSnapShot?.transform = transform
        }
    }
    
    func deletePage(sender: UITapGestureRecognizer) {
        let currentLocation =  sender.location(in: self.collectionView)
        let indexPathForLocation: NSIndexPath? = self.collectionView!.indexPathForItem(at: currentLocation) as NSIndexPath?
        print(indexPathForLocation!)
        if indexPathForLocation != nil {
            try! realm.write {
                comics[self.currentComicsIndex!].pages.remove(at: indexPathForLocation!.row)
                images.remove(at: indexPathForLocation!.row)
                self.collectionView!.deleteItems(at: [indexPathForLocation! as IndexPath])
            }
        }
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! EditingComics
        cell.imageEditing?.image = images[indexPath.row]
        return cell
    }
    
    @IBAction func cancelEditingComics(sender: Any) {
        self.images = []
        try! realm.write {
            comics[currentComicsIndex!]["nameComics"] = textFieldName.text
            if comics[self.currentComicsIndex!].pages.count == 0 {
                realm.delete(comics[currentComicsIndex!])
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
}
