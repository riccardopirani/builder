//
//  RicercaViewController.swift
//  Quote
//
//  Created by riccardo on 26/04/18.
//  Copyright © 2018 ViewSoftware. All rights reserved.
//

/* Annotazioni:
   La variabile pubblica Stato definisce come l'utente entra all'iterno della View
   se la Stato=Ricerca l'utente sta cercando un artcolo mentre se lo stato=Inserimento l'utente sta inserendo un Articolo
 */

import UIKit
import SwiftQRScanner

//Ricerca View Controller
class RicercaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate
{
    //Variabile che rappresenta il cantiere
    public var Cantiere: Cantiere!
    //Lo variabile Stato può essere di 3 tipi
    //1) Ricerca (ricerca di un articolo nel listino)
    //2) Magazzino (ricerca di un articolo in magazzino)
    //3) Preventivo (ricerca di un cantiere senza preventivo agganciato)
    public var Stato = "Ricerca"
    //Array che contiene i preventivi senza cantiere agganciato
    private var filteredDataPreventivi: [PreventivoStruct] = []
    //Array che contiene gli articoli ricercati
    private var filteredData: [ArticoloStruct] = []
    //Array che contiene gli articoli ricercati in magazzino
    private var filteredDataMagazzino: [ArticoloMagazzinoStruct] = []
    //UITableView in cui vengono caricati i valori
    private var TableViewArticoli: UITableView!
    //UISearchBar che effettua la ricerca per codice articolo
    private var mySearchBar: UISearchBar!
    //Variabile che rappresenta l'utente
    public var u: User = User()
    //Stringa che rappresenta la ricerca per codice barcode
    public var Barcode: String = String()
    //Button della UI
    let buttonReturn = UIButton()
    let buttonCreazioneArticolo = UIButton()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        self.view.backgroundColor = UIColor.gray
        //Recupero le dimensioni della barra di stato e del display
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height + 10
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        var height: CGFloat = 0
        var PosizioneYdiUiTableView = ((2 * barHeight) + barHeight + 6)
        //Verifica dello Stato delle UiViewController per impostare l'altezza della UiTableView
        if(Stato == "Inserimento") {
            height = ((displayHeight - (2 * barHeight) + 6) - 180)
        }
        else if(Stato == "Ricerca" || Stato == "Magazzino") {
            height = ((displayHeight - (2 * barHeight) + 6))
        }
        else if(Stato == "Preventivo") {
            height = displayHeight
            PosizioneYdiUiTableView = 0
        }

        //Configurazione Table-View
        TableViewArticoli = UITableView(frame: CGRect(x: 0, y: PosizioneYdiUiTableView, width: displayWidth, height: height))
        TableViewArticoli.register(CustomTableViewCellArticolo.self, forCellReuseIdentifier: "MyCell")
        TableViewArticoli.dataSource = self
        TableViewArticoli.delegate = self
        TableViewArticoli.tableFooterView = UIView()
        TableViewArticoli.rowHeight = 130
        //Configurazione Barra di Ricerca
        mySearchBar = UISearchBar(frame: CGRect(x: 0, y: barHeight + 6, width: displayWidth, height: (2 * barHeight)))
        mySearchBar.placeholder = "Cerca articoli"
        mySearchBar.delegate = self
        self.TableViewArticoli.layer.borderWidth = 2.0;
        self.view.addSubview(TableViewArticoli)
        self.view.addSubview(mySearchBar)
        //Implemento la sparizione della tastiera:
        TableViewArticoli.keyboardDismissMode = .onDrag
        //Bottone per tornare alla schermata precedente
        let ImageReturn = UIImage(named: "return.png") as UIImage?
        buttonReturn.frame = CGRect(x: displayWidth / 2, y: ((displayHeight - (2 * barHeight) + 6) - 5), width: 100, height: 80)
        buttonReturn.backgroundColor = UIColor.gray
        buttonReturn.setImage(ImageReturn, for: .normal)
        buttonReturn.setTitle("", for: .normal)
        buttonReturn.addTarget(self, action: #selector(ReturnButton), for: .touchUpInside)
        self.view.addSubview(buttonReturn)
        //Questo if verifica se si sta facendo una ricerca di un articolo nel listino o di un articolo in magazzino
        if(Stato == "Ricerca" || Stato == "Magazzino")
        {
            buttonReturn.isHidden = true
            //Button Creazione Nuovo Cantiere
            var imagenewarticolo = UIImage(named: "add-button.png") as UIImage?
            if(Stato == "Magazzino")
            {
                imagenewarticolo = UIImage(named: "qrcode.png") as UIImage?
            }
            buttonCreazioneArticolo.frame = CGRect(x: self.view.frame.width - 90, y: self.view.frame.height - 350, width: 80, height: 80)
            buttonCreazioneArticolo.layer.cornerRadius = 0.5 * buttonCreazioneArticolo.bounds.size.width
            buttonCreazioneArticolo.clipsToBounds = true
            buttonCreazioneArticolo.backgroundColor = UIColor.gray
            buttonCreazioneArticolo.setImage(imagenewarticolo, for: .normal)
            buttonCreazioneArticolo.setTitle("", for: .normal)
            buttonCreazioneArticolo.addTarget(self, action: #selector(CreazioneNuovoArticolo), for: .touchUpInside)
            self.view.addSubview(buttonCreazioneArticolo)

            if(Stato == "Magazzino")
            {
                buttonCreazioneArticolo.isHidden = false
            }

        }
        //Con questa condizione verifico se sto eseguendo la ricerca di un preventivo
            else if(Stato == "Preventivo")
        {
            //Nasconod i campi ui non necessari
            mySearchBar.isHidden = true
            buttonReturn.isHidden = false
            buttonCreazioneArticolo.isHidden = false
            RicercaPreventiviSenzaCantiere()

        }

    }

    //Funzione che esegue la ricerca di un barcode
    public func RicercaBarcode(Barcode: String)
    {
        self.Barcode = Barcode
        self.searchBar(mySearchBar, textDidChange: "")
    }

    //Funzione decide cosa visualizzare nell'uiviewcontroller
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }

