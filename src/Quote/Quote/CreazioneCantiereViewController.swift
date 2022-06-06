//
//  CreazioneCantiereViewController.swift
//  Quote
//
//  Created by riccardo on 09/07/18.
//  Copyright © 2018 ViewSoftware. All rights reserved.
//

import UIKit

//View Controller per la creazione dei cantieri
class CreazioneCantiereViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
    //Componenti UI
    private var labelRagioneSocialeCliente: UILabel = UILabel()
    private var labelNomeCantiere: UILabel = UILabel()
    private var txtNomeCantiere: UITextField = UITextField()
    private var buttonReturn: UIButton = UIButton()
    private var PickerTipologiaCantiere: UIPickerView = UIPickerView()
    private let buttonSelezionaCliente = UIButton()
    private let buttonSelezionaPreventivi = UIButton()
    private let buttonCreazioneCantiere = UIButton()
    //Array che contiene le tipologie del cantiere
    private let tipologieCantiere = ["Consuntivo", "Preventivo"]
    public var c: Cliente?
    public var preventivoTemp: PreventivoStruct?
    //Tipologia Cantiere selezionata
    private var TipologiaCantiereSelezionata: Int = 0

    //Funzione eseguita al caricamento della view
    override func viewDidLoad()
    {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        self.view.backgroundColor = UIColor.white
        initView()
    }

    //Funzione di inizializzazione della view
    func initView() {
        //Bottone per tornare alla schermata precedente
        let ImageReturn = UIImage(named: "return.png") as UIImage?
        buttonReturn.frame = CGRect(x: (self.view.frame.width / 2), y: 600, width: 80, height: 80)
        buttonReturn.backgroundColor = UIColor.white
        buttonReturn.setImage(ImageReturn, for: .normal)
        buttonReturn.setTitle("", for: .normal)
        buttonReturn.addTarget(self, action: #selector(Return), for: .touchUpInside)
        self.view.addSubview(buttonReturn)
        //Configurazione UISwitch Tipologia Cantiere
        self.PickerTipologiaCantiere = UIPickerView(frame: CGRect(x: 170, y: 50, width: 160, height: 50))
        self.PickerTipologiaCantiere.delegate = self as UIPickerViewDelegate
        self.PickerTipologiaCantiere.dataSource = self as UIPickerViewDataSource
        self.PickerTipologiaCantiere.backgroundColor = UIColor.gray
        self.view.addSubview(PickerTipologiaCantiere)
        //UILabel Tipologia Cantiere
        let labelTipologia = UILabel(frame: CGRect(x: 20, y: 65, width: 100, height: 21))
        labelTipologia.text = "Tipologia"
        labelTipologia.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        self.view.addSubview(labelTipologia)
        //UITextField NomeCantiere
        txtNomeCantiere = UITextField(frame: CGRect(x: 170, y: 150, width: 160, height: 30));
        txtNomeCantiere.backgroundColor = UIColor.lightGray
        txtNomeCantiere.text = ""
        txtNomeCantiere.isHidden = false
        self.view.addSubview(txtNomeCantiere)
        //UILabel Tipologia Cantiere
        labelNomeCantiere = UILabel(frame: CGRect(x: 25, y: 150, width: 180, height: 21))
        labelNomeCantiere.text = "Nome Cantiere: "
        labelNomeCantiere.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        labelNomeCantiere.isHidden = false
        self.view.addSubview(labelNomeCantiere)
        //Button Seleziona Cliente
        let image = UIImage(named: "clienti.png") as UIImage?
        buttonSelezionaCliente.frame = CGRect(x: 30, y: 300, width: 250, height: 80)
        buttonSelezionaCliente.clipsToBounds = true
        buttonSelezionaCliente.backgroundColor = UIColor.gray
        buttonSelezionaCliente.setImage(image, for: .normal)
        buttonSelezionaCliente.setTitle("Seleziona Cliente", for: .normal)
        buttonSelezionaCliente.addTarget(self, action: #selector(RicercaCliente), for: .touchUpInside)
        buttonSelezionaCliente.semanticContentAttribute = .forceLeftToRight
        self.view.addSubview(buttonSelezionaCliente)
        //Button per la seleziona del preventivo
        let imagePreventivi = UIImage(named: "preventivi.png") as UIImage?
        buttonSelezionaPreventivi.frame = CGRect(x: 30, y: 300, width: 250, height: 80)
        buttonSelezionaPreventivi.clipsToBounds = true
        buttonSelezionaPreventivi.backgroundColor = UIColor.gray
        buttonSelezionaPreventivi.setImage(imagePreventivi, for: .normal)
        buttonSelezionaPreventivi.setTitle("Seleziona Preventivo", for: .normal)
        buttonSelezionaPreventivi.addTarget(self, action: #selector(SelezionePreventivo), for: .touchUpInside)
        buttonSelezionaPreventivi.semanticContentAttribute = .forceLeftToRight
        self.view.addSubview(buttonSelezionaPreventivi)
        buttonSelezionaPreventivi.isHidden = true
        //Button Crezione Cantiere
        let imagenuovocantiere = UIImage(named: "nuovo_cantiere.png") as UIImage?
        buttonCreazioneCantiere.frame = CGRect(x: 30, y: 450, width: 250, height: 80)
        buttonCreazioneCantiere.clipsToBounds = true
        buttonCreazioneCantiere.backgroundColor = UIColor.gray
        buttonCreazioneCantiere.setImage(imagenuovocantiere, for: .normal)
        buttonCreazioneCantiere.setTitle("Creazione Cantiere", for: .normal)
        buttonCreazioneCantiere.addTarget(self, action: #selector(CreazioneCantiere), for: .touchUpInside)
        buttonCreazioneCantiere.semanticContentAttribute = .forceLeftToRight
        self.view.addSubview(buttonCreazioneCantiere)
        //UILabel Ragione Sociale Cliente
        labelRagioneSocialeCliente = UILabel(frame: CGRect(x: 25, y: 250, width: 280, height: 21))
        labelRagioneSocialeCliente.text = ""
        labelRagioneSocialeCliente.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        labelRagioneSocialeCliente.isHidden = true
        self.view.addSubview(labelRagioneSocialeCliente)
        //Verifico che il cliente sia istanziato!
        if((c) != nil)
        {
            labelRagioneSocialeCliente.isHidden = false
            labelRagioneSocialeCliente.text = "Cliente:  \(c!.GetRagioneSociale())"
        }
        //Verifico se è stato selezionato il preventivo
        if(preventivoTemp != nil)
        {
            //Seleziona la pickerview corrispondente alla tipologia del cantiere a preventivo
            self.PickerTipologiaCantiere.selectRow(1, inComponent: 0, animated: true)
            labelRagioneSocialeCliente.isHidden = true
            buttonSelezionaPreventivi.isHidden = true
            buttonSelezionaCliente.isHidden = true
            labelRagioneSocialeCliente.isHidden = true
            txtNomeCantiere.isHidden = true
            labelNomeCantiere.isHidden = true
            TipologiaCantiereSelezionata = 1
        }
    }

    //Bottone per tornare alla schermata principale
    @objc func ReturnButton(sender: UIButton!) {
        dismiss(animated: true)
    }

    //Funzione che ritorna il numero di row nell'uipickerview
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tipologieCantiere[row]
    }


    //Ritorna il numero di colonne nell'uipickerview
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    //Ritorna il numero di tipologie del cantiere
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tipologieCantiere.count
    }

    //Questa funzione viene chiamata quando viene modificata la selezione dell'uipickerview, corrispondente alla tipologia del cantiere
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        //Cantiere Consuntivo
        if(row == 0)
        {
            labelNomeCantiere.isHidden = false
            txtNomeCantiere.isHidden = false
            buttonSelezionaCliente.isHidden = false
            TipologiaCantiereSelezionata = 0
            buttonSelezionaPreventivi.isHidden = true
        }
        //Cantiere Preventivo
            else
        {
            labelNomeCantiere.isHidden = true
            txtNomeCantiere.isHidden = true
            buttonSelezionaCliente.isHidden = true
            labelRagioneSocialeCliente.isHidden = true
            TipologiaCantiereSelezionata = 1
            buttonSelezionaPreventivi.isHidden = false
        }
    }

    //Funzione per la ricerca del Cantiere
    @objc func CreazioneCantiere(sender: UIButton!) {

        //Creazione Cantiere a Consuntivo
        if(TipologiaCantiereSelezionata == 0)
        {
            //Verifico che il cliente sia stato selezionato
            if((c) != nil)
            {
                //Verifico che il nome cantiere sia inserito
                if(self.txtNomeCantiere.text != "")
                {
                    //Istanzio il cantiere
                    let cantieretemp = Cantiere(Cliente: self.c!)
                    //Eseguo la cercazione del cantiere
                    cantieretemp.Crea(NomeCantiere: self.txtNomeCantiere.text!, completion: { result in

                        //Se il canitere viene generato correttamente lo visualizzo
                        if(result == true)
                        {
                            DispatchQueue.main.async(execute: {

                                let CantiereSelezionato = GestioneCantieriViewController(CantiereSet: cantieretemp)
                                self.present(CantiereSelezionato, animated: true, completion: nil)
                            })
                        }
                        //Se non viene generato correttamente visualizzo un errore
                            else
                        {
                            let alertController = UIAlertController(title: "Errore", message: "Creazione Cantiere non riuscita", preferredStyle: .alert)
                            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(OKAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    })

                }
                //Se non è stato inserito il nome cantiere visualizzo un errore
                    else {
                        let alertController = UIAlertController(title: "Errore", message: "Nome cantiere non inserito", preferredStyle: .alert)
                        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(OKAction)
                        self.present(alertController, animated: true, completion: nil)
                }
            }
            //Se non è stato selezionato un cliente visualizzo un errore
                else
            {
                let alertController = UIAlertController(title: "Errore", message: "Cliente non selezionato", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        else
        {
            //Verifico che il preventivo sia selezionato
            if(preventivoTemp != nil)
            {
                //Istanzio il cantiere a preventivo
                let cantieretemp = Cantiere(PreventivoPassed: self.preventivoTemp!)
                //Eseguo la cercazione del cantiere
                cantieretemp.CreaCantierePreventivo(completion: { result in

                    //Se il canitere viene generato correttamente lo visualizzo
                    if(result == true)
                    {
                        DispatchQueue.main.async(execute: {

                            let CantiereSelezionato = GestioneCantieriViewController(CantiereSet: cantieretemp)
                            self.present(CantiereSelezionato, animated: true, completion: nil)
                        })
                    }
                    //Se non viene generato correttamente visualizzo un errore
                        else
                    {
                        let alertController = UIAlertController(title: "Errore", message: "Creazione Cantiere non riuscita", preferredStyle: .alert)
                        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(OKAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                })
            }

        }

    }

    //Funzione per la seleziona del preventivo
    @objc func SelezionePreventivo(sender: UIButton!) {
        //Istanzio la view controller per la ricerca degli articoli
        let RicercaArticoliView = RicercaViewController()
        //Configuro lo stato della view con il Preventivo
        RicercaArticoliView.Stato = "Preventivo"
        //Visualizzo la View Controller
        self.present(RicercaArticoliView, animated: true, completion: nil)
    }

    //Funzione per la ricerca del Cliente
    @objc func RicercaCliente(sender: UIButton!) {
        //Istanzio la view controller per la ricerca del cliente
        let RicercaClienteView = ClienteViewController()
        //Configuro la view controller nello stato di inserimento
        RicercaClienteView.stato = ModalitaCliente.Inserisci
        //Visualizzo la ViewController
        self.present(RicercaClienteView, animated: true, completion: nil)
    }

    //Funzione che ritorna alla schermata precedente
    @objc func Return(sender: UIButton!) {
        let Cantieri = TabBarViewController()
        self.present(Cantieri, animated: true, completion: nil)
    }

}

