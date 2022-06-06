/**
 * Project Quote
 * @author Riccardo Pirani
 * @version 1
 */

import Foundation

//Struttura Articolo ricerca di default
struct ArticoloStruct: Codable {

    var IdArticolo: Int!
    var CodArt: String!
    var CodMarca: String!
    var Descrizione: String!
    var Prezzo: Double!
    var PrezzoListino: Double!
    var CodiceValuta: String!
    var Fornitore: String!
    var Importato: String!
    var Tipo: String!
    var NomeTipologia: String!
    var UM: String!
    var FamigliadiSconto: String!
    var TipoArticolo: String!
    var CodiceBarcode: String!

    init(IdArticolo: Int)
    {
        self.IdArticolo = 0
        CodArt = ""
        CodMarca = ""
        Descrizione = ""
        Prezzo = 0
        PrezzoListino = 0
        CodiceValuta = ""
        Fornitore = ""
        Importato = ""
        Tipo = ""
        NomeTipologia = ""
        UM = ""
        FamigliadiSconto = ""
        TipoArticolo = ""
        CodiceBarcode = ""
    }

}

//Struttura Tipologie Preventivo
struct TipologiaStruct: Codable {
    var IdTipologiaPreventivo: Int!
    var NomeTipologia: String!
}

//Classe che rappresenta un articolo
public class Articolo {

    var Articolo: ArticoloStruct = ArticoloStruct(IdArticolo: 0)
    var Tipologia: TipologiaStruct = TipologiaStruct()

    //Costruttore
    init() {

    }

    //Costruttore che inizializza l'articolo
    init(SetArticolo: ArticoloStruct) {

        self.Articolo.IdArticolo = SetArticolo.IdArticolo
        self.Articolo.CodArt = SetArticolo.CodArt
        self.Articolo.CodMarca = SetArticolo.CodMarca
        self.Articolo.Descrizione = SetArticolo.Descrizione
        self.Articolo.Prezzo = SetArticolo.Prezzo
        self.Articolo.CodiceValuta = SetArticolo.CodiceValuta
        self.Articolo.PrezzoListino = SetArticolo.PrezzoListino
        self.Articolo.Fornitore = SetArticolo.Fornitore
        self.Articolo.Importato = SetArticolo.Importato
        self.Articolo.Tipo = SetArticolo.Tipo
        self.Articolo.UM = SetArticolo.UM
    }


    //Ricerca di un articolo
    func RicercaArticolo(CodiceArticolo: String, Descrizione: String, completion: @escaping ([ArticoloStruct]) -> Void) {

        DispatchQueue.global(qos: .userInteractive).async {
            let articolo_temp = ArticoloModel()

            articolo_temp.RicercaArticolo(CodArt: CodiceArticolo, Descrizione: Descrizione, completion: {
                result in
                completion(result)
            })
        }

    }

    //Recupero del codice articolo
    public func GetCodArt() -> String {
        return Articolo.CodArt ?? ""
    }

    //Recupero del codice marca
    public func GetCodMarca() -> String {
        return Articolo.CodMarca ?? ""
    }

    //Recupero del prezzo
    public func GetPrezzo() -> Double {
        return Articolo.Prezzo ?? 0
    }

    //Recupero della descrizione
    public func GetDescrizione() -> String {
        return Articolo.Descrizione ?? ""
    }

    //Funzione per il recupero del codice valuta
    public func GetCodiceValuta() -> String {
        return Articolo.CodiceValuta ?? ""
    }

    //Funzione per il recupero del fornitore
    public func GetFornitore() -> String {
        return Articolo.Fornitore ?? ""
    }

    //Funzione per il recupero dell'importato
    public func GetImportato() -> String {
        return Articolo.Importato ?? ""
    }

    //Recupero per il recupero della tipologia articolo
    public func GetTipo() -> String {
        return Articolo.Tipo ?? ""
    }

    //Funzione per il recupero dell'unità di misura
    public func GetUM() -> String {
        return Articolo.UM ?? ""
    }

    //Funzione per l'inserimento di un nuovo articolo
    public func Inserisci(UM: String, Prezzo: Float, Descrizione: String, CodArt: String, completion: @escaping (Bool) -> ())
    {
        DispatchQueue.global(qos: .userInteractive).async {
            let articolomodel = ArticoloModel()
            articolomodel.Inserisci(UM: UM, Prezzo: Prezzo, Descrizione: Descrizione, CodArt: CodArt, completion: {
                result in
                completion(result)
            })
        }
    }

    //Funzione per l'arriornamento di un articolo
    public func Aggiorna(UM: String, Prezzo: Float, Descrizione: String, CodArt: String, completion: @escaping (Bool) -> ())
    {
        DispatchQueue.global(qos: .userInteractive).async {
            let articolomodel = ArticoloModel()
            articolomodel.Aggiorna(IdArticolo: self.Articolo.IdArticolo, UM: UM, Prezzo: Prezzo, Descrizione: Descrizione, CodArt: CodArt, completion: {
                result in
                completion(result)
            })
        }
    }

    //Funzione per l'eliminazione di un articolo
    func Elimina(completion: @escaping (Bool) -> Void) {

        DispatchQueue.global(qos: .userInteractive).async {
            let artmodel = ArticoloModel()
            artmodel.EliminaArticolo(IdArticolo: self.Articolo.IdArticolo, completion: {
                result in
                completion(result)
            })
        }
    }



}
