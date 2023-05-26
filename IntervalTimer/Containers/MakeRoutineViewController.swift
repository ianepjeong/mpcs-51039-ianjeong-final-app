//
//  MakeRoutineViewController.swift
//  IntervalTimer
//
//  Resources used:
//      https://stackoverflow.com/questions/24577838/segue-not-getting-selected-row-number
//
//  Created by Ian Jeong on 5/18/23.
//

import UIKit

// https://developer.apple.com/forums/thread/111569
protocol UpdateVC {
    func UpdateDur (newDur: Int, key:String)
    
    func reload()
}

class MakeRoutineViewController: UIViewController, UpdateVC {
    
   
    @IBOutlet weak var makeButton: UIButton!
    @IBOutlet var makeRoutineView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var makeRoutineTable: UITableView!
    
    var routines : [Routine]?
    var routine = Routine(name: "New Routine",
                         duration: ["Warm Up": 0, "High": 0, "Low":0, "Cycle":0, "Cool Down": 0])
    
    var options: [String]!
    var defaultTime = [10, 30, 10, 5, 30]
    
    var keys = ["Warm Up", "High", "Low", "Cycle", "Cool Down"]

    var timeOptions = Array(0...60)
    
    func UpdateDur(newDur: Int, key: String) {
        self.routine.duration[key] = newDur
    }
    
    func reload() {
        self.viewDidAppear(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.makeRoutineTable.delegate = self
        self.makeRoutineTable.dataSource = self
        
        self.nameTextField.delegate = self
        
        self.options = ["Warm Up Duration",
                        "High Intensity Duration",
                        "Low Intensity Duration",
                        "Cycle",
                        "Cool Down"]

        self.makeButton.setTitle("Create", for: .normal)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.makeRoutineTable.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TimeSettingViewController {
            let selectedIndex = self.makeRoutineTable.indexPath(for: sender as! MakeRoutineTableViewCell)
            if selectedIndex?.row == 3 {
                destination.cycle = true
            }
            
            destination.delegate = self
            destination.currKey = self.keys[selectedIndex!.row]
            destination.routine = self.routine
            destination.previousV = self.makeRoutineView
        }
        
        // create
        if let destination = segue.destination as? RoutineListViewController,
           let rout = self.routines {
            destination.routines = rout
            destination.routines.append(self.routine)
            //destination.routines!.append(self.routine)
        }
    }
    
    @IBAction func make(_ sender: Any) {
        self.routine.name = nameTextField.text!
        self.performSegue(withIdentifier: "listRoutine", sender: sender)
    }
    
}

extension MakeRoutineViewController: UITableViewDelegate {
    
    
}

extension MakeRoutineViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.makeRoutineTable.dequeueReusableCell(withIdentifier: "makeRoutineCell") as! MakeRoutineTableViewCell
        let currentOption = self.options[indexPath.row]
        let currentDurKey = self.keys[indexPath.row]
        let currentDur = self.routine.duration[currentDurKey]
        
        cell.option = currentOption
        if indexPath.row != 3 {
            cell.timeOptions = currentDur
        } else {
            cell.durationLabel.text = String(currentDur!)
        }
        
        return cell
    }
}

extension MakeRoutineViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.routine.name = textField.text!
    }
}

