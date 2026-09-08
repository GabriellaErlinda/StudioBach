import FirebaseAnalytics
import FirebasePerformance
import SwiftUI

struct FirebaseScreenTrackable: ViewModifier {
    let screenName: String

    func body(content: Content) -> some View {
        content
            .onAppear {
                Analytics.logEvent(AnalyticsEventScreenView, parameters: [
                    AnalyticsParameterScreenName: screenName,
                    AnalyticsParameterScreenClass: screenName
                ])
            }
    }
}

extension View {
    func trackScreen(_ name: String) -> some View {
        self.modifier(FirebaseScreenTrackable(screenName: name))
    }
}
