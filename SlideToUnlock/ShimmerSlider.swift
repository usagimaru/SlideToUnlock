//
//  ContentView.swift
//  SlideToUnlock
//
//  Created by usagimaru on 2025/03/03.
//

import SwiftUI

#Preview {
	ZStack {
		Rectangle()
			.foregroundStyle(.black)
			.ignoresSafeArea()
		VStack(spacing: 0) {
			ShimmerSliderComponent(placeholderText: "slide to unlock")
			ShimmerSliderComponent(placeholderText: "スライドして解除")
			ShimmerSliderComponent(placeholderText: "きらきらひかる")
			ShimmerSliderComponent(placeholderText: "スライダーの溝よ")
		}
	}
}

/// スライダー + 背景
struct ShimmerSliderComponent: View {
	
	@State var backViewHeight: CGFloat = 88
	@State var horizontalPadding: CGFloat = 30
	@State var placeholderText: String
	
	var body: some View {
		ZStack {
			ShimmerSliderBackView()
				.frame(height: backViewHeight, alignment: .bottom)
			ShimmerSlider(placeholderText: placeholderText)
				.padding(.horizontal, horizontalPadding)
		}
	}
	
}

/// スライダー
struct ShimmerSlider: View {
	
	@State var placeholderText: String
	@State var cornerRadius: CGFloat = 12
	@State var knobSize: CGSize = .init(width: 68, height: 44)
	@State var groovePadding: CGFloat = 4
	
	@State private var isAnimated: Bool = false
	@State private var offset: CGFloat = 0
	@State private var shimmerOpacity: CGFloat = 1.0
	
	var body: some View {
		ZStack {
			SliderGroove(placeholderText: $placeholderText, cornerRadius: cornerRadius + groovePadding, shimmerOpacity: $shimmerOpacity)
				.frame(height: knobSize.height + groovePadding * 2)
				.overlay {
					GeometryReader { geo in
						SliderKnob(cornerRadius: cornerRadius)
							.frame(width: knobSize.width, height: knobSize.height)
							.offset(x: offset, y: groovePadding)
							.gesture(
								DragGesture()
									.onChanged { gesture in
										isAnimated = false
										offset = min(
											max(gesture.translation.width, 0),
											geo.size.width - knobSize.width - groovePadding * 2
										)
										
										let adj = (geo.size.width - knobSize.width) / 2
										shimmerOpacity = 1.0 - (offset / (geo.size.width - knobSize.width - groovePadding * 2 - adj))
									}
									.onEnded { _ in
										isAnimated = true
										offset = .zero
										shimmerOpacity = 1.0
									}
							)
							.animation(.spring(response: 0.1, dampingFraction: 1.0, blendDuration: 0.3),
									   value: isAnimated)
							.padding(.horizontal, 4)
					}
				}
				.clipShape(RoundedRectangle(cornerRadius: cornerRadius + groovePadding + 1))
		}
	}
	
}

/// スライダー背景ビュー
struct ShimmerSliderBackView: View {
	
	var body: some View {
		ZStack {
			LinearGradient(stops: [
				Gradient.Stop(color: Color(white: 0.30), location: 0.0),
				Gradient.Stop(color: Color(white: 0.15), location: 0.50),
				Gradient.Stop(color: Color(white: 0.05), location: 0.50),
				Gradient.Stop(color: Color(white: 0.03), location: 1.0),
			],
						   startPoint: .top,
						   endPoint: .bottom)
		}
		.overlay {
			GeometryReader { geo in
				Rectangle()
					.strokeBorder(Color.white, lineWidth: 1)
					.frame(width: geo.size.width + 2)
					.offset(x: -1)
					.opacity(0.2)
					.clipped()
			}
		}
		.opacity(0.95)
	}
}

/// 溝
struct SliderGroove: View {
	
