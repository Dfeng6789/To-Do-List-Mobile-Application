import Foundation
import UIKit
import Firebase

class EditAccountViewController: UIViewController {

    @IBOutlet var passwordField: UITextField!
    @IBOutlet var passwordConfirmField: UITextField!
    @IBOutlet var oldPasswordField: UITextField!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var messageLabel: UILabel!
    var ref: DatabaseReference!
    var user = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        messageLabel.text = ""
        passwordField.text = ""
        passwordConfirmField.text = ""
        oldPasswordField.text = ""
        let imgNumber = Int.random(in: 1..<5)
        if (imgNumber == 1) {
            imgView.image = UIImage(named: "tree")
        } else if (imgNumber == 2) {
            imgView.image = UIImage(named: "tree")
        } else if (imgNumber == 3) {
            imgView.image = UIImage(named: "turtle")
        } else if (imgNumber == 4) {
            imgView.image = UIImage(named: "coconut")
        }
        ref.child("users").observe(DataEventType.value, with: {
            (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                DispatchQueue.main.async {
                    if let items = value[self.user] as? NSDictionary {
                        for (key, value) in items {
                            if let keyString = key as? String {
                                if keyString == "name" {
                                    if let name = value as? String {
                                        self.nameField.text = "\(name)"
                                    }
                                }
                            }
                        }
                    }
                }
            }
        })
    }
    
    @IBAction func save(_ sender: UIStoryboardSegue) {
        if nameField.text! == "" {
            messageLabel.text = "Please do not leave the name field blank"
        } else if passwordField.text! != "" || passwordConfirmField.text! != "" || oldPasswordField.text != "" {
            if passwordField.text! == "" || passwordConfirmField.text! == "" || oldPasswordField.text == "" {
                messageLabel.text = "Please fill out all password fields"
            } else {
                ref.child("users").observe(.value, with: {
                    (snapshot) in
                    if let value = snapshot.value as? NSDictionary {
                        if let items = value[self.user] as? NSDictionary {
                            for (key, value) in items {
                                if let keyString = key as? String {
                                    if keyString == "password" {
                                        if let password = value as? String {
                                            if password == self.oldPasswordField.text! {
                                                if self.passwordField.text! == self.passwordConfirmField.text! {
                                                    if password != self.passwordField.text! {
                                                        self.ref.child("users/\(self.user)").setValue(["password": self.passwordField.text!, "name": self.nameField.text!])
                                                        self.passwordField.text = ""
                                                        self.passwordConfirmField.text = ""
                                                        self.oldPasswordField.text = ""
                                                        self.messageLabel.text = "Account successfully updated!"
                                                        self.performSegue(withIdentifier: "unwindToTable", sender: self)
                                                    } else {
                                                        self.messageLabel.text = "Password is unchanged"
                                                    }
                                                } else {
                                                    self.messageLabel.text = "New passwords do not match"
                                                }
                                            } else {
                                                self.messageLabel.text = "Incorrect old password"
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                })
            }
        } else {
            ref.child("users").observe(DataEventType.value, with: {
                (snapshot) in
                if let value = snapshot.value as? NSDictionary {
                    if let items = value[self.user] as? NSDictionary {
                        for (key, value) in items {
                            if let keyString = key as? String {
                                if keyString == "password" {
                                    if let password = value as? String {
                                        self.ref.child("users/\(self.user)").setValue(["password": password, "name": self.nameField.text!])
                                        self.messageLabel.text = "Account successfully updated!"
                                    }
                                }
                            }
                        }
                    }
                }
            })
        }
    }
}
