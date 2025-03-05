//
//  ShimmerText.swift
//  SlideToUnlock
//
//  Created by usagimaru on 2025/03/05.
//

import SwiftUI

#Preview {
	ZStack {
		Rectangle()
			.foregroundStyle(.black)
		VStack(spacing: 20) {
			ShimmerText(text: "slide to unlock", textColor: .gray, _debug: true)
			ShimmerText(text: "slide to unlock", textColor: .gray)
		}
	}
}

struct ShimmerText: View {
	
	@State var text: String
	@State var font: Font =  .system(size: 21)
	@State var textColor: Color
	@State var shimmerColors: [Gradient.Stop]?
	@State var shimmerOffset: CGFloat = 10
	@State var horizontalPadding: CGFloat = 0
	@State var verticalPadding: CGFloat = 0
	@State var animationDuration: TimeInterval = 1.5
	@State var shimmerBlendMode: BlendMode = .colorDodge
	@State var masking: Bool = true
	
	@State var _debug: Bool = false
	@State private var shimmering: Bool = true
	
	static func defaultMaskColors() -> [Gradient.Stop] {
		[
			Gradient.Stop(color: .white, location: 0.0),
			Gradient.Stop(color: .white, location: 0.2),
			Gradient.Stop(color: .white.opacity(0.5), location: 0.5),
			Gradient.Stop(color: .clear, location: 1.0),
		]
	}
	
	var body: some View {
		ZStack {
			Text(text)
				.font(font)
				.foregroundStyle(textColor)
			
			// overlay()より前にpaddingを設定すると、overlay()の大きさも広げられる
				.padding(.horizontal, horizontalPadding)
				.padding(.vertical, verticalPadding)
				.overlay {
					// GeometryReaderは親Viewの情報を取るため、Textのサイズを取るにはoverlay()の中で使用する
					GeometryReader { geo in
						let gradientSize = geo.size.width
						
						RadialGradient(stops: shimmerColors ?? ShimmerText.defaultMaskColors(),
									   center: .center,
									   startRadius: 0,
									   endRadius: gradientSize / 2)
						.blendMode(_debug ? .normal : shimmerBlendMode)
						.offset(x: shimmering ? -gradientSize - shimmerOffset : gradientSize + shimmerOffset)
						.animation(.linear(duration: animationDuration).repeatForever(autoreverses: false),
								   value: shimmering)
						.onAppear {
							shimmering.toggle()
						}
						// パフォーマンスを考慮してmask()をスルーできる仕組みを作ってみたが、十分な効力があるかは調査不足
						// （例えば blendMode = .colorDodge の場合はmask()をする必要がないかもしれない）
						.mask(enabled: _debug ? false : masking) {
							Text(text)
								.font(font)
						}
					}
				}
		}
		.border(_debug ? .red : .clear)
	}
	
}

extension View {
	
	// Masking or pass-through
	@inlinable func mask<Mask>(enabled: Bool, @ViewBuilder _ mask: () -> Mask) -> some View where Mask : View {
		Group {
			if enabled {
				self.mask(mask)
			}
			else {
				self
			}
		}
	}
}
