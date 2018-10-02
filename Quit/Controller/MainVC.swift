//
//  MainVC.swift
//  Quit
//
//  Created by Alex Tudge on 02/02/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import UIKit

//Crash on deletion of savings goal
//Vaping stats?

class MainVC: UITableViewController, SavingGoalVCDelegate, QuitDateSetVCDelegate {
    
    private var viewModel: MainVCViewModel?
    private let refreshController = UIRefreshControl()
    private let userDefaults = UserDefaults.standard
    private var catagoryTextView: UITextView?
    private var quitData: QuitData?
    private var hasSetupOnce = false
    
    @IBOutlet weak var quitDateLabel: UILabel!
    @IBOutlet weak var setQuitDataButton: UIButton!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var savingsScrollView: UIScrollView!
    @IBOutlet weak var savingsPageControl: UIPageControl!
    @IBOutlet weak var addSavingButton: UIButton!
    @IBOutlet weak var cravingScrollView: UIScrollView!
    @IBOutlet weak var cravingPageControl: UIPageControl!
    @IBOutlet weak var cravingButton: UIButton!
    @IBOutlet weak var healthScrollView: UIScrollView!
    @IBOutlet weak var section2Placeholder: UILabel!
    @IBOutlet weak var section3Placeholder: UILabel!
    @IBOutlet weak var section4Placeholder: UILabel!
    
    override func viewDidLoad() {
        
        viewModel = MainVCViewModel()
        
        viewModel?.requestNotifAuth()
        setupInitialState()
        setupPullToRefresh()
        
        //Observe the userDefaults quitData; if it changes update the UI
        
        userDefaults.addObserver(self, forKeyPath: "quitData", options: NSKeyValueObservingOptions.new, context: nil)
        
        if let returnedData = userDefaults.object(forKey: "quitData") as? [String: Any] {
            self.quitData = QuitData(quitData: returnedData)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //This needs to be called only once, but also after the UI has been setup to ensure sizings are correct
        
        if !hasSetupOnce {
            
            tableView.rowHeight = UIScreen.main.bounds.height / 2
            isQuitDateSet()
            hasSetupOnce = true
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey: Any]?,
                               context: UnsafeMutableRawPointer?) {
        
        if let returnedData = userDefaults.object(forKey: "quitData") as? [String: Any] {
            
            quitData = QuitData(quitData: returnedData)
            isQuitDateSet()
        }
    }
    
    private func setupInitialState() {
        
        //Assume no quit date is set
        
        setQuitDataButton.isHidden = false
        setQuitDataButton.titleLabel?.numberOfLines = 1
        setQuitDataButton.titleLabel?.adjustsFontSizeToFitWidth = true
        quitDateLabel.isHidden = true
        cravingButton.isHidden = true
        addSavingButton.isHidden = true
        savingsPageControl.isHidden = true
    }
    
    private func setupPullToRefresh() {
        
        //Pull to refrsh the time-dependent data
        
        self.tableView.refreshControl = refreshController
        refreshController.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshController.tintColor = Constants.greenColour
    }
    
    @objc private func refreshData(_ sender: Any) {
        isQuitDateSet()
    }
    
    func isQuitDateSet() {
        
        guard let data = self.quitData, data.quitDate != nil else { return }
        
        //If a quit date has been set populate the UI
        
        hidePlaceholders()
        setupSection1()
        setupSection2()
        setupSection3()
        
        //Only set up health stats if the quit date has passed
        
        if viewModel?.quitDateIsInPast(quitData: data) == true {
            setupSection4()
        } else {
            hideHealthStats()
        }
        endRefreshing()
    }
    
    private func endRefreshing() {
        refreshController.endRefreshing()
    }
    
    private func hidePlaceholders() {
        
        section2Placeholder.isHidden = true
        section3Placeholder.isHidden = true
        section4Placeholder.isHidden = true
    }
    
    private func hideHealthStats() {
        
        let subViews = self.healthScrollView.subviews
        for subview in subViews { subview.removeFromSuperview() }
    }
    
    //Injections
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toQuitInfoVC" {
            if let destination = segue.destination as? QuitInfoVC {
                destination.delegate = self
                destination.quitData = quitData
                destination.persistenceManager = self.viewModel?.persistenceManager
            }
        }
        
