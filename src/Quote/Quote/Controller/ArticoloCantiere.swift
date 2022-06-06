/**
 * Project Quote
 * @author Riccardo Pirani
 * @version 1
 */


import Foundation

struct ArticoloCantiereStruct: Codable {

    var IdArticoloCantiere: Int!
    var CodArt: String!
    var CodMarca: String!
    var Descrizione: String!
    var Prezzo: Double!
    var Quantita: Double!

    func GetIdArticoloCantiere() -> Int {
        return IdArticoloCantiere
    }
}

public class ArticoloCantiere: Articolo {

    private var IdArticoloCantiere: Int!
    public var DataInserimento: String!
    public var Quantita: Double!
    public var ExtraPreventivo: Int = 0
    //Rappresenta il Cantiere in cui è presente l'articolo!
    private var CantiereInterno: Cantiere!

    init(Cantiere: Cantiere) {
        super.init()
        self.CantiereInterno = Cantiere
    }

    init(SetArticolo: ArticoloStruct, Cantiere: Cantiere) {
        super.init(SetArticolo: SetArticolo)
        self.CantiereInterno = Cantiere
    }

    init(SetArticoloCantiere: ArticoloCantiereStruct, Cantiere: Cantiere) {
        super.init()
        self.CantiereInterno = Cantiere
        self.IdArticoloCantiere = SetArticoloCantiere.GetIdArticoloCantiere()
    }

    //Caricamento Tipologie Articoli
    func CaricaTipologieArticoli(completion: @escaping ([TipologiaStruct]) -> Void) {

        DispatchQueue.global(qos: .userInteractive).async {
            let articolo_temp = ArticoloModel()
            articolo_temp.CaricaTipologia(completion: {
                result in
                completion(result)
            })
        }

    }

    //Carica Articoli Cantiere
    func CaricaArticoliCantiere(completion: @escaping ([ArticoloCantiereStruct]) -> Void) {

        DispatchQueue.global(qos: .userInteractive).async {
            let articolo_temp = ArticoloModel()

            articolo_temp.CaricaArticoliCantiere(IdCantiere: self.CantiereInterno.GetIdCantiere(), completion: {
                    result in
                    completion(result)
                })
        }

    }

    func InserimentoArticoloCantiere(IdTipologia: Int, Rapportino: Bool, completion: @escaping (Bool) -> Void) {

        DispatchQueue.global(qos: .userInteractive).async {
            let artmodel = ArticoloModel()
            artmodel.InserimentoArticoloCantiere(IdTipologia: IdTipologia, Rapportino: Rapportino, IdCantiere: self.CantiereInterno.GetIdCantiere(), ExtraPreventivo: 0, IdUtente: Int(GetIdUtenteLogin()), CodArt: super.GetCodArt(), Descrizione: super.GetDescrizione(), CodMarca: super.GetCodMarca(), CodiceValuta: super.GetCodiceValuta(), Prezzo: super.GetPrezzo(), Quantita: self.Quantita!, Fornitore: super.GetFornitore(), Importato: super.GetImportato(), Data: self.DataInserimento!, completion: {
                    result in
                    completion(result)
                })
        }
    }

    func EliminaArticolo(completion: @escaping (Bool) -> Void) {

        DispatchQueue.global(qos: .userInteractive).async {
            let artmodel = ArticoloModel()
            artmodel.EliminazioneArticoloCantiere(IdArticoloCantiere: self.IdArticoloCantiere, completion: {
                result in
                completion(result)
            })
        }
    }



}
