# Native OAuth Authentication Setup Guide

This guide explains how to set up native Google and Apple Sign-In for the Memeic app using Supabase.

## Overview

The app now uses native OAuth authentication:
- **Google Sign-In**: Uses `google_sign_in` package for native Android/iOS Google authentication
- **Apple Sign-In**: Uses `sign_in_with_apple` package for native iOS Apple authentication
- **Supabase Integration**: Both methods obtain ID tokens from native providers and authenticate with Supabase using `signInWithIdToken`

## Prerequisites

1. Supabase project with Google and Apple providers enabled
2. Google Cloud Console project
3. Apple Developer account (for Apple Sign-In)

## Android Setup

### 1. Google Sign-In Configuration

1. **Get SHA-1 Fingerprint**:
   ```bash
   cd android
   ./gradlew signingReport
   ```
   Copy the SHA-1 fingerprint from the debug keystore.

2. **Google Cloud Console Setup**:
   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Create a new project or select existing one
   - Enable Google+ API
   - Go to "Credentials" → "Create Credentials" → "OAuth 2.0 Client ID"
   - Create credentials for:
     - **Web application** (required for Supabase)
     - **Android application**:
       - Package name: `com.memeic.app`
       - SHA-1 certificate fingerprint: (paste your SHA-1)
     - **iOS application**:
       - Bundle ID: `com.memeic.app`

3. **Configure Android**:
   - Copy the Web Client ID from Google Cloud Console
   - Add to `android/app/src/main/res/values/strings.xml`:
     ```xml
     <resources>
         <string name="default_web_client_id">YOUR_WEB_CLIENT_ID_HERE</string>
     </resources>
     ```

4. **Update AndroidManifest.xml** (if needed):
   The package should already handle this, but verify that the MainActivity has the correct package name.

### 2. Supabase Configuration

1. Go to Supabase Dashboard → Authentication → Providers
2. Enable Google provider
3. Add your **Web Client ID** and **Web Client Secret** from Google Cloud Console
4. Add your **Android Client ID** (optional, for better mobile experience)
5. Add your **iOS Client ID** (optional, for better mobile experience)

## iOS Setup

### 1. Google Sign-In Configuration

1. **Add URL Scheme**:
   - Open `ios/Runner.xcworkspace` in Xcode
   - Select Runner project → Info tab
   - Under "URL Types", add a new URL Type:
     - Identifier: `GoogleSignIn`
     - URL Schemes: `YOUR_REVERSED_CLIENT_ID` (from GoogleService-Info.plist)
   - Or add to `ios/Runner/Info.plist`:
     ```xml
     <key>CFBundleURLTypes</key>
     <array>
         <dict>
             <key>CFBundleTypeRole</key>
             <string>Editor</string>
             <key>CFBundleURLSchemes</key>
             <array>
                 <string>YOUR_REVERSED_CLIENT_ID</string>
             </array>
         </dict>
     </array>
     ```

2. **Add GoogleService-Info.plist** (if using Firebase):
   - Download from Firebase Console
   - Add to `ios/Runner/` directory
   - Add to Xcode project

### 2. Apple Sign-In Configuration

1. **Enable Capability in Xcode**:
   - Open `ios/Runner.xcworkspace` in Xcode
   - Select Runner target → Signing & Capabilities
   - Click "+ Capability"
   - Add "Sign in with Apple"

2. **Configure in Apple Developer**:
   - Go to [Apple Developer Portal](https://developer.apple.com/)
   - Certificates, Identifiers & Profiles
   - Select your App ID (`com.memeic.app`)
   - Enable "Sign in with Apple" capability
   - Save changes

3. **Supabase Configuration**:
   - Go to Supabase Dashboard → Authentication → Providers
   - Enable Apple provider
   - Configure Apple provider:
     - Services ID: (create in Apple Developer Portal)
     - Secret Key: (generate in Apple Developer Portal)
     - Team ID: (from Apple Developer account)
     - Key ID: (from Apple Developer account)

## Testing

### Google Sign-In
1. Run the app on a device or emulator
2. Tap "Continue with Google"
3. Select a Google account
4. Grant permissions
5. Should authenticate with Supabase and navigate to main app

### Apple Sign-In
1. Run the app on an iOS device (not available on simulator)
2. Tap "Continue with Apple"
3. Use Face ID/Touch ID or Apple ID password
4. Grant permissions
5. Should authenticate with Supabase and navigate to main app

## Troubleshooting

### Google Sign-In Issues

**"Sign in failed" error**:
- Verify SHA-1 fingerprint is correct in Google Cloud Console
- Ensure Web Client ID is in `strings.xml`
- Check that package name matches: `com.memeic.app`

**"Developer error"**:
- Verify OAuth consent screen is configured in Google Cloud Console
- Check that Google+ API is enabled

### Apple Sign-In Issues

**"Sign in with Apple not available"**:
- Verify capability is enabled in Xcode
- Check that App ID has Sign in with Apple enabled in Apple Developer Portal
- Ensure testing on a physical device (not simulator)

**"Invalid client" error**:
- Verify Services ID is correctly configured in Supabase
- Check that Team ID, Key ID, and Secret Key are correct

## Notes

- The implementation uses native sign-in flows, providing a better user experience than web-based OAuth
- ID tokens are obtained from native providers and sent to Supabase for authentication
- No deep linking or custom URL schemes are required for this implementation
- The app will handle authentication state automatically through Supabase's auth state stream

## Additional Resources

- [Supabase Auth Documentation](https://supabase.com/docs/guides/auth)
- [Google Sign-In for Flutter](https://pub.dev/packages/google_sign_in)
- [Sign in with Apple for Flutter](https://pub.dev/packages/sign_in_with_apple)
- [Supabase Native Auth Guide](https://supabase.com/docs/guides/auth/social-login/auth-google)

