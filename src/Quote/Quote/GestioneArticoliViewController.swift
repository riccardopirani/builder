
//  GestioneArticoli.swift
//  Quote
//
//  Created by riccardo on 24/04/18.
//  Copyright © 2018 ViewSoftware. All rights reserved.
//

import UIKit

//ViewController per la gestione degli articoli in cantiere
class GestioneArticoliViewController: UIViewController, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource
{
    //Variabile che rappresenta il cantiere e L'articolo Selezionato
    public var CantiereInterno: Cantiere!
    public var ArticoloSelezionato: ArticoloCantiere!
    private var Extensioni: Extend = Extend()
    private var Rapportino: Bool = false
    //Oggetti Grafici
    private var TipologiaLoad: [TipologiaStruct] = []
    private var TipologiaUIPicker: UIPickerView = UIPickerView()
    private let datePicker: UIDatePicker = UIDatePicker()
    private var labelCodArtINFO: UILabel = UILabel()
    private var labelCodArt: UILabel = UILabel()
    private var labelRapportino: UILabel = UILabel()
    private var labelDescrizioneINFO: UILabel = UILabel()
    private var labelDescrizione: UILabel = UILabel()
    private var labelPrezzoINFO: UILabel = UILabel()
    private var labelPrezzo: UILabel = UILabel()
    private var labelQuantitaINFO: UILabel = UILabel()
    private var txtQuantita: UITextField = UITextField()
    private var labelDataINFO: UILabel = UILabel()
    private var SwitchRapportino: UISwitch = UISwitch()
    private var IdTipologia: Int = 0
    /* UiTableView */
    private var ArticoliTableView: UITableView!
    private var ArticoliCantiereLoad: [ArticoloCantiereStruct] = []

