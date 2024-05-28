//
//  CollectionViewCell.swift
//  youTube2
//
//  Created by sunny on 18/10/2018.
//  Copyright © 2018 sunny. All rights reserved.
//

import UIKit

protocol deleteCollectionDelegate {
    func delete()
    
}

class CollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {
   
    @IBOutlet weak var VideoTitle: UILabel!
    
    @IBOutlet weak var play: UILabel!
    
    var deleteItem: deleteCollectionDelegate?
    
    @IBOutlet weak var backGroundImage: UIImageView!
    @IBOutlet weak var closeButtonView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    
    

}
