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
			.foregroundStyle(.orange)
			.brightness(-0.3)
			.ignoresSafeArea()
		VStack(spacing: 0) {
			ShimmerSliderComponent(properties: .init(placeholderText: "slide to unlock"))
			ShimmerSliderComponent(properties: .init(placeholderText: "滑動解鎖"))
			ShimmerSliderComponent(properties: .init(placeholderText: "الانزلاق لفتح القفل"))
				.environment(\.layoutDirection, .rightToLeft)
			ShimmerSliderComponent(properties: .init(placeholderText: "slide to unlock"))
				.environment(\.layoutDirection, .rightToLeft)
		}
	}
}

struct ShimmerSliderProperties {
	
	var placeholderText: String
	
	var font: Font = .init(UIFont(name: "Helvetica Neue", size: 21)!)
	var textColor: Color = .init(white: 0.3)
	
	var backViewHeight: CGFloat = 88
	var horizontalPadding: CGFloat = 30
	var grooveOpacity: CGFloat = 0.9
	var backOpacity: CGFloat = 0.7
	
	var knobCornerRadius: CGFloat = 12
	var knobSize: CGSize = .init(width: 68, height: 44)
	var groovePadding: CGFloat = 4
	
}

/// スライダー + 背景
struct ShimmerSliderComponent: View {
	
	@State var properties: ShimmerSliderProperties
	
	var body: some View {
		ZStack {
			ShimmerSliderBackView(properties: properties, withGroove: true)
			ShimmerSlider(properties: properties)
				.padding(.horizontal, properties.horizontalPadding)
		}
	}
	
}

/// スライダー
struct ShimmerSlider: View {
	
	@State var properties: ShimmerSliderProperties
	
	@State private var isAnimated: Bool = false
	@State private var offset: CGFloat = 0
	@State private var shimmerOpacity: CGFloat = 1.0
	
	var body: some View {
		ZStack {
			let grooveCornerRadius = properties.knobCornerRadius + properties.groovePadding - 1
			let height = properties.knobSize.height + properties.groovePadding * 2
			
			// 溝
			SliderGroove(properties: properties, shimmerOpacity: $shimmerOpacity)
				.frame(height: height)
				.opacity(properties.grooveOpacity)
				.overlay {
					GeometryReader { geo in
						// つまみ
						SliderKnob(cornerRadius: properties.knobCornerRadius)
							.frame(width: properties.knobSize.width, height: properties.knobSize.height)
							.offset(x: offset, y: properties.groovePadding)
							.gesture(
								DragGesture()
									.onChanged { gesture in
										isAnimated = false
										offset = min(
											max(gesture.translation.width, 0),
											geo.size.width - properties.knobSize.width - properties.groovePadding * 2
										)
										
										let adj = (geo.size.width - properties.knobSize.width) / 2
										shimmerOpacity = 1.0 - (offset / (geo.size.width - properties.knobSize.width - properties.groovePadding * 2 - adj))
									}
									.onEnded { _ in
										isAnimated = true
										offset = .zero
										shimmerOpacity = 1.0
									}
							)
							.animation(.spring(response: 0.2, dampingFraction: 1.0, blendDuration: 0),
									   value: isAnimated)
							.padding(.horizontal, properties.groovePadding)
						// RTLレイアウトの時にドラッグ方向を最適化する
							.flipsForRightToLeftLayoutDirection(true)
					}
				}
			// つまみの影が溝より外に出ないようにカットする
				.clipShape(RoundedRectangle(cornerRadius: grooveCornerRadius + 1))
		}
	}
	
}

/// スライダー背景ビュー
struct ShimmerSliderBackView: View {
	
	@State var properties: ShimmerSliderProperties
	@State var withGroove: Bool = false
	
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
		.frame(height: properties.backViewHeight)
		.overlay {
			GeometryReader { geo in
				ZStack {
					Rectangle()
						.frame(width: geo.size.width, height: 1)
						.foregroundStyle(.white)
						.blendMode(.overlay)
						.opacity(0.6)
					
					Rectangle()
						.frame(width: geo.size.width, height: 1)
						.offset(y: geo.size.height - 1)
						.foregroundStyle(.black)
						.blendMode(.multiply)
				}
			}
		}
		.overlay {
			Group {
				if withGroove {
					// 溝の裏に穴を開ける
					RoundedRectangle(cornerRadius: properties.knobCornerRadius + properties.groovePadding - 2)
						.padding(.horizontal, properties.horizontalPadding + 1)
						.padding(.vertical, (properties.backViewHeight - properties.knobSize.height) / 2 - properties.groovePadding + 1)
						.blendMode(.destinationOut)
				}
			}
		}
		.compositingGroup()
		.opacity(properties.backOpacity)
		.clipped()
	}
}

/// 溝
struct SliderGroove: View {
	
	@State var properties: ShimmerSliderProperties
	@Binding var shimmerOpacity: CGFloat
	
	@Environment(\.layoutDirection) var layoutDirection: LayoutDirection
	
	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: properties.knobCornerRadius)
				.fill(
					LinearGradient(stops: [
						Gradient.Stop(color: Color(white: 0.05, opacity: 1.0), location: 0.0),
						Gradient.Stop(color: Color(white: 0.15, opacity: 1.0), location: 1.0),
					],
								   startPoint: .top,
								   endPoint: .bottom)
				)
				.overlay {
					RoundedRectangle(cornerRadius: properties.knobCornerRadius + properties.groovePadding)
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
			
			ShimmerText(text: properties.placeholderText,
						font: properties.font,
						textColor: properties.textColor,
						isRTL: layoutDirection == .rightToLeft ? true : false)
			.opacity(shimmerOpacity)
		}
	}
	
}

/// つまみ
struct SliderKnob: View {
	
	@State var cornerRadius: CGFloat
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
							.offset(x: 1.0)
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
	
	@State var arrowHandWidth: CGFloat
	@State var arrowHeadSize: CGFloat
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
