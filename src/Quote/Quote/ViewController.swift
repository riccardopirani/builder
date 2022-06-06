//
//  ViewController.swift
//  Quote
//
//  Created by riccardo on 27/12/17.
//  Copyright © 2017 ViewSoftware. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    @IBOutlet weak var UsernameTextBox: UITextField!
    @IBOutlet weak var SetupButton: UIButton!
    @IBOutlet weak var PasswordTextBox: UITextField!
    @IBOutlet weak var LoginButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        PasswordTextBox.isSecureTextEntry = true;
        self.LoginServer(CallAtStart: true)
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {
                diallow, error in

            })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //Funzione che porta alla view di configurazione
    @IBAction func GotoSetupView(_ sender: Any) {
        let setupview = SetupViewController()
        setupview.InizializzaView()
        self.present(setupview, animated: true, completion: nil)
    }

    //Funzione di Login al Server
    //CallAtStart server per verificare se l'utente sta effettuando il login all'avvio dell'applicazione
    func LoginServer(CallAtStart: Bool) {



        let db = Database()
        if(db.GetServerURL() != "")
        {
            if(CallAtStart == true) {
                self.UsernameTextBox.text = db.GetPersistentValue(EntinyName: "UserLogin", ValueName: "username")
                self.PasswordTextBox.text = db.GetPersistentValue(EntinyName: "UserLogin", ValueName: "password")
            }
            let UserLogin = User()
            UserLogin.Login(Username: self.UsernameTextBox.text!, Password: self.PasswordTextBox.text!, completion: { result in
                DispatchQueue.main.async {
                    if(result == true)
                    {
                        if(db.SetPersistentValue(EntinyName: "UserLogin", ValueName: "username", Value: self.UsernameTextBox.text!) == true &&
                                db.SetPersistentValue(EntinyName: "UserLogin", ValueName: "password", Value: self.PasswordTextBox.text!) == true) {
                            OperationQueue.main.addOperation
                            {
                                let secondViewController = TabBarViewController(nibName: "Cantieri", bundle: nil)
                                secondViewController.InizializzaView()
                                self.present(secondViewController, animated: true, completion: nil)
                            }
                        }
                        else {
                            let alertController = UIAlertController(title: "Errore", message: "Salvataggio parametri non riuscito!", preferredStyle: .alert)
                            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(OKAction)
                            self.present(alertController, animated: true, completion: nil)

                        }
                    }
                    else
                    {

                        if(CallAtStart == false) {
                            let alertController = UIAlertController(title: "Errore", message: "Login non riuscito, controlla i dati di accesso!", preferredStyle: .alert)
                            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(OKAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                }

            })

        }
        else {
            if(CallAtStart == false) {
                let alertController = UIAlertController(title: "Server non configurato", message: "", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
            }

        }

    }

    //Bottone di Login al Server
    @IBAction func Login(_ sender: Any)
    {
        //Chiamo la funzione di Login al server
        self.LoginServer(CallAtStart: false)
    }

}



