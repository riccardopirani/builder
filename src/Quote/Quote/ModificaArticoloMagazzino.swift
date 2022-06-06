//
//  ModificaArticoloMagazzino.swift
//  Quote
//
//  Created by riccardo on 18/03/19.
//  Copyright © 2019 ViewSoftware. All rights reserved.
//
//

import Foundation
import CoreLocation
import MapKit
import SwiftQRScanner

class ModificaArticoloMagazzino: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource
{
    private let buttonAggiornaMagazzino: UIButton = UIButton()
    public var art: ArticoloMagazzinoStruct = ArticoloMagazzinoStruct()
    public var u = User()
    private var labelCodArt: UILabel = UILabel()
    private var labelDescrizione: UILabel = UILabel()
    private var labelQuantita: UILabel = UILabel()
    private var labelMagazzino: UILabel = UILabel()
    private var labelMagazzinoMod: UILabel = UILabel()
    private var labelQuantitaMod: UILabel = UILabel()
    private var labelTipologia: UILabel = UILabel()
    private var txtQuantita: UITextField = UITextField()
    private var txtDescrizione: UITextField = UITextField()
    private var TipologiaUIPicker: UIPickerView = UIPickerView()
    private var MagazzinoModUIPicker: UIPickerView = UIPickerView()
    private let valori = ["Carico", "Scarico", "Rimozione", "Spostamento"]
    private var SetValue: String = "Carico"
    private var filteredDataMagazzini: [MagazzinoStruct] = []
    private var filteredDataMagazziniSelect: MagazzinoStruct = MagazzinoStruct()
    
    //Costruttore
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    //Costruttore
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        self.view.backgroundColor = UIColor.white
        
