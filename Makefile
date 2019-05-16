test:
	xcodebuild \
		-project ./Chausie.xcodeproj \
		-scheme Chausie \
		-configuration Debug \
		-sdk iphonesimulator \
		-destination 'platform=iOS Simulator,OS=12.2,name=iPhone 8' \
		| xcpretty -c

install-gems:
	bundle install --path vendor/bundle

lint-lib:
	bundle exec pod lib lint

release-pod:
	bundle exec pod trunk push --allow-warnings