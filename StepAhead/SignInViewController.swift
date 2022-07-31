//
//  SignInViewController.swift
//  StepAhead
//
//  Created by CoopStudent on 2022-07-31.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUp(_ sender: Any) {
        validateFields()
    }
    
    @IBAction func loginRedirect(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Login")
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    func validateFields(){
        if(email.text?.isEmpty == true){
            print("No email text")
            return
        }
        
        if(password.text?.isEmpty == true){
            print("No password")
            return
        }
        signup()
        
    }
    
    func signup(){
        
        print("signup")
        Auth.auth().createUser(withEmail: email.text!, password: password.text!){ (user, error) in
            if(error == nil && user != nil){
                
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = self.username.text!
                changeRequest?.commitChanges { error in
                    if(error == nil){
                        print("User display name changed")
                    }
                    
                    print(self.username.text!)
                }
                
            }else{
                print("Error creating user: \(error!.localizedDescription)")
            }
        }
        
                
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Login")
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
            
        }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
