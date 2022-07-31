//
//  LoginViewController.swift
//  StepAhead
//
//  Created by CoopStudent on 2022-07-31.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        validateFields()
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
        
        login()
    }

    func login(){
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { [weak self] authResult, error in
            guard self != nil else {return}
            if let error = error{
                print(error.localizedDescription)
            }
            self?.checkUserInfo()
        }
    }
    
    func checkUserInfo(){
        if(Auth.auth().currentUser != nil){
            print(Auth.auth().currentUser!.uid)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TabBar")
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true)
        }
    }
    
    @IBAction func signUpRedirect(_ sender: Any) {
        let storyboard = UIStoryboard(name:"Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignUP")
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