    //Funzione per il colore della StatusBar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    //Bottone per creazione articolo e ricerca articoli con codice barcode
    @objc func CreazioneNuovoArticolo(sender: UIButton!) {
        if(Stato == "Ricerca")
        {
            let NuovoArticoloView = ModificaArticoloViewController()
            NuovoArticoloView.Stato = "Creazione"
            NuovoArticoloView.InizializzaView()
            self.present(NuovoArticoloView, animated: true, completion: nil)
        }
        else if(Stato == "Magazzino")
        {
            let scanner = QRCodeScannerController()
            scanner.InizializzaView()
            scanner.delegate = self
            self.present(scanner, animated: true, completion: nil)
        }
    }

    //Bottone per tornare alla schermata principale
    @objc func ReturnButton(sender: UIButton!) {
        if(Stato == "Preventivo")
        {
            let CreazioneCantiereView = CreazioneCantiereViewController()
            CreazioneCantiereView.InizializzaView()
            self.present(CreazioneCantiereView, animated: true, completion: nil)
        }
        else
        {
            let GestioneArticoli = GestioneArticoliViewController()
            GestioneArticoli.InizializzaView()
            GestioneArticoli.CantiereInterno = Cantiere
            self.present(GestioneArticoli, animated: true, completion: nil)
        }
    }

    //Funzione che effettua la ricerca dei preventivi senza cantiere
    func RicercaPreventiviSenzaCantiere()
    {
        let temp = Preventivo()
        temp.CaricaCantieriSenzaPreventivoAgganciato(completion: { result in
            DispatchQueue.main.async {
                self.filteredDataPreventivi.removeAll()
                self.filteredDataPreventivi = result

                self.TableViewArticoli.reloadData()
            }
        });
    }

    //Funzione che viene eseguito alla selezione della row nel tableview
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //Verifico di essere nello stato di inserimento
        if(Stato == "Inserimento")
        {
            let GestioneArticoli = GestioneArticoliViewController()
            GestioneArticoli.CantiereInterno = Cantiere
            GestioneArticoli.ArticoloSelezionato = ArticoloCantiere.init(SetArticolo: filteredData[indexPath.row], Cantiere: Cantiere)
            self.present(GestioneArticoli, animated: true, completion: nil)
        }
        //Verifico di essere nello stato di ricerca
            else if(Stato == "Ricerca")
        {
            let atemp = Articolo(SetArticolo: filteredData[indexPath.row])
            //Se l'articolo è stato inserito internamento è possibile modificarlo
            if(atemp.GetImportato() == "Interno" || atemp.GetImportato() == "INTERNO" || atemp.GetImportato() == "100Impianti")
            {
                let ModificaArticoloView = ModificaArticoloViewController()
                ModificaArticoloView.Stato = "Modifica"
                ModificaArticoloView.articolomodifica = atemp
                ModificaArticoloView.InizializzaView()
                self.present(ModificaArticoloView, animated: true, completion: nil)
            }
            //Se l'articolo è staot importato da un listino non può essere modificato
                else
            {
                let alertController = UIAlertController(title: "Errore", message: "questo articolo non può essere modificato", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
            }

        }
        //Verifico di essere nello stato Magazzino
            else if(Stato == "Magazzino")
        {
            let ModificaArticoloView = ModificaArticoloMagazzino()
            ModificaArticoloView.art = filteredDataMagazzino[indexPath.row]
            ModificaArticoloView.InizializzaView()
            self.present(ModificaArticoloView, animated: true, completion: nil)
        }
        //Verifico di essere nello stato Preventivo
            else if (Stato == "Preventivo")
                {
                let ViewPreventivo = CreazioneCantiereViewController()
                ViewPreventivo.preventivoTemp = filteredDataPreventivi[indexPath.row]
                ViewPreventivo.InizializzaView()
                self.present(ViewPreventivo, animated: true, completion: nil)
        }
    }

