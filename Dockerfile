# Use latest stable channel SDK.
FROM dart:stable AS build

# Resolve app dependencies.
WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

# Copy app source code (except anything in .dockerignore) and AOT compile app.
COPY . .
RUN dart compile exe bin/entry.dart -o bin/tuda

# Build minimal serving image from AOT-compiled `/tuda`
# and the pre-built AOT-runtime in the `/runtime/` directory of the base image.
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/tuda /app/bin/

# Setting port
ENV TUDA_PORT=5001

# Start server.
EXPOSE 5001
CMD ['/app/bin/tuda']
