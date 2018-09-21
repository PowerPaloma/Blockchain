//
//  ViewController.swift
//  Blockchain
//
//  Created by Ada 2018 on 20/09/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var lastLabel: UILabel!
    @IBOutlet var buyLabel: UILabel!
    @IBOutlet var sellLabel: UILabel!
    @IBOutlet var currencyPicker: UIPickerView!
    
    var currencies: [String] = []
    var values = Array<Any>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doGetRequest()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func doGetRequest(){
        var getRequest = URLRequest(url: URL(string: "https://blockchain.info/ticker")!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        getRequest.httpMethod = "GET"
        
        let getTask = URLSession.shared.dataTask(with: getRequest) {
            (data, response, error) in
            
            if data != nil {
                do {
                    guard let objJSON = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] else {return}
                        DispatchQueue.main.async {
                      
                            self.currencies = Array<String>(objJSON.keys)
                            self.values = Array(objJSON.values)
                            
                            self.currencyPicker.reloadAllComponents()
                       }
                        
                    
                } catch {
                    DispatchQueue.main.async {
                        print("Unable to parse JSON response in \(getRequest)")
                    }
                }
            } else {
                print("Received empty quest response from \(getRequest)")
            }
        }
        
        DispatchQueue.global(qos: .background).async {
            getTask.resume()
        }
    }
}
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       let value = self.values[row] as! Dictionary<String,Any>
        
        self.buyLabel.text = "\(value["15m"]!)"
        self.lastLabel.text = "\(value["last"]!)"
        self.sellLabel.text = "\(value["sell"]!)"
        
    }
    
}
