//
//  TaskTimerAttributes.swift
//  Runner
//
//  Created by Magalie Kalash on 18/08/2025.
//


import Foundation
import ActivityKit


struct TaskTimerAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var taskId: String
        var startedAt: Date?
        var elapsed: Int
        var isRunning: Bool
    }
    var title: String
}
