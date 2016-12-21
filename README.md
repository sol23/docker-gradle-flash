# docker-gradle-flash

This image contains everything that is needed for testing flash projects build with gradle.

    Gradle 3.2.1
    Java Jdk8
    AirSDKCompiler 22.0
    StandaloneFlashPlayerDebugger 24.0

### Volumes:
- `/project` _actual project (starting workdir of image)_
- `/gradle` _gradle cache directory_

### Environment variables:
- `FLEX_HOME` _AirSdk location_
- `FLASH_PLAYER_LOCATION` _executable of standalone flash player_
