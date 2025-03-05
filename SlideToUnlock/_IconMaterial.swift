//
//  _IconMaterial.swift
//  SlideToUnlock
//
//  Created by usagimaru on 2025/03/05.
//

import SwiftUI

// Material for App Icon (preview only)

#Preview {
	ZStack {
		Color.gray
		Icon(cornerRadius: 0, arrowHandWidth: 60 * 2, arrowHeadSize: 72 * 2, paddingVertically: 68 * 2, paddingHorizontally: 50 * 2)
			.frame(width: 256 * 2, height: 256 * 2)
	}
}

struct Icon: View {
	
	@State var cornerRadius: CGFloat = 20
	@State var arrowHandWidth: CGFloat = 13
	@State var arrowHeadSize: CGFloat = 18
	@State var arrowWidth: CGFloat = 144
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
						ArrowView(arrowHandWidth: arrowHandWidth, arrowHeadSize: arrowHeadSize, bevelDepth: 4, bevelOpacity: 0.5)
							.offset(x: horizontalAdjustment)
							.padding(.vertical, paddingVertically)
							.padding(.horizontal, paddingHorizontally)
					}
				}
			}
			.clipShape(.rect(cornerRadius: cornerRadius))
		}
	}
	
}
