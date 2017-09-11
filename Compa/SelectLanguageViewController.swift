//
//  SelectLanguageViewController.swift
//  Compa
//
//  Created by MacBook Pro on 6/12/2560 BE.
//  Copyright © 2560 CyberWorks. All rights reserved.
//

import UIKit

class SelectLanguageViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var languagePicker: UIPickerView!
    @IBOutlet weak var setButton: CalcCompabilityUIButton!
    
    let pickerData = ["English", "日本語"]
    let langArray = ["en", "ja"]
    var selection:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        languagePicker.dataSource = self
        languagePicker.delegate = self
        
        let lang = Locale.current.languageCode!
        self.languagePicker.selectRow(self.langArray.index(of: lang)!, inComponent: 0, animated: false)
        
        
    }
    
    /*
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let lang = Locale.current.languageCode!
        self.languagePicker.selectRow(self.langArray.index(of: lang)!, inComponent: 0, animated: false)
        
    }
 */

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Data Sources
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selection = pickerData[row]
    }
 
    
    @IBAction func selectLanguage(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        if self.selection != nil {
            print("this is selected: \(self.selection!)");
            UserDefaults.standard.set([self.langArray[self.pickerData.index(of: self.selection!)!]], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
