import SwiftUI

public protocol WKEmptyViewDelegate: Any {
    func didPressPrimaryButton()
    func didPressFilterButton()
}

public struct WKEmptyView: View {

    @ObservedObject var appEnvironment = WKAppEnvironment.current
    @ObservedObject var viewModel: WKEmptyViewModel
    var delegate: WKEmptyViewDelegate?

    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(appEnvironment.theme.paperBackground)
                ScrollView {
                    VStack {
                        Spacer()
                        Image(uiImage: viewModel.image)
                            .frame(width: 132, height: 118)
                        Text(viewModel.localizedStrings.title)
                            .font(Font(WKFont.for(.boldBody)))
                            .foregroundColor(Color(appEnvironment.theme.text))
                            .padding([.top], 12)
                            .padding([.bottom], 8)
                            .multilineTextAlignment(.center)
                        if  viewModel.type == .filter {
                          WKEmptyViewFilterView()
                        } else {
                            Text(viewModel.localizedStrings.subtitle)
                                .font(Font(WKFont.for(.footnote)))
                                .foregroundColor(Color(appEnvironment.theme.secondaryText))
                                .multilineTextAlignment(.center)
                        }
                        if viewModel.type == .noItems {
                            WKSecondaryButton(title: viewModel.localizedStrings.buttonTitle, action: delegate?.didPressPrimaryButton)
                                .padding([.leading, .trailing], 32)
                        }
                        Spacer()
                    }
                    .frame(minHeight: geometry.size.height)
                    .padding([.leading, .trailing], 32)
                }
            }
        }
    }

}

struct WKEmptyViewFilterView: View {

    @ObservedObject var appEnvironment = WKAppEnvironment.current
    var delegate: WKEmptyViewDelegate?

    var body: some View {

        // get localized strings
        HStack(spacing: 0) {
            Text("Modify")
                .font(Font(WKFont.for(.footnote)))
                .foregroundColor(Color(appEnvironment.theme.secondaryText))
                .multilineTextAlignment(.center)
                .padding(0)
            Button(action: {
                delegate?.didPressFilterButton()
            }, label: {
                Text("3 filters")
                    .font(Font(WKFont.for(.footnote)))
                    .foregroundColor(Color(appEnvironment.theme.link))
                    .padding(2)
                    .frame(height: 30)
                    .background(Color(appEnvironment.theme.paperBackground))
            })
            .padding(0)
            Text("to see more Watchlist items.")
                .font(Font(WKFont.for(.footnote)))
                .foregroundColor(Color(appEnvironment.theme.secondaryText))
                .multilineTextAlignment(.center)
                .padding(0)
        }
    }

}
