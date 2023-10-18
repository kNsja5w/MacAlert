
# MacAlert ![128-mac 1](https://github.com/kNsja5w/MacAlert/assets/16246095/c2ff7ef5-8622-4a51-8cf6-0a340df44f7f) 

MacAlert is a macOS app that helps you preventing theft, by keeping watch over the power connection status and starting an alarm, when disconnected unintentionally. It was used as small security measure during travel and work in public spaces, with power plugged in.

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Introduction

MacAlert is a SwiftUI-based macOS application that monitors your power adapter's status and provides audio alerts when it's disconnected. This can be particularly useful to ensure that your Mac remains powered when needed or to alert you in case of unintentional disconnection.


<img width="888" alt="Bildschirmfoto 2023-10-18 um 23 49 37" src="https://github.com/kNsja5w/MacAlert/assets/16246095/5d370246-eb4e-482b-9048-4ec74f8aa501">



## Features

- Real-time monitoring of power adapter connection.
- Customizable audio alerts.
- Ability to confirm unplugging intentions.
- Easy-to-use user interface.

- Future roll-out with Apple Developer Membership is planned!

## Installation

1. Clone or download the MacAlert repository to your Mac.
2. Open the Xcode project in the repository.
3. Build and run the project in Xcode.

## Usage

1. Upon running MacAlert, you will see a simple interface indicating the current status of your power adapter:

    - "Power Adapter Connected" when the adapter is connected.
    - "Power Adapter Disconnected" when the adapter is disconnected.

2. To play an audio alert, click the "Play Sound" button. You can stop the sound by clicking "Stop Sound."

3. If the power adapter is disconnected, MacAlert will display a confirmation dialog asking if you intentionally unplugged the power. You can confirm this intention by clicking "Yes."

4. If you do not confirm, MacAlert will play an alert sound after a short delay.

## Contributing

If you'd like to contribute to MacAlert, feel free to open issues, submit pull requests, or provide suggestions to help improve the application. Your contributions are highly appreciated.

## License

MacAlert is released under the [GNU General Public License v3.0](LICENSE). You are free to use, modify, and distribute this software as long as you comply with the terms of the license. See the [LICENSE](LICENSE) file for more details.

---

**Note:** MacAlert uses IOKit and AVFoundation frameworks to monitor power status and play audio alerts. Make sure to grant necessary permissions for the app to function properly.
