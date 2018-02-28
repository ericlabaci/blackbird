//
//  PhoneAuthViewController.swift
//  Blackbird
//
//  Created by Eric Labaci on 2/28/18.
//  Copyright © 2018 Blackbird. All rights reserved.
//

import UIKit
import FirebaseAuth

class PhoneAuthViewController: UIViewController {
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.phoneNumberTextField.text = "+55 16 99765-3735"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
    }
    
    
    @IBAction func didTapSendCode(_ sender: Any) {
        if let phoneNumber = self.phoneNumberTextField.text {
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil, completion: { (verificationID, error) in
                if let error = error {
                    let alertController = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                
                let storyboard = UIStoryboard(name: "PhoneAuth", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "code")
                self.navigationController?.pushViewController(vc, animated: true)
            })
        }
    }
}
