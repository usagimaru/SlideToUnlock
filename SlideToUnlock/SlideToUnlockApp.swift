//
//  SlideToUnlockApp.swift
//  SlideToUnlock
//
//  Created by usagimaru on 2025/03/03.
//

import SwiftUI

#Preview {
	LockScreenView()
	//DemoView()
}

@main
struct SlideToUnlockApp: App {
	var body: some Scene {
		WindowGroup {
			LockScreenView()
		}
	}
}

struct DemoView: View {
	var body: some View {
		ZStack {
			Rectangle()
				.foregroundStyle(.black)
			VStack(spacing: 0) {
				Spacer()
				ShimmerSliderComponent(placeholderText: "slide to unlock")
				ShimmerSliderComponent(placeholderText: "スライドして解除")
				ShimmerSliderComponent(placeholderText: "きらきらひかる")
				Spacer()
				ShimmerSliderComponent(backViewHeight: 140,
									   placeholderText: "slide to unlock")
				.offset(y: 1)
			}
		}
		.ignoresSafeArea()
	}
}

// ホビーアプリなので、雑な実装は許して、、🙈
struct LockScreenView: View {
	var body: some View {
		ZStack {
//			Rectangle()
//				.foregroundStyle(.red)
//				.ignoresSafeArea()
			GeometryReader { geo in
				Image("fish")
					.resizable()
					.scaledToFill()
					.ignoresSafeArea()
					.frame(width: geo.size.width, height: geo.size.height)
					.offset(x: 50)
			}
			
			VStack {
				ZStack {
					Rectangle()
						.foregroundStyle(.clear)
						.frame(height: 200)
						.overlay(
							LinearGradient(stops: [
								Gradient.Stop(color: Color(white: 0.30), location: 0.0),
								Gradient.Stop(color: Color(white: 0.15), location: 0.50),
								Gradient.Stop(color: Color(white: 0.05), location: 0.50),
								Gradient.Stop(color: Color(white: 0.03), location: 1.0),
							],
										   startPoint: .top,
										   endPoint: .bottom)
						)
						.opacity(0.70)
					VStack {
						Spacer()
							.frame(height: 30)
						Text("9:41")
							.font(.init(UIFont(name: "Helvetica Neue", size: 92)!))
							.fontWeight(.light)
							.foregroundStyle(
								Color.white.shadow(
									.inner(color: .black.opacity(0.5), radius: 0, x: 0, y: 1)
								)
							)
						Text("Tuesday, January 9")
							.font(.init(UIFont(name: "Helvetica Neue", size: 21)!))
							.foregroundStyle(
								Color.white.shadow(
									.inner(color: .black.opacity(0.5), radius: 0, x: 0, y: 0.5)
								)
							)
					}
				}
				.overlay {
					GeometryReader { geo in
						Rectangle()
							.strokeBorder(Color.white, lineWidth: 1)
							.frame(width: geo.size.width + 2, height: geo.size.height + 1)
							.offset(x: -1, y: -1)
							.opacity(0.2)
							.clipped()
					}
				}
				
				Spacer()
				ShimmerSliderComponent(backViewHeight: 140,
									   placeholderText: "slide to unlock",
									   grooveOpacity: 0.9,
									   backOpacity: 0.70)
					.offset(y: 1)
					.compositingGroup()
					
			}
			.ignoresSafeArea()
			.compositingGroup()
			.shadow(color: .black.opacity(0.2), radius: 10, y: 5)
		}
	}
}

