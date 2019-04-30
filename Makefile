EXAMPLE_DIR := Examples/ChausieExample

setup-example:
	carthage build --no-skip-current
	mv Carthage $(EXAMPLE_DIR)/Carthage