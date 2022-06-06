//
//  NoleggiViewController.swift
//  Quote
//
//  Created by riccardo on 28/11/2019.
//  Copyright © 2019 ViewSoftware. All rights reserved.
//

import UIKit


//Classe che rappresenta la view dei noleggi
class NoleggiViewController: UIViewController, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource
{
    //Variabili che verrano utilizzate nella view dei cantierie
    public var CantiereInterno: Cantiere!
    private var ExtraPreventivo: Int = 0
    private var Data: String = ""
    private var RagioneSociale: String = ""
    private var Costo: String = ""
    //IdTipologia selezionata nell'UiPickerView
    private var IdTipologia: Int = 0
    //La variabile Extensioni si occupa di effettuare il check dei valori
    private var Extensioni: Extend = Extend()
    //Componenti UI
    private var labelTipoMezzo: UILabel = UILabel()
    private var txtTipoMezzo: UITextField = UITextField()
    private var labelMatricola: UILabel = UILabel()
    private var txtMatricola: UITextField = UITextField()
    private var labelTrasporto: UILabel = UILabel()
    private var txtTrasporto: UITextField = UITextField()
    private var labelCostoNoleggio: UILabel = UILabel()
    private var txtCostoNoleggio: UITextField = UITextField()
    private var labelData: UILabel = UILabel()
    private let datePicker: UIDatePicker = UIDatePicker()
    private var labelDataTermine: UILabel = UILabel()
    private let datePickerTermine: UIDatePicker = UIDatePicker()
    private var TipologiaLoad: [TipologiaStruct] = []
    private var TipologiaUIPicker: UIPickerView = UIPickerView()
    private var NoleggiTableView: UITableView!
    private var NoleggiCantiereLoad: [NoleggioStruct] = []


