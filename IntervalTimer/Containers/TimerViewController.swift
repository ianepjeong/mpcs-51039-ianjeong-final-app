//
//  TimerViewController.swift
//  IntervalTimer
//
//  Created by Ian Jeong on 5/19/23.
//

import UIKit
import AVFoundation
import UserNotifications

class TimerViewController: UIViewController {
    
    @IBOutlet weak var intervalLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
    var audioPlayer: AVAudioPlayer?

    var routine: Routine! {
        didSet {
            self.currentStage = "Warm Up"
            self.currLoop = routine.duration["Cycle"]!
            self.timeRemaining = routine.duration["Warm Up"]!
        }
    }
    
    var timer: Timer = Timer()
    var countingDown: Bool = false
    
    var currentStage : String!
    var currLoop : Int!
    var timeRemaining: Int!
    
    var authorized: Bool!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .authorized:
                self.authorized = true
            case .denied:
                self.authorized = false
                print("Application Not Allowed to Display Notifications")
            default:
                self.requestAuthorization(completionHandler: { (success) in
                    guard success else { return }
                    self.authorized = true
                })
            }
        }
        configureUserNotificationsCenter()
        
        intervalLabel.text = routine.name
    }

        
    @IBAction func onClick(_ sender: Any) {
        if countingDown {
            countingDown = false
            timer.invalidate()
            startStopButton.setTitle("Start", for: .normal)
        } else {
            countingDown = true
            if intervalLabel.text == routine.name {
                intervalLabel.text = "Warm Up"
            }
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
            startStopButton.setTitle("Pause", for: .normal)
        }
    }
    
    // https://www.youtube.com/watch?v=NAsQCNpodPI
    @objc func timerCounter() -> Void {
        
        if self.timeRemaining == 1 && self.currentStage == "Cool Down" {
            timer.invalidate()
        }
        if self.timeRemaining == 0 {
            self.loopThroughCycles()
        }
        self.timeRemaining = self.timeRemaining - 1
        let time = secToHourMinSec(sec: self.timeRemaining)
        let timeString = makeTimeString(hours: time.0, min: time.1, sec: time.2)
        self.timerLabel.text = timeString
        
        // Schedule Local Notification
        if self.authorized {
            self.scheduleLocalNotification()
        }
    }
    
    func loopThroughCycles() -> Void {
        // https://stackoverflow.com/questions/73010821/swift-how-to-wait-for-sound-to-be-played
        AudioServicesPlaySystemSoundWithCompletion(UInt32(1304)) {}
        if self.currentStage == "Warm Up" {
            self.currentStage = "High"
            intervalLabel.text = "High"
            self.timeRemaining = self.routine.duration["High"]!
        } else if self.currentStage == "High" {
            self.currentStage = "Low"
            intervalLabel.text = "Low"
            self.timeRemaining = self.routine.duration["Low"]!
        } else if self.currentStage == "Low" && self.currLoop > 0 {
            self.currentStage = "High"
            intervalLabel.text = "High"
            self.timeRemaining = self.routine.duration["High"]!
            self.currLoop -= 1
        } else if self.currentStage == "Low" && self.currLoop == 0 {
            self.currentStage = "Cool Down"
            intervalLabel.text = "Cool Down"
            self.timeRemaining = self.routine.duration["Cool Down"]!
        }
    }
    
    func secToHourMinSec(sec: Int) -> (Int, Int, Int) {
        // H, M, S
        return ( (sec / 3600), ((sec % 3600) / 60), ((sec % 3600) % 60) )
    }
    
    func makeTimeString(hours: Int, min: Int, sec: Int) -> String {
        let hourString = String(format: "%02d", hours)
        let minString = String(format: "%02d", min)
        let secString = String(format: "%02d", sec)
        return "\(hourString):\(minString):\(secString)"
    }
}


// https://cocoacasts.com/actionable-notifications-with-the-user-notifications-framework
extension TimerViewController:  UNUserNotificationCenterDelegate {
    
    struct Notification1 {
        
        struct Category {
            static let Pause = "Pause"
        }
        
        struct Action {
            static let Pause = "Pause"
        }
    }
    
    struct Notification2 {
        
        struct Category {
            static let Start = "Start"
        }
        
        struct Action {
            static let Start = "Start"
        }
    }
    
    private func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
        // Request Authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }

            completionHandler(success)
        }
    }
    
    private func configureUserNotificationsCenter() {
        UNUserNotificationCenter.current().delegate = self
        
        let actionPause = UNNotificationAction(identifier: Notification1.Action.Pause, title: "Pause", options: [.foreground,])
        let actionStart = UNNotificationAction(identifier: Notification2.Action.Start, title: "Start", options: [.foreground,])
        
        // Define Categories
        let pauseCategory = UNNotificationCategory(identifier: Notification1.Category.Pause, actions: [actionPause], intentIdentifiers: [], options: [])
        let startCategory = UNNotificationCategory(identifier: Notification2.Category.Start, actions: [actionStart], intentIdentifiers: [], options: [])

        // Register Categories
        UNUserNotificationCenter.current().setNotificationCategories([pauseCategory, startCategory])
    }
    
    private func scheduleLocalNotification() {
        // Create Notification Content
        let notificationContent = UNMutableNotificationContent()

        // Configure Notification Content
        let time = secToHourMinSec(sec: self.timeRemaining)
        let timeString = makeTimeString(hours: time.0, min: time.1, sec: time.2)
        notificationContent.title = "Time Remaing: \(timeString)"
        
        // Set Category Identifier
        if self.countingDown {
            notificationContent.categoryIdentifier = Notification1.Category.Pause
        } else {
            notificationContent.categoryIdentifier = Notification2.Category.Start
        }

        // Add Trigger
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        
        // Create Notification Request
        let notificationRequest = UNNotificationRequest(identifier: "timer_local_notification", content: notificationContent, trigger: notificationTrigger)
        
        // Add Request to User Notification Center
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case Notification1.Action.Pause:
            countingDown = false
            timer.invalidate()
            startStopButton.setTitle("Start", for: .normal)
        case Notification2.Action.Start:
            countingDown = true
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
            startStopButton.setTitle("Pause", for: .normal)
        default:
            print("Other Action")
        }

        completionHandler()
    }

    
}
