//
//  LoadingGif.swift
//  Inquire
//
//  Created by Henry Liu on 8/16/20.
//  Copyright © 2020 Henry Liu. All rights reserved.
//

import UIKit

class LoadingGif: UIViewController {

    @IBOutlet weak var loadingGif: UIImageView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadingGif.loadGif(name: "loadingGif")
    }
    
    

    
}
