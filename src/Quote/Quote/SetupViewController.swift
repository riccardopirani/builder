//
//  SetupViewController.swift
//  Quote
//
//  Created by riccardo on 16/07/18.
//  Copyright © 2018 ViewSoftware. All rights reserved.
//

import UIKit
import CoreData

//Classe di Setup per inizializzare i parametri per il server 
class SetupViewController: UIViewController
{
    private var buttonSaveParameter: UIButton = UIButton()
    private var labelServer: UILabel = UILabel()
    private var labelPort: UILabel = UILabel()
    private var txtServer: UITextField = UITextField()
    private var txtPort: UITextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        //Configurazione Iniziale
        self.view.backgroundColor = UIColor.white
        //Configurazione Server
        txtServer = UITextField(frame: CGRect(x: 120, y: 180, width: 200, height: 21));
        txtServer.backgroundColor = UIColor.lightGray
        txtServer.text = ""
        self.view.addSubview(txtServer)
        labelServer = UILabel(frame: CGRect(x: 20, y: 180, width: 100, height: 19))
        labelServer.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        labelServer.text = "Server: "
        self.view.addSubview(labelServer)
        //Configurazione Port
        txtPort = UITextField(frame: CGRect(x: 120, y: 250, width: 200, height: 21));
        txtPort.backgroundColor = UIColor.lightGray
        txtPort.text = ""
        self.view.addSubview(txtPort)
        labelPort = UILabel(frame: CGRect(x: 20, y: 250, width: 100, height: 19))
        labelPort.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        labelPort.text = "Port: "
        self.view.addSubview(labelPort)
        //Configurazione Bottone Salvataggio Configurazione Server
        let imagesavebutton = UIImage(named: "setup.png") as UIImage?
        buttonSaveParameter.frame = CGRect(x: 60, y: 350, width: 80, height: 80)
        buttonSaveParameter.backgroundColor = UIColor.white
        buttonSaveParameter.setImage(imagesavebutton, for: .normal)
        buttonSaveParameter.setTitle("Save Setup", for: .normal)
        buttonSaveParameter.addTarget(self, action: #selector(SaveParameter), for: .touchUpInside)
        self.view.addSubview(buttonSaveParameter)
        //Configurazione Return UIButton
        let ImageReturn = UIImage(named: "return.png") as UIImage?
        let buttonReturn = UIButton()
        buttonReturn.frame = CGRect(x: (self.view.frame.width / 2), y: 600, width: 80, height: 80)
        buttonReturn.backgroundColor = UIColor.white
        buttonReturn.setImage(ImageReturn, for: .normal)
        buttonReturn.setTitle("Go Home", for: .normal)
        buttonReturn.addTarget(self, action: #selector(ReturnAction), for: .touchUpInside)
        self.view.addSubview(buttonReturn)
        //Caricamento Parametri
        LoadParameter()
    }

    //Funzione che carica i parametri
    func LoadParameter() {

        let db = Database()
        if(db.GetServerURL().isEmpty == true) {
            print("\n Parametri non presenti")
        }
        else {
            txtServer.text = db.getServer()
            txtPort.text = db.GetPort()
            print("\n Parametri caricati")
        }

    }

    //Funzione che permette di tornare alla schermata principale
    @objc func ReturnAction(sender: UIButton!) {
        dismiss(animated: true)
    }

    //Funzione che permette di salvare i parametri nel db
    @objc func SaveParameter(sender: UIButton!)
    {
        let db = Database()
        if(db.SetServer(Server: txtServer.text!, Port: Int32(txtPort.text!)!) == true)
        {
            print("Configurazione Server riuscita")
        }
        else
        {
            print("Errore di configurazione")
        }

    }

}
