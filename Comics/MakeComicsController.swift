//
//  MakeComicsController.swift
//  Comics
//
//  Created by Andrey Apet on 14.11.16.
//  Copyright © 2016 Andrey Apet. All rights reserved.
//

import Foundation
import UIKit

class MakeComicsController : UIViewController {
    
    @IBOutlet private weak var containerOfElements: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func changeElementContainerHidden(segue: UIStoryboardSegue) {
        
        containerOfElements.isHidden = !containerOfElements.isHidden
        
    }
    
}
