//
//  CarCell.swift
//  Cars
//
//  Created by Linkon Sid on 17/12/22.
//

import SwiftUI

struct CarCell: View {
    var data: CarViewData!

    var body: some View {
        ZStack {
            Color.clear
            VStack(alignment: .center) {
                thumbnail()
                title()
                dateTime()
                description()
            }
            .font(.body)
        }
        Spacer()
    }
}

// MARK: - Custom Views
extension CarCell {
    func thumbnail() -> some View {
        guard let imageURL = data.image?.replacingOccurrences(of: ".jpg", with: ""), let image = UIImage(named: imageURL) else {
            return AnyView(defaultThumbNail())
        }
        return AnyView(thumbNail(image: image))
    }

    func description() -> some View {
        Text(data.description)
            .foregroundColor(Color.white)
            .font(.system(size: 14, weight: .regular))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(EdgeInsets(top: 0, leading: 6, bottom: 6, trailing: 6))
    }

    func dateTime() -> some View {
        Text(data.date+" "+data.time)
            .foregroundColor(Color.white)
            .font(.system(size: 13, weight: .light))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(EdgeInsets(top: 0, leading: 6, bottom: 1, trailing: 6))
    }

    func thumbNail(image: UIImage) -> some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
    }

    func defaultThumbNail() -> some View {
        Image(Asset.Assets.audiQ2.name)
            .resizable()
            .scaledToFill()
    }

    func title() -> some View {
        Text(data.title)
            .foregroundColor(Color.white)
            .font(.system(size: 24, weight: .regular))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(EdgeInsets(top: 0, leading: 6, bottom: 2, trailing: 6))
    }
}
