//
//  UIViewControllers+Utils.swift
//  Virtual Tourist
//
//  Created by Debidutt Prasad on 20/11/19.
//  Copyright © 2019 Debidutt Prasad. All rights reserved.
//

import UIKit

extension UIViewController {

    func stopObservingNotifications() {
        NotificationCenter.default.removeObserver(self)
    }

    /// Starts observing a specific notification.
    func startObservingNotification(withName name: Notification.Name, usingSelector selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }
}

extension UIViewController {

    func makeErrorAlertController(
        withMessage message: String,
        andDefaultActionHandler action: ((UIAlertAction) -> Void)? = nil
        ) -> UIAlertController {
        return makeErrorAlertController(
            withMessage: message,
            actionTitle: NSLocalizedString("Ok", comment: "The title of the default alert action."),
            andDefaultActionHandler: action
        )
    }
    
    func makeErrorAlertController(
        withMessage message: String,
        actionTitle title: String,
        andDefaultActionHandler action: ((UIAlertAction) -> Void)? = nil
        ) -> UIAlertController {
        let alert = makeAlertController(
            withTitle: NSLocalizedString("Error", comment: "The title of the alert to be displayed."),
            andMessage: message
        )
        alert.addAction(UIAlertAction(
            title: title,
            style: .default,
            handler: action
        ))

        return alert
    }

    func makeAlertController(withTitle title: String, andMessage message: String) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: .alert)
    }
}
