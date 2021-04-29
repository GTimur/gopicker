#!/bin/sh
env GOOS=windows GOARCH=386 go build -o gopicker_x86.exe
env GOOS=windows GOARCH=amd64 go build -o gopicker_x64.exe


