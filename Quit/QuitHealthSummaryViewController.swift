//
//  QuitHealthSummaryViewController.swift
//  Quit
//
//  Created by Alex Tudge on 22/11/2019.
//  Copyright © 2019 Alex Tudge. All rights reserved.
//

import UIKit

class QuitHealthSummaryViewController: QuitCelebrationBaseViewController {
    
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var titleLabel: QuitLabel!
    @IBOutlet private weak var textView: UITextView!
    
//    var healthStat: HealthStats?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

private extension QuitHealthSummaryViewController {
    func setupUI() {
        stackView.layer.cornerRadius = 5
        stackView.backgroundColor = UIColor.quitBackgroundColour.withAlphaComponent(0.6)
//        textView.text = healthStat?.information()
        guard let profile = persistenceManager?.getProfile(),
            let minuteSmokeFree = profile.minutesSmokeFree else {
            return
        }
//        let time = (healthStat?.secondsForHealthState() ?? 0) / 60
//        let progress = Float(minuteSmokeFree / time)
//        if progress >= 1 {
//            setupEmitter()
//        }
    }
}
