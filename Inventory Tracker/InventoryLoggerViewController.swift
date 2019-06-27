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

class InventoryLoggerViewController : UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = [kGTLRAuthScopeSheetsSpreadsheetsReadonly] // ensure signing in allows only for spreadsheet reading
        
        if GIDSignIn.sharedInstance().currentUser == nil { // not signed in
            print("not signed in")
            signInButton.isHidden = false
            signOutButton.isHidden = true
        }
        else {
            signInButton.isHidden = true
            signOutButton.isHidden = false
        }
        // Uncomment the line below to prevent the user from signing in every time they open the app
//        GIDSignIn.sharedInstance().signInSilently()
        
//        outputText.isHidden = true
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("error: \(error.localizedDescription)")
            //            self.service.authorizer = nil
        } else { // sign-in successful
            //            signInButton.isHidden = true
            //            outputText.isHidden = false
            print("it worked \(String(describing: user.profile.name))")
            toggleSignInSignOutVisibility()
        }
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        print("signout pressed")
        GIDSignIn.sharedInstance().signOut()
        toggleSignInSignOutVisibility()
    }
    
    func toggleSignInSignOutVisibility() {
        signInButton.isHidden = !signInButton.isHidden
        signOutButton.isHidden = !signOutButton.isHidden
    }
    
}
