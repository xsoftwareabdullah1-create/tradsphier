# TradeSphere — Flutter Android project

This is a real Flutter project source structure, not an HTML preview.

## Included
- Material 3 dark UI
- Home, Markets, Trade, Portfolio, Wallet
- Searchable markets
- Buy/Sell order screen
- Quantity and estimated total
- Sell-balance limiter
- Demo login/payment-link gates

## Safety / production status
This build is **paper-trading/demo software**. It does not place real stock or crypto orders and does not process real money.

A production financial app still needs licensed/contracted broker or exchange APIs, live market data, secure backend infrastructure, KYC/AML and applicable regulations, payment-provider contracts, audit/security controls, privacy policy, terms, and Google Play financial-feature declarations.

## Build
Install Flutter + Android tooling, then:
flutter pub get
flutter run

Release:
flutter build appbundle

The AAB is created at:
build/app/outputs/bundle/release/

## Package ID
Set a unique final applicationId such as:
com.yourcompany.tradesphere

Choose it carefully before publishing because the Play Store package ID becomes the app's permanent identifier.

## Android-only/mobile note
ZArchiver can extract and manage this ZIP, but it cannot compile Flutter. A Flutter SDK/Android build environment is required to produce the AAB.


## V2 additions

- Login screen
- Signup screen
- Order history
- Open-order cancellation confirmation
- Release/signing checklist
- Android Play Store configuration notes

## Play Store release setup

1. Create the final Android application ID before publishing.
2. Create a release/upload keystore and keep it outside source control.
3. Configure `android/key.properties` locally; never commit it.
4. Configure the release signing configuration in Gradle.
5. Use Play App Signing in Play Console.
6. Run `flutter build appbundle`.
7. Test the generated AAB through an internal testing track before production.
8. Complete Play Console App content, Data safety, privacy policy and financial-features declarations as applicable.

For TradeSphere's planned stock/crypto functionality, Google Play classifies stock trading/portfolio management and crypto wallet/exchange functionality as financial features, so the declaration must accurately describe what the app actually offers.

## V3 backend connection

The Flutter client now calls the Node/Express API for signup, login, order creation, order history, and cancellation. MongoDB persists users and orders. JWT access tokens are stored locally on the device.

Default emulator API: `http://10.0.2.2:5000/api/v1`.

For a physical Android device, use `--dart-define=API_BASE_URL=http://YOUR-LAN-IP:5000/api/v1`.

This is still a controlled paper-trading backend. It is not a live brokerage/exchange integration.

## V7 payment integration
See `RAZORPAY_V7_SETUP.md`. The Wallet screen now opens Razorpay Checkout with UPI enabled and verifies the payment with the backend. It is not a fake success button.
