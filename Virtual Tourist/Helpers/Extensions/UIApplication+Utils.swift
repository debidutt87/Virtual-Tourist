//
//  UIApplication+Utils.swift
//  Virtual Tourist
//
//  Created by Debidutt Prasad on 20/11/19.
//  Copyright © 2019 Debidutt Prasad. All rights reserved.
//

import UIKit

extension UIApplication {

    func enableNetworkingActivityIndicator(_ isEnabled: Bool) {
        DispatchQueue.main.async {
            self.isNetworkActivityIndicatorVisible = isEnabled
        }
    }
}
