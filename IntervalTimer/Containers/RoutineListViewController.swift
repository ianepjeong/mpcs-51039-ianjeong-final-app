//
//  ViewController.swift
//  IntervalTimer
//
//  Created by Ian Jeong on 5/16/23.
//

import UIKit

class RoutineListViewController: UIViewController {
    
    
    @IBOutlet weak var makeRoutineButton: UIButton!
    
    @IBOutlet weak var routineTableView: UITableView!
    
    var routines: [Routine] = [
        Routine(name: "Routine 1",
                duration: ["Warm Up": 10, "High": 30, "Low":10, "Cycle":5, "Cool Down": 30]),
        Routine(name: "Routine 2",
                duration: ["Warm Up": 10, "High": 30, "Low":10, "Cycle":10, "Cool Down": 30]),
        Routine(name: "Routine 3",
                duration: ["Warm Up": 10, "High": 1200, "Low":10, "Cycle":1, "Cool Down": 30])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.makeRoutineButton.setTitle("+", for: .normal)
        
        // deals with display
        self.routineTableView.dataSource = self
        // deals with interaction
        self.routineTableView.delegate = self
    }
    
    
    @IBAction func clickButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "makeRoutine", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // segue leading to Making Routine
        if let destination = segue.destination as? MakeRoutineViewController {
            destination.routines = self.routines
        }
        if let destination = segue.destination as? TimerViewController,
           let selectedIndex = self.routineTableView.indexPath(for: sender as! RoutineCellTableViewCell) {
            destination.routine = self.routines[selectedIndex.row]
        }
        
    }
}

extension RoutineListViewController: UITableViewDataSource {
    //MARK: DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.routines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.routineTableView.dequeueReusableCell(withIdentifier: "routineCell") as! RoutineCellTableViewCell
        let currentRoutine = self.routines[indexPath.row]
        
        cell.routine = currentRoutine
        return cell
    }

}

extension RoutineListViewController: UITableViewDelegate {
    // MARK: Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let cell = self.routineTableView.cellForRow(at: indexPath) {
//
//        }
    }
}
