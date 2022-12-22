//
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 06/10/2022.
//

import UIKit

extension DojoInputField {
    
    func setUpFieldForCountriesDropDown() {
        dropDownCountries = viewModel?.getCountriesItems() ?? []
        if dropDownCountries.count > selectedPickerPosition {
            let displayingItem = dropDownCountries[selectedPickerPosition]
            textFieldMain.text = displayingItem.title
            textFieldMain.tintColor = .clear
        }
    }
    
    func getSelectedCountry() -> CountryDropdownItem? {
        guard dropDownCountries.count > selectedPickerPosition else {
            return nil
        }
        return dropDownCountries[selectedPickerPosition]
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
