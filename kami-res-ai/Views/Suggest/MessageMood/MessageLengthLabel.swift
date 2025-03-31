//
//  MessageLengthLabel.swift
//  kami-res-ai
//
//  Created by KJ on 3/31/25.
//

import SwiftUI

struct MessageLengthLabel: View {
    
    let length: MessageLength
    let isSelected: Bool

    var body: some View {
        Text(length.description)
            .font(.subheadline)
            .padding(.vertical, 8)
            .padding(.horizontal, 20)
            .overlay {
                RoundedRectangle(cornerRadius: 8, style: .circular)
                    .stroke(
                        isSelected ? Color.black :Color.gray,
                        lineWidth: isSelected ? 1 : 0.5
                    )
                    .shadow(radius: 1)
            }
    }
}

#Preview {
    MessageLengthLabel(length: MessageLength.medium, isSelected: true)
    MessageLengthLabel(length: MessageLength.medium, isSelected: false)
}