	@Binding var placeholderText: String
	@State var cornerRadius: CGFloat = 12
	@Binding var shimmerOpacity: CGFloat
	
	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: cornerRadius)
				.fill(
					LinearGradient(stops: [
						Gradient.Stop(color: Color(white: 0.05, opacity: 1.0), location: 0.0),
						Gradient.Stop(color: Color(white: 0.15, opacity: 1.0), location: 1.0),
					],
								   startPoint: .top,
								   endPoint: .bottom)
				)
				.clipShape(RoundedRectangle(cornerRadius: cornerRadius))
				.overlay {
					RoundedRectangle(cornerRadius: cornerRadius + 1)
						.strokeBorder(
							LinearGradient(gradient: Gradient(colors: [
								Color(white: 0.50, opacity: 1.0),
								Color(white: 0.60, opacity: 1.0)
							]),
										   startPoint: .top,
										   endPoint: .bottom),
							lineWidth: 1)
						.opacity(1.0)
						.blendMode(.colorDodge)
				}
			
			ShimmerText(text: placeholderText,
						font: .init(UIFont(name: "Helvetica Neue", size: 23)!),
						textColor: .init(white: 0.3))
			.opacity(shimmerOpacity)
		}
	}
	
}

/// つまみ
struct SliderKnob: View {
	
	@State var cornerRadius: CGFloat = 20
	@State var arrowHandWidth: CGFloat = 13
	@State var arrowHeadSize: CGFloat = 18
	@State var paddingVertically: CGFloat = 10
	@State var paddingHorizontally: CGFloat = 16
	@State var horizontalAdjustment: CGFloat = 2
	
	var body: some View {
		GeometryReader { geo in
			ZStack {
				LinearGradient(stops: [
					Gradient.Stop(color: Color(white: 1.00), location: 0.00),
					Gradient.Stop(color: Color(white: 0.85), location: 0.50),
					Gradient.Stop(color: Color(white: 0.82), location: 0.50),
					Gradient.Stop(color: Color(white: 0.64), location: 1.00),
				],
							   startPoint: .top,
							   endPoint: .bottom)
				VStack {
					HStack {
						ArrowView(arrowHandWidth: arrowHandWidth, arrowHeadSize: arrowHeadSize)
							.offset(x: horizontalAdjustment)
							.padding(.vertical, paddingVertically)
							.padding(.horizontal, paddingHorizontally)
					}
				}
			}
			.overlay(
				RoundedRectangle(cornerRadius: cornerRadius)
					.stroke(.white, lineWidth: 1)
			)
			.clipShape(.rect(cornerRadius: cornerRadius))
			.shadow(color: .black.opacity(0.5), radius: 6, x: 0, y: 3)
		}
	}
}

/// 矢印
struct ArrowView: View {
	
	@State var arrowHandWidth: CGFloat = 40
	@State var arrowHeadSize: CGFloat = 60
	@State var bevelDepth: CGFloat = 0.5
	@State var bevelBlurSize: CGFloat = 0.5
	@State var bevelOpacity: CGFloat = 0.8
	
	var body: some View {
		GeometryReader { geo in
			let arrowWidth = geo.size.height
			
			Path { path in
				path.move(to: CGPoint(x: 0, y: arrowWidth / 2))
				path.addLine(to: CGPoint(x: 0, y: arrowWidth / 2 - arrowHandWidth / 2))
				path.addLine(to: CGPoint(x: geo.size.width - arrowHeadSize, y: arrowWidth / 2 - arrowHandWidth / 2))
				path.addLine(to: CGPoint(x: geo.size.width - arrowHeadSize, y: 0))
				path.addLine(to: CGPoint(x: geo.size.width, y: arrowWidth / 2))
				path.addLine(to: CGPoint(x: geo.size.width - arrowHeadSize, y: geo.size.height))
				path.addLine(to: CGPoint(x: geo.size.width - arrowHeadSize, y: arrowWidth / 2 + arrowHandWidth / 2))
				path.addLine(to: CGPoint(x: 0, y: arrowWidth / 2 + arrowHandWidth / 2))
				path.closeSubpath()
			}
			// inner shadow / drop shadow
			.fill(
				LinearGradient(stops: [
					Gradient.Stop(color: Color(hue: 0, saturation: 0, brightness: 0.80), location: 0.0),
					Gradient.Stop(color: Color(hue: 0, saturation: 0, brightness: 0.63), location: 0.50),
					Gradient.Stop(color: Color(hue: 0, saturation: 0, brightness: 0.55), location: 0.50),
					Gradient.Stop(color: Color(hue: 0, saturation: 0, brightness: 0.40), location: 1.0),
				],
							   startPoint: .top,
							   endPoint: .bottom)
					.shadow(.inner(color: .black.opacity(bevelOpacity),
								   radius: bevelBlurSize, x: 0, y: bevelDepth))
					.shadow(.drop(color: .white.opacity(bevelOpacity),
								  radius: bevelBlurSize, x: 0, y: bevelDepth))
			)
		}
	}
	
}
