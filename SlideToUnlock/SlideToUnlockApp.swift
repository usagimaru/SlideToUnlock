//
//  SlideToUnlockApp.swift
//  SlideToUnlock
//
//  Created by usagimaru on 2025/03/03.
//

import SwiftUI

#Preview {
	DemoView()
}

@main
struct SlideToUnlockApp: App {
	var body: some Scene {
		WindowGroup {
			DemoView()
		}
	}
}

struct DemoView: View {
	var body: some View {
		ZStack {
			Rectangle()
				.foregroundStyle(.black)
				.ignoresSafeArea()
			
			VStack {
				Spacer()
				VStack(spacing: 0) {
					ShimmerSliderComponent(placeholderText: "スライドして解除")
					ShimmerSliderComponent(placeholderText: "きらきらひかる")
					ShimmerSliderComponent(placeholderText: "made with SwiftUI")
				}
				Spacer()
				ShimmerSliderComponent(backViewHeight: 130, placeholderText: "slide to unlock")
					.offset(y: 1)
			}
			.ignoresSafeArea()
		}
	}
}

