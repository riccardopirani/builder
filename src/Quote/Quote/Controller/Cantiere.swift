
import Foundation

//Struct che identifica un Cantiere
struct CantiereStruct: Codable {
    var IdCantiere: Int
    var IdCliente: Int
    var Filiale: String?
    var RagioneSociale: String
    var NomeCantiere: String
    var DataCreazioneCantiere: String
    var Tipologia: String
    var StatoCantiere: String
    var StatoFatturazione: Int
    var DescrizioneEstesa: String?
    var Indirizzo: String?
    var CAP: String?
    var Citta: String?
    var Provincia: String?

    init(IdCantiere: String) {
        self.Provincia = ""
        self.Citta = ""
        self.Indirizzo = ""
        self.CAP = ""
        self.IdCantiere = 0
        self.IdCliente = 0
        self.Filiale = ""
        self.RagioneSociale = ""
        self.NomeCantiere = ""
        self.DataCreazioneCantiere = ""
        self.Tipologia = ""
        self.StatoCantiere = ""
        self.StatoFatturazione = 0
        self.DescrizioneEstesa = ""
    }
}

//Classe che identifica un cantiere
public class Cantiere {

    private var CantiereInterno: CantiereStruct = CantiereStruct.init(IdCantiere: "")
    private var ClienteCantiere: Cliente = Cliente()
    private var PreventivoInterno: Preventivo = Preventivo()
    
    init() {
    }

    //Costruttore con Preventivo
    init(PreventivoPassed: PreventivoStruct)
    {
        self.PreventivoInterno = Preventivo(PreventivoPassed: PreventivoPassed)
    }

    //Costruttore con cliente
    init(Cliente: Cliente) {
        self.ClienteCantiere = Cliente
    }

    //Costruttore con cantiere
    init(SetCantiere: CantiereStruct) {

        inizializza(SetCantiere: SetCantiere)
    }

    //Funzione di inizializzazione del cantiere
    func inizializza(SetCantiere: CantiereStruct) {
        self.CantiereInterno.IdCantiere = SetCantiere.IdCantiere
        self.CantiereInterno.IdCliente = SetCantiere.IdCliente
        if(!(SetCantiere.Filiale?.isEmpty ?? false)) {
            self.CantiereInterno.Filiale = SetCantiere.Filiale
        }
        else {
            self.CantiereInterno.Filiale = "";
        }

        self.CantiereInterno.RagioneSociale = SetCantiere.RagioneSociale
        self.CantiereInterno.NomeCantiere = SetCantiere.NomeCantiere
        self.CantiereInterno.DataCreazioneCantiere = SetCantiere.DataCreazioneCantiere
        self.CantiereInterno.Tipologia = SetCantiere.Tipologia
        self.CantiereInterno.StatoCantiere = SetCantiere.StatoCantiere
        self.CantiereInterno.StatoFatturazione = SetCantiere.StatoFatturazione
        if(!(SetCantiere.DescrizioneEstesa?.isEmpty ?? false)) {
            self.CantiereInterno.DescrizioneEstesa = SetCantiere.DescrizioneEstesa
        }
        else {
            self.CantiereInterno.DescrizioneEstesa = ""
        }
        if(!(SetCantiere.Indirizzo?.isEmpty ?? false)) {
            self.CantiereInterno.Indirizzo = SetCantiere.Indirizzo
        }
        else {
            self.CantiereInterno.Indirizzo = ""
        }
        if(!(SetCantiere.CAP?.isEmpty ?? false)) {
            self.CantiereInterno.CAP = SetCantiere.CAP
        }
        else {
            self.CantiereInterno.CAP = ""
        }
        if(!(SetCantiere.Citta?.isEmpty ?? false)) {
            self.CantiereInterno.Citta = SetCantiere.Citta
        }
        else {
            self.CantiereInterno.Citta = ""
        }
        if(!(SetCantiere.Provincia?.isEmpty ?? false)) {
            self.CantiereInterno.Provincia = SetCantiere.Provincia
        }
        else {
            self.CantiereInterno.Provincia = ""
        }

    }

