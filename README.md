# Chausie

[![CI Status](https://img.shields.io/travis/shoheiyokoyama/Chausie.svg?style=flat)](https://travis-ci.org/shoheiyokoyama/Chausie)
[![Version](https://img.shields.io/cocoapods/v/Chausie.svg?style=flat)](https://cocoapods.org/pods/Chausie)
[![License](https://img.shields.io/cocoapods/l/Chausie.svg?style=flat)](https://cocoapods.org/pods/Chausie)
[![Platform](https://img.shields.io/cocoapods/p/Chausie.svg?style=flat)](https://cocoapods.org/pods/Chausie)

## Overview

Chausie provides a customizable container view controller that manages navigation between pages of content. Page of contents can be controlled programmatically by your implementation or directly by the user's gesture. Chausie is designed to be flexible and extensible, provides intuitive and simple interfaces.

## Features

<img src="https://github.com/shoheiyokoyama/Assets/blob/master/Chausie/example.gif" width=160 align="right">

### implementation

Chausie is designed to be a simple and minimal implementation to make the flexible user interface. 

Chausie provides APIs for managing page content, and implementers can customize views. See [example code](https://github.com/shoheiyokoyama/Chausie/tree/master/Examples/ChausieExample) for details.

### maintenability

Chausie is used and oprated in iOS applications. Aim for continuous maintenance and enhancement by members of [CATS ( CyberAgent Advanced Technology Studio )](https://github.com/cats-oss).

## View Components

Chausie provides container view to compose pages of content. components that compose view container is available, so you can design flexible layout.

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

Clone the repo to run the example project, and run `make` from the [Example directory](https://github.com/shoheiyokoyama/Chausie/tree/master/Examples/ChausieExample) first.
See sample code [here](https://github.com/shoheiyokoyama/Chausie/tree/master/Examples/ChausieExample/ChausieExample) for details.

## Requirements

## Installation

Chausie is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Chausie'
```

## Author

shoheiyokoyama, shohei.yok0602@gmail.com

## License

Chausie is available under the MIT license. See the LICENSE file for more info.
