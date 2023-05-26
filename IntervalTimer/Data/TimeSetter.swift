//
//  TimeSetter.swift
//  IntervalTimer
//
//  Created by Ian Jeong on 5/18/23.
//

import UIKit



class TimeSetter: UIPickerView {
    var timeOptions = Array(0...60)
}

extension TimeSetter: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return timeOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timeOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(self.timeOptions[row])
    }
}

extension TimeSetter: UIPickerViewDelegate {
    
}
