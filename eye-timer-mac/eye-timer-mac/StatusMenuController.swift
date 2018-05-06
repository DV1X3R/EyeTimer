//
//  StatusMenuController.swift
//  eye-timer-mac
//
//  Created by dx on 06/05/2018.
//  Copyright © 2018 DV1X3R. All rights reserved.
//

import Cocoa

class StatusMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var timerItem: NSMenuItem!
    
    @IBOutlet weak var timerView: NSView!
    @IBOutlet weak var timerSlider: NSSliderCell!
    @IBOutlet weak var timeLabel: NSTextField!
    @IBOutlet weak var statusLabel: NSTextField!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var stateRelax = false
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    override func awakeFromNib() {
        statusItem.menu = statusMenu
        timerItem.view = timerView
        
        let icon = NSImage(named: NSImage.Name(rawValue: "statusIcon"))
        icon?.isTemplate = true
        statusItem.image = icon

        let tickTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {
            timer in
            self.timerSlider.integerValue -= 1
            self.timeUpdate(self)
            self.stateUpdate()
        })
        RunLoop.main.add(tickTimer, forMode: .commonModes)
    }
    
    @IBAction func timeUpdate(_ sender: Any) {
        let m = self.timerSlider.integerValue / 60
        let s = self.timerSlider.integerValue % 60
        self.timeLabel.stringValue = String(m) + ":" + (s < 10 ? "0" + String(s) : String(s))
    }
    
    func stateUpdate()
    {
        if self.timerSlider.integerValue == 0
        {
            if stateRelax
            {
                deliverNotification(subtitle: "Work time", text: "20 min timer started")
                statusLabel.stringValue = "Work time"
                statusLabel.textColor = NSColor.systemRed
                timerSlider.maxValue = 20 * 60
            }
            else
            {
                deliverNotification(subtitle: "Relax time", text: "2 min timer started")
                statusLabel.stringValue = "Relax time"
                statusLabel.textColor = NSColor.systemGreen
                timerSlider.maxValue = 2 * 60
            }
            timerSlider.integerValue = Int(timerSlider.maxValue)
            stateRelax = !stateRelax
            timeUpdate(self)
        }
    }
    
    func deliverNotification(subtitle: String, text: String)
    {
        let notification = NSUserNotification()
        notification.title = "Eye Timer"
        notification.subtitle = subtitle
        notification.informativeText = text
        //notification.soundName = NSUserNotificationDefaultSoundName
        NSUserNotificationCenter.default.deliver(notification)
    }
    
}
