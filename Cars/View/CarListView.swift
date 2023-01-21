//
//  ContentView.swift
//  Cars
//
//  Created by Linkon Sid on 16/12/22.
//

import SwiftUI
import AlertToast

struct CarListView: View{
    @ObservedObject var viewModel: CarListViewModel
    var interactor:CarListInteractorInput
    var body: some View {
        NavigationView {
            ZStack {
                background()
                loader()
                carList()
            }
            .toast(isPresenting: $viewModel.viewError,duration: 3){
                AlertToast(type: .regular, title: AppConstants.ErrorMessage.defaultError)
                    }
            .navigationBarTitle(Text(AppConstants.Text.appTitle))
        }
        .onAppear(perform:interactor.fetchData)
    }
}

extension CarListView{
    func carList()->some View{
        List(viewModel.viewObject) { data in
                CarCell(data: data)
                    .listRowBackground(Color.clear)
                    .listRowInsets(.init())
            }
            .background(Color.clear)
            .listStyle(PlainListStyle())
    }
    func background()->some View{
        Color.black
            .ignoresSafeArea()
    }
    func loader()->some View{
        ProgressLoader(tintColor: .white, scaleSize: 2.0).padding(.bottom,50).hidden(!viewModel.viewLoader)
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CarListConfigurator().configure()
    }
}
