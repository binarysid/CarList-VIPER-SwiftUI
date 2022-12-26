//
//  ContentView.swift
//  Cars
//
//  Created by Linkon Sid on 16/12/22.
//

import SwiftUI
import AlertToast

struct CarListView: View {
    //view model manages the requested data for the view
    @StateObject var viewModel = CarListViewModel()
    init(){
        AppTheme.navigationBarColors(background: .black, titleColor: .white)
        }
    var body: some View {
        NavigationView {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                ProgressLoader(tintColor: .white, scaleSize: 2.0).padding(.bottom,50).hidden(!viewModel.showLoader)
                List(viewModel.viewObject) { data in
                        CarCell(data: data)
                            .listRowBackground(Color.clear)
                            .listRowInsets(.init())
                    }
                    .background(Color.clear)
                    .listStyle(PlainListStyle())
            }
            .toast(isPresenting: $viewModel.showError,duration: 3){
                    AlertToast(type: .regular, title: "Something went wrong")
                    }
            .navigationBarTitle(Text(AppConstants.Text.appTitle))
        }
        .onAppear(perform:viewModel.fetchData)
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CarListView()
    }
}
