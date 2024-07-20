# barkbuddy

A new Flutter project.

## Text-to-speech how-to
Generate audio with:

```bash
curl -H "Authorization: Bearer "$(gcloud auth print-access-token) \
 -H "x-goog-user-project: chatterbox-73d26" \
 -H "Content-Type: application/json; charset=utf-8" \
 --data @tts-request "https://texttospeech.googleapis.com/v1/text:synthesize" \
  | jq -r .audioContent | base64 -d > audio.wav
```

Example request:
```json
{
  "audioConfig": {
    "audioEncoding": "MP3",
    "effectsProfileId": [
      "small-bluetooth-speaker-class-device"
    ],
    "pitch": 0,
    "speakingRate": 1
  },
  "input": {
    "text": "Good boy, everything is alright."
  },
  "voice": {
    "languageCode": "en-US",
    "name": "en-US-Journey-F"
  }
}
```

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.