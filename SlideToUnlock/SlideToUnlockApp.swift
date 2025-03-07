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
				ShimmerSliderComponent(properties: .init(placeholderText: "slide to unlock"))
				ShimmerSliderComponent(properties: .init(placeholderText: "ロック解除"))
				ShimmerSliderComponent(properties: .init(placeholderText: "滑動解鎖"))
				ShimmerSliderComponent(properties: .init(placeholderText: "الانزلاق لفتح القفل"))
					.environment(\.layoutDirection, .rightToLeft)
				ShimmerSliderComponent(properties: .init(placeholderText: "slide to unlock"))
					.environment(\.layoutDirection, .rightToLeft)
				Spacer()
				ShimmerSliderComponent(properties: .init(placeholderText: "slide to unlock", backViewHeight: 140))
				.offset(y: 1)
			}
		}
		.ignoresSafeArea()
		.preferredColorScheme(.light)
	}
}

// ホビーアプリなので、雑な実装は許して、、🙈
struct LockScreenView: View {
	var body: some View {
		GeometryReader { geo in
			ZStack {
//				Rectangle()
//					.foregroundStyle(.red)
//					.ignoresSafeArea()
				
				Image("fish")
					.resizable()
					.scaledToFill()
					.ignoresSafeArea()
					.offset(x: 54)
					.frame(width: geo.size.width, height: geo.size.height)
				
				VStack {
					ZStack {
						Rectangle()
							.foregroundStyle(.clear)
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
						
						VStack(spacing: 0) {
							Spacer()
								.frame(height: geo.safeAreaInsets.top)
							
							VStack {
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
									.padding(.bottom, 20)
							}
							.padding(0)
						}
					}
					.overlay {
						GeometryReader { geo in
							Rectangle()
								.frame(width: geo.size.width, height: 1)
								.offset(y: geo.size.height - 1)
								.foregroundStyle(.black)
								.blendMode(.multiply)
						}
					}
					.frame(height: 160 + geo.safeAreaInsets.bottom)
					
					Spacer()
					ShimmerSliderComponent(properties: .init(placeholderText: "slide to unlock",
															 backViewHeight: 160 + geo.safeAreaInsets.bottom))
					.offset(y: 1)
					.compositingGroup()
				}
				.ignoresSafeArea()
			}
			.compositingGroup()
			.shadow(color: .black.opacity(0.2), radius: 10, y: 5)
		}
		.preferredColorScheme(.light)
	}
}

