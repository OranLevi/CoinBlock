
# CoinBlock

CoinBlock is a mobile application that allows users to track and monitor cryptocurrency prices and portfolios. With CoinBlock, you can stay up-to-date with the latest market trends, view detailed coin information, and track your investments, all in one convenient app.

## Features

**Real-time Coin Prices**: Get access to real-time cryptocurrency prices.<br>
**Portfolio Tracking**: Easily track your cryptocurrency investments and monitor their performance.<br>
**Coin Details**: View detailed information, charts, and historical data for each supported cryptocurrency.<br>
**User-friendly Interface**: Enjoy a clean and intuitive user interface that makes it easy to navigate and interact with the app.<br>

## Screenshots

[[Screenshots1]](https://github.com/OranLevi/CoinBlock/blob/dev/Screenshots/Screenshot1.png?raw=true) , [[Screenshots2]](https://github.com/OranLevi/CoinBlock/blob/dev/Screenshots/Screenshot2.png?raw=true)

## Architecture

CoinBlock follows the MVVM (Model-View-ViewModel) architectural pattern. Here's a brief explanation of the different components:

**Model**: Contains the data models and entities used in the app.<br>
**View**: Defines the user interface components and their layout using SwiftUI.<br>
**ViewModel**: Acts as an intermediary between the View and Model, providing data and handling user interactions. It also abstracts the API calls and data processing logic using Combine.<br>
**Service**: Handles network requests to the coingecko API and provides data to the ViewModel.<br>

## Folder Structure

The project is organized as follows:

**Models**: Contains the data models used in the app.<br>
**Views**: Contains the SwiftUI view files.<br>
**ViewModels**: Contains the ViewModel files.<br>
**Services**: Contains the networking code to interact with the coingecko API.<br>
**Utilities**: Contains utility classes.<br>
**Extensions**: Contains Swift extensions that add extra functionality to existing classes or types.

## Getting Started

To get started with MovieMagic, follow the instructions below:

1. Clone the repository:

```sh
git clone https://github.com/OranLevi/CoinBlock.git
```
2. Open the CoinBlock.xcodeproj file in Xcode.

Build and run the app in the Xcode simulator or on a physical device.

## Contact
Contributions are always welcome! If you have any ideas for features, bug fixes, or other improvements, please submit a pull request.
