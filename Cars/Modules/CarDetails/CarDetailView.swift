//
//  CarDetailView.swift
//  Cars
//
//  Created by Linkon Sid on 13/4/23.
//

import SwiftUI

struct CarDetailView: View {
    let details: CarViewData

    var body: some View {
        Text(details.title)
    }
}

//struct CarDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        CarDetailView()
//    }
//}
