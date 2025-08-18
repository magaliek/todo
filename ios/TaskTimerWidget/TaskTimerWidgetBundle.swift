//
//  TaskTimerWidgetBundle.swift
//  TaskTimerWidget
//
//  Created by Magalie Kalash on 18/08/2025.
//

import WidgetKit
import SwiftUI

@main
struct TaskTimerWidgetBundle: WidgetBundle {
    var body: some Widget {
        TaskTimerWidget()
        TaskTimerWidgetControl()
        TaskTimerLiveActivity()
    }
}
