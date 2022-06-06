//
//  RistornatiViewController.swift
//  Quote
//
//  Created by riccardo on 20/11/2019.
//  Copyright © 2019 ViewSoftware. All rights reserved.
//

import UIKit


//Classe che rappresenta la view dei ristoranti
class RistorantiViewController: UIViewController, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource
{
    //Variabili che verrano utilizzate nella view dei cantierie
    public var CantiereInterno: Cantiere!
    private var ExtraPreventivo: Int = 0
    private var Data: String = ""
    private var RagioneSociale: String = ""
    private var Costo: String = ""
    //La variabile Extensioni si occupa di effettuare il check dei valori
    private var Extensioni: Extend = Extend()
    //Componenti UI
    private var labelRagioneSociale: UILabel = UILabel()
    private var txtRagioneSociale: UITextField = UITextField()
    private var RistorantiTableView: UITableView!
    private var RistorantiCantiereLoad: [RistoranteStruct] = []
    private var labelCosto: UILabel = UILabel()
    private var txtCosto: UITextField = UITextField()
    private var labelData: UILabel = UILabel()
    private let datePicker: UIDatePicker = UIDatePicker()

    override func viewDidLoad() {

        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        self.view.backgroundColor = UIColor.white
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = "Ristoranti"
        //Configurazione UILabel ragione sociale ristorante
        labelRagioneSociale = UILabel(frame: CGRect(x: 20, y: 60, width: 200, height: 21))
        labelRagioneSociale.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        labelRagioneSociale.text = "Ragione Sociale: "
        self.view.addSubview(labelRagioneSociale)
        //Configurazione UITextField per ragione sociale
        txtRagioneSociale = UITextField(frame: CGRect(x: 200, y: 60, width: 140, height: 21));
        txtRagioneSociale.backgroundColor = UIColor.lightGray
        txtRagioneSociale.text = ""
        self.view.addSubview(txtRagioneSociale)
        //Configurazione UILabel costo
        labelCosto = UILabel(frame: CGRect(x: 20, y: 160, width: 200, height: 21))
        labelCosto.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        labelCosto.text = "Costo: "
        self.view.addSubview(labelCosto)
        //Configurazione UITextField costo
        txtCosto = UITextField(frame: CGRect(x: 200, y: 160, width: 140, height: 21));
        txtCosto.backgroundColor = UIColor.lightGray
        txtCosto.text = ""
        self.view.addSubview(txtCosto)
        //Configurazione UILabel data
        labelData = UILabel(frame: CGRect(x: 20, y: 260, width: 200, height: 21))
        labelData.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        labelData.text = "Data: "
        self.view.addSubview(labelData)
        //Configurazione DataPicker
        self.datePicker.frame = CGRect(x: 140, y: 240, width: 250, height: 80)
        self.datePicker.timeZone = NSTimeZone.local
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = UIDatePicker.Mode.date;
        self.view.addSubview(datePicker)

        //Configurazione bottone per inserimento di un articolo in db
        let ImageInserimento = UIImage(named: "add-button.png") as UIImage?
        let buttonInserimento = UIButton()
        buttonInserimento.frame = CGRect(x: 240, y: 350, width: 80, height: 80)
        buttonInserimento.backgroundColor = UIColor.white
        buttonInserimento.setImage(ImageInserimento, for: .normal)
        buttonInserimento.setTitle("Inserisci Articolo", for: .normal)
        buttonInserimento.addTarget(self, action: #selector(InserisciRistorante), for: .touchUpInside)
        self.view.addSubview(buttonInserimento)

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
        RistorantiTableView = UITableView(frame: CGRect(x: 0, y: 430, width: displayWidth, height: self.view.frame.height - 380))
        RistorantiTableView.register(CustomTableViewCellArticolo.self, forCellReuseIdentifier: "MyCell")
        RistorantiTableView.dataSource = self
        RistorantiTableView.delegate = self
        RistorantiTableView.tableFooterView = UIView()
        RistorantiTableView.rowHeight = 80
        RistorantiTableView.layer.borderWidth = 2.0
        self.view.addSubview(RistorantiTableView)

        //Eseguo il caricamento dei ristoranti
        CaricamentoRistoranti()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    @objc func Return(sender: UIButton!) {
        let CantiereSelezionato = GestioneCantieriViewController(CantiereSet: CantiereInterno!)
        self.present(CantiereSelezionato, animated: true, completion: nil)
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
    @objc func InserisciRistorante(sender: UIButton!) {

        //Instanzione la variabile ristorante
        let ristorante = Ristorante(Cantiere: CantiereInterno)
        /* Prima di inserire il ristorante devo verificare i campi inseriti */

        if(txtCosto.text?.CheckIsFloat == true && txtRagioneSociale.text?.count ?? 0 > 0)
        {
            DispatchQueue.main.async
            {

                //Recupero la data dal DataPicker
                let data = self.Extensioni.CastFromDateToString_SqlServer_DateTime(mydate: self.datePicker.date)
                //Effettuo l'inserimento nel db
                ristorante.Inserisci(Data: data, RagioneSociale: self.txtRagioneSociale.text!, Costo: self.txtCosto.text!, completion: { result in

                    if(result == true)
                    {
                        self.CaricamentoRistoranti()
                    }
                    else
                    {
                        let alertController = UIAlertController(title: "Errore", message: "Inserimento non riuscito", preferredStyle: .alert)
                        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(OKAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                })

            }
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
        return RistorantiCantiereLoad.count
    }

    //Visualizzazione dei valori nell'UITableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.beginUpdates()
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! CustomTableViewCellArticolo
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.masksToBounds = true
        cell.labCodArt.text = "Ragione Sociale: \(RistorantiCantiereLoad[indexPath.row].RagioneSociale!)     Costo: \(RistorantiCantiereLoad[indexPath.row].Costo!)"
        cell.labDescrizione.text = "Data: \(RistorantiCantiereLoad[indexPath.row].Data!)"
        cell.labPrezzo.text = " "
        tableView.endUpdates()
        return cell
    }


    //Conteggio del numero di valore presenti nel picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        1
    }

    //Funzione che effettua il caricamento dei ristoranti nell'UITableView
    func CaricamentoRistoranti()
    {
        let rtemp = Ristorante(Cantiere: CantiereInterno)
        rtemp.Carica(completion: { result in

            self.RistorantiCantiereLoad.removeAll()
            self.RistorantiCantiereLoad = result
            DispatchQueue.main.async {
                self.RistorantiTableView.reloadData()
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
        let del = Ristorante(SetRistorante: RistorantiCantiereLoad[indexPath.row], Cantiere: CantiereInterno)

        del.Elimina(completion: { result in

            if(result == true)
            {
                self.CaricamentoRistoranti()
            }
            else
            {
                let alertController = UIAlertController(title: "Errore", message: "Eliminazione ristorante non riuscita", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
            }
        })

    }
}


