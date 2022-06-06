//
//  ModificaArticoloViewController.swift
//  Quote
//
//  Created by riccardo on 04/09/18.
//  Copyright © 2018 ViewSoftware. All rights reserved.
//

import UIKit

//Classe che viene utilizza per la modifica di un articolo
class ModificaArticoloViewController: UIViewController
{
    var Stato = "Creazione"
    private var labelCodArt: UILabel = UILabel()
    private var txtCodArt: UITextField = UITextField()
    private var labelprezzo: UILabel = UILabel()
    private var txtprezzo: UITextField = UITextField()
    private var labeldescrizione: UILabel = UILabel()
    private var txtdescrizione: UITextField = UITextField()
    private var labelum: UILabel = UILabel()
    private var txtum: UITextField = UITextField()
    public var articolomodifica: Articolo = Articolo()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        self.view.backgroundColor = UIColor.white
        //Configurazione UITextField,UILabel Codice Articolo
        labelCodArt = UILabel(frame: CGRect(x: 20, y: 50, width: 100, height: 21))
        labelCodArt.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        labelCodArt.text = "CodArt:"
        self.view.addSubview(labelCodArt)
        txtCodArt = UITextField(frame: CGRect(x: 120, y: 50, width: 200, height: 21));
        txtCodArt.backgroundColor = UIColor.lightGray
        txtCodArt.text = ""
        self.view.addSubview(txtCodArt)
        //Configurazione UITextField,UILabel Prezzo
        labelprezzo = UILabel(frame: CGRect(x: 20, y: 100, width: 100, height: 21))
        labelprezzo.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        labelprezzo.text = "Prezzo:"
        self.view.addSubview(labelprezzo)
        txtprezzo = UITextField(frame: CGRect(x: 120, y: 100, width: 200, height: 21));
        txtprezzo.backgroundColor = UIColor.lightGray
        txtprezzo.text = ""
        self.view.addSubview(txtprezzo)
        //Configurazione UITextField,UILabel Descrizione
        labeldescrizione = UILabel(frame: CGRect(x: 20, y: 150, width: 100, height: 21))
        labeldescrizione.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        labeldescrizione.text = "Descrizione:"
        self.view.addSubview(labeldescrizione)
        txtdescrizione = UITextField(frame: CGRect(x: 120, y: 150, width: 200, height: 21));
        txtdescrizione.backgroundColor = UIColor.lightGray
        txtdescrizione.text = ""
        self.view.addSubview(txtdescrizione)
        //Configurazione UITextField,UILabel Unità Misura
        labelum = UILabel(frame: CGRect(x: 20, y: 200, width: 100, height: 21))
        labelum.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        labelum.text = "UM:"
        self.view.addSubview(labelum)
        txtum = UITextField(frame: CGRect(x: 120, y: 200, width: 200, height: 21));
        txtum.backgroundColor = UIColor.lightGray
        txtum.text = ""
        self.view.addSubview(txtum)
        //Configurazione UiButton per tornare a schermata precedente
        let ImageReturn = UIImage(named: "return.png") as UIImage?
        let buttonReturn = UIButton()
        buttonReturn.frame = CGRect(x: 50, y: 300, width: 80, height: 80)
        buttonReturn.backgroundColor = UIColor.white
        buttonReturn.setImage(ImageReturn, for: .normal)
        buttonReturn.setTitle("Go Home", for: .normal)
        buttonReturn.addTarget(self, action: #selector(Return), for: .touchUpInside)
        self.view.addSubview(buttonReturn)
        //Configurazione UIButton per inserimento articolo
        let imageInserimentoArticolo = UIImage(named: "add-button.png") as UIImage?
        let buttonInserimento = UIButton()
        buttonInserimento.frame = CGRect(x: 150, y: 300, width: 80, height: 80)
        buttonInserimento.backgroundColor = UIColor.white
        buttonInserimento.setImage(imageInserimentoArticolo, for: .normal)
        buttonInserimento.setTitle("Inserisci", for: .normal)
        buttonInserimento.addTarget(self, action: #selector(InserimentoArticolo), for: .touchUpInside)
        self.view.addSubview(buttonInserimento)
        //Carico i valori dell'articolo nel caso in cui l'utente stia effettuando una modifica
        if(Stato == "Modifica") {
            self.txtCodArt.text = articolomodifica.GetCodArt()
            self.txtdescrizione.text = articolomodifica.GetDescrizione()
            self.txtum.text = articolomodifica.GetUM()
            self.txtprezzo.text = "\(articolomodifica.GetPrezzo())"
        }

    }

    //Prima di inserire l'articolo controllo che i campi siano compilati correttamente
    @objc func InserimentoArticolo(sender: UIButton!) {

        //Stato Creazione: sto inserendo un nuovo articolo
        //Stato Modifica: sto modificando un articolo esistente

        //Verifica compilazione campi
        var error = ""
        if(txtprezzo.text != "" && txtum.text != "" && txtCodArt.text != "" && txtdescrizione.text != "") {
            if(txtprezzo.text?.CheckIsFloat == true) {

                if(txtum.text!.count == 2) {

                    if(Stato == "Creazione") {

                        DispatchQueue.main.async
                        {
                            let articolotemp = Articolo()
                            articolotemp.Inserisci(UM: self.txtum.text!, Prezzo: Float(self.txtprezzo.text!)!, Descrizione: self.txtdescrizione.text!, CodArt: self.txtCodArt.text!, completion: { result in

                                    if(result == false) {
                                        error = "inserimento articolo non riuscito"
                                    }

                                })
                        }
                    }

                    else if(Stato == "Modifica") {
                        DispatchQueue.main.async
                        {
                            self.articolomodifica.Aggiorna(UM: self.txtum.text!, Prezzo: Float(self.txtprezzo.text!)!, Descrizione: self.txtdescrizione.text!, CodArt: self.txtCodArt.text!, completion: { result in

                                    if(result == false) {
                                        error = "aggiornamento articolo non riuscito"
                                    }

                                })
                        }

                    }
                }
                else {
                    error = "l'unità di misura deve contenere 2 caratteri"
                }
            }
            else {
                error = "il prezzo non è nel formato corretto"
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
            title = "Articolo Inserito"
            if(Stato == "Modifica") {
                title = "Modifica Articolo riuscita"
            }
            let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }


    }

    //Funzione che torna alla schermata precedente
    func returnPreviousView() {
        let returnView = TabBarViewController()
        self.present(returnView, animated: true, completion: nil)
    }

    //Funzione che vienen eseguita dal bottone per tornare alla schermata precedente
    @objc func Return(sender: UIButton!) {
        returnPreviousView()

    }

}


