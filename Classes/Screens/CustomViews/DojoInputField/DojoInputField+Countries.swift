//
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 06/10/2022.
//

import UIKit

extension DojoInputField {
    
    func setUpFieldForCountriesDropDown() {
        dropDownCountries = getCSVData() ?? []
        if dropDownCountries.count > selectedPickerPosition {
            let displayingItem = dropDownCountries[selectedPickerPosition]
            textFieldMain.text = displayingItem.title
            textFieldMain.tintColor = .clear
        }
    }
    
    func getCSVData() -> Array<CountryDropdownItem>? {
        let bundle = Bundle(for: type(of: self))
        guard let countriesCSV = bundle.url(forResource: "countries", withExtension: "csv") else {
            return nil
        }
        
        do {
            let content = try String(contentsOf: countriesCSV)
            var parsedCSV: [CountryDropdownItem] = content.components(
                separatedBy: "\n"
            ).map{
                CountryDropdownItem(title: $0.components(separatedBy: ",")[0], //TODO: make sure it won't crash
                                    isoCode: $0.components(separatedBy: ",")[1])}
            if parsedCSV.count > 0 {
                parsedCSV.removeFirst()
            }
            return parsedCSV
        }
        catch {
            return []
        }
    }
    
    func getSelectedCountry() -> CountryDropdownItem? {
        getCSVData()?[selectedPickerPosition]
    }
}

extension DojoInputField: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        dropDownCountries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if dropDownCountries.count > row {
            return dropDownCountries[row].title
        } else {
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if dropDownCountries.count > row {
            selectedPickerPosition = row
            textFieldMain.text = dropDownCountries[row].title
        }
    }
}
