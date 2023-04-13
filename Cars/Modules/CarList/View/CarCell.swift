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
                if let imageURL = data.image?.replacingOccurrences(of: ".jpg", with: ""),let image = UIImage(named: imageURL) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                }
                else{// set default image if not image found
                    Image(AppConstants.Image.DefaultCar)
                        .resizable()
                        .scaledToFill()
                }
                Text(data.title)
                    .foregroundColor(Color.white)
                    .font(.system(size: 24, weight: .regular))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 0, leading: 6, bottom: 2, trailing: 6))
                Text(data.date+" "+data.time)
                    .foregroundColor(Color.white)
                    .font(.system(size: 13, weight: .light))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 0, leading: 6, bottom: 1, trailing: 6))
                Text(data.description)
                    .foregroundColor(Color.white)
                    .font(.system(size: 14, weight: .regular))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 0, leading: 6, bottom: 6, trailing: 6))
            }
            .font(.body)
        }
        Spacer()
    }
}
