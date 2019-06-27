//
//  Util.swift
//  Inventory Tracker
//
//  Created by Finn Frankis on 6/26/19.
//  Copyright © 2019 FinnitoProductions. All rights reserved.
//

import Foundation
import UIKit

class Util {
    static func sendAlert(title : String, message : String, controller: UIViewController) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK",
                                                style: .default,
                                                handler: nil))
        controller.present(alertController, animated: true, completion: nil)
        
    }
}