    override func viewDidLoad() {

        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        self.view.backgroundColor = UIColor.white
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = "Noleggi"
        //Configurazione UILabel per il tipo mezzo
        labelTipoMezzo = UILabel(frame: CGRect(x: 20, y: 60, width: 200, height: 21))
        labelTipoMezzo.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        labelTipoMezzo.text = "Tipo Mezzo: "
        self.view.addSubview(labelTipoMezzo)
        //Configurazione UITextField per tipo mezzo
        txtTipoMezzo = UITextField(frame: CGRect(x: 200, y: 60, width: 140, height: 21));
        txtTipoMezzo.backgroundColor = UIColor.lightGray
        txtTipoMezzo.text = ""
        self.view.addSubview(txtTipoMezzo)
        //Configurazione UILabel matricola
        labelMatricola = UILabel(frame: CGRect(x: 20, y: 100, width: 200, height: 21))
        labelMatricola.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        labelMatricola.text = "Matricola: "
        self.view.addSubview(labelMatricola)
        //Configurazione UITextField matricola
        txtMatricola = UITextField(frame: CGRect(x: 200, y: 100, width: 140, height: 21));
        txtMatricola.backgroundColor = UIColor.lightGray
        txtMatricola.text = ""
        self.view.addSubview(txtMatricola)
        //Configurazione UILabel matricola
        labelTrasporto = UILabel(frame: CGRect(x: 20, y: 140, width: 200, height: 21))
        labelTrasporto.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        labelTrasporto.text = "Trasporto: "
        self.view.addSubview(labelTrasporto)
        //Configurazione UITextField matricola
        txtTrasporto = UITextField(frame: CGRect(x: 200, y: 140, width: 140, height: 21));
        txtTrasporto.backgroundColor = UIColor.lightGray
        txtTrasporto.text = ""
        self.view.addSubview(txtTrasporto)
        //Configurazione UILabel costo noleggio
        labelCostoNoleggio = UILabel(frame: CGRect(x: 20, y: 200, width: 200, height: 21))
        labelCostoNoleggio.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        labelCostoNoleggio.text = "Costo Noleggio: "
        self.view.addSubview(labelCostoNoleggio)
        //Configurazione UITextField noleggio
        txtCostoNoleggio = UITextField(frame: CGRect(x: 200, y: 200, width: 140, height: 21));
        txtCostoNoleggio.backgroundColor = UIColor.lightGray
        txtCostoNoleggio.text = ""
        self.view.addSubview(txtCostoNoleggio)
        //Configurazione UILabel data inizio noleggio
        labelData = UILabel(frame: CGRect(x: 20, y: 260, width: 200, height: 21))
        labelData.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        labelData.text = "Data Inizio: "
        self.view.addSubview(labelData)
        //Configurazione DataPicker data inizio noleggio
        self.datePicker.frame = CGRect(x: 140, y: 240, width: 250, height: 80)
        self.datePicker.timeZone = NSTimeZone.local
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = UIDatePicker.Mode.date;
        self.view.addSubview(datePicker)
        //Configurazione UILabel data termine noleggio
        labelDataTermine = UILabel(frame: CGRect(x: 20, y: 320, width: 200, height: 21))
        labelDataTermine.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        labelDataTermine.text = "Data Termine: "
        self.view.addSubview(labelDataTermine)
        //Configurazione DataPicker data termine noleggio
        self.datePickerTermine.frame = CGRect(x: 140, y: 300, width: 250, height: 80)
        self.datePickerTermine.timeZone = NSTimeZone.local
        self.datePickerTermine.backgroundColor = UIColor.white
        self.datePickerTermine.datePickerMode = UIDatePicker.Mode.date;
        self.view.addSubview(datePickerTermine)
        //Configurazione UIPickerView Tipologia
        let labelTipologia = UILabel(frame: CGRect(x: 20, y: 390, width: 200, height: 21))
        labelTipologia.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        labelTipologia.textAlignment = .left
        labelTipologia.text = "Tipologia:"
        self.view.addSubview(labelTipologia)
        //Configurazione della UiPickerView
        self.TipologiaUIPicker = UIPickerView(frame: CGRect(x: 150, y: 380, width: 200, height: 50))
        self.TipologiaUIPicker.delegate = self
        self.TipologiaUIPicker.dataSource = self
        self.TipologiaUIPicker.backgroundColor = UIColor.gray
        self.view.addSubview(TipologiaUIPicker)
        //Configurazione bottone per inserimento di un articolo in db
        let ImageInserimento = UIImage(named: "add-button.png") as UIImage?
        let buttonInserimento = UIButton()
        buttonInserimento.frame = CGRect(x: 240, y: 420, width: 80, height: 80)
        buttonInserimento.backgroundColor = UIColor.clear
        buttonInserimento.setImage(ImageInserimento, for: .normal)
        buttonInserimento.setTitle("Inserisci Articolo", for: .normal)
        buttonInserimento.addTarget(self, action: #selector(InserimentoNoleggio), for: .touchUpInside)
        self.view.addSubview(buttonInserimento)
        //Configurazione Bottone Ritorno a Schermata precedente
        let ImageReturn = UIImage(named: "return.png") as UIImage?
        let buttonReturn = UIButton()
        buttonReturn.frame = CGRect(x: 50, y: 420, width: 80, height: 80)
        buttonReturn.backgroundColor = UIColor.white
        buttonReturn.setImage(ImageReturn, for: .normal)
        buttonReturn.setTitle("Go Home", for: .normal)
        buttonReturn.addTarget(self, action: #selector(Return), for: .touchUpInside)
        self.view.addSubview(buttonReturn)
        /* Configurazione TableView  */
        let displayWidth: CGFloat = self.view.frame.width
        NoleggiTableView = UITableView(frame: CGRect(x: 0, y: 500, width: displayWidth, height: self.view.frame.height - 380))
        NoleggiTableView.register(CustomTableViewCellArticolo.self, forCellReuseIdentifier: "MyCell")
        NoleggiTableView.dataSource = self
        NoleggiTableView.delegate = self
        NoleggiTableView.tableFooterView = UIView()
        NoleggiTableView.rowHeight = 80
        NoleggiTableView.layer.borderWidth = 2.0
        self.view.addSubview(NoleggiTableView)
        NoleggiTableView.isHidden = false

        //Eseguo il caricamento dei ristoranti
        Caricamento()
        CaricaTipologie()
        //Inizializzo l'IdTipologia con la prima tipologia caricata
        //IdTipologia = TipologiaLoad[0].IdTipologiaPreventivo!

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    //Funzione che viene eseguita per tornare alla schermata precedente
    @objc func Return(sender: UIButton!) {
        let CantiereSelezionato = GestioneCantieriViewController(CantiereSet: CantiereInterno!)
        self.present(CantiereSelezionato, animated: true, completion: nil)
    }

    //Funzione per il caricamento tipologie articoli
    func CaricaTipologie()
    {
        let atemp = ArticoloCantiere(Cantiere: CantiereInterno!)
        atemp.CaricaTipologieArticoli(completion: { result in
            self.TipologiaLoad = result
            self.IdTipologia = self.TipologiaLoad[0].IdTipologiaPreventivo!
            self.TipologiaUIPicker.reloadAllComponents()
            self.TipologiaUIPicker.updateConstraints()
        });
    }


    //Metodo delegato che ritorna il numero di righe
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return TipologiaLoad.count
    }

    // Metodo delegato che ritorna il valore mostrato nella riga
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return TipologiaLoad[row].NomeTipologia
    }

    // Metodo deleta5o quando viene selezionata una righa della UiPickerView delle tipologie
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        IdTipologia = TipologiaLoad[row].IdTipologiaPreventivo!
    }


