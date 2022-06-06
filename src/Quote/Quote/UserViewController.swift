//
//  UserViewController.swift
//  Quote
//
//  Created by riccardo on 25/07/18.
//  Copyright © 2018 ViewSoftware. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        self.view.backgroundColor = UIColor.white
        //Configurazione UIButton logout
        let imageLogout = UIImage(named: "user.png") as UIImage?
        let buttonlogout: UIButton = UIButton()
        buttonlogout.frame = CGRect(x: (Extend.screenWidth / 2) - 60, y: (Extend.screenHeight / 2) - 50, width: 150, height: 120)
        buttonlogout.backgroundColor = UIColor.white
        buttonlogout.set(image: imageLogout, attributedTitle: NSAttributedString(string: "Logout"), at: UIButton.Position(rawValue: 1)!, width: 80, state: UIControl.State.normal)
        buttonlogout.addTarget(self, action: #selector(LogOutfunction), for: .touchUpInside)
        self.view.addSubview(buttonlogout)

    }

    //Funzione di LogOut
    @objc func LogOutfunction(sender: UIButton!) {
        let utemp = User()
        if(utemp.LogOut() == true) {
            DispatchQueue.main.async {
                exit(0)
            }
        }
    }

}