    override func viewDidLoad() {

        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        self.view.backgroundColor = UIColor.white
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = "Gestione Articoli"
        //Configurazione label Articoli
        labelCodArtINFO = UILabel(frame: CGRect(x: 20, y: 60, width: 200, height: 21))
        labelCodArtINFO.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        labelCodArtINFO.text = "CodArt: "
        self.view.addSubview(labelCodArtINFO)
        labelCodArt = UILabel(frame: CGRect(x: 100, y: 60, width: 200, height: 21))
        labelCodArt.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        labelCodArt.text = ArticoloSelezionato?.GetCodArt() ?? ".."
        self.view.addSubview(labelCodArt)
        //Configurazione label Descrizione
        labelDescrizioneINFO = UILabel(frame: CGRect(x: 20, y: 100, width: 200, height: 21))
        labelDescrizioneINFO.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        labelDescrizioneINFO.text = "Descrizione: "
        self.view.addSubview(labelDescrizioneINFO)
        labelDescrizione = UILabel(frame: CGRect(x: 120, y: 100, width: 200, height: 21))
        labelDescrizione.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        labelDescrizione.text = ArticoloSelezionato?.GetDescrizione() ?? ".."
        self.view.addSubview(labelDescrizione)
        //Configurazione label Prezzo
        labelPrezzoINFO = UILabel(frame: CGRect(x: 20, y: 140, width: 200, height: 21))
        labelPrezzoINFO.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        labelPrezzoINFO.text = "Prezzo: "
        self.view.addSubview(labelPrezzoINFO)
        labelPrezzo = UILabel(frame: CGRect(x: 120, y: 140, width: 200, height: 21))
        labelPrezzo.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        labelPrezzo.text = "\(ArticoloSelezionato?.GetPrezzo() ?? 0)"
        self.view.addSubview(labelPrezzo)
        //Configurazione label Quantita
        labelQuantitaINFO = UILabel(frame: CGRect(x: 20, y: 180, width: 200, height: 21))
        labelQuantitaINFO.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        labelQuantitaINFO.text = "Quantita: "
        self.view.addSubview(labelQuantitaINFO)
        txtQuantita = UITextField(frame: CGRect(x: 120, y: 180, width: 200, height: 21));
        txtQuantita.backgroundColor = UIColor.lightGray
        txtQuantita.text = "1"
        self.view.addSubview(txtQuantita)
        //Configurazione Data Label
        labelDataINFO = UILabel(frame: CGRect(x: 20, y: 240, width: 200, height: 19))
        labelDataINFO.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        labelDataINFO.text = "Data: "
        self.view.addSubview(labelDataINFO)
        //Configurazione DataPicker
        self.datePicker.frame = CGRect(x: 90, y: 220, width: 300, height: 80)
        self.datePicker.timeZone = NSTimeZone.local
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = UIDatePicker.Mode.date;
        self.view.addSubview(datePicker)
        //Configurazione Bottone inserimento articoli
        let ImageSelezionaArticolo = UIImage(named: "articoli.png") as UIImage?
        let buttonSelezionaArticolo = UIButton()
        buttonSelezionaArticolo.frame = CGRect(x: 150, y: 350, width: 80, height: 80)
        buttonSelezionaArticolo.backgroundColor = UIColor.white
        buttonSelezionaArticolo.setImage(ImageSelezionaArticolo, for: .normal)
        buttonSelezionaArticolo.setTitle("Inserisci Articolo", for: .normal)
        buttonSelezionaArticolo.addTarget(self, action: #selector(RicercaArticolo), for: .touchUpInside)
        self.view.addSubview(buttonSelezionaArticolo)
        //Configurazione Bottone per Inserimento Articolo in Database
        let ImageInserimentoArticolo = UIImage(named: "inserisci.png") as UIImage?
        let buttonInserimentoArticolo = UIButton()
        buttonInserimentoArticolo.frame = CGRect(x: 240, y: 350, width: 80, height: 80)
        buttonInserimentoArticolo.backgroundColor = UIColor.white
        buttonInserimentoArticolo.setImage(ImageInserimentoArticolo, for: .normal)
        buttonInserimentoArticolo.setTitle("Inserisci Articolo", for: .normal)
        buttonInserimentoArticolo.addTarget(self, action: #selector(InserisciArticolo), for: .touchUpInside)
        self.view.addSubview(buttonInserimentoArticolo)
        //Configurazione Bottone Ritorno a Schermata precedente
        let ImageReturn = UIImage(named: "return.png") as UIImage?
        let buttonReturn = UIButton()
        buttonReturn.frame = CGRect(x: 50, y: 350, width: 80, height: 80)
        buttonReturn.backgroundColor = UIColor.white
        buttonReturn.setImage(ImageReturn, for: .normal)
        buttonReturn.setTitle("Go Home", for: .normal)
        buttonReturn.addTarget(self, action: #selector(Return), for: .touchUpInside)
        self.view.addSubview(buttonReturn)
        /* Configurazione TableView  */
        let displayWidth: CGFloat = self.view.frame.width
        ArticoliTableView = UITableView(frame: CGRect(x: 0, y: 430, width: displayWidth, height: self.view.frame.height - 380))
        ArticoliTableView.register(CustomTableViewCellArticolo.self, forCellReuseIdentifier: "MyCell")
        ArticoliTableView.dataSource = self
        ArticoliTableView.delegate = self
        ArticoliTableView.tableFooterView = UIView()
        ArticoliTableView.rowHeight = 80
        ArticoliTableView.layer.borderWidth = 2.0
        self.view.addSubview(ArticoliTableView)
        //Configurazione UISwift per inserimento Articoli in rapportino
        SwitchRapportino = UISwitch(frame: CGRect(x: 300, y: 380, width: 0, height: 0))
        SwitchRapportino.setOn(false, animated: true)
        SwitchRapportino.addTarget(self, action: #selector(RisorseUmaneViewController.switchValueDidChange(sender:)), for: .valueChanged)
        self.view.addSubview(SwitchRapportino)
        //UILabel rapportino
        labelRapportino = UILabel(frame: CGRect(x: 290, y: 350, width: 200, height: 21))
        labelRapportino.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        labelRapportino.text = "Rapportino: "
        self.view.addSubview(labelRapportino)
        //Configurazione UIPickerView Articolo
        let label = UILabel(frame: CGRect(x: (self.view.frame.width / 2) - 170, y: 310, width: 90, height: 24))
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        label.textAlignment = .center
        label.text = "Tipologia: "
        self.view.addSubview(label)
        //Configurazione :impostazioni picker view
        self.TipologiaUIPicker = UIPickerView(frame: CGRect(x: (self.view.frame.width / 2) - 70, y: 300, width: 200, height: 50))
        self.TipologiaUIPicker.delegate = self
        self.TipologiaUIPicker.dataSource = self
        self.TipologiaUIPicker.backgroundColor = UIColor.white
        self.view.addSubview(TipologiaUIPicker)
        /* carico gli aritcoli del cantiere e le tipologie */
        CaricaArticoliCantiere()
        CaricaTipologie()
        SwitchRapportino.isHidden = false
        labelRapportino.isHidden = false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    //Funzione che permette di tornare alla schermata precedente
    @objc func Return(sender: UIButton!) {
        let CantiereSelezionato = GestioneCantieriViewController(CantiereSet: CantiereInterno!)
        self.present(CantiereSelezionato, animated: true, completion: nil)
    }

    //Funzione che effettua la ricerca di un articolo
    @objc func RicercaArticolo(sender: UIButton!) {
        let RicercaArticoliView = RicercaViewController()
        RicercaArticoliView.Stato = "Inserimento"
        RicercaArticoliView.Cantiere = CantiereInterno
        self.present(RicercaArticoliView, animated: true, completion: nil)
    }

    //Funzione per il caricamento tipologie articoli
    func CaricaTipologie()
    {
        let atemp = ArticoloCantiere(Cantiere: CantiereInterno)
        atemp.CaricaTipologieArticoli(completion: { result in
            DispatchQueue.main.async
            {
                self.TipologiaLoad = result
                self.TipologiaUIPicker.reloadAllComponents()
                self.TipologiaUIPicker.updateConstraints()
            }
        });
    }

    //Metodo delegato che ritorna il numero di righe
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return TipologiaLoad.count
    }

    // Metodo delegato che ritorna il valore mostrato nella riga
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        IdTipologia = TipologiaLoad[row].IdTipologiaPreventivo
        return TipologiaLoad[row].NomeTipologia
    }

    // Metodo deleta5o quando viene selezionata una righa della UiPickerView delle tipologie
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        IdTipologia = TipologiaLoad[row].IdTipologiaPreventivo!
    }

    //Number of Columns into UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }


    //Funzione per l'inserimento di un articolo
    @objc func InserisciArticolo(sender: UIButton!)
    {
        /* Prima di inserire l'articolo devo verificare che la quantita inserita sia corretta */
        if(txtQuantita.text?.CheckIsFloat == true && (self.ArticoloSelezionato) != nil)
        {
            DispatchQueue.main.async
            {

                let PrezzoNoConv = self.self.txtQuantita.text

                if let PrezzoNoConv = PrezzoNoConv
                {

                    let Prezzotxt = Double(PrezzoNoConv)
                    self.ArticoloSelezionato.DataInserimento = self.Extensioni.CastFromDateToString_SqlServer_DateTime(mydate: self.datePicker.date)
                    self.ArticoloSelezionato.Quantita = Prezzotxt

                    self.ArticoloSelezionato.InserimentoArticoloCantiere(IdTipologia: self.IdTipologia, Rapportino: self.Rapportino, completion: { result in

                        if(result == true)
                        {
                            self.CaricaArticoliCantiere()
                        }
                        else
                        {
                            print("Errore inserimento")
                        }
                    })
                }
                else {
                    print("Formato quantita non corretto")
                }
            }
        }

        else {
            let alertController = UIAlertController(title: "Errore", message: "Verifica di aver compilato correttamente i campi!", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    //Ritorna il numero di articoli presenti in un array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArticoliCantiereLoad.count
    }

    //Genera le per la UiTableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.beginUpdates()
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! CustomTableViewCellArticolo
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.masksToBounds = true
        cell.labCodArt.text = "CodArt: \(ArticoliCantiereLoad[indexPath.row].CodArt!)  Prezzo: \(ArticoliCantiereLoad[indexPath.row].Prezzo!)"
        cell.labDescrizione.text = "Quantità: \(ArticoliCantiereLoad[indexPath.row].Quantita!) -- Desc: \(ArticoliCantiereLoad[indexPath.row].Descrizione!)"
        cell.labPrezzo.text = " "
        tableView.endUpdates()
        return cell
    }

    //Carica gli articoli presenti in un cantiere
    func CaricaArticoliCantiere()
    {
        let atemp = ArticoloCantiere(Cantiere: CantiereInterno)
        atemp.CaricaArticoliCantiere(completion: { result in

            DispatchQueue.main.async
            {
                self.ArticoliCantiereLoad.removeAll()
                self.ArticoliCantiereLoad = result
                self.ArticoliTableView.reloadData()
            }

        });
    }

    //Permette di inseriro l'articolo o meno in un rapportino
    @objc func switchValueDidChange(sender: UISwitch!)
    {
        if (sender.isOn == true) {
            Rapportino = true
        }
        else {
            Rapportino = false
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
        let ArticoloDelete = ArticoloCantiere(SetArticoloCantiere: ArticoliCantiereLoad[indexPath.row], Cantiere: CantiereInterno)

        ArticoloDelete.EliminaArticolo(completion: { result in

            if(result == true)
            {
                self.CaricaArticoliCantiere()
            }
            else
            { let alertController = UIAlertController(title: "Errore", message: "Eliminazione Articolo non riuscita", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
            }
        })

    }
}

