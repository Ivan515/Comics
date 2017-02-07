//
//  HandlingController.swift
//  Comics
//
//  Created by Andrey Apet on 17.11.16.
//  Copyright © 2016 Andrey Apet. All rights reserved.
//

import UIKit

class HandlingController: UIViewController {
    
    var showElementsController = false
    var currentPageTemplate = 1
    var maxPagesTemplate = 1
    
    
    @IBOutlet weak var numberPage: UILabel!
    @IBOutlet weak var pageRightOrNewPage: UIButton!
    @IBOutlet weak var pageBack: UIButton!
    @IBOutlet weak var menuElements: UIButton!
    
 
    @IBAction func pageRightOrAddNewPage(_ sender: UIButton) {
        
        if currentPageTemplate > maxPagesTemplate {
            maxPagesTemplate += 1
        }
        currentPageTemplate += 1
        pageBack.isEnabled = true
        if currentPageTemplate >= maxPagesTemplate {
            pageRightOrNewPage.setBackgroundImage(#imageLiteral(resourceName: "newPage"), for: .normal)
        }
        numberPage.text = "\(currentPageTemplate)/\(maxPagesTemplate)"
    }
    
    @IBAction func clearAfterSave(segue: UIStoryboardSegue) {
        currentPageTemplate = 1
        maxPagesTemplate = 1
        pageBack.isEnabled = false
        numberPage.text = "\(currentPageTemplate)/\(maxPagesTemplate)"
    }
    
   
    @IBAction func pageLeft(_ sender: UIButton) {
     
        if currentPageTemplate > maxPagesTemplate {
            maxPagesTemplate += 1
        }
        pageBack.setBackgroundImage(#imageLiteral(resourceName: "backPage"), for: .normal)
        currentPageTemplate -= 1
        if currentPageTemplate == 1 {
            pageBack.isEnabled = false
        }
        pageRightOrNewPage.setBackgroundImage(#imageLiteral(resourceName: "nextPage"), for: .normal)
        pageRightOrNewPage.isEnabled = true
        numberPage.text = "\(currentPageTemplate)/\(maxPagesTemplate)"
    }
    
    @IBAction func saveComics(_ sender: UIButton) {
    }
    
    var enabledElements = true
    @IBAction func changeHiddenElementsGalery(_ sender: UIButton) {
        
        if enabledElements {
            menuElements.setBackgroundImage(#imageLiteral(resourceName: "elementMenu"), for: .normal)
        } else {
            menuElements.setBackgroundImage(#imageLiteral(resourceName: "menu"), for: .normal)
        }
        enabledElements = !enabledElements
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
//        self.view!.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "marvel"))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
