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
import ScrollableGraphView
import CRNotifications
import NotificationBannerSwift
import FillableLoaders


class MainVC: UIViewController {
    
    var notificationTocken: NotificationToken? = nil
    var notificationTocken1: NotificationToken? = nil

    var realm: Realm!
    var user: SyncUser?

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent;
    }
    
    
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
    @IBOutlet weak var statView: UIView!
    @IBOutlet weak var currentTaskStatView: UIView!
    @IBOutlet weak var currentTaskCount: UILabel!
    @IBOutlet weak var currentTaskPlanCount: UILabel!
    @IBOutlet weak var currentTaskDueDate: UILabel!
    @IBOutlet weak var currentTaskComleteGauge: UILabel!
    @IBOutlet weak var logInOutBtn: UIButton!
    
    let day: Int = 86400
    var timerCount = 25
    let workTimer = 25
    let restTimer = 5
    let longRestTimer = 15
    var mainCount = Timer()
    var isMainCountRun = false
    var startTime: Date?
    var finisedWorkSessionNumber: Int = 0
    var activityType: ActivityType = .work
    var numberOfRounds: Int = UserDefaults.standard.integer(forKey: "numberOfRounds")
    let dayMonth = Calendar.current.ordinality(of: .day, in: .month, for: Date())
    var weekStat: Array<Int> = []
    var weekGraphView: ScrollableGraphView!
    var graphView: ScrollableGraphView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupComplitionIndicator()
                
        statView.roundCorners(corners: .allCorners, radius: 3)
        
        weekStat = StatDataService.instance.loadWeekStat()
        StatDataService.instance.loadWeekDaysNames()
        
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 10
        self.startBtn.roundCorners(corners: .allCorners, radius: 5)
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground(notif:)), name: .UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(taskDidSelect(notif:)), name: NOTIF_TODO_ITEM_DID_SELECT, object: nil)
        
        //MARK: Создаем недельный график на основном экране
        
        
        
        setupRealm()
        
        if SyncUser.current != nil {
            initialStat()
            logInOutBtn.setImage(UIImage(named: "login"), for: .normal)
        } else {
            logInOutBtn.setImage(UIImage(named: "logout"), for: .normal)
        }
        
        graphRedraw()
        
        timerStartPosition()

        if UserDefaults.standard.bool(forKey: "startSetuped") == false {
            UserDataService.instance.initialCategoriesSetup()
            UserDefaults.standard.set(true, forKey: "startSetuped")
        }

    
        
    }
    
    func graphRedraw() {
        
        print("Graph REDRAW!")
        
        graphView = ScrollableGraphView(frame: statView.frame, dataSource: self)
        
        // Setup the plot
        let barPlot = BarPlot(identifier: "bar")
        let referenceLines = ReferenceLines()
        
        barPlot.barWidth = 15
        barPlot.barLineWidth = 0.5
        barPlot.barLineColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        barPlot.barColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7)
        
        barPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        barPlot.animationDuration = 1.5
        
        // Setup LinePlot
        let linePlot = LinePlot(identifier: "darkLine")
        linePlot.lineWidth = 1
        linePlot.lineColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        linePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        
        linePlot.shouldFill = true
        linePlot.fillType = ScrollableGraphViewFillType.gradient
        linePlot.fillGradientType = ScrollableGraphViewGradientType.linear
        linePlot.fillGradientStartColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
        linePlot.fillGradientEndColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1)
        
        linePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        let dotPlot = DotPlot(identifier: "darkLineDot") // Add dots as well.
        dotPlot.dataPointSize = 2
        dotPlot.dataPointFillColor = UIColor.white
        
        dotPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        // Setup reference lines
        referenceLines.referenceLineColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        referenceLines.referenceLineLabelColor = UIColor.white
        referenceLines.dataPointLabelColor = UIColor.white
        
        referenceLines.positionType = .relative
        
        // Add everything
        graphView.dataPointSpacing = 25
        graphView.leftmostPointPadding = 40
        graphView.shouldAdaptRange = true
        graphView.addPlot(plot: barPlot)
        graphView.backgroundFillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        graphView.addReferenceLines(referenceLines: referenceLines)
        
        self.view.addSubview(graphView)
        weekGraphView = graphView
    }

    
    func initialStat() {
        print(realm)
        if realm != nil {
            
            print("load initial staff!")
            
            var calendar = NSCalendar.current
            calendar.timeZone = TimeZone(abbreviation: "UTC")!
            let todayAtMidnight = calendar.startOfDay(for: Date().localDate()!)
            let components = NSDateComponents()
            components.hour = 23
            components.minute = 59
            components.second = 59
            let endToday = Calendar.current.date(byAdding: components as DateComponents, to: todayAtMidnight)
            let dayResult = realm.objects(WorkSession.self).filter("start > %@ && start < %@", todayAtMidnight, endToday!)
            let monthResult = realm.objects(WorkSession.self).filter("start > %@ && start < %@", Date().startOfMonth()!, Date().endOfMonth()!)
            
            notificationTocken = dayResult.observe { [weak self] (changes: RealmCollectionChange ) in
                switch changes {
                case .initial:
                    
                    // загружаем показатели статистики за неделю
                    self?.weekStat = self!.loadWeekStat()
                    self?.graphView.reload()
                
                    print("Load initial data")
                    
                    // Настраиваем показатели статистики за день
                    self?.currentDayOfMonth.text = "\(Date().currentDayOfMonth())"
                    self?.dayOfWeekLbl.text = "\(Date().currentDayOfWeek().uppercased())"
                    self?.dayCountLbl.text = "\(dayResult.count * 25)"
                    self?.currentTaskCount.text = "\(UserDataService.instance.getCurrentProjectWorkSeeionsDone() * 25)"
                    
                    self?.countGaugeStat()
                    
                    // Настраиваем показатель статистика за месяц
                    self?.monthCount.text = "\(Date().currentMonthName().uppercased())"
                    self?.monthCountLbl.text = "\(monthResult.count * 25)"
                    
                case .update(_, _,  _, _):
                    
                    print("load update data!")
                    
                    // !!! ПОВТОРЯЮЩИЙСЯ КОД, НЕОБХОДИМО ИСПРАВИТЬ !!!
                    // загружаем показатели статистики за неделю
                    self?.weekStat = self!.loadWeekStat()
                    self?.graphView.reload()
                    
                    // Настраиваем показатели статистики за день
                    self?.currentDayOfMonth.text = "\(Date().currentDayOfMonth())"
                    self?.dayOfWeekLbl.text = "\(Date().currentDayOfWeek().uppercased())"
                    self?.dayCountLbl.text = "\(dayResult.count * 25)"
                    self?.currentTaskCount.text = "\(UserDataService.instance.getCurrentProjectWorkSeeionsDone() * 25)"
                    
                    self?.countGaugeStat()
                    
                    
                    // Настраиваем показатель статистика за месяц
                    self?.monthCount.text = "\(Date().currentMonthName().uppercased())"
                    self?.monthCountLbl.text = "\(monthResult.count * 25)"
                    self?.currentTaskCount.text = "\(UserDataService.instance.getCurrentProjectWorkSeeionsDone() * 25)"
                    
                    NotificationCenter.default.post(name: NOTIF_DATA_DID_CHANGE, object: nil)
                    
                case .error(let error):
                    fatalError("\(error)")
                }
            }
            
        }
    }
    
    func loadWeekStat() -> Array<Int> {
        var weekStat: Array<Int> = []
        for index in 0...6 {
            let beginingOfWeekDay = Date().startOfWeek()! + Double(day * index)
            let endOfWeekDay = Date().endOfDay(date: beginingOfWeekDay)
            let dayResult = realm.objects(WorkSession.self).filter("start > %@ && start < %@", beginingOfWeekDay, endOfWeekDay)
            
            weekStat.append(dayResult.count * 25)
        }
        
        return weekStat
    }
    
    func setupRealm() {
        if let _ = SyncUser.current {
            // We have already logged in here!
            print("We have already logged in!")
            let configuration = Realm.Configuration(
                syncConfiguration: SyncConfiguration(user: SyncUser.current!, realmURL: REALM_URL)
            )
            self.realm = try! Realm(configuration: configuration)
            initialStat()
        } else {
            let alertController = UIAlertController(title: "Login to Realm Cloud", message: "Supply a nice nickname!", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Login", style: .default, handler: { [unowned self]
                alert -> Void in
                
                SyncUser.logIn(with: .usernamePassword(username: REALM_USERNAME, password: REALM_PASSWORD), server: AUTH_URL, onCompletion: { [weak self](user, err) in
                    if let user = user {
                        let configuration = Realm.Configuration(
                            syncConfiguration: SyncConfiguration(user: user, realmURL: REALM_URL)
                        )
                        self?.realm = try! Realm(configuration: configuration)
                        
                        print("Login sucessiful!")
                        StatDataService.init()
                        self?.logInOutBtn.setImage(UIImage(named: "login"), for: .normal)
                        self?.initialStat()
                    } else if let error = err {
                        fatalError(error.localizedDescription)
                    }
                })
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        print(SyncUser.current)
        if SyncUser.current != nil {
            SyncUser.current?.logOut()
            logInOutBtn.setImage(UIImage(named: "logout"), for: .normal)
        } else {
            self.setupRealm()
            self.initialStat()
        }
    }
    

    
    
    
    @objc func taskDidSelect(notif: Notification) {
        
        guard let selectedTask = UserDataService.instance.selectedProject else {return}
        taskLbl.text = selectedTask.name ?? "Select smth todo.."
        timerCount = workTimer + 1
        updateTimer()
        currentTaskCount.text = "\(UserDataService.instance.getCurrentProjectWorkSeeionsDone() * 25)"
        
        if UserDataService.instance.selectedProject?.dueDate != nil {
//            currentTaskDueDate.text =
        } else {
            currentTaskDueDate.text = "DUE DATE NOT SET"
            currentTaskDueDate.textColor = UIColor.white
        }
        
        currentTaskPlanCount.text = "\((UserDataService.instance.selectedProject?.planCount)! * 25)"
        

        currentTaskStatView.isHidden = false
        countGaugeStat()
    }
    
    func countGaugeStat() {
        guard let selectedProject = UserDataService.instance.selectedProject else {return}
        let count = Float(selectedProject.workSessions.count)
        let planCount = Float(selectedProject.planCount)
        let result = Int((count / planCount) * 100)
        currentTaskComleteGauge.text = "\(result)%"
    }
        
    func runMainCount() {
        
        startTime = Date().localDate()
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
                let workSession = WorkSession()
                workSession.start = startTime
                workSession.end = Date().localDate()
                UserDataService.instance.saveFinishedWorkSession(workSeesion: workSession)
                
                numberOfRounds += 1
                UserDefaults.standard.set(numberOfRounds, forKey: "numberOfRounds")
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
                    UserDefaults.standard.set(numberOfRounds, forKey: "numberOfRounds")
                } else {
                    timerCount = workTimer
                    activityType = .work
                }
            }
            
            timerStartPosition()
            
            if activityType == .rest || activityType == .longRest {
                mainBG.image = UIImage(named: "restBG")
                startBtn.setTitle("TAKE A REST", for: .normal)
                dayDateView.isHidden = true
                dayStatView.isHidden = true
                monthDateView.isHidden = true
                monthStatView.isHidden = true
                statView.isHidden = true
                weekGraphView.isHidden = true
                currentTaskStatView.isHidden = true
            } else {
                mainBG.image = UIImage(named: "mainBG")
                setupComplitionIndicator()
                dayDateView.isHidden = false
                dayStatView.isHidden = false
                monthDateView.isHidden = false
                monthStatView.isHidden = false
                statView.isHidden = false
                weekGraphView.isHidden = false
                currentTaskStatView.isHidden = false
                
            }
        }
    }
    
    @objc func updateStat() {
//        finisedTasksNumber = UserDataService.instance.selectedProject?.workSession.fi
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
        
        if UserDataService.instance.selectedProject == nil {
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
        
        countGaugeStat()
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
        
        let banner = NotificationBanner(title: "Ops..!", subtitle: "Please select a task to continue!", style: .warning)
        banner.show()
        
//        let alert = UIAlertController(title: "Ops..!", message: "Please select a task to continue", preferredStyle: .alert)
//        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
//        alert.addAction(action)
//        self.present(alert, animated: true, completion: nil)
    }
    
    func creteStatusBarPath() -> CGPath {
        
        let mainPath2 = UIBezierPath(rect: CGRect(x: currentTaskCount.frame.origin.x, y: currentTaskCount.frame.origin.y, width: currentTaskCount.frame.width, height: currentTaskCount.frame.height))
        
        return mainPath2.cgPath
    }
    
    deinit {
        notificationTocken?.invalidate()
    }
    
}

extension MainVC: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
    }
    
    //This is key callback to present notification while the app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //You can either present alert ,sound or increase badge while the app is in foreground too with ios 10
        //to distinguish between notifications
        if notification.request.identifier == requestIdentifier {
            
            completionHandler( [.alert,.sound,.badge])
            
        }
    }
}

extension MainVC: ScrollableGraphViewDataSource {
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        // Return the data for each plot.
        switch(plot.identifier) {
        case "bar":
            return Double(weekStat[pointIndex])
        case "darkLine":
            return Double(weekStat[pointIndex])
        case "darkLineDot":
            return Double(weekStat[pointIndex])
        default:
            return 0
        }
    }
    
    func label(atIndex pointIndex: Int) -> String {
        
        return StatDataService.instance.weekDays[pointIndex].uppercased()
    }
    
    func numberOfPoints() -> Int {
        
        return 7
    }
}


