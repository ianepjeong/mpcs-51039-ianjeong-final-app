//
//  TimeSettingViewController.swift
//  IntervalTimer
//
//  resources used for this file:
//      https://stackoverflow.com/questions/29617835/how-do-i-setup-a-second-component-with-a-uipickerview
//      https://www.youtube.com/watch?v=lICHh10y_XU
//
//  Created by Ian Jeong on 5/18/23.
//

import UIKit

class TimeSettingViewController: UIViewController {
    
    @IBOutlet weak var timePicker: UIPickerView!
    
    var minOptions = Array(0...60)
    var secOptions = Array(0...60)
    var cycleOptions = Array(0...100)
    var minSec = [0: 0, 1: 0]
    
    var cycle: Bool = false
    
    var routine: Routine?
    var currKey: String!
    
    var delegate: UpdateVC?
    var previousV: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timePicker.delegate = self
        timePicker.dataSource = self
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.delegate?.reload()
    }
}

extension TimeSettingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if self.cycle {
            return 1
        } else {
            return 2
        }
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.cycle {
            return self.cycleOptions.count
        } else {
            return self.minOptions.count
        }
        
    }
    
    // https://stackoverflow.com/questions/52080144/uipickerview-not-returning-the-correct-row-that-the-user-has-selected
    // STORE USER SELECTED DATA
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if self.cycle {
            self.delegate?.UpdateDur(newDur: self.cycleOptions[row], key: self.currKey)
        } else {
            if component == 0 {
                self.minSec[component] = self.minOptions[row] * 60 // convert minute to second
                let dur = self.minSec[0]! + self.minSec[1]!
                self.delegate?.UpdateDur(newDur: dur, key: self.currKey)
            } else {
                self.minSec[component] = self.minOptions[row]
                let dur = self.minSec[0]! + self.minSec[1]!
                self.delegate?.UpdateDur(newDur: dur, key: self.currKey)
            }
        }
    }

    // PREPARE ROWS FOR THE PICKER VIEW
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        if self.cycle {
            self.delegate?.UpdateDur(newDur: self.cycleOptions[row], key: self.currKey)
            return "\(String(self.cycleOptions[row])) cycles"
        } else {
            if component == 0 {
                self.minSec[component] = self.minOptions[row] * 60 // convert minute to second
//                let dur = self.minSec[0]! + self.minSec[1]!
//                self.delegate?.UpdateDur(newDur: dur, key: self.currKey)
                let selectedMin = String(self.minOptions[row])
                return "\(selectedMin) min"
            } else {
                self.minSec[component] = self.minOptions[row]
//                let dur = self.minSec[0]! + self.minSec[1]!
//                self.delegate?.UpdateDur(newDur: dur, key: self.currKey)
                let selectedSec = String(self.secOptions[row])
                return "\(selectedSec) sec"
            }
        }

    }
}
