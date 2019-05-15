test:
	xcodebuild \
		-project ./Chausie.xcodeproj \
		-scheme Chausie \
		-configuration Debug \
		-sdk iphonesimulator \
		-destination 'platform=iOS Simulator,OS=12.2,name=iPhone 8' \
		| xcpretty -c