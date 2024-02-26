# route_optima_mobile_app

Route Optima mobile app for riders.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## How to run the app

You need to specify your own Geo API Key (Google Maps API Key) to build the app. You can get the API Key from [Google Cloud Platform](https://cloud.google.com/maps-platform/).

After you get the API Key, you need to perform the following steps:

1. Create a file called `gradle.properties` in the `android\app` folder of the project. Then copy the content inside the `gradle.properties.template` file and replace the `YOUR_API_KEY` with your own API Key.

2. Create a file called `googleMapConsts.dart` in the `lib\constants` folder of the project. Then copy the content inside the `googleMapConsts.dart.template` file and replace the `YOUR_API_KEY` with your own API Key.

All Set. Now you can build the app easily.
