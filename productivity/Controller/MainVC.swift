//
//  MainVC.swift
//  productivity
//
//  Created by MoHapX on 15.05.2018.
//  Copyright © 2018 R'systems Inc. All rights reserved.
//

import UIKit
import RealmSwift
import FontAwesomeKit_Swift
import UserNotifications
import DottedProgressBar


class MainVC: UIViewController {
    
    var notificationTocken: NotificationToken? = nil
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent;
    }
    
    let realm = try! Realm()

    
    // Настройка центра Уведомлений
    let centerNotif = UNUserNotificationCenter.current()
    let notifOptions: UNAuthorizationOptions = .badge
    let requestIdentifier = "SampleRequest" //identifier is to cancel the notification request
   
    

    // Outlets
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var taskLbl: UILabel!
    @IBOutlet weak var tenMinuteLbl: UILabel!
    @IBOutlet weak var minuteLbl: UILabel!
    @IBOutlet weak var tenSecondsLbl: UILabel!
    @IBOutlet weak var secondsLbl: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var currentDayOfMonth: UILabel!
    @IBOutlet weak var monthCount: UILabel!
    @IBOutlet weak var mainBG: UIImageView!
    @IBOutlet weak var roundOneCompletionIndicator: UIView!
    @IBOutlet weak var rountTwoCompletionIndicator: UIView!
    @IBOutlet weak var roundTreeCompletionIndicator: UIView!
    @IBOutlet weak var roundFourComplitionIndicator: UIView!
    @IBOutlet weak var dayOfWeekLbl: UILabel!
    @IBOutlet weak var dayCountLbl: UILabel!
    @IBOutlet weak var monthCountLbl: UILabel!
    @IBOutlet weak var dayDateView: UIView!
    @IBOutlet weak var dayStatView: UIView!
    @IBOutlet weak var monthDateView: UIView!
    @IBOutlet weak var monthStatView: UIView!
    
    var timerCount = 25
    let workTimer = 25
    let restTimer = 5
    let longRestTimer = 15
    var mainCount = Timer()
    var isMainCountRun = false
    var startTime: Date?
    var finisedTasksNumber: Int = 0
    var activityType: ActivityType = .work
    var numberOfRounds: Int = 0
    let dayMonth = Calendar.current.ordinality(of: .day, in: .month, for: Date())

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 10
        self.startBtn.roundCorners(corners: .allCorners, radius: 5)
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground(notif:)), name: .UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(taskDidSelect(notif:)), name: NOTIF_TODO_ITEM_DID_SELECT, object: nil)
        
//         let progressBar = DottedProgressBar(frame: CGRect(x: 205, y: 395, width: 100, height: 10), numberOfDots: 4, initialProgress: 2)
//        progressBar.progressAppearance = DottedProgressBar.DottedProgressAppearance(dotRadius: 5.0, dotsColor: UIColor.white, dotsProgressColor: UIColor.darkGray, backColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0))
//        view.addSubview(progressBar)
        
        // Следим за обновлением данных по завершенным временным блокам
        
        var calendar = NSCalendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        let todayAtMidnight = calendar.startOfDay(for: Date())
        let components = NSDateComponents()
        components.hour = 23
        components.minute = 59
        components.second = 59
        let endToday = Calendar.current.date(byAdding: components as DateComponents, to: todayAtMidnight)
        print("Начало и конец дня:", todayAtMidnight, endToday!)
        print("Текущая дата:", Date())
        print(Date().startOfMonth()!, Date().endOfMonth()!)
        let dayResult = realm.objects(Task.self).filter("start > %@ && start < %@", todayAtMidnight, endToday!)
        let monthResult = realm.objects(Task.self).filter("start > %@ && start < %@", Date().startOfMonth()!, Date().endOfMonth()!)
        notificationTocken = dayResult.observe { [weak self] (changes: RealmCollectionChange ) in
            switch changes {
            case .initial:
                
                // Настраиваем показатели статистика за день
                self?.currentDayOfMonth.text = "\(Date().currentDayOfMonth())"
                self?.dayOfWeekLbl.text = "\(Date().currentDayOfWeek().uppercased())"
                self?.dayCountLbl.text = "\(dayResult.count * 25)"
                
                // Настраиваем показатель статистика за месяц
                self?.monthCount.text = "\(Date().currentMonthName().uppercased())"
                self?.monthCountLbl.text = "\(monthResult.count * 25)"
                
            case .update(_, _,  _, _):
                
                // !!! ПОВТОРЯЮЩИЙСЯ КОД, НЕОБХОДИМО ИСПРАВИТЬ !!!
                // Настраиваем показатели статистика за день
                self?.currentDayOfMonth.text = "\(Date().currentDayOfMonth())"
                self?.dayOfWeekLbl.text = "\(Date().currentDayOfWeek().uppercased())"
                self?.dayCountLbl.text = "\(dayResult.count * 25)"
                
                // Настраиваем показатель статистика за месяц
                self?.monthCount.text = "\(Date().currentMonthName().uppercased())"
                self?.monthCountLbl.text = "\(monthResult.count * 25)"
            
            case .error(let error):
                fatalError("\(error)")
            }
        }
        
        print(dayResult.count)
        
        timerStartPosition()

