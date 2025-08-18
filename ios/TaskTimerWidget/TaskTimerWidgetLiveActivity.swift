import WidgetKit
import SwiftUI
import ActivityKit

struct TaskTimerLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TaskTimerAttributes.self) { context in
            // 🔒 Lock Screen presentation
            VStack(alignment: .leading, spacing: 8) {
                Text(context.attributes.title)
                    .font(.headline)

                // Smooth updating every second
                if let startedAt = context.state.startedAt,
                   context.state.isRunning {
                    TimelineView(.periodic(from: .now, by: 1)) { _ in
                        Text(formatElapsed(
                            baseElapsed: context.state.elapsed,
                            startedAt: startedAt
                        ))
                        .monospacedDigit()
                        .font(.title2)
                    }
                } else {
                    Text(formatStaticElapsed(context.state.elapsed))
                        .monospacedDigit()
                        .font(.title2)
                }

                if !context.state.isRunning {
                    Text("Paused")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
            .activityBackgroundTint(Color.black.opacity(0.4))
            .activitySystemActionForegroundColor(.white)

        } dynamicIsland: { context in
            // 🍎 Dynamic Island regions
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    VStack {
                        Text(context.attributes.title)
                        if let startedAt = context.state.startedAt,
                           context.state.isRunning {
                            TimelineView(.periodic(from: .now, by: 1)) { _ in
                                Text(formatElapsed(
                                    baseElapsed: context.state.elapsed,
                                    startedAt: startedAt
                                ))
                                .monospacedDigit()
                            }
                        } else {
                            Text(formatStaticElapsed(context.state.elapsed))
                                .monospacedDigit()
                        }
                    }
                }
            } compactLeading: {
                Image(systemName: "timer")
            } compactTrailing: {
                if let startedAt = context.state.startedAt,
                   context.state.isRunning {
                    TimelineView(.periodic(from: .now, by: 1)) { _ in
                        Text(formatElapsed(
                            baseElapsed: context.state.elapsed,
                            startedAt: startedAt
                        ))
                        .monospacedDigit()
                    }
                } else {
                    Text(formatStaticElapsed(context.state.elapsed))
                        .monospacedDigit()
                }
            } minimal: {
                Image(systemName: "timer")
            }
        }
    }
}

// MARK: - Helpers
fileprivate func formatElapsed(baseElapsed: Int, startedAt: Date) -> String {
    let total = baseElapsed + Int(Date().timeIntervalSince(startedAt))
    return formatStaticElapsed(total)
}

fileprivate func formatStaticElapsed(_ secs: Int) -> String {
    let h = secs / 3600
    let m = (secs % 3600) / 60
    let s = secs % 60
    return String(format: "%02d:%02d:%02d", h, m, s)
}