        if segue.identifier == "toSettingsVC" {
            if let destination = segue.destination as? SettingsVC {
                destination.delegate = self
                destination.persistenceManager = self.viewModel?.persistenceManager
            }
        }
        
        if segue.identifier == "toSavingGoalVC" {
            if let destination = segue.destination as? SavingGoalVC {
                destination.delegate = self
                destination.persistenceManager = self.viewModel?.persistenceManager
                if let sender = sender as? SavingGoal {
                    destination.savingGoal = sender
                }
            }
        }
    }
}

////SECTION 1 - header section
extension MainVC {
    
    private func setupSection1() {
        
        cravingButton.isHidden = false
        displayQuitDate()
        setupQuitTimer()
    }
    
    private func displayQuitDate() {
        
        guard quitData?.quitDate != nil else { return }
        setQuitDataButton.isHidden = true
        quitDateLabel.isHidden = false
        quitDateLabel.text = viewModel?.stringQuitDate(quitData: quitData)
    }
    
    //Show the smoke free duration
    
    private func setupQuitTimer() {
        
        Timer.scheduledTimer(timeInterval: 1,
                             target: self,
                             selector: #selector(updateCountdownLabel),
                             userInfo: nil,
                             repeats: true)
    }
    
    @objc func updateCountdownLabel() {
        countdownLabel.text = viewModel?.countdownLabel(quitData: quitData)
    }
    
    @IBAction func cravingButton(_ sender: Any) {
        
        let alertController = UIAlertController(title: viewModel?.cravingButtonAlertTitle(),
                                                message: viewModel?.cravingButtonAlertMessage(),
                                                preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
            
            //Reset the quit date
            
            if self.viewModel?.quitDateIsInPast(quitData: self.quitData) == true {
                self.viewModel?.setUserDefaultsQuitDateToCurrent(quitData: self.quitData)
            }
            let textField = alertController.textFields![0] as UITextField
            self.viewModel?.persistenceManager?.addCraving(
                catagory: (textField.text != nil) ? textField.text!.capitalized : "",
                smoked: true)
            
            //As the quit date has changed we need to refresh the entire UI
            
            self.isQuitDateSet()
        }
        alertController.addAction(yesAction)
        
        let noAction = UIAlertAction(title: "No", style: .default) { _ in
            let textField = alertController.textFields![0] as UITextField
            self.viewModel?.persistenceManager?.addCraving(
                catagory: (textField.text != nil) ? textField.text! : "",
                smoked: false)
            self.processCravingData()
            self.viewModel?.appStoreReview(quitData: self.quitData)
            self.isQuitDateSet()
        }
        alertController.addAction(noAction)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Mood/trigger"
        }
        
        self.present(alertController, animated: true)
    }
}

////SECTION 2 - savings info
extension MainVC {
    
    internal func setupSection2() {
        
        savingsPageControl.isHidden = false
        addSavingButton.isHidden = false
        removeSavingsSubViews()
        savingsPageControllerCount()
        populateScrollView()
    }
    
    private func removeSavingsSubViews() {
        
        let subViews = self.savingsScrollView.subviews
        for subview in subViews { subview.removeFromSuperview() }
    }
    
    private func savingsPageControllerCount() {
        self.savingsPageControl.numberOfPages = viewModel?.countForSavingPageController() ?? 0
    }
    
