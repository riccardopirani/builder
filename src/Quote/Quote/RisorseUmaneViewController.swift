//
//  RisorseUmaneViewController.swift
//  Quote
//
//  Created by riccardo on 10/04/18.
//  Copyright © 2018 ViewSoftware. All rights reserved.
//

import UIKit

//Classe che rappresenta una Risorsa Umana
class RisorseUmaneViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource
{
    //Dichiarazione Oggetti
    //L'array User contiene le informazione su tutti gli utenti presenti nel database
    private var UserLoad: [UserStruct] = []
    private var RisorseUmaneUIPicker: UIPickerView = UIPickerView()
    private let datePicker: UIDatePicker = UIDatePicker()
    private let StartPicker: UIDatePicker = UIDatePicker()
    private let EndPicker: UIDatePicker = UIDatePicker()
    private let PausaPicker: UIDatePicker = UIDatePicker()
    private var textView: UITextView = UITextView()
    private var RisoseUmaneTableView: UITableView!
    private var RisorseUmaneLoad: [RisorsaUmanaStruct] = []
    private var SwitchRapportino: UISwitch = UISwitch()
    private var TipologiaLoad: [TipologiaStruct] = []
    private var TipologiaUIPicker: UIPickerView = UIPickerView()
    //L'oggetto RisorsaUmana Rappresenta la risorsa che verrà inserita
    public var Cantiere: Cantiere?
    private var RisorsaSelezionata: RisorsaUmana?
    private var Extensioni: Extend = Extend()
    public var Stato: String = "Inserimento"
    private var RisorsaRapportino: Bool = false;
    private var IdTipologia: Int = 0

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        self.view.backgroundColor = UIColor.white
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = "Risorse Umane"
        InitRisorseUmaneViewController();
        //Modifica UiPickerView delle Risorse con l'utente che ha effettuato il login
        print("Login di : \(UserLoginDefault.Username)")
        selectPicker(withText: UserLoginDefault.Username)

    }

    //Funzione di Configurazione Iniziale della View
    private func InitRisorseUmaneViewController() {

        //inizializzo il Cantiere
        let displayWidth: CGFloat = self.view.frame.width
        //Carico le Risorse
        CaricaRisorse()
        //Configurazione Label Risorsa
        let label = UILabel(frame: CGRect(x: (self.view.frame.width / 2) - 150, y: 65, width: 90, height: 24))
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        label.textAlignment = .center
        label.text = "Risorsa: "
        self.view.addSubview(label)
        //Configurazione :impostazioni picker view
        self.RisorseUmaneUIPicker = UIPickerView(frame: CGRect(x: (self.view.frame.width / 2) - 70, y: 50, width: 200, height: 50))
        self.RisorseUmaneUIPicker.delegate = self
        self.RisorseUmaneUIPicker.dataSource = self
        self.RisorseUmaneUIPicker.backgroundColor = UIColor.white
        self.view.addSubview(RisorseUmaneUIPicker)
        //Configuro il DataTime Picker per la data
        self.datePicker.frame = CGRect(x: 10, y: 100, width: self.view.frame.width, height: 80)
        self.datePicker.timeZone = NSTimeZone.local
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = UIDatePicker.Mode.date;
        //Aggiunto un evento quando viene modificato il valore del datePicker
        self.datePicker.addTarget(self, action: #selector(RisorseUmaneViewController.datePickerValueChanged(_:)), for: .valueChanged)
        self.view.addSubview(datePicker)
        //Congiurazione Ore di Inizio e Fine
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let dateStart = dateFormatter.date(from: "08:00")
        let dateEnd = dateFormatter.date(from: "17:30")
        let datePausa = dateFormatter.date(from: "01:30")
        //Configuro il DataPicker di Start
        self.StartPicker.frame = CGRect(x: (self.view.frame.width / 2) - 90, y: 190, width: 100, height: 40)
        self.StartPicker.timeZone = NSTimeZone.local
        self.StartPicker.backgroundColor = UIColor.white
        self.StartPicker.datePickerMode = UIDatePicker.Mode.time
        self.StartPicker.date = dateStart!
        self.StartPicker.addTarget(self, action: #selector(RisorseUmaneViewController.SetDataInizio(sender:)), for: .valueChanged)
        self.StartPicker.minuteInterval = 30
        self.view.addSubview(StartPicker)
        //Configuro il DataPicker di End
        self.EndPicker.frame = CGRect(x: (self.view.frame.width / 2) + 60, y: 190, width: 100, height: 40)
        self.EndPicker.timeZone = NSTimeZone.local
        self.EndPicker.backgroundColor = UIColor.white
        self.EndPicker.datePickerMode = UIDatePicker.Mode.time
        self.EndPicker.date = dateEnd!
        self.EndPicker.addTarget(self, action: #selector(RisorseUmaneViewController.SetDataFine(sender:)), for: .valueChanged)
        self.EndPicker.minuteInterval = 30
        self.view.addSubview(EndPicker)
        //Configuro il DataPicker di Pausa
        self.PausaPicker.frame = CGRect(x: (self.view.frame.width / 2) - 30, y: 250, width: 100, height: 40)
        self.PausaPicker.timeZone = NSTimeZone.local
        self.PausaPicker.backgroundColor = UIColor.white
        self.PausaPicker.datePickerMode = UIDatePicker.Mode.time
        self.PausaPicker.date = datePausa!
        self.PausaPicker.addTarget(self, action: #selector(RisorseUmaneViewController.SetPausa(sender:)), for: .valueChanged)
        self.PausaPicker.minuteInterval = 30
        self.view.addSubview(PausaPicker)
        //Configurazione Testo TextView
        self.textView = UITextView(frame: CGRect(x: 0, y: 370, width: displayWidth, height: 85))
        self.automaticallyAdjustsScrollViewInsets = false
        textView.font = UIFont(name: "HelveticaNeue-Bold", size: 18.0)
        textView.textAlignment = NSTextAlignment.justified
        textView.textColor = UIColor.blue
        textView.backgroundColor = UIColor.lightGray
        self.view.addSubview(textView)
        //Bottone per inserimento:
        let ImageInserisci = UIImage(named: "inserisci.png") as UIImage?
        let ButtonInserisciRisorsaUmana = UIButton()
        ButtonInserisciRisorsaUmana.frame = CGRect(x: (self.view.frame.width / 2) - 180, y: 465, width: 80, height: 80)
        ButtonInserisciRisorsaUmana.setImage(ImageInserisci, for: .normal)
        ButtonInserisciRisorsaUmana.setTitleColor(UIColor.black, for: .normal)
        ButtonInserisciRisorsaUmana.set(image: ImageInserisci, attributedTitle: NSAttributedString(string: "Inserisci"), at: UIButton.Position(rawValue: 1)!, width: 30, state: UIControl.State.normal)
        ButtonInserisciRisorsaUmana.addTarget(self, action: #selector(InserisciRisorsaButtonAction), for: .touchUpInside)
        self.view.addSubview(ButtonInserisciRisorsaUmana)
        //Bottone per tornare a schermata principale
        let ImageReturn = UIImage(named: "return.png") as UIImage?
        let buttonReturn = UIButton()
        buttonReturn.frame = CGRect(x: (self.view.frame.width / 2) - 80, y: 465, width: 80, height: 80)
        buttonReturn.backgroundColor = UIColor.white
        buttonReturn.setImage(ImageReturn, for: .normal)
        buttonReturn.setTitle("Go Home", for: .normal)
        buttonReturn.addTarget(self, action: #selector(Return), for: .touchUpInside)
        self.view.addSubview(buttonReturn)
        //Configuro lo UISwitch per l'inserimento delle risorse nel cantiere
        let labelRapportino = UILabel(frame: CGRect(x: (self.view.frame.width / 2) + 30, y: 465, width: 130, height: 21))
        labelRapportino.text = "Rapportino?"
        labelRapportino.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        self.view.addSubview(labelRapportino)
        SwitchRapportino = UISwitch(frame: CGRect(x: (self.view.frame.width / 2) + 50, y: 500, width: 0, height: 0))
        SwitchRapportino.setOn(false, animated: true)
        SwitchRapportino.addTarget(self, action: #selector(RisorseUmaneViewController.switchValueDidChange(sender:)), for: .valueChanged)
        self.view.addSubview(SwitchRapportino)

        //Stato Inserimento: l'utente sta inserendo delle risorse dentro una cantiere
        if(Stato == "Inserimento")
        {
            RisorsaSelezionata = RisorsaUmana(CantiereInterno: Cantiere!)
            //Configurazione table view
            RisoseUmaneTableView = UITableView(frame: CGRect(x: 0, y: 570, width: displayWidth, height: self.view.frame.height - 500))
            RisoseUmaneTableView.register(CustomTableViewCellArticolo.self, forCellReuseIdentifier: "MyCell")
            RisoseUmaneTableView.dataSource = self
            RisoseUmaneTableView.delegate = self
            RisoseUmaneTableView.tableFooterView = UIView()
            RisoseUmaneTableView.rowHeight = 60
            RisoseUmaneTableView.layer.borderWidth = 2.0
            self.view.addSubview(RisoseUmaneTableView)
            //Carica Le risorse Umane e chiamo i Metodi di configurazione
            CaricaRisorseCantiere()
            //Configurazione UIPickerView Tipologia
            let labelTipologia = UILabel(frame: CGRect(x: (self.view.frame.width / 2) - 170, y: 310, width: 90, height: 24))
            labelTipologia.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
            labelTipologia.textAlignment = .center
            labelTipologia.text = "Tipologia: "
            self.view.addSubview(labelTipologia)
            //Configurazione :impostazioni picker view
            self.TipologiaUIPicker = UIPickerView(frame: CGRect(x: (self.view.frame.width / 2) - 70, y: 300, width: 200, height: 50))
            self.TipologiaUIPicker.delegate = self
            self.TipologiaUIPicker.dataSource = self
            self.TipologiaUIPicker.backgroundColor = UIColor.white
            self.view.addSubview(TipologiaUIPicker)
        }
        SetPausa(sender: PausaPicker)
        SetDataInizio(sender: StartPicker)
        SetDataFine(sender: EndPicker)
        datePickerValueChanged(datePicker)
        SwitchRapportino.isHidden = false
        labelRapportino.isHidden = false
        CaricaTipologie()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //Selezione dello username in base al valore passato per valore
    func selectPicker(withText text: String)
    {
        let sub = text.lowercased()
        if let index = self.UserLoad.firstIndex(where: { $0.Username.lowercased() == sub })
        {
            print("Indice di riga: \(index)")
            RisorseUmaneUIPicker.selectRow(index, inComponent: 0, animated: true)
        }
        else {
            print("testo non trovato")
        }
    }


    //Funzione per il caricamento tipologie articoli
    func CaricaTipologie()
    {
        let atemp = ArticoloCantiere(Cantiere: Cantiere!)
        atemp.CaricaTipologieArticoli(completion: { result in
            self.TipologiaLoad = result
            self.TipologiaUIPicker.reloadAllComponents()
            self.TipologiaUIPicker.updateConstraints()
        });
    }

    //Funzione per il caricamento delle risorse Umane
    func CaricaRisorse()
    {
        let rtemp = User()
        rtemp.CaricaUtenti(completion: { result in
            self.UserLoad = result
            self.RisorseUmaneUIPicker.reloadAllComponents()
            self.RisorseUmaneUIPicker.updateConstraints()
        });
    }

    @objc func SetPausa(sender: UIDatePicker) {
        RisorsaSelezionata?.SetOrePausa(Pausa: Extensioni.CastFromDateToString_SqlServer_Pausa(mydate: PausaPicker.date))
    }

    @objc func SetDataFine(sender: UIDatePicker) {
        RisorsaSelezionata?.SetOreFine(OreFine: Extensioni.CastFromDateToString_SqlServer_DateTime(mydate: EndPicker.date))
    }
    @objc func SetDataInizio(sender: UIDatePicker) {

        RisorsaSelezionata?.SetOreInizio(OreInizio: Extensioni.CastFromDateToString_SqlServer_DateTime(mydate: StartPicker.date))
    }

    //inserimento di una risorsa umana
    @objc func InserisciRisorsaButtonAction(sender: UIButton!)
    {
        if(textView.text.isEmpty || RisorsaSelezionata?.GetIdUtente() == 0)
        {
            let alertController = UIAlertController(title: title, message: "Attenzione non hai compilato tutti i campi", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {

            RisorsaSelezionata?.SetIdTipologia(IdTipologia: IdTipologia)
            RisorsaSelezionata?.SetDescrizione(Descrizione: textView.text)
            RisorsaSelezionata?.SetRisorsaRapporto(RisorsaRapportino: RisorsaRapportino)
            if(Stato == "Inserimento")
            {

                RisorsaSelezionata?.InserisciRisorsa(completion: { result in

                    if(result == true)
                    {
                        self.CaricaRisorseCantiere()
                    }
                    else
                    {
                        let alertController = UIAlertController(title: "Errore", message: "Non sono riuscito ad inserire la risorsa!", preferredStyle: .alert)
                        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(OKAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                })
            }
        }

    }

    @objc func Return(sender: UIButton!) {
        self.performSegueToReturnBack()
    }

    //Metodo delegato che ritorna il numero di righe
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        if pickerView == RisorseUmaneUIPicker {
            return UserLoad.count
        }
        else {
            return TipologiaLoad.count
        }
    }

    // Metodo delegato che ritorna il valore mostrato nella riga
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if pickerView == RisorseUmaneUIPicker {
            RisorsaSelezionata?.SetIdUtente(IdUtente: UserLoad[row].IdUtente)
            return UserLoad[row].Username
        }
        else {

            IdTipologia = TipologiaLoad[row].IdTipologiaPreventivo
            return TipologiaLoad[row].NomeTipologia
        }
    }

    // Metodo Delato Chiamao quando viene selezionata unarigha
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == RisorseUmaneUIPicker {
            RisorsaSelezionata?.SetIdUtente(IdUtente: UserLoad[row].IdUtente!)
        }
        else {
            IdTipologia = TipologiaLoad[row].IdTipologiaPreventivo!
            RisorsaSelezionata?.SetIdTipologia(IdTipologia: IdTipologia)
        }
    }

    //Number of Columns into UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    //this func get select Date from UIDatePicker
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {

        RisorsaSelezionata?.SetData(Data: Extensioni.CastFromDateToString_SqlServer_DateTime(mydate: sender.date))
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RisorseUmaneLoad.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        RisoseUmaneTableView.beginUpdates()
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! CustomTableViewCellArticolo
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.masksToBounds = true
        cell.labCodArt.text = RisorseUmaneLoad[indexPath.row].Risorsa
        cell.labDescrizione.text = RisorseUmaneLoad[indexPath.row].Descrizione
        cell.labPrezzo.text = ""
        RisoseUmaneTableView.endUpdates()
        return cell
    }

    //Caricamento risorse in un cantiere
    func CaricaRisorseCantiere()
    {
        if(Stato == "Inserimento")
        {
            let rtemp = RisorsaUmana(CantiereInterno: Cantiere!)
            rtemp.CaricaRisorseUmaneCantiere(completion: { result in
                self.RisorseUmaneLoad.removeAll()
                self.RisorseUmaneLoad = result
                DispatchQueue.main.async {
                    self.RisoseUmaneTableView.reloadData()
                }
            });
        }
    }

    //Switch utilizzato per switchare su un UiSwitch sul rapportino
    @objc func switchValueDidChange(sender: UISwitch!)
    {
        if (sender.isOn == true) {
            RisorsaRapportino = true
        }
        else {
            RisorsaRapportino = false
        }
    }

    //Abilita la possbilità di editare UiTableView
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    //Funzione di elminazione delle UiTableViewCell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { /*Istruzione diversa da eliminazione*/ return }
        //Eliminaizone  row
        let risorsadelete = RisorsaUmana(IdRisorsaUmana: RisorseUmaneLoad[indexPath.row].IdRisorseUmane, CantiereInterno: Cantiere!)

        risorsadelete.EliminaRisorsaCantiere(completion: { result in

            if(result == true)
            {
                self.CaricaRisorseCantiere()
            }
            else
            { let alertController = UIAlertController(title: "Errore", message: "Eliminazione Risorsa non riuscita", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
            }
        })

    }
}

