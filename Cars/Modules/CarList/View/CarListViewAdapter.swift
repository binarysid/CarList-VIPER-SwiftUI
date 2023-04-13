//
//  CarAdapter.swift
//  Cars
//
//  Created by Linkon Sid on 12/4/23.
//

import SwiftUI
import Combine

final class CarListViewAdapter: ObservableObject {
    @Published var state: CarViewState
    var presenter: CarViewInput?

    init(state: CarViewState) {
        self.state = state
    }
    func fetchList() async {
        await presenter?.fetchCarList()
    }
}

extension CarListViewAdapter: CarViewOutput {
    func showLoader() {
        Task {
            await MainActor.run {
                state.viewLoader = true
            }
        }
    }
    
    func hideLoader() {
        Task {
            await MainActor.run {
                state.viewLoader = false
            }
        }
    }
    
    func update(error: String) {
        Task {
            await MainActor.run {
                state.viewError = true
                state.errorMessage = error
            }
        }
    }
    
    func update(data: [CarViewData]) {
        Task {
            await MainActor.run {
                state.viewObject = data
            }
        }
    }
}

extension CarListViewAdapter {
    func navigationRouteBuilder<Content: View>(
        from data: CarViewData,
        @ViewBuilder content: () -> Content
      ) -> some View {
        NavigationLink(
            destination: buildDetailView(with: data)) {
              content()
        }
    }

    private func buildDetailView(with data: CarViewData) -> some View {
        guard let detailView = presenter?.makeDetailView(with: data) else { return AnyView(EmptyView()) }
        return AnyView(detailView)
    }
}
