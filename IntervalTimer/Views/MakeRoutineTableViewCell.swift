//
//  MakeRoutineTableViewCell.swift
//  IntervalTimer
//
//  Created by Ian Jeong on 5/18/23.
//

import UIKit

class MakeRoutineTableViewCell: UITableViewCell {
   
    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    
    
    var option: String? {
        didSet {
            self.optionLabel?.text = option
        }
    }
    
    var timeOptions: Int? {
        didSet {
            let minute = String(timeOptions! / 60)
            let second = String(timeOptions! % 60)
            var secFormatted: String
            if second.count == 2 {
                secFormatted = second
            } else {
                secFormatted = "0" + second
            }
            self.durationLabel?.text = "\(minute):\(secFormatted)"
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