    //Effettua la ricerca dei cantieri sia preventivo che a consuntivo
    func RicercaCantiere(NomeCantiere: String, completion: @escaping ([CantiereStruct]) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            let ctemp = CantiereModel()

            ctemp.RicercaCantiere(NomeCantiere: NomeCantiere, completion: { result in

                completion(result)
            })
        }

    }

    //Recupero il nome del cantiere
    func GetNomeCantiere() -> String {
        return CantiereInterno.NomeCantiere
    }

    //Recupero la ragione sociale del cantiere
    func GetRagioneSociale() -> String {
        return CantiereInterno.RagioneSociale
    }

    //Recupero la filiale del cantiere
    func GetFiliale() -> String {
        return CantiereInterno.Filiale ?? ""
    }

    //Recupero la data di creazione del cantiere
    func GetDataCreazioneCantiere() -> String {
        return CantiereInterno.DataCreazioneCantiere
    }

    //Recupero l'id del cliente
    func GetIdCliente() -> Int {
        return CantiereInterno.IdCliente
    }

    //Recupero la tipologia del cantierew
    func GetTipologia() -> String {
        return CantiereInterno.Tipologia
    }

    //Recupero lo stato del cantiere
    func GetStatoCantiere() -> String {
        return CantiereInterno.StatoCantiere
    }

    //Configuro lo stato del cantiere
    func SetStatoCantiere(Stato: String) {
        self.CantiereInterno.StatoCantiere = Stato
    }

    //Recupero lo stato della fatturazione
    func GetStatoFatturazione() -> Int {
        return CantiereInterno.StatoFatturazione
    }

    //Recupero l'id del cantiere
    func GetIdCantiere() -> Int {
        return CantiereInterno.IdCantiere
    }

    //Recupero la descrizione estesa
    func GetDescrizioneEstesa() -> String {
        return CantiereInterno.DescrizioneEstesa ?? ""
    }

    //Eseguo l'aggiornamento del cantiere
    func AggiornaCantiere(DescrizioneEstesa: String, Stato: String, completion: @escaping (Bool) -> ())
    {

        DispatchQueue.global(qos: .userInteractive).async {
            let cmodel = CantiereModel()
            cmodel.AggiornaCantiere(IdCantiere: self.GetIdCantiere(), DescrizioneEstesa: DescrizioneEstesa, Stato: Stato, completion: {
                    result in
                    completion(result)
                })
        }
    }

    //Genero il cantiere a consuntivo
    func Crea(NomeCantiere: String, completion: @escaping (Bool) -> Void) {

        DispatchQueue.global(qos: .userInteractive).async {
            print("Funzione crea Cantiere nel Controller")
            self.CantiereInterno.NomeCantiere = NomeCantiere
            self.CantiereInterno.IdCliente = self.ClienteCantiere.GetIdCliente()
            self.CantiereInterno.Filiale = "SEDE"
            let cmodel = CantiereModel()
            cmodel.CreazioneCantiere(IdCliente: self.ClienteCantiere.GetIdCliente(), NomeCantiere: NomeCantiere,
                completion: {
                    result in
                    self.inizializza(SetCantiere: result[0] as CantiereStruct)
                    print("Funzione crea Cantiere nel Controller inizializzazione ")
                    completion(true)
                })

            print("Funzione crea Cantiere nel Controller fine")
        }
    }
    
    //Genero il cantiere a preventivo
    func CreaCantierePreventivo( completion: @escaping (Bool) -> Void) {

        DispatchQueue.global(qos: .userInteractive).async {
            self.CantiereInterno.NomeCantiere = self.PreventivoInterno.GetRiferimentoInterno()
            self.CantiereInterno.IdCliente = self.PreventivoInterno.GetIdCliente()
            self.CantiereInterno.Filiale = "SEDE"
            let cmodel = CantiereModel()
            cmodel.CreazioneCantierePreventivo(PreventivoPassed: self.PreventivoInterno,
                completion: {
                    result in
                    self.inizializza(SetCantiere: result[0] as CantiereStruct)
                    completion(true)
                })
        }
    }
   

}



