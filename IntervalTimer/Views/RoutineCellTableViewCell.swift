//
//  RoutineCellTableViewCell.swift
//  IntervalTimer
//
//  Created by Ian Jeong on 5/17/23.
//

import UIKit

class RoutineCellTableViewCell: UITableViewCell {

    @IBOutlet weak var routineNameLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    var routine: Routine? {
        didSet {
            self.routineNameLabel?.text = routine?.name
            
            var sumTime = routine!.duration["Warm Up"]!
            sumTime += routine!.duration["High"]! * routine!.duration["Cycle"]!
            sumTime += routine!.duration["Low"]! * routine!.duration["Cycle"]!
            sumTime += routine!.duration["Cool Down"]!
            
            let min = String(sumTime / 60)
            let sec = String(sumTime % 60)
            var secFormatted: String
            if sec.count == 2 {
                secFormatted = sec
            } else {
                secFormatted = "0" + sec
            }
            print(secFormatted)
            self.durationLabel?.text = "\(min):\(secFormatted)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