    //Funzione che esegue la view controller per la ricerca dell'articolo
    @objc func RicercaArticolo(sender: UIButton!) {
        let RicercaArticoliView = RicercaViewController()
        RicercaArticoliView.Stato = "Inserimento"
        RicercaArticoliView.Cantiere = CantiereInterno
        self.present(RicercaArticoliView, animated: true, completion: nil)
    }


    //Number of Columns into UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }


    //Funzione per l'inserimento di un ristorante
    @objc func InserimentoNoleggio(sender: UIButton!) {

        //Instanzione la variabile del noleggio
        let noleggio = Noleggio(Cantiere: CantiereInterno)
        // Prima di inserimento di un noleggio che i parametri siano compilati correttamente
        if(((txtTrasporto.text?.CheckIsFloat)! == true) && (txtTipoMezzo.text?.count)! > 0 && (txtMatricola.text?.count)! > 0)
        {
                //Recupero la data inizio e fine dal DataPicker
                let datainizio = self.Extensioni.CastFromDateToString_SqlServer_DateTime(mydate: self.datePicker.date)
                let datafine = self.Extensioni.CastFromDateToString_SqlServer_DateTime(mydate: self.datePickerTermine.date)
                //Recupero l'id del fornitore
                let IdFonitore = self.IdTipologia
                let CostoTrasporto = (self.txtTrasporto.text! as NSString).floatValue
                //Effettuo l'inserimento nel db
                noleggio.Inserisci(IdFornitore: IdFonitore, ExtraPreventivo: 0, TipoMezzo: self.txtTipoMezzo.text!, Matricola: self.txtMatricola.text!, Trasporto: CostoTrasporto, CostoNoleggio: CostoTrasporto, DataInizioNoleggio: datainizio, DataTermineNoleggio: datafine, completion: { result in


                    //Creo una coda asincrona
                    DispatchQueue.main.async
                    {
                    if(result == true)
                    {
                        self.Caricamento()
                    }
                    else
                    {
                        let alertController = UIAlertController(title: "Errore", message: "Inserimento non riuscito", preferredStyle: .alert)
                        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(OKAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    }
                })

            
        }

        else {
            let alertController = UIAlertController(title: "Errore", message: "Verifica di aver compilato correttamente i campi!", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

//Conteggio del numero di ristoranti presenti nell'array dei ristoranti caricati
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("\n Noleggi caricati: \(NoleggiCantiereLoad.count) \n")
        return NoleggiCantiereLoad.count
    }

//Visualizzazione dei valori nell'UITableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.beginUpdates()
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! CustomTableViewCellArticolo
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.masksToBounds = true
        cell.labCodArt.text = "Tipo Mezzo: \(NoleggiCantiereLoad[indexPath.row].TipoMezzo!)"
        cell.labDescrizione.text = "Data inizio: \(NoleggiCantiereLoad[indexPath.row].DataInizioNoleggio!)"
        cell.labPrezzo.text = " "
        tableView.endUpdates()
        return cell
    }



//Funzione che effettua il caricamento dei ristoranti nell'UITableView
    func Caricamento()
    {
        let rtemp = Noleggio(Cantiere: CantiereInterno)
        rtemp.Carica(completion: { result in

            self.NoleggiCantiereLoad.removeAll()
            self.NoleggiCantiereLoad = result
            DispatchQueue.main.async {
                self.NoleggiTableView.reloadData()
            }
        });
    }


//Abilita la possbilità di editare UiTableView
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

//Funzione di elminazione delle UiTableViewCell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { /*Istruzione diversa da eliminazione*/ return }
        //Eliminaizone  row
        let del = Noleggio(SetNoleggio: NoleggiCantiereLoad[indexPath.row], Cantiere: CantiereInterno)

        del.Elimina(completion: { result in

            if(result == true)
            {
                self.Caricamento()
            }
            else
            {
                let alertController = UIAlertController(title: "Errore", message: "Eliminazione noleggio non riuscita", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
            }
        })
    }
}


