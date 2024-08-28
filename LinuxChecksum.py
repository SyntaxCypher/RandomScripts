import os
import json
import hashlib
import time
import sys
import select

print("Attention: DO NOT EXIT, File Integrity Check Running")
print("Seth Bates, 2023 Checksum Verification Script")
print("Version: 1.1")
print("")
print("Checksum Verification in progress:")
print("")

# Define the path to the checksum data file
checksum_data_file = "/path/to/checksums.json"

# Function to load the checksum data from the JSON file
def load_checksum_data():
    if os.path.exists(checksum_data_file):
        with open(checksum_data_file, 'r') as file:
            data = json.load(file)
        return data
    else:
        return {}

# Function to save the checksum data to the JSON file
def save_checksum_data(data):
    with open(checksum_data_file, 'w') as file:
        json.dump(data, file, indent=4)

# Load existing checksum data or create a new empty dictionary
checksum_data = load_checksum_data()
if checksum_data is None:
    checksum_data = {}

# Define the directories to check
directories = ["/path/here", "/path/here"]

# Define the files to exclude from checksum calculation
exclude_files = [
    "/path/here",
    "/path/here"
]

# Initialize variables for progress tracking
total_files = 0
processed_files = 0
checksum_changed = False

# Get the total number of files
for directory in directories:
    for root, _, files in os.walk(directory):
        total_files += len(files)

# Loop through each directory
for directory in directories:
    for root, _, files in os.walk(directory):
        for file_name in files:
            file_path = os.path.join(root, file_name)

            # Check if the file matches any exclude file pattern
            exclude_file = False
            for exclude in exclude_files:
                if file_path.startswith(exclude):
                    exclude_file = True
                    break

            if exclude_file:
                # Skip excluded file
                print(f"Excluded file: {file_path}")
                continue

            # Get the current checksum of the file
            with open(file_path, 'rb') as file:
                file_contents = file.read()
                current_checksum = hashlib.sha256(file_contents).hexdigest()

            # Check if the file's checksum has changed
            if file_path in checksum_data and checksum_data[file_path] != current_checksum:
                # Alert the user about the changed checksum
                print(f"Checksum of file {file_path} has changed!")

                # Set the checksum_changed flag to true
                checksum_changed = True
            else:
                # Checksum verified
                print(f"Checksum verified for file {file_path}")

            # Update the file's checksum in the checksum data dictionary
            checksum_data[file_path] = current_checksum

            # Update progress variables
            processed_files += 1
            progress_percentage = round((processed_files / total_files) * 100)
            print(f"Progress: {progress_percentage}% ({processed_files}/{total_files})")

# Save the updated checksum data to the JSON file
save_checksum_data(checksum_data)

# Prompt user to press any key or wait for timeout
timeout_seconds = 20
start_time = time.time()

while time.time() < start_time + timeout_seconds:
    if checksum_changed:
        break

    # Check for key press (non-blocking)
    if sys.stdin in select.select([sys.stdin], [], [], 0)[0]:
        key = sys.stdin.read(1)
        break

    time.sleep(1)

# Checksum changed, no timeout occurred
if checksum_changed:
    print("A checksum change has been detected. Press any key to exit...")
    sys.stdin.read(1)
# Timeout occurred
else:
    print("Timeout reached. Exiting...")
