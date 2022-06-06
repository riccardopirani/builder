//
//  GestioneCantieriViewController.swift
//  Quote
//
//  Created by riccardo on 05/04/18.
//  Copyright © 2018 ViewSoftware. All rights reserved.
//


/* Annotazioni:

    1) Questa View ha due metodi costruttori uno inzializza l'oggetto cantiereinterno attraverso una struct l'atro attraverso un oggeto!
 */

import UIKit
import CoreLocation

class GestioneCantieriViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    //Il Cantiere da Gestire nel View Controller
    private var TextViewDescrizioneCantiere: UITextView = UITextView()
    private var pickerviewStato: UIPickerView = UIPickerView()
    private var labelNomeCantiere: UILabel = UILabel()
    private let statoCantiere = ["InCorso", "Chiuso", "Lavoro terminato inserire bolle "]
    private var immagineStatoCantiere: UIImageView = UIImageView()
    var CantiereInterno: Cantiere
    private let DistLtoR: CGFloat = 130
    private let DistRtoL: CGFloat = 50

    init(CantiereSet: Cantiere) {
        CantiereInterno = CantiereSet
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        self.view.backgroundColor = UIColor.white
    }

    func initView() {

        //Configurazione label NomeCantiere
        let labelNomeCantiereINFO = UILabel(frame: CGRect(x: 20, y: 60, width: 120, height: 21))
        labelNomeCantiereINFO.text = "Cantiere:"
        labelNomeCantiereINFO.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        self.view.addSubview(labelNomeCantiereINFO)
        //Configurazione label NomeCantiere
        labelNomeCantiere = UILabel(frame: CGRect(x: 100, y: 60, width: 200, height: 21))
        labelNomeCantiere.text = CantiereInterno.GetNomeCantiere()
        self.view.addSubview(labelNomeCantiere)
        //Configurazioe label Cliente
        let labelClienteINFO = UILabel(frame: CGRect(x: 20, y: 100, width: 130, height: 21))
        labelClienteINFO.text = "Ragione Sociale:"
        labelClienteINFO.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        self.view.addSubview(labelClienteINFO)
        //Configurazione label Cliente
        let labelCliente = UILabel(frame: CGRect(x: 180, y: 100, width: 180, height: 21))
        labelCliente.text = CantiereInterno.GetRagioneSociale()
        self.view.addSubview(labelCliente)
        //Configurazioe label Filiale
        let labelFilialeINFO = UILabel(frame: CGRect(x: 20, y: 140, width: 130, height: 21))
        labelFilialeINFO.text = "Filiale:"
        labelFilialeINFO.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        self.view.addSubview(labelFilialeINFO)
        //Configurazione label Filiale
        let labelFiliale = UILabel(frame: CGRect(x: 100, y: 140, width: 180, height: 21))
        labelFiliale.text = CantiereInterno.GetFiliale()
        self.view.addSubview(labelFiliale)
        //Configurazioe label Stato
        let labelStato = UILabel(frame: CGRect(x: 20, y: 190, width: 130, height: 21))
        labelStato.text = "Stato:"
        labelStato.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        self.view.addSubview(labelStato)
        //Configurazione PickerView
        self.pickerviewStato = UIPickerView(frame: CGRect(x: 90, y: 180, width: 160, height: 50))
        self.pickerviewStato.delegate = self as UIPickerViewDelegate
        self.pickerviewStato.dataSource = self as UIPickerViewDataSource
        self.pickerviewStato.backgroundColor = UIColor.gray
        self.view.addSubview(pickerviewStato)
        //UIImage Stato Cantiere
        immagineStatoCantiere = UIImageView(frame: CGRect(x: (self.view.frame.width / 2) + 50, y: 180, width: 50, height: 50));
        immagineStatoCantiere.image = UIImage(named: "InCorso.png")
        immagineStatoCantiere.backgroundColor = UIColor.gray
        self.view.addSubview(immagineStatoCantiere)
        //UiTextView Descizione Cantiere
        self.TextViewDescrizioneCantiere = UITextView(frame: CGRect(x: 0, y: 250, width: self.view.frame.width, height: 80))
        self.automaticallyAdjustsScrollViewInsets = false
        TextViewDescrizioneCantiere.font = UIFont(name: "HelveticaNeue-Bold", size: 18.0)
        TextViewDescrizioneCantiere.textAlignment = NSTextAlignment.justified
        TextViewDescrizioneCantiere.textColor = UIColor.blue
        TextViewDescrizioneCantiere.isEditable = true
        TextViewDescrizioneCantiere.backgroundColor = UIColor.lightGray
        TextViewDescrizioneCantiere.text = CantiereInterno.GetDescrizioneEstesa()
        self.view.addSubview(TextViewDescrizioneCantiere)
        //Configurazione Bottone Risorse Umane
        let buttonRisorseUmane = UIButton(type: .custom)
        buttonRisorseUmane.frame = CGRect(x: (self.view.frame.width / 2) - DistLtoR, y: 360, width: 100, height: 100)
        buttonRisorseUmane.layer.cornerRadius = 0.5 * buttonRisorseUmane.bounds.size.width
        buttonRisorseUmane.clipsToBounds = true
        buttonRisorseUmane.setImage(UIImage(named: "risorse_umane.png"), for: .normal)
        buttonRisorseUmane.backgroundColor = UIColor.lightGray
        buttonRisorseUmane.addTarget(self, action: #selector(RisorseUmanebuttonAction), for: .touchUpInside)
        self.view.addSubview(buttonRisorseUmane)
        //Configurazione Bottone Kilometri
        let buttonKilometri = UIButton(type: .custom)
        buttonKilometri.frame = CGRect(x: (self.view.frame.width / 2) + DistRtoL, y: 360, width: 100, height: 100)
        buttonKilometri.layer.cornerRadius = 0.5 * buttonKilometri.bounds.size.width
        buttonKilometri.clipsToBounds = true
        buttonKilometri.setImage(UIImage(named: "kilometri.png"), for: .normal)
        buttonKilometri.backgroundColor = UIColor.lightGray
        buttonKilometri.addTarget(self, action: #selector(KilometributtonAction), for: .touchUpInside)
        self.view.addSubview(buttonKilometri)
        //Bottone per gli Articoli
        let buttonArticoli = UIButton(type: .custom)
        buttonArticoli.frame = CGRect(x: (self.view.frame.width / 2) - DistLtoR, y: 480, width: 100, height: 100)
        buttonArticoli.layer.cornerRadius = 0.5 * buttonArticoli.bounds.size.width
        buttonArticoli.clipsToBounds = true
        buttonArticoli.setImage(UIImage(named: "articoli.png"), for: .normal)
        buttonArticoli.backgroundColor = UIColor.lightGray
        buttonArticoli.addTarget(self, action: #selector(ArticolibuttonAction), for: .touchUpInside)
        self.view.addSubview(buttonArticoli)
        //Bottone per Rapportini
        let buttonRapportini = UIButton(type: .custom)
        buttonRapportini.frame = CGRect(x: (self.view.frame.width / 2) + DistRtoL, y: 480, width: 100, height: 100)
        buttonRapportini.layer.cornerRadius = 0.5 * buttonArticoli.bounds.size.width
        buttonRapportini.clipsToBounds = true
        buttonRapportini.setImage(UIImage(named: "rapportini.png"), for: .normal)
        buttonRapportini.backgroundColor = UIColor.lightGray
        buttonRapportini.addTarget(self, action: #selector(RapportinobuttonAction), for: .touchUpInside)
        self.view.addSubview(buttonRapportini)
        buttonRapportini.isHidden = false
        //Bottone per Ristoranti
        let buttonRistoranti = UIButton(type: .custom)
        buttonRistoranti.frame = CGRect(x: (self.view.frame.width / 2) + DistRtoL, y: 600, width: 100, height: 100)
        buttonRistoranti.layer.cornerRadius = 0.5 * buttonRistoranti.bounds.size.width
        buttonRistoranti.clipsToBounds = true
        buttonRistoranti.setImage(UIImage(named: "ristorante.png"), for: .normal)
        buttonRistoranti.backgroundColor = UIColor.lightGray
        buttonRistoranti.addTarget(self, action: #selector(RistorantibuttonAction), for: .touchUpInside)
        self.view.addSubview(buttonRistoranti)
        //Bottone per Noleggi
        let buttonNoleggi = UIButton(type: .custom)
        buttonNoleggi.frame = CGRect(x: (self.view.frame.width / 2) - DistLtoR, y: 600, width: 100, height: 100)
        buttonNoleggi.layer.cornerRadius = 0.5 * buttonNoleggi.bounds.size.width
        buttonNoleggi.clipsToBounds = true
        buttonNoleggi.setImage(UIImage(named: "noleggi.png"), for: .normal)
        buttonNoleggi.backgroundColor = UIColor.lightGray
        buttonNoleggi.addTarget(self, action: #selector(NoleggibuttonAction), for: .touchUpInside)
        self.view.addSubview(buttonNoleggi)
        //Visualizzo il button dei rapportini
        buttonRapportini.isHidden = false
        //Bottone per tornare a schermata principale
        let ImageReturn = UIImage(named: "return.png") as UIImage?
        let buttonReturn = UIButton()
        buttonReturn.frame = CGRect(x: (self.view.frame.width / 2), y: 700, width: 80, height: 80)
        buttonReturn.backgroundColor = UIColor.white
        buttonReturn.setImage(ImageReturn, for: .normal)
        buttonReturn.setTitle("Go Home", for: .normal)
        buttonReturn.addTarget(self, action: #selector(ReturnToHomebuttonAction), for: .touchUpInside)
        self.view.addSubview(buttonReturn)
        //Modifica stato cantiere
        pickerviewStato.selectRow(statoCantiere.firstIndex(of: CantiereInterno.GetStatoCantiere())!, inComponent: 0, animated: true)
        selectPicker(withText: CantiereInterno.GetStatoCantiere())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Funzione che si occupa di aprire la ViewController dei ristoranti
    @objc func RistorantibuttonAction(sender: UIButton!) {
        let Ristoranti = RistorantiViewController()
        Ristoranti.CantiereInterno = CantiereInterno
        Ristoranti.InizializzaView()
        self.present(Ristoranti, animated: true, completion: nil)
    }

    //Funzione che si occupa di aprire la ViewController dei Kilometri
    @objc func KilometributtonAction(sender: UIButton!) {
        let GestioneKilometri = GestioneKilometriViewController()
        GestioneKilometri.CantiereInterno = CantiereInterno
        GestioneKilometri.InizializzaView()
        self.present(GestioneKilometri, animated: true, completion: nil)
    }

    //Funzione che si occupa di aprire la ViewController degli articoli
    @objc func ArticolibuttonAction(sender: UIButton!) {
        let GestioneArticoli = GestioneArticoliViewController()
        GestioneArticoli.CantiereInterno = CantiereInterno
        GestioneArticoli.InizializzaView()
        self.present(GestioneArticoli, animated: true, completion: nil)

    }

    //Funzione che si occupa di aprire la ViewController dei rapportini
    @objc func RapportinobuttonAction(sender: UIButton!) {
        let Rapportini = RapportiniViewController(Cantiere: CantiereInterno)
        Rapportini.InizializzaView()
        self.present(Rapportini, animated: true, completion: nil)
    }

    //Funzione che si occupa di aprire la ViewController delle risorse umane
    @objc func RisorseUmanebuttonAction(sender: UIButton!) {
        let RisorseUmaneView = RisorseUmaneViewController()
        RisorseUmaneView.Cantiere = CantiereInterno
        RisorseUmaneView.InizializzaView()
        self.present(RisorseUmaneView, animated: true, completion: nil)
    }

    //Funzione che si occupa di aprire la ViewController dei noleggi
    @objc func NoleggibuttonAction(sender: UIButton!) {
        let ViewNoleggi = NoleggiViewController()
        ViewNoleggi.CantiereInterno = CantiereInterno
        ViewNoleggi.InizializzaView()
        self.present(ViewNoleggi, animated: true, completion: nil)
    }

    //Funzione che si occupa di selezionare il picker corrispondete al valore dello stato del cantiere
    func selectPicker(withText text: String) {
        if let index = statoCantiere.firstIndex(of: text) {
            pickerviewStato.selectRow(index, inComponent: 0, animated: true)
            ChangeRow(row: index, stato: text)
        } else {
            print("text not found")
        }
    }

    //Funzione che si occupa di ritornare alla View precedente
    @objc func ReturnToHomebuttonAction(sender: UIButton!) {

        self.CantiereInterno.AggiornaCantiere(DescrizioneEstesa: self.TextViewDescrizioneCantiere.text, Stato: self.CantiereInterno.GetStatoCantiere(), completion: { result in

                if(result == true)
                {
                    DispatchQueue.main.async
                    {
                        let Home = TabBarViewController(nibName: "Cantieri", bundle: nil)
                        self.present(Home, animated: true, completion: nil)
                    }
                }
            })
    }

    //Ritorna il valore selezionato nello stato del cantiere
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return statoCantiere[row]
    }

    //Ritorna il numero di colonne presenti nell'UiPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    //Ritorna il numero di stati dei cantieri
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return statoCantiere.count
    }

    //Funzione chiamata quando avviene la modifica dello stato del cantiere
    private func ChangeRow(row: Int, stato: String) {
        //Stato in corso
        if(row == 0 || stato == "InCorso") {
            self.immagineStatoCantiere.image = UIImage(named: "InCorso.png")
            self.CantiereInterno.SetStatoCantiere(Stato: "InCorso")
        }
        //stato chiuso
            else if(row == 1 || stato == "Chiuso") {
                self.immagineStatoCantiere.image = UIImage(named: "Accettato.png")
                self.CantiereInterno.SetStatoCantiere(Stato: "Chiuso")
        }
        //stato in cui mancano le bolle
        else {
                self.immagineStatoCantiere.image = UIImage(named: "Rifiutato.png")
                self.CantiereInterno.SetStatoCantiere(Stato: "Lavoro terminato inserire bolle ")
            
        }
    }
    //Questa funzione viene chiamata quando viene modificata la selezione dell'uipickerview, corrispondente allo stato del cantiere
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        ChangeRow(row: row, stato: "")
    }

    //Inizializza il pickerView
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = statoCantiere[row]
        return label
    }
}
