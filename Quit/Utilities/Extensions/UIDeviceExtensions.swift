//
//  UIDeviceExtensions.swift
//  Quit
//
//  Created by Alex Tudge on 09/11/2019.
//  Copyright © 2019 Alex Tudge. All rights reserved.
//

import UIKit

extension UIDevice {
    var isPortait: Bool {
        return orientation == .portrait || orientation == .portraitUpsideDown
    }
}