    private func populateScrollView() {
        
        guard viewModel != nil, viewModel?.persistenceManager != nil else { return }
        
        let width = self.savingsScrollView.bounds.width
        let height = self.savingsScrollView.bounds.height
        
        savingsScrollView.addSubview(financialSummary(height: height, width: width))
        
        //Set up any potential savings goals
        
        guard viewModel!.persistenceManager!.savingsGoals.count > 0 else { return }
        
        for goal in 0..<viewModel!.persistenceManager.savingsGoals.count {
            
            let savingGoal = viewModel!.persistenceManager!.savingsGoals[goal]
            let savingProgress = savingsProgress(goal: savingGoal,
                                                 index: goal,
                                                 height: height,
                                                 width: width)
            if savingProgress != nil {
                self.savingsScrollView.addSubview(savingProgress!)
                self.savingsScrollView.addSubview(savingsNameLabel(goal: savingGoal,
                                                                    index: goal,
                                                                    height: height,
                                                                    width: width))
            }
        }
        savingScrollAdmin()
    }
    
    //Generating UI elements for savings info
    
    private func financialSummary(height: CGFloat, width: CGFloat) -> UITextView {
        
        let savingsOverviewText = UITextView(frame: CGRect(x: 0,
                                                           y: height / 3,
                                                           width: width,
                                                           height: height))
        savingsOverviewText.attributedText = viewModel?.savingsAttributedText(quitData: quitData)
        savingsOverviewText.backgroundColor = .clear
        savingsOverviewText.isEditable = false
        savingsOverviewText.isSelectable = false
        return savingsOverviewText
    }
    
    private func savingsProgress(goal: SavingGoal,
                                 index: Int,
                                 height: CGFloat,
                                 width: CGFloat) -> KDCircularProgress? {
        
        guard let chartGen = viewModel?.chartFactory else { return nil }
        
        let savingGoalProgressView = chartGen.generateProgressView()
        savingGoalProgressView.tag = index
        savingGoalProgressView.frame = CGRect(x: width * CGFloat(index + 1),
                                              y: 0,
                                              width: width,
                                              height: height)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapOnASavingsGoal(_:)))
        tap.numberOfTapsRequired = 1
        savingGoalProgressView.addGestureRecognizer(tap)
        savingGoalProgressView.animate(toAngle: viewModel!.savingsProgressAngle(goalAmount: goal.goalAmount,
                                                                                quitData: quitData)!,
                                       duration: 2,
                                       completion: nil)
        return savingGoalProgressView
    }
    
    private func savingsNameLabel(goal: SavingGoal, index: Int, height: CGFloat, width: CGFloat) -> UILabel {
        
        let label = UILabel(frame: CGRect(x: (width * CGFloat(index + 1) + (width / 3)),
                                          y: height / 2,
                                          width: width - (width / 3),
                                          height: 100))
        guard let savingGoalName = goal.goalName else { return UILabel() }
        let string = NSAttributedString(string: savingGoalName, attributes: Constants.savingsInfoAttributes)
        label.attributedText = string
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        return label
    }
    
    private func savingScrollAdmin() {
        
        let scrollWidth = savingsScrollView.frame.width
        let scrollHeight = savingsScrollView.frame.height
        let goalsCount = viewModel?.countForSavingPageController() ?? 1
        savingsScrollView.contentSize = CGSize(width: scrollWidth * CGFloat(goalsCount),
                                                    height: scrollHeight)
        savingsScrollView.delegate = self
        savingsPageControl.currentPage = 0
    }
    
    @objc private func handleTapOnASavingsGoal(_ sender: UITapGestureRecognizer) {
        
        let view = sender.view
        guard let tag = view?.tag else { return }
        let savingGoal = viewModel?.persistenceManager?.savingsGoals[tag]
        performSegue(withIdentifier: "toSavingGoalVC", sender: savingGoal)
    }
}

////SECTION 3 - Craving information
extension MainVC {
    
    private func setupSection3() {
        
        cravingPageControl.isHidden = false
        setupScrollView()
        processCravingData()
    }
    
