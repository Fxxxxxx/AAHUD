//
//  HUD.swift
//  Test
//
//  Created by Fxxx on 2018/11/12.
//  Copyright © 2018 Aaron Feng. All rights reserved.
//

import UIKit
import MBProgressHUD

public class HUD: NSObject {
    
    static private let windowManager = WindowManager()
    
    @discardableResult
    public class func showLoading(message: String?, view: UIView? = nil, mode: MBProgressHUDMode = .indeterminate, mask: Bool = false) -> MBProgressHUD {
        
        let showView = view ?? windowManager.window!
        let hud = MBProgressHUD.showAdded(to: showView, animated: true)
        showView.bringSubviewToFront(hud)
        hud.removeFromSuperViewOnHide = true
        hud.mode = mode
        if message != nil {
            hud.label.text = message
            hud.bezelView.color = UIColor.black
            hud.contentColor = UIColor.white
            hud.minSize = CGSize.init(width: 160, height: 90)
            hud.bezelView.layer.masksToBounds = true
            hud.bezelView.layer.cornerRadius = 10
        } else {
            hud.animationType = .zoom
            hud.bezelView.color = UIColor.clear
        }
        if mask {
            hud.backgroundColor = UIColor.init(white: 0, alpha: 0.3)
        }
        
        return hud
        
    }
    
    public class func hide(_ hud: MBProgressHUD) {
        DispatchQueue.main.async {
            hud.hide(animated: true)
        }
    }
    
    public class func hide(from view: UIView) {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    
    public class func hide() {
        hide(from: windowManager.window!)
    }
    
    public class func show(message: String, icon: UIImage? = nil, view: UIView? = nil) {
        
        let showView = view ?? windowManager.window!
        let hud = MBProgressHUD.showAdded(to: showView, animated: true)
        showView.bringSubviewToFront(hud)
        if icon != nil {
            hud.mode = .customView
            let imageView = UIImageView.init(image: icon)
            hud.customView = imageView
            hud.minSize = CGSize.init(width: 160, height: 90)
        } else {
            hud.mode = .text
        }
        hud.animationType = .zoomOut
        hud.removeFromSuperViewOnHide = true
        hud.isUserInteractionEnabled = false
        hud.bezelView.style = .blur
        hud.bezelView.layer.masksToBounds = true
        hud.bezelView.layer.cornerRadius = 10
        hud.bezelView.color = UIColor.black
        hud.label.textColor = UIColor.white
        hud.label.numberOfLines = 0
        hud.label.text = message
        hud.hide(animated: true, afterDelay: 1.0)
        
    }
    
    public class func showSuccess(_ success: String, view: UIView? = nil) {
        let icon = UIImage.init(named: "hud_success", in: bundle, compatibleWith: nil)
        show(message: success, icon: icon, view: view)
    }
    
    public class func showError(_ error: String, view: UIView? = nil) {
        let icon = UIImage.init(named: "hud_error", in: bundle, compatibleWith: nil)
        show(message: error, icon: icon, view: view)
    }
    
    public class func showInfo(_ info: String, view: UIView? = nil) {
        let icon = UIImage.init(named: "hud_info", in: bundle, compatibleWith: nil)
        show(message: info, icon: icon, view: view)
    }
    
}

extension HUD {
    static let bundle = getResourceBundle()
    static func getResourceBundle() -> Bundle? {
        let bundle = Bundle.init(for: HUD.self)
        let path = bundle.path(forResource: "HUD", ofType: "bundle")
        return Bundle.init(path: path ?? "")
    }
}

extension HUD {
    
    private class WindowManager: NSObject {
        
        var window: UIWindow?
        var isKeyboardShowing = false
        
        override init() {
            
            super.init()
            NotificationCenter.default.addObserver(self, selector: #selector(windowChange(sender:)), name: UIWindow.didBecomeVisibleNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(windowChange(sender:)), name: UIWindow.didBecomeHiddenNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(windowChange(sender:)), name: UIWindow.didBecomeKeyNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(windowChange(sender:)), name: UIWindow.didResignKeyNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(hiddenKeyboard), name: UIResponder.keyboardDidHideNotification , object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification , object: nil)
            window = frontWindow()
            
        }
        
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
        
        @objc private func hiddenKeyboard() {
            isKeyboardShowing = false
        }
        
        @objc private func showKeyboard() {
            isKeyboardShowing = true
        }
        
        @objc private func windowChange(sender: Notification) {
            window = frontWindow()
        }
        
        private func frontWindow() -> UIWindow? {
            
            for window in UIApplication.shared.windows.reversed() {
                
                guard window.screen == UIScreen.main else {
                    continue
                }
                guard !window.isHidden && window.alpha > 0 else {
                    continue
                }
                guard window.windowLevel >= .normal else {
                    continue
                }
                guard !window.description.hasPrefix("<UIRemoteKeyboardWindow") || isKeyboardShowing else {
                    continue
                }
                return window
                
            }
            return nil
            
        }
        
    }
    
}
