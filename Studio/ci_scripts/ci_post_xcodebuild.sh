#!/bin/sh
set -e

echo "--- Starting Firebase Crashlytics Post-Build Script ---"

if [ "$CI_XCODEBUILD_ACTION" = "archive" ]; then
    DSYM_PATH="${CI_ARCHIVE_PATH}/dSYMs/${PRODUCT_NAME}.app.dSYM"
    FIREBASE_RUN_SCRIPT="${CI_PRIMARY_REPOSITORY_PATH}/SourcePackages/checkouts/firebase-ios-sdk/Crashlytics/run"
    GSP_PATH="${CI_PRIMARY_REPOSITORY_PATH}/Studio/GoogleService-Info.plist"

    if [ -d "$DSYM_PATH" ]; then
        if [ -f "$FIREBASE_RUN_SCRIPT" ]; then
            "$FIREBASE_RUN_SCRIPT" -gsp "$GSP_PATH" "$DSYM_PATH"
            echo "Successfully uploaded dSYM symbols to Firebase!"
        else
            echo "Error: Firebase run script not found at $FIREBASE_RUN_SCRIPT"
        fi
    else
        echo "Warning: dSYM file not found at $DSYM_PATH"
    fi
fi