        //Caricamento Magazzini
        DispatchQueue.main.async {
            let mtemp = Magazzino(User: self.u)
            mtemp.CaricaMagazzini(completion: { result in
                DispatchQueue.main.async {
                    self.filteredDataMagazzini = result
                    print("\n \n Magazzini caricati: \(result.count)")
                    //Configurazione Picker View Tipologia Preventivo
                    self.labelMagazzinoMod = UILabel(frame: CGRect(x: 20, y: 400, width: 120, height: 21))
                    self.labelMagazzinoMod.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
                    self.labelMagazzinoMod.text = "Magazzino: "
                    self.view.addSubview(self.labelMagazzinoMod)
                    self.MagazzinoModUIPicker = UIPickerView(frame: CGRect(x: 150, y: 400, width: 200, height: 50))
                    self.MagazzinoModUIPicker.delegate = self
                    self.MagazzinoModUIPicker.dataSource = self
                    self.MagazzinoModUIPicker.backgroundColor = UIColor.white
                    self.view.addSubview(self.MagazzinoModUIPicker)
                }

            });
        }
        //Configurazione Bottone QrCode
        let imageQrCode = UIImage(named: "add-button.png") as UIImage?
        buttonAggiornaMagazzino.frame = CGRect(x: 250, y: 500, width: 100, height: 100)
        buttonAggiornaMagazzino.backgroundColor = UIColor.white
        buttonAggiornaMagazzino.set(image: imageQrCode, attributedTitle: NSAttributedString(string: "Aggiorna"), at: UIButton.Position(rawValue: 1)!, width: 30, state: UIControl.State.normal)
        buttonAggiornaMagazzino.addTarget(self, action: #selector(AggiornaArticoloMagazzino), for: .touchUpInside)
        buttonAggiornaMagazzino.contentHorizontalAlignment = .center
        self.view.addSubview(buttonAggiornaMagazzino)
        //Label Codice Articolo
        labelCodArt = UILabel(frame: CGRect(x: 20, y: 60, width: 300, height: 21))
        labelCodArt.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        labelCodArt.text = "CodArt: \(String(describing: art.CodArt!))"
        self.view.addSubview(labelCodArt)
        //Label Descrizione
        labelDescrizione = UILabel(frame: CGRect(x: 20, y: 100, width: 300, height: 21))
        labelDescrizione.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        labelDescrizione.text = "Descrizione: \(String(describing: art.Descrizione!))"
        self.view.addSubview(labelDescrizione)
        //Label Magazzino
        labelMagazzino = UILabel(frame: CGRect(x: 20, y: 140, width: 300, height: 21))
        labelMagazzino.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        labelMagazzino.text = "Magazzino: \(String(describing: art.Magazzino!))"
        self.view.addSubview(labelMagazzino)
        //Label Quantita
        labelQuantita = UILabel(frame: CGRect(x: 20, y: 180, width: 300, height: 21))
        labelQuantita.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        labelQuantita.text = "Quantita attuale: \(String(describing: art.Quantita!))"
        self.view.addSubview(labelQuantita)
        //Button per tornare alla schermata principale
        let ImageReturn = UIImage(named: "return.png") as UIImage?
        let buttonReturn: UIButton = UIButton()
        buttonReturn.frame = CGRect(x: (self.view.frame.width / 2), y: 600, width: 80, height: 80)
        buttonReturn.backgroundColor = UIColor.white
        buttonReturn.setImage(ImageReturn, for: .normal)
        buttonReturn.setTitle("", for: .normal)
        buttonReturn.addTarget(self, action: #selector(Return), for: .touchUpInside)
        self.view.addSubview(buttonReturn)
        //Configurazione Picker View Tipologia Preventivo
        labelTipologia = UILabel(frame: CGRect(x: 20, y: 270, width: 120, height: 21))
        labelTipologia.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        labelTipologia.text = "Tipologia: "
        self.view.addSubview(labelTipologia)
        self.TipologiaUIPicker = UIPickerView(frame: CGRect(x: (self.view.frame.width / 2) - 70, y: 270, width: 200, height: 50))
        self.TipologiaUIPicker.delegate = self as UIPickerViewDelegate
        self.TipologiaUIPicker.dataSource = self as UIPickerViewDataSource
        self.TipologiaUIPicker.backgroundColor = UIColor.white
        self.view.addSubview(TipologiaUIPicker)
        //Quantita--> labelQuantitaMod e txtQuantita
        labelQuantitaMod = UILabel(frame: CGRect(x: 20, y: 220, width: 60, height: 21))
        labelQuantitaMod.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        labelQuantitaMod.text = "Quantita: "
        self.view.addSubview(labelQuantitaMod)
        txtQuantita = UITextField(frame: CGRect(x: 120, y: 220, width: 200, height: 21));
        txtQuantita.backgroundColor = UIColor.lightGray
        txtQuantita.text = "1"
        self.view.addSubview(txtQuantita)
        //TextBox Descrizione
        txtDescrizione = UITextField(frame: CGRect(x: 50, y: 500, width: 150, height: 21));
        txtDescrizione.backgroundColor = UIColor.lightGray
        txtDescrizione.text = "desc"
        self.view.addSubview(txtDescrizione)
    }

    //Funzione per aggiornare articolo in magazzino
    @objc func AggiornaArticoloMagazzino(sender: UIButton!) {

        if(txtQuantita.text?.isInt == true) {
            if(txtDescrizione.text!.count > 0) {
                let mtemp = Magazzino(SetArticolo: art, User: u)
                mtemp.Aggiorna(Quantita: Int(txtQuantita.text!)!, QuantitaPrecedente: art.Quantita!, IdMagazzino2: filteredDataMagazziniSelect.IdMagazzino!, Modalita: SetValue, Descrizione: txtDescrizione.text!, completion: { result in

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                                if(result == false) {
                                    let alertController = UIAlertController(title: "Errore", message: "\(self.SetValue) non riuscito ", preferredStyle: .alert)
                                    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                    alertController.addAction(OKAction)
                                    self.present(alertController, animated: true, completion: nil)
                                }
                                else {
                                    if(self.SetValue == "Rimozione") {
                                        self.previosScreen()
                                    }
                                    else if(self.SetValue == "Scarico") {
                                        self.art.Quantita = self.art.Quantita! - Int(self.txtQuantita.text!)!
                                    }
                                    else if(self.SetValue == "Carico") {
                                        self.art.Quantita = self.art.Quantita! + Int(self.txtQuantita.text!)!
                                    }
                                    else if(self.SetValue == "Spostamento") {
                                        self.art.IdMagazzino = self.filteredDataMagazziniSelect.IdMagazzino!

                                    }
                                    self.labelQuantita.text = "Quantita attuale: \(String(describing: self.art.Quantita!))"
                                    self.labelMagazzino.text = "Magazzino: \(String(describing: self.filteredDataMagazziniSelect.Nome!))"
                                }
                            });
                    });
            }
            else {
                let alertController = UIAlertController(title: "Errore", message: "descrizione non inserita", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)

            }
        }
        else {
            let alertController = UIAlertController(title: "Errore", message: "quantita non corretta", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    //Questa funzione verifica quale selezione viene effettuata
    func CheckSelezione(row: Int) {
        if(valori[row] == "Carico") {

            txtQuantita.isEnabled = true
            txtQuantita.isUserInteractionEnabled = true
        }
        else if(valori[row] == "Scarico") {
            txtQuantita.isEnabled = true
            txtQuantita.isUserInteractionEnabled = true
        }

        else if(valori[row] == "Rimozione") {
            txtQuantita.isEnabled = false
            txtQuantita.isUserInteractionEnabled = false
        }
        else {
            txtQuantita.isEnabled = true
            txtQuantita.isUserInteractionEnabled = true
        }
        SetValue = valori[row]
    }

    //Funzione per tornare alla schermata principale
    func previosScreen() {
        let returnView = TabBarViewController()
        returnView.InizializzaView()
        self.present(returnView, animated: true, completion: nil)
    }
    
    //Funzione per tornare alla schermata principale
    @objc func Return(sender: UIButton!) {
        previosScreen()
    }

    //Numero di componenti nell'UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == TipologiaUIPicker {
            return valori.count
        }
        else {
            return filteredDataMagazzini.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == TipologiaUIPicker {
            CheckSelezione(row: row)
            return valori[row]
        }
        else {
            filteredDataMagazziniSelect = filteredDataMagazzini[row]
            return filteredDataMagazzini[row].Nome
        }
    }


}
