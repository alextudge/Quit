//
//  Extensions.swift
//  Quit
//
//  Created by Alex Tudge on 05/02/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import Charts

extension Date {
    func offsetFrom(date: Date) -> String {
        if date > Date() {
            return "Counting down to your quit date!"
        }
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: date, to: self)
        let seconds = "\(difference.second ?? 0) secs"
        let minutes = "\(difference.minute ?? 0) mins" + "\n" + seconds
        let hours = "\(difference.hour ?? 0) hours" + "\n" + minutes
        let days = "\(difference.day ?? 0) days" + "\n" + hours
        if let day = difference.day, day > 0 {
            return days
        }
        if let hour = difference.hour, hour > 0 {
            return hours
        }
        if let minute = difference.minute, minute > 0 {
            return minutes
        }
        if let second = difference.second, second > 0 {
            return seconds
        }
        return ""
    }
}

class ChartXAxisFormatter: NSObject {
    private var dateFormatter: DateFormatter?
    private var referenceTimeInterval: TimeInterval?
    convenience init(referenceTimeInterval: TimeInterval, dateFormatter: DateFormatter) {
        self.init()
        self.referenceTimeInterval = referenceTimeInterval
        self.dateFormatter = dateFormatter
    }
}

extension ChartXAxisFormatter: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard let dateFormatter = dateFormatter,
            let referenceTimeInterval = referenceTimeInterval
            else {
                return ""
        }
        let date = Date(timeIntervalSince1970: value * 3600 * 24 + referenceTimeInterval)
        return dateFormatter.string(from: date)
    }
}

extension Int {
    var degreesToRadians: CGFloat {
        return CGFloat(self) * .pi / 180
    }
}

extension UIView {
    func gradient(colors: [CGColor]) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = layer.cornerRadius
        gradientLayer.colors = colors
        layer.insertSublayer(gradientLayer, at: 0)
        return gradientLayer
    }
    
    class func fromNib<T: UIView>() -> T {
        //swiftlint:disable:next force_cast
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

extension UITextField {
    func addDoneButtonToKeyboard(action: Selector?) {
        let doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        doneToolbar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: action)
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        self.inputAccessoryView = doneToolbar
    }
}

func standardisedDate(date: Date) -> Date {
    let formatter = DateFormatter()
    formatter.timeStyle = .none
    formatter.dateStyle = .short
    let stringDate = formatter.string(from: date)
    return formatter.date(from: stringDate)!
}

func mediumDateFormatter() -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
}
