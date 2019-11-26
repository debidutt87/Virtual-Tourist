//
//  PhotoCollectionViewCell.swift
//  Virtual Tourist
//
//  Created by Debidutt Prasad on 24/11/19.
//  Copyright © 2019 Debidutt Prasad. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var photoImageView: UIImageView!

    @IBOutlet weak var photoLoadingActivityIndicator: UIActivityIndicatorView!

    override func prepareForReuse() {
        super.prepareForReuse()
        photoLoadingActivityIndicator.stopAnimating()
        photoImageView.image = nil
    }
}
