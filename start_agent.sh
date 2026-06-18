#!/bin/bash
echo 'Starting Agent Setup...'
npm install -g openclaw
echo 'Installation complete. Starting OpenClaw...'
/usr/local/bin/openclaw &
echo 'Starting Gateway...'
/usr/local/bin/openclaw gateway
