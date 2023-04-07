FROM cirrusci/flutter AS builder

WORKDIR /app

COPY . .

RUN flutter pub get && flutter test && flutter build apk

FROM cirrusci/android-sdk:31

WORKDIR /app

COPY --from=builder /app/build/app/outputs/flutter-apk/app-release.apk .

CMD ["echo", "APK file built successfully!"]