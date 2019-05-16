# Chausie

<p align="center">
  <img src="https://github.com/shoheiyokoyama/Assets/blob/master/Chausie/logo.png">
</p>

## Overview

[![Build Status](https://travis-ci.com/cats-oss/Chausie.svg?branch=master)](https://travis-ci.com/cats-oss/Chausie)
[![codecov](https://codecov.io/gh/cats-oss/Chausie/branch/master/graph/badge.svg)](https://codecov.io/gh/cats-oss/Chausie)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-green.svg)](https://github.com/Carthage/Carthage)
[![Carthage compatible](https://img.shields.io/badge/Cocoapods-compatible-brightgreen.svg)](https://cocoapods.org/pods/Chausie)
[![License](https://img.shields.io/badge/License-MIT-lightgrey.svg
)](http://mit-license.org)
![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)

Chausie provides a customizable container view controller that manages navigation between pages of content. Page of contents can be controlled programmatically by your implementation or directly by the user's gesture. Chausie is designed to be flexible and extensible, provides intuitive and simple interfaces.

## Features

<img src="https://github.com/shoheiyokoyama/Assets/blob/master/Chausie/example.gif" width=180 align="right">

### implementation

Chausie is designed to be a simple and minimal implementation to make the flexible user interface. Chausie provides APIs for managing page content, and implementers can customize views. See [example code](https://github.com/cats-oss/Chausie/tree/master/Examples/ChausieExample) for details.

### maintenability

Chausie is used and oprated in iOS applications. Aim for continuous maintenance and enhancement by members of [CATS ( CyberAgent Advanced Technology Studio )](https://github.com/cats-oss).

If you need any help, please visit our [GitHub issues](https://github.com/cats-oss/Chausie/issues) and feel free to file an issue.

There are multiple ways you can contribute to this project. We welcome contributions ( GitHub issues, pull requets, etc. )

## View Components

Chausie provides container view to compose pages of content. Components that compose view container is available, so you can design flexible layout.

<p align="center">
  <img src="https://github.com/shoheiyokoyama/Assets/blob/master/Chausie/components.png">
</p>

## Usage

You can use Chausie API intuitively and simply, like this:

```swift
TabPageViewController(
    components: [
        Component(
            child: FirstViewController(),
            cellModel: Category.fashion
        ),
        Component(
            child: SecondViewController(),
            cellModel: Category.food
        )
    ]
)
```

Clone the repo to run the example project, and run `make` from the [Example directory](https://github.com/cats-oss/Chausie/tree/master/Examples/ChausieExample) first.
See sample code [here](https://github.com/cats-oss/Chausie/tree/master/Examples/ChausieExample/ChausieExample) for details.

## Requirements

- Swift 5.0
- Xcode 10.2.1

## Installation

### CocoaPods

Chausie is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod "Chausie"
```

### Carthage

Add the following line to your `Cartfile`:

```ruby
github "cats-oss/Chausie"
```

## Future tasks

- [x] Basic implementation 
- [ ] Other tab view style
- [ ] Instantiates from xib or storyboard
- [ ] Rearchitecture content of page
- [ ] And more...

## License

Chausie is available under the MIT license. See the [LICENSE](https://github.com/cats-oss/Chausie/blob/master/LICENSE) file for more info.
