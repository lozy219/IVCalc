//
//  IVPMCollectionViewController
//  IVCalc
//
//  Created by Lei Mingyu on 24/7/16.
//  Copyright © 2016 mingyu. All rights reserved.
//

import UIKit

class IVPMCollectionViewController: UICollectionViewController {
    let reuseIdentifier = "pokemon-cell"
    let imageCache = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.TOTAL_NUMBER_OF_PM
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! IVPMCollectionViewCell
        cell.imageView.image = UIImage(named: "ball")
        let pokemonNumber = indexPath.item + 1
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            if let image = self.imageCache.objectForKey(pokemonNumber) as? UIImage {
                dispatch_async(dispatch_get_main_queue(), {
                    cell.imageView.image = image
                })
            } else if let imageURL = NSURL(string: String(format: "http://www.serebii.net/pokearth/sprites/green/%03d.png", pokemonNumber)) {
                if let data = NSData(contentsOfURL: imageURL) {
                    if let image = UIImage(data: data) {
                        self.imageCache.setObject(image, forKey: pokemonNumber)
                        dispatch_async(dispatch_get_main_queue(), {
                            cell.imageView.image = image
                        })
                    }
                }
            }
        }
        return cell
    }
}

extension IVPMCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let cellWidth = UIScreen.mainScreen().bounds.width / 3.5
        return CGSizeMake(cellWidth, cellWidth)
    }
}