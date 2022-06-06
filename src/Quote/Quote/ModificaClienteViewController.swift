//
//  ModificaClienteViewController.swift
//  Quote
//
//  Created by riccardo on 05/09/18.
//  Copyright © 2018 ViewSoftware. All rights reserved.
//

import UIKit

class ModificaClienteViewController: UIViewController
{

    public var Stato: String = "Creazione"
    private var labelRagioneSociale: UILabel = UILabel()
    private var txtRagioneSociale: UITextField = UITextField()
    private var labelIndirizzo: UILabel = UILabel()
    private var txtIndirizzo: UITextField = UITextField()
    private var labelCitta: UILabel = UILabel()
    private var txtCitta: UITextField = UITextField()
    public var clientetemp: Cliente = Cliente()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        self.view.backgroundColor = UIColor.white
        //Configurazione UITextField,UILabel Ragione Sociale
        labelRagioneSociale = UILabel(frame: CGRect(x: 20, y: 50, width: 180, height: 21))
        labelRagioneSociale.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        labelRagioneSociale.text = "Ragione Sociale:"
        self.view.addSubview(labelRagioneSociale)
        txtRagioneSociale = UITextField(frame: CGRect(x: 160, y: 50, width: 200, height: 21));
        txtRagioneSociale.backgroundColor = UIColor.lightGray
        txtRagioneSociale.text = ""
        self.view.addSubview(txtRagioneSociale)
        //Configurazione UITextField,UILabel Indirizzo
        labelIndirizzo = UILabel(frame: CGRect(x: 20, y: 100, width: 100, height: 21))
        labelIndirizzo.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        labelIndirizzo.text = "Indirizzo:"
        self.view.addSubview(labelIndirizzo)
        txtIndirizzo = UITextField(frame: CGRect(x: 160, y: 100, width: 200, height: 21));
        txtIndirizzo.backgroundColor = UIColor.lightGray
        txtIndirizzo.text = ""
        self.view.addSubview(txtIndirizzo)
        //Configurazione UITextField,UILabel Citta
        labelCitta = UILabel(frame: CGRect(x: 20, y: 150, width: 100, height: 21))
        labelCitta.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        labelCitta.text = "Citta:"
        self.view.addSubview(labelCitta)
        txtCitta = UITextField(frame: CGRect(x: 160, y: 150, width: 200, height: 21));
        txtCitta.backgroundColor = UIColor.lightGray
        txtCitta.text = ""
        self.view.addSubview(txtCitta)
        //Configurazione UiButton per tornare a schermata precedente
        let ImageReturn = UIImage(named: "return.png") as UIImage?
        let buttonReturn = UIButton()
        buttonReturn.frame = CGRect(x: 50, y: 300, width: 80, height: 80)
        buttonReturn.backgroundColor = UIColor.white
        buttonReturn.setImage(ImageReturn, for: .normal)
        buttonReturn.setTitle("Go Home", for: .normal)
        buttonReturn.addTarget(self, action: #selector(Return), for: .touchUpInside)
        self.view.addSubview(buttonReturn)
        //Configurazione UIButton per inserimento cliente
        let imageInserimentoArticolo = UIImage(named: "add-button.png") as UIImage?
        let buttonInserimento = UIButton()
        buttonInserimento.frame = CGRect(x: 150, y: 300, width: 80, height: 80)
        buttonInserimento.backgroundColor = UIColor.white
        buttonInserimento.setImage(imageInserimentoArticolo, for: .normal)
        buttonInserimento.setTitle("", for: .normal)
        buttonInserimento.addTarget(self, action: #selector(InserimentoCliente), for: .touchUpInside)
        self.view.addSubview(buttonInserimento)

        if(Stato == "Modifica") {
            self.txtRagioneSociale.text = clientetemp.GetRagioneSociale()
            self.txtIndirizzo.text = clientetemp.GetIndirizzo()
            self.txtCitta.text = clientetemp.GetCitta()
        }
    }

    //Prima di inserire l'articolo controllo che i campi siano compilati correttamente
    @objc func InserimentoCliente(sender: UIButton!) {

        //Stato Creazione: sto inserendo un nuovo cliente
        //Stato Modifica: sto modificando un cliente

        //Verifica compilazione campi
        var error = ""
        if(txtCitta.text != "" && txtIndirizzo.text != "" && txtRagioneSociale.text != "") {

            if(Stato == "Creazione") {

                DispatchQueue.main.async
                {
                    let ctemp = Cliente()
                    ctemp.Inserisci(RagioneSociale: self.txtRagioneSociale.text!, Indirizzo: self.txtIndirizzo.text!, Citta: self.txtCitta.text!, completion: { result in

                        if(result == false) {
                            error = "inserimento cliente non riuscito"
                        }

                    })
                }
            }

            else if(Stato == "Modifica") {

                clientetemp.Aggiorna(RagioneSociale: self.txtRagioneSociale.text!, Indirizzo: self.txtIndirizzo.text!, Citta: self.txtCitta.text!, completion: { result in

                    if(result == false) {
                        error = "aggiornamento cliente non riuscito"
                    }

                })

            }

        }

        else {
            error = "alcuni campi non sono stati compilati"
        }
        if(error != "") {
            let alertController = UIAlertController(title: "Errore", message: error, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            title = "Cliente Inserito"
            if(Stato == "Modifica") {
                title = "Modifica Cliente riuscita"
            }
            let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }


    }

    func returnPreviousView() {
        let returnView = TabBarViewController()
        self.present(returnView, animated: true, completion: nil)
    }
    @objc func Return(sender: UIButton!) {
        returnPreviousView()
    }

    


}
