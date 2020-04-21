//  Created by Hameed Miya on 4/19/20.
//  Copyright © 2020 HMITL. All rights reserved.
//

import UIKit
import Toaster

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        /// Set Snack Bar Customization.
        ToastView.appearance().backgroundColor = .darkGray
        ToastView.appearance().font = .systemFont(ofSize: 20)
        
        return true
    }
}
