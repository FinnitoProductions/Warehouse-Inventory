//
//  InventoryLoggerViewController.swift
//  Inventory Tracker
//
//  Created by Finn Frankis on 6/26/19.
//  Copyright © 2019 FinnitoProductions. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn
import GoogleAPIClientForREST

class InventoryLoggerViewController : UIViewController, GIDSignInUIDelegate {
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = [kGTLRAuthScopeSheetsSpreadsheetsReadonly] // ensure signing in allows only for spreadsheet reading
        GIDSignIn.sharedInstance().signInSilently()
        
//        outputText.isHidden = true
    }
    
    
    
}