    //Conta il numero di cantieri nel UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //Condizione in cui gli articoli non siano a magazzino
        if(Stato != "Magazzino")
        {
            //Condizione in cui si stanno cercando degli articoli nel listino
            if(Stato != "Preventivo")
            {
                return filteredData.count
            }
            //Condizione in cui i dati siano a Preventivo
                else if(Stato == "Preventivo")
            {
                return filteredDataPreventivi.count
            }
        }
        //Condizione di ricerca di articoli in magazzino
        return filteredDataMagazzino.count
    }

    //Configurazione TableViewCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        TableViewArticoli.beginUpdates()
        let cell = TableViewArticoli.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! CustomTableViewCellArticolo
        //Configurazione nel caso in cui sia nello stato di ricerca
        if(Stato == "Ricerca" || Stato == "Inserimento")
        {
            cell.labCodArt.text = "Cod: \(filteredData[indexPath.row].CodArt!)     Prz: \(filteredData[indexPath.row].Prezzo!)   di \(filteredData[indexPath.row].Importato!)"
            cell.labDescrizione.text = filteredData[indexPath.row].Descrizione!
        }
        //Configurazione nel caso in cui sia nello stato Magazzino
            else if(Stato == "Magazzino")
        {
            cell.labCodArt.text = "Cod: \(filteredDataMagazzino[indexPath.row].CodArt!)  PZ: \(filteredDataMagazzino[indexPath.row].Quantita!) - Inserito: \(filteredDataMagazzino[indexPath.row].Utente!)"
            cell.labDescrizione.text = "  Magazzino:\(String(describing: filteredDataMagazzino[indexPath.row].Magazzino!))"
        }
        //Configurazione nel caos in cui sia nello stato Preventivo
            else
        {
            cell.labCodArt.text = "Ragione Sociale: \(String(describing: filteredDataPreventivi[indexPath.row].RagioneSociale!))   "
            cell.labDescrizione.text = "Riferimento interno: \(filteredDataPreventivi[indexPath.row].RiferimentoInterno!)   "
        }
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.masksToBounds = true
        cell.labPrezzo.text = ""
        TableViewArticoli.endUpdates()
        return cell
    }

    //Questo Metodo Aggiorna i Dati basati sulla textbox di ricerca
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        //Imposto un ritardo sull'esecuzione della ricerca dei cantieri
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {

                //Verifico se sto cercando un articolo in magazzino
                if(self.Stato == "Ricerca" || self.Stato == "Inserimento")
                {
                    let articolo_temp = Articolo()
                    articolo_temp.RicercaArticolo(CodiceArticolo: searchText, Descrizione: "", completion: { result in
                        DispatchQueue.main.async {
                            self.filteredData.removeAll()
                            self.filteredData = result

                            self.TableViewArticoli.reloadData()
                        }
                    });
                }
                //Verifico se sto cercando un articolo in magazzino
                    else if(self.Stato == "Magazzino")
                {
                    let articolo_temp = Magazzino(User: self.u)
                    articolo_temp.RicercaArticoliMagazzino(CodArt: searchText, IdMagazzino: 0, Barcode: self.Barcode, completion: { result in
                        DispatchQueue.main.async
                        {
                            self.filteredDataMagazzino.removeAll()
                            self.filteredDataMagazzino = result
                            self.TableViewArticoli.reloadData()
                        }
                    });
                }

                //Condizione in cui verifico se sto ricercando dei preventivi senza cantieri agganciato
                    else if(self.Stato == "Preventivo")
                {
                    self.RicercaPreventiviSenzaCantiere()
                }
            });
    }

    //Funzione di elminazione delle UiTableViewCell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        let articoloDelete = Articolo(SetArticolo: filteredData[indexPath.row])
        if(Stato == "Ricerca" && articoloDelete.GetTipo() == "Interno") {
            guard editingStyle == .delete else { /*Istruzione diversa da eliminazione*/ return }
            //Eliminaizone  row
            articoloDelete.Elimina(completion: { result in

                DispatchQueue.main.async {
                    if(result == true)
                    {
                        self.TableViewArticoli.reloadData()
                    }
                    else
                    {
                        let alertController = UIAlertController(title: "Errore", message: "Eliminazione Articolo non riuscita", preferredStyle: .alert)
                        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(OKAction)
                        self.present(alertController, animated: true, completion: nil)

                    }
                }
            })
        }
    }

}

//Estensione per eseguire la ricerca con codice QrCode
extension RicercaViewController: QRScannerCodeDelegate
{
    func qrScanner(_ controller: UIViewController, scanDidComplete result: String) {
        print("result:\(result)")

        //Inizializzazione con barcode
        if((Int(result)) != nil) {
            Barcode = "\(result)"
            RicercaBarcode(Barcode: Barcode)
        }
        //Altrementi visualizzo messaggio di errore
            else {
                DispatchQueue.main.async(execute: {
                    let alertController = UIAlertController(title: "Errore", message: "QrCode non valido", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true, completion: nil)

                })

        }
    }

    //Esecuzione del fail nel caso in cui la scansione fallisca
    func qrScannerDidFail(_ controller: UIViewController, error: String) {
        print("error:\(error)")
    }

    //Errore scansione qr
    func qrScannerDidCancel(_ controller: UIViewController) {
        print("SwiftQRScanner did cancel")
    }


}
