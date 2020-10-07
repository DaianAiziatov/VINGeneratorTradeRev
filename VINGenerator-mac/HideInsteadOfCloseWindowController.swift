//
//  HideInsteadOfCloseWindowController.swift
//  VINGenerator-mac
//
//  Created by Daian Aziatov on 2020-10-07.
//  Copyright © 2020 Daian Aziatov. All rights reserved.
//

import Cocoa

class HideInsteadOfCloseWindowController: NSWindowController, NSWindowDelegate {
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        NSApp.hide(nil)
        return false
    }
}
