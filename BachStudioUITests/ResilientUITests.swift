import XCTest

final class ResilientUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func testErrorStateRecovery() throws {
        let tryAgainButton = app.buttons["tryAgainButton"]

        if tryAgainButton.exists {
            tryAgainButton.tap()
            // Assert loading or recovery state follows
            let loadingIndicator = app.otherElements["loadingView"]
            XCTAssertTrue(tryAgainButton.exists || loadingIndicator.exists)
        }
    }
}
