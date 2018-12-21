import WebKit
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var salida: UITextField!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var wkWebView: WKWebView!
    var definicion:String?
    var palabra:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buscar(_ sender: Any) {
        definicion = textField.text!
        let urlWiki = "https://es.wikipedia.org/w/api.php?action=query&prop=extracts&format=json&exintro=&titles=\(definicion!.replacingOccurrences(of: " ", with: "%20"))"
        let urlObjeto = URL(string:urlWiki)
        let tarea = URLSession.shared.dataTask(with: urlObjeto!) { (datos, respuesta, error) in
            if error == nil {
                do{
                    let json = try JSONSerialization.jsonObject(with: datos!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:Any]
                    // print(json)
                    
                    let querySubJson = json["query"] as! [String:Any]
                    
                    //print(querySubJson)
                    let pagesSubJson = querySubJson["pages"] as! [String:Any]
                    //print(pagesSubJson)
                    
                    let keySubJson = pagesSubJson.keys.first
                    
                    let idSubJson = pagesSubJson[keySubJson!] as! [String:Any]
                    
                    //print(idSubJson)
                    
                    
                    let extractStringHtml = idSubJson["extract"] as! String
                    self.palabra = extractStringHtml
                    
                    //print(extractStringHtml)
                    
                    DispatchQueue.main.sync(execute: {
                        
                        self.wkWebView.loadHTMLString(extractStringHtml, baseURL: nil)
                    })
                }catch {
                    print("El Procesamiento del JSON tuvo un error")
                }
            } else {
                print(error!)
            }
        }
        self.salida.text = self.palabra
        tarea.resume()
    }
}
