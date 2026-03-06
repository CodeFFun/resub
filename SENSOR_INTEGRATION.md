# Sensor Integration Documentation

This project now includes two sensor integrations to enhance user experience:

## 1. Ambient Light Sensor - Auto Theme Switching

### Overview
The ambient light sensor automatically switches between light and dark themes based on the ambient light levels detected by your device.

### Features
- **Automatic Theme Detection**: Changes theme based on ambient light intensity
- **Configurable Threshold**: Dark mode activates when light is below 50 lux
- **User Control**: Can be enabled/disabled from Sensor Settings

### How It Works
1. The ambient light sensor continuously monitors light levels
2. When light intensity falls below 50 lux, the app switches to dark mode
3. When light intensity rises above 50 lux, the app switches to light mode
4. Changes happen automatically without requiring user intervention

### Usage
1. Navigate to **Profile** → **Sensor Settings**
2. Toggle **Ambient Light Theme** switch to enable/disable
3. When enabled, theme will change automatically based on ambient light

### Technical Details
- **Service**: `AmbientLightService` (`lib/core/services/sensors/ambient_light_service.dart`)
- **Provider**: `themeModeProvider` (`lib/app/theme/theme_mode_provider.dart`)
- **Dark Mode Threshold**: 50 lux (configurable in `AmbientLightService.darkModeThreshold`)

---

## 2. Proximity Sensor - Auto Logout

### Overview
The proximity sensor can automatically trigger a logout when an object is detected near the device for a specified duration. This provides an additional layer of privacy protection.

### Features
- **Proximity Detection**: Monitors when objects are near the device
- **Timed Trigger**: Requires 3 seconds of continuous proximity before triggering
- **Confirmation Dialog**: Shows a confirmation before logging out
- **User Control**: Can be enabled/disabled from Sensor Settings

### How It Works
1. The proximity sensor listens for objects coming close to the device
2. When proximity is detected continuously for 3 seconds, a dialog appears
3. User can choose to logout or cancel
4. If confirmed, the app logs out and returns to the login screen

### Usage
1. Navigate to **Profile** → **Sensor Settings**
2. Toggle **Proximity Logout** switch to enable/disable
3. When enabled, cover the proximity sensor (usually near the front camera) for 3 seconds
4. Choose **Logout** or **Cancel** in the confirmation dialog

### Technical Details
- **Service**: `ProximitySensorService` (`lib/core/services/sensors/proximity_sensor_service.dart`)
- **Wrapper**: `ProximityLogoutWrapper` (`lib/core/widgets/proximity_logout_wrapper.dart`)
- **Provider**: `proximityLogoutEnabledProvider`
- **Trigger Delay**: 3000ms (configurable in `ProximitySensorService.proximityDelay`)

---

## Sensor Settings Screen

A dedicated settings screen provides control over both sensors:
- **Location**: Profile → Sensor Settings
- **File**: `lib/features/settings/presentation/pages/sensor_settings_screen.dart`

### Available Controls
1. **Ambient Light Theme Toggle**: Enable/disable auto theme switching
2. **Proximity Logout Toggle**: Enable/disable proximity-based logout
3. **Information Section**: Explains what each sensor does

---

## Android Permissions

The following sensor features are declared in `AndroidManifest.xml`:

```xml
<uses-feature android:name="android.hardware.sensor.light" android:required="false"/>
<uses-feature android:name="android.hardware.sensor.proximity" android:required="false"/>
```

Note: These features are marked as `required="false"` to ensure the app works on devices without these sensors.

---

## Dependencies

- **ambient_light**: ^0.1.4 - Provides ambient light sensor data
- **proximity_sensor**: ^1.3.10 - Provides proximity sensor data

---

## File Structure

```
lib/
├── core/
│   ├── services/
│   │   └── sensors/
│   │       ├── ambient_light_service.dart     # Ambient light sensor service
│   │       └── proximity_sensor_service.dart  # Proximity sensor service
│   └── widgets/
│       └── proximity_logout_wrapper.dart       # Proximity logout wrapper widget
├── app/
│   └── theme/
│       └── theme_mode_provider.dart            # Updated to support auto theme
└── features/
    └── settings/
        └── presentation/
            └── pages/
                └── sensor_settings_screen.dart  # Sensor settings UI

```

---

## Customization

### Adjusting Ambient Light Threshold
Edit `lib/core/services/sensors/ambient_light_service.dart`:
```dart
static const int darkModeThreshold = 50; // Change this value
```

### Adjusting Proximity Delay
Edit `lib/core/services/sensors/proximity_sensor_service.dart`:
```dart
static const int proximityDelay = 3000; // Change this value (in milliseconds)
```

---

## Testing

### Testing Ambient Light Sensor
1. Enable "Ambient Light Theme" in Sensor Settings
2. Cover the light sensor (usually near the front camera)
3. Theme should switch to dark mode
4. Uncover the sensor, theme should switch to light mode

### Testing Proximity Sensor
1. Enable "Proximity Logout" in Sensor Settings
2. Cover the proximity sensor for 3 seconds
3. A dialog should appear asking to confirm logout
4. Select "Logout" to test the logout functionality

---

## Troubleshooting

### Theme not changing automatically
- Ensure "Ambient Light Theme" is enabled in Sensor Settings
- Check if your device has an ambient light sensor
- Try covering/uncovering the sensor near the front camera
- Check console for any error messages

### Proximity logout not working
- Ensure "Proximity Logout" is enabled in Sensor Settings
- Check if your device has a proximity sensor
- Try covering the area near the front camera for at least 3 seconds
- Check console for any error messages

### Sensors not available
- Not all devices have ambient light or proximity sensors
- The app will continue to work normally without these features
- Manual theme switching is always available in the Appearance setting

---

## Notes

- Both features are **opt-in** and disabled by default
- Sensor states are persisted across app restarts using SharedPreferences
- The proximity logout includes a confirmation dialog to prevent accidental logouts
- Theme changes from ambient light are temporary and don't override manual theme preferences
