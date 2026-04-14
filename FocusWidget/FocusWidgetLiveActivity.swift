//
//  FocusWidgetLiveActivity.swift
//  FocusWidget
//
//  Created by Felicia Joshlyn Purnomo on 12/04/26.
//

import ActivityKit
import AppIntents
import SwiftUI
import WidgetKit

struct FocusWidgetLiveActivity: Widget {

    var body: some WidgetConfiguration {
        ActivityConfiguration(for: FocusAttributes.self) { context in
            //MARK: LOCK SCREEN UI
            HStack(alignment: .center, spacing: 0) {

                // 1. LEFT SIDE: The Hamster
                Image("HamsterIdle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 85, height: 85)
                    // Extra padding so he doesn't touch the very edge of the "bubble"
                    .padding(.leading, 15)

                // 2. THE RIGHT SIDE: Pushed to the edge with padding
                VStack(alignment: .trailing, spacing: 0) {
                    
                    // Task Name
                    Text(context.attributes.taskName)
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.white.opacity(0.6))
                        .padding(.trailing, 8)

                    // LARGE TIMER
                    Group {
                        if context.state.mode == .focus {
                            Text(context.state.startTime, style: .timer)
                        } else {
                            Text(
                                timerInterval: context.state
                                    .startTime...(context.state.startTime
                                    .addingTimeInterval(900)),
                                countsDown: true
                            )
                        }
                    }
                    .font(.system(size: 44, weight: .bold, design: .rounded))  // Slightly smaller to accommodate padding
                    .monospacedDigit()
                    .foregroundStyle(.white)
                    .padding(.vertical, -2)

                    // CIRCULAR BUTTONS
                    HStack(spacing: 14) {
                        // STOP
                        Button(intent: StopSessionIntent()) {
                            ZStack {
                                Circle().fill(.white).frame(
                                    width: 42,
                                    height: 42
                                )
                                Image(systemName: "square.fill").font(
                                    .system(size: 14)
                                ).foregroundStyle(.black)
                            }
                        }
                        .buttonStyle(.plain)

                        // PAUSE
                        Button(intent: ToggleBreakIntent()) {
                            ZStack {
                                Circle().fill(.white.opacity(0.15)).frame(
                                    width: 42,
                                    height: 42
                                )
                                Image(
                                    systemName: context.state.mode == .focus
                                        ? "pause.fill" : "play.fill"
                                )
                                .font(.system(size: 16)).foregroundStyle(.white)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.top, 4)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 20)  // Pushes content away from the right edge
            }
            .padding(.vertical, 12)  // Adds space at the very top and bottom of the bubble
            .activityBackgroundTint(Color.black)
        } dynamicIsland: { context in
            // MARK: - DYNAMIC ISLAND UI
            DynamicIsland {
                // Leading: The Big Hamster
                DynamicIslandExpandedRegion(.leading) {
                    Image("HamsterIdle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)  // Keep him large
                        .padding(.leading, 6)
                }

                // Trailing: Timer AND Buttons together
                // Putting buttons here prevents the "pushing down" effect
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing, spacing: 8) {
                        // The Timer
                        Group {
                            if context.state.mode == .focus {
                                Text(context.state.startTime, style: .timer)
                            } else {
                                Text(
                                    timerInterval: context.state
                                        .startTime...(context.state.startTime
                                        .addingTimeInterval(900)),
                                    countsDown: true
                                )
                            }
                        }
                        .font(
                            .system(size: 30, weight: .bold, design: .rounded)
                        )
                        .monospacedDigit()
                        .foregroundStyle(.white)

                        // The Buttons (Now inside the trailing column)
                        HStack(spacing: 12) {
                            Button(intent: StopSessionIntent()) {
                                ZStack {
                                    Circle().fill(.white).frame(
                                        width: 44,
                                        height: 44
                                    )
                                    Image(systemName: "square.fill").font(
                                        .system(size: 14)
                                    ).foregroundStyle(.black)
                                }
                            }
                            .buttonStyle(.plain)

                            Button(intent: ToggleBreakIntent()) {
                                ZStack {
                                    Circle().fill(.white.opacity(0.15)).frame(
                                        width: 44,
                                        height: 44
                                    )
                                    Image(
                                        systemName: context.state.mode == .focus
                                            ? "pause.fill" : "play.fill"
                                    )
                                    .font(.system(size: 16)).foregroundStyle(
                                        .white
                                    )
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.trailing, 8)
                    .padding(.top, 10)
                }

                // We leave .bottom empty so the island stays compact
                //MARK: COMPACT VER
            } compactLeading: {
                Image("HamsterIdle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(2)
            } compactTrailing: {
                if context.state.mode == .focus {
                    Text(context.state.startTime, style: .timer)
                        .monospacedDigit()
                        .font(
                            .system(.caption2, design: .rounded, weight: .bold)
                        )
                        .foregroundStyle(.white)
                        .frame(width: 43)
                } else {
                    Text(
                        timerInterval: context.state
                            .startTime...(context.state.startTime
                            .addingTimeInterval(900)),
                        countsDown: true
                    )
                    .monospacedDigit()
                    .font(.system(.caption2, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 43)
                }
            } minimal: {
                Image(systemName: "timer")
                    .foregroundStyle(.white)
            }
            .keylineTint(.white.opacity(0.3))
        }
    }
}
