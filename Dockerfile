# Use a Linux system that already has Go installed
FROM golang:1.22.5 AS base

# Work inside /app folder
WORKDIR /app

# Copy dependency file into the system
COPY go.mod .

# Download Go dependencies
RUN go mod download

# Copy all project files into the system
COPY . .

# Build the app and create a file called "main"
RUN go build -o main .

# Start again from a minimal Linux system
FROM gcr.io/distroless/base

# Copy the built app file from the first system
COPY --from=base /app/main .

# Copy static files (HTML/CSS)
COPY --from=base /app/static ./static

# The app uses port 8080
EXPOSE 8080

# Run the app when this system starts
CMD ["./main"]
