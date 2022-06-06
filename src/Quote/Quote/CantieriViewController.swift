import UIKit

//View che si occupa della ricerca dei cantieri
class CantieriViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    //Button per la creazione dei cantieri
    private var buttonCreazioneCantiere: UIButton = UIButton()
    //Array che contiene i cantieri ricercati
    private var filteredData: [CantiereStruct] = []
    //Tableview dove vengono visualizzati i cantieri
    private var myTableView: UITableView!
    //Barra di ricerca dei cantieri
    private var mySearchBar: UISearchBar!


    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        self.view.backgroundColor = UIColor.gray
        //Recupero le dimensioni della barra di stato e del display
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height + 10
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        //Configurazione Table-View
        myTableView = UITableView(frame: CGRect(x: 0, y: ((2 * barHeight) + barHeight + 6), width: displayWidth, height: displayHeight - (2 * barHeight) + 6))
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.tableFooterView = UIView()
        myTableView.rowHeight = 100
        //Configurazione Barra di Ricerca
        mySearchBar = UISearchBar(frame: CGRect(x: 0, y: barHeight + 6, width: displayWidth, height: (2 * barHeight)))
        mySearchBar.delegate = self
        mySearchBar.placeholder = "Cerca cantieri"
        self.view.addSubview(myTableView)
        self.view.addSubview(mySearchBar)
        //Button Creazione Nuovo Cantiere
        let ImageNuovoCantiere = UIImage(named: "nuovo_cantiere.png") as UIImage?
        buttonCreazioneCantiere.frame = CGRect(x: self.view.frame.width - 250, y: self.view.frame.height - 250, width: 200, height: 80)
        buttonCreazioneCantiere.clipsToBounds = true
        buttonCreazioneCantiere.backgroundColor = UIColor.gray
        buttonCreazioneCantiere.setImage(ImageNuovoCantiere, for: .normal)
        buttonCreazioneCantiere.setTitle("Nuovo cantiere", for: .normal)
        buttonCreazioneCantiere.addTarget(self, action: #selector(NuovoCantierebuttonAction), for: .touchUpInside)
        buttonCreazioneCantiere.semanticContentAttribute = .forceRightToLeft
        self.view.addSubview(buttonCreazioneCantiere)
        //Implemento la "sparizione" della tastiera:
        myTableView.keyboardDismissMode = .onDrag
        //Prima ricerca di default
        self.searchBar(mySearchBar, textDidChange: "")
    }

    //Funzione per inizializzazione view controller all'avvio
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent

    }
    //Modifico lo status della bar style
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    //Bottone per Creazione Nuovo Cantiere
    @objc func NuovoCantierebuttonAction(sender: UIButton!) {
        let CreazioneNuovoCantiere = CreazioneCantiereViewController()
        CreazioneNuovoCantiere.InizializzaView()
        self.present(CreazioneNuovoCantiere, animated: true, completion: nil)

    }

    //Selezione della riga
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let CantiereSelect = Cantiere(SetCantiere: filteredData[indexPath.row])
        let CantiereSelezionato = GestioneCantieriViewController(CantiereSet: CantiereSelect)
        CantiereSelezionato.InizializzaView()
        self.present(CantiereSelezionato, animated: true, completion: nil)
    }

    //Conta il Numero di Cantieri nel UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return filteredData.count
    }

    //Configurazione TableViewCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        myTableView.beginUpdates()
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as UITableViewCell
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.masksToBounds = true
        cell.textLabel?.numberOfLines = 5
        cell.textLabel?.text = " \(filteredData[indexPath.row].RagioneSociale) \n \(filteredData[indexPath.row].NomeCantiere)  \n Tipologia: \(filteredData[indexPath.row].Tipologia) "
        //Carico lo stato del Cantiere e in base allo stato cambio l'immagine dello stato del cantiere
        let Stato = filteredData[indexPath.row].StatoCantiere
        var image = UIImage(named: "Rifiutato.png")!
        if(Stato == "Chiuso")
        {
            image = UIImage(named: "Accettato.png")!
        }
        else if(Stato == "InCorso")
        {
            image = UIImage(named: "InCorso.png")!
        }
        cell.imageView?.image = image
        cell.textLabel?.sizeToFit()
        myTableView.endUpdates()
        return cell
    }

    //Questo Metodo Aggiorna i Dati basati sulla textbox di ricerca
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        let ctemp = Cantiere()
        ctemp.RicercaCantiere(NomeCantiere: searchText, completion: { result in
            DispatchQueue.main.async {
                self.filteredData.removeAll()
                self.filteredData = result
                self.myTableView.reloadData()
            }
        });
    }

}
