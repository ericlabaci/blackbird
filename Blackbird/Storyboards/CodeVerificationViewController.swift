//
//  CodeVerificationViewController.swift
//  Blackbird
//
//  Created by Eric Labaci on 2/28/18.
//  Copyright © 2018 Blackbird. All rights reserved.
//

import UIKit
import FirebaseAuth

class CodeVerificationViewController: UIViewController {
    @IBOutlet weak var codeVerificationTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
    }
    
    @IBAction func didTapVerifyCode(_ sender: Any) {
        guard let verificationCode = self.codeVerificationTextField.text,
            let verificationID = UserDefaults.standard.value(forKey: "authVerificationID") as? String else {
                return
        }
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                let alertController = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            UserDefaults.standard.removeObject(forKey: "authVerificationID")
            NavigationUtils.goToHome()
        }
    }
}
