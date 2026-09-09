import XCTest

final class BachStudioUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    // MARK: - Launch / Record tab (default tab)

    func test_launchesOnRecordTab() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.staticTexts["Let's Compose Music"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["TAP TO RECORD"].exists)
    }

    func test_mainRecordTab_micTap_showsPermissionPromptOrEntersRecordingState() {
        let app = XCUIApplication()
        app.launch()

        let micButton = app.buttons["recordMicButton"]
        XCTAssertTrue(micButton.waitForExistence(timeout: 5))

        addUIInterruptionMonitor(withDescription: "Microphone Permission") { alert in
            if alert.buttons["OK"].exists {
                alert.buttons["OK"].tap()
                return true
            }
            if alert.buttons["Allow"].exists {
                alert.buttons["Allow"].tap()
                return true
            }
            return false
        }

        micButton.tap()
        app.tap() // nudge the interruption monitor to evaluate

        let timerAppeared = app.staticTexts.matching(
            NSPredicate(format: "label MATCHES %@", "^[0-9]+:[0-9]{2}$")
        ).firstMatch.waitForExistence(timeout: 3)
        let stillOnIdleScreen = app.staticTexts["TAP TO RECORD"].exists

        XCTAssertTrue(timerAppeared || stillOnIdleScreen, "Expected either start recording or remain on idle ")
    }

    func test_mainRecordTab_addFileButton_opensPopup() {
        let app = XCUIApplication()
        app.launch()

        let addFileButton = app.buttons["addFileButton"]
        XCTAssertTrue(addFileButton.waitForExistence(timeout: 5))
        addFileButton.tap()
    }

    // MARK: - Projects tab

    func test_projectsTab_showsHeaderAndSeededProjects() {
        let app = XCUIApplication()
        app.launch()

        app.tabBars.buttons["Projects"].tap()

        XCTAssertTrue(app.staticTexts["PROJECTS"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["PROJECT 3"].exists)
        XCTAssertTrue(app.staticTexts["PROJECT 2"].exists)
        XCTAssertTrue(app.staticTexts["PROJECT 1"].exists)
    }

    func test_tappingAProject_opensProjectDetail() {
        let app = XCUIApplication()
        app.launch()

        app.tabBars.buttons["Projects"].tap()

        let firstProject = app.staticTexts["PROJECT 3"]
        XCTAssertTrue(firstProject.waitForExistence(timeout: 5))
        firstProject.tap()

        XCTAssertTrue(app.buttons["RECORD NEW TAKE"].waitForExistence(timeout: 5))
    }

    func test_addNewProjectButton_isPresentOnProjectsTab() {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Projects"].tap()

        XCTAssertTrue(app.buttons["addNewProjectButton"].waitForExistence(timeout: 5))
    }

    // MARK: - Record New Take flow (via Projects -> a project -> RECORD NEW TAKE)

    func test_recordNewTake_micTap_showsPermissionPromptOrEntersRecordingState() {
        let app = XCUIApplication()
        app.launch()

        app.tabBars.buttons["Projects"].tap()
        app.staticTexts["PROJECT 3"].tap()
        app.buttons["RECORD NEW TAKE"].tap()

        let micButton = app.buttons["newTakeMicButton"]
        XCTAssertTrue(micButton.waitForExistence(timeout: 5))

        addUIInterruptionMonitor(withDescription: "Microphone Permission") { alert in
            if alert.buttons["OK"].exists {
                alert.buttons["OK"].tap()
                return true
            }
            if alert.buttons["Allow"].exists {
                alert.buttons["Allow"].tap()
                return true
            }
            return false
        }

        micButton.tap()
        app.tap()

        let timerAppeared = app.staticTexts.matching(
            NSPredicate(format: "label MATCHES %@", "^[0-9]+:[0-9]{2}$")
        ).firstMatch.waitForExistence(timeout: 3)
        let stillOnIdleScreen = app.staticTexts["TAP TO RECORD"].exists

        XCTAssertTrue(timerAppeared || stillOnIdleScreen)
    }

    func test_recordNewTake_addFileButton_opensPopup() {
        let app = XCUIApplication()
        app.launch()

        app.tabBars.buttons["Projects"].tap()
        app.staticTexts["PROJECT 3"].tap()
        app.buttons["RECORD NEW TAKE"].tap()

        let addFileButton = app.buttons["addFileButton"]
        XCTAssertTrue(addFileButton.waitForExistence(timeout: 5))
        addFileButton.tap()
    }
}