//        UserDataService.instance.initialCategoriesSetup()

    
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("will appear!")
    }
    
    @objc func taskDidSelect(notif: Notification) {
        taskLbl.text = UserDataService.instance.selectedItem?.name ?? "Select smth todo.."
        timerCount = workTimer + 1
        updateTimer()
    }
        
    func runMainCount() {
        
        startTime = Date()
        isMainCountRun = true
        triggerNotification()
        UserDefaults.standard.set(Date().timeIntervalSinceReferenceDate + Double(timerCount), forKey: "finishCount")
        mainCount = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MainVC.updateTimer), userInfo: nil, repeats: true)
        
    }
    
    
    @objc func updateTimer() {
        if timerCount > 0 {
            timerCount -= 1
            tenMinuteLbl.text = "\(timerCount/60/10 % 6)"
            minuteLbl.text = "\(timerCount / 60 % 10)"
            tenSecondsLbl.text = "\(timerCount / 10 % 6)"
            secondsLbl.text = "\(timerCount % 10)"
        } else {
            
            
            if activityType == .work {
                
                // Сохраняем завершенный блок работы
                let task = Task()
                task.start = startTime
                task.end = Date()
                UserDataService.instance.saveFinishedTask(task: task)
                
                numberOfRounds += 1
            }
            
            
            // Переключаем тип активности
            if activityType == .work && numberOfRounds < 4 {
                activityType = .rest
                timerCount = restTimer
            } else {
                if numberOfRounds == 4 {
                    activityType = .longRest
                    timerCount = longRestTimer
                    numberOfRounds = 0
                } else {
                    timerCount = workTimer
                    activityType = .work
                }
            }
            
            timerStartPosition()
            
            if activityType == .rest || activityType == .longRest {
                mainBG.image = UIImage(named: "restBG")
                startBtn.setTitle("TAKE A REST", for: .normal)
                dayDateView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2)
                dayStatView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2)
                monthDateView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2)
                monthStatView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2)
            } else {
                mainBG.image = UIImage(named: "mainBG")
                setupComplitionIndicator()
                dayDateView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1)
                dayStatView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1)
                monthDateView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1)
                monthStatView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1)
                
            }
        }
    }
    
    @objc func updateStat() {
//        finisedTasksNumber = UserDataService.instance.selectedItem?.tasks.filter()
    }
    
    func setupComplitionIndicator() {
        switch numberOfRounds {
        case 0:
            roundOneCompletionIndicator.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            rountTwoCompletionIndicator.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1)
            roundTreeCompletionIndicator.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1)
            roundFourComplitionIndicator.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1)
        case 1:
            roundOneCompletionIndicator.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            rountTwoCompletionIndicator.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            roundTreeCompletionIndicator.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1)
            roundFourComplitionIndicator.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1)
        case 2:
            roundOneCompletionIndicator.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            rountTwoCompletionIndicator.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            roundTreeCompletionIndicator.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            roundFourComplitionIndicator.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1)
        case 3:
            roundOneCompletionIndicator.backgroundColor = UIColor.white
            rountTwoCompletionIndicator.backgroundColor = UIColor.white
            roundTreeCompletionIndicator.backgroundColor = UIColor.white
            roundFourComplitionIndicator.backgroundColor = UIColor.white
        default:
            roundOneCompletionIndicator.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            rountTwoCompletionIndicator.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1)
            roundTreeCompletionIndicator.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1)
            roundFourComplitionIndicator.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1)
        }
    }
    
    @IBAction func startCountPressed(_ sender: Any) {
        
        if UserDataService.instance.selectedItem == nil {
            notSelectedTaskAlert()
            return
        }
        
        if isMainCountRun == false {
            runMainCount()
        } else {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            timerStartPosition()
        }
        if isMainCountRun {
            startBtn.setTitle("STOP", for: .normal)
        } else {
            startBtn.setTitle("START", for: .normal)
        }
    }
    
    func timerStartPosition() {
        mainCount.invalidate()
        isMainCountRun = false
        timerCount += 1
        updateTimer()
        startBtn.setTitle("START", for: .normal)
    }
    
    @objc func willEnterForeground(notif: Notification) {
        let finishCount = UserDefaults.standard.double(forKey: "finishCount")
        let currentCount = Date().timeIntervalSinceReferenceDate
        if finishCount > currentCount {
            timerCount = Int(finishCount - Date().timeIntervalSinceReferenceDate) + 1
            updateTimer()
        } else {
            timerStartPosition()
        }
    }
    
    func triggerNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Time is up!"
        content.body = "Good, make a small rest to start it over..."
        content.sound = UNNotificationSound.default()
        
        
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: TimeInterval(timerCount), repeats: false)
        let request = UNNotificationRequest(identifier:requestIdentifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().add(request){(error) in
            
            if (error != nil){
                
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    func notSelectedTaskAlert() {
        let alert = UIAlertController(title: "Ops..!", message: "Please select a task to continue", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension MainVC: UNUserNotificationCenterDelegate {
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Tapped in notification")
    }
    
    //This is key callback to present notification while the app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("Notification being triggered")
        //You can either present alert ,sound or increase badge while the app is in foreground too with ios 10
        //to distinguish between notifications
        if notification.request.identifier == requestIdentifier {
            
            completionHandler( [.alert,.sound,.badge])
            
        }
    }
}


