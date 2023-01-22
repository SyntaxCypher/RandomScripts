#!/bin/bash

# Set password length
length=32

# Set character sets
lowercase="abcdefghijklmnopqrstuvwxyz"
uppercase="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
digits="0123456789"
symbols="!@#%&*_"

# Combine character sets
chars="$lowercase$uppercase$digits$symbols"

# Generate password
password=$(cat /dev/urandom | tr -dc "$chars" | head -c $length)

# Print password
echo "Your new password is: $password"