    private func removeCravingsSubViews() {
        
        let subViews = self.cravingScrollView.subviews
        for subview in subViews { subview.removeFromSuperview() }
    }
    
    private func setupScrollView() {
        
        removeCravingsSubViews()
        cravingPageControl.isHidden = true
        
        guard viewModel?.persistenceManager.cravings != nil,
            viewModel?.persistenceManager.cravings.count != 0 else { return }
        
        cravingPageControl.isHidden = false
        let scrollViewHeight = cravingScrollView.bounds.height
        let scrollViewWidth = cravingScrollView.bounds.width
        
        if let barChart = viewModel?.chartFactory?.generateBarChart(width: scrollViewHeight, height: scrollViewHeight) {
            cravingScrollView.addSubview(barChart)
        }
        catagoryTextView = catagoryTextField(width: scrollViewWidth, height: scrollViewHeight)
        cravingScrollView.addSubview(catagoryTextView!)
        cravingScrollView.contentSize = CGSize(width: scrollViewWidth * 2, height: scrollViewHeight)
        cravingScrollView.bounces = false
        cravingScrollView.delegate = self
    }
    
    private func catagoryTextField(width: CGFloat, height: CGFloat) -> UITextView {
        
        let catagoryTextField = UITextView()
        catagoryTextField.frame = CGRect(x: width * 1, y: 0, width: width - 10, height: height)
        catagoryTextField.backgroundColor = .clear
        catagoryTextField.isEditable = false
        return catagoryTextField
    }
    
    private func processCravingData() {
        
        guard let data = viewModel?.processCravingData() else { return }
        let triggers = viewModel?.chartFactory?.updateCravingData(cravingDict: data.0,
                                                      smokedDict: data.1,
                                                      catagoryDict: data.2)
        catagoryTextView?.attributedText = triggers
    }
}

////SECTION 4 - Health
extension MainVC {
    
    func setupSection4() {
        prepareHealthScrollView()
    }
    
    func prepareHealthScrollView() {
        
        guard viewModel != nil else { return }
        
        let scrollViewWidth = self.healthScrollView.frame.width
        hideHealthStats()
        
        var int = 0
        for (index, xValue) in Constants.healthStats {

            let label = generateHealthLabel(int: int,
                                            width: scrollViewWidth,
                                            xValue: xValue,
                                            iValue: index)
            self.healthScrollView.addSubview(label)
            int += Int(label.bounds.height)
        }
        
        self.healthScrollView.bounces = false
        self.healthScrollView.alwaysBounceHorizontal = false
        self.healthScrollView.contentSize = CGSize(width: scrollViewWidth,
                                                   height: CGFloat(Constants.healthStats.count * 100))
        self.healthScrollView.delegate = self
    }
    
    func generateHealthLabel(int: Int, width: CGFloat, xValue: Double, iValue: String) -> UILabel {
        
        let label = UILabel(frame: CGRect(x: 0, y: int, width: Int(width), height: 100))
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        let attString: NSAttributedString?
        if (quitData!.minuteSmokeFree! / xValue) * 100 < 100 {
            attString = NSAttributedString(
                string: "\(iValue): \(Int((quitData!.minuteSmokeFree! / xValue) * 100 < 100 ? (quitData!.minuteSmokeFree! / xValue) * 100 : 100))%",
                attributes: Constants.notAchieved)
        } else {
            attString = NSAttributedString(string: "\(iValue): 100%", attributes: Constants.achieved)
        }
        label.attributedText = attString
        return label
    }
}

////Multi-section functions
extension MainVC {
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView == savingsScrollView {
            let pageWidth = savingsScrollView.frame.width
            let currentPage = floor((savingsScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
            self.savingsPageControl.currentPage = Int(currentPage)
        } else if scrollView == cravingScrollView {
            let pageWidth = cravingScrollView.frame.width
            let currentPage = floor((cravingScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
            self.cravingPageControl.currentPage = Int(currentPage)
        }
    }
}
