//
//  ContentView.swift
//  Animated Progress Ring
//
//  Created by Karthick on 12/06/26.
//

import SwiftUI

struct ContentView: View {

    @State private var progress: CGFloat = 0
    @State private var pulse = false
    @State private var displayedPercentage = 0
    @State private var linearProgress: CGFloat = 0
    @State private var animationID = UUID()
    
    private func startAnimation() {
        animationID = UUID()
        progress = 0
        linearProgress = 0
        displayedPercentage = 0

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 2.5)) {
                progress = 1.0
            }
            withAnimation(.easeInOut(duration: 2.5)) {
                linearProgress = 1.0
            }

            for value in 0...100 {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(value) * 0.025) {
                    displayedPercentage = value
                }
            }
        }
    }

    var body: some View {
        VStack(spacing: 30) {

            ZStack {

                Circle()
                    .stroke(
                        Color.gray.opacity(0.15),
                        lineWidth: 20
                    )
                    .scaleEffect(pulse ? 1.05 : 0.95)
                    .opacity(pulse ? 0.6 : 1)

                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        AngularGradient(
                            colors: [.red, .orange, .yellow, .green],
                            center: .center
                        ),
                        style: StrokeStyle(
                            lineWidth: 20,
                            lineCap: .round
                        )
                    )
                    .shadow(color: .blue.opacity(0.5), radius: 10)
                    .shadow(color: .purple.opacity(0.4), radius: 20)
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 2.0, dampingFraction: 0.8), value: progress)
                    .id(animationID)

                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.blue.opacity(0.25), .clear],
                            center: .center,
                            startRadius: 10,
                            endRadius: 70
                        )
                    )
                    .frame(width: 120, height: 120)
                    .scaleEffect(pulse ? 1.15 : 0.9)

                VStack(spacing: 4) {
                    Text("\(displayedPercentage)%")
                        .font(.system(size: 42, weight: .bold))

                    Text("Completed")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 220, height: 220)

            VStack(alignment: .leading, spacing: 10) {

                HStack {
                    Text("Progress")
                        .font(.headline)

                    Spacer()

                    Text("\(displayedPercentage)%")
                        .fontWeight(.semibold)
                }

                GeometryReader { geometry in
                    ZStack(alignment: .leading) {

                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.15))
                            .frame(height: 16)

                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: [.red, .orange, .yellow, .green],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(
                                width: geometry.size.width * linearProgress,
                                height: 16
                            )
                            .animation(.easeInOut(duration: 2.5), value: linearProgress)
                    }
                }
                .frame(height: 16)
            }
            .padding(.horizontal, 30)
        }
        .onAppear {
            startAnimation()

            withAnimation(
                .easeInOut(duration: 1.5)
                .repeatForever(autoreverses: true)
            ) {
                pulse = true
            }
        }
    }
}
