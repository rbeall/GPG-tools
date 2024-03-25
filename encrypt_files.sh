#!/bin/bash

# Define the directory to search for files
TARGET_DIRECTORY="/Users/directory/with/gpg/files"

# Recipient's email or key ID
RECIPIENT_EMAIL="none@none.com"

# Check if gpg is installed
if ! command -v gpg &> /dev/null
then
    echo "GPG could not be found. Please install it first."
    exit 1
fi

# Function to encrypt a file or remove if it matches .DS*
encrypt_file() {
    local file="$1"
    # Check if the file matches the .DS* pattern
    if [[ "$file" == *.DS* ]]; then
        echo "Removing file: $file"
        rm "$file"
    else
        gpg --output "${file}.gpg" --encrypt --recipient "$RECIPIENT_EMAIL" "$file"
        if [[ $? -eq 0 ]]; then
            echo "Encrypted: $file"
            # Optional: Remove the original file after encryption
            rm "$file"
        else
            echo "Failed to encrypt: $file"
        fi
    fi
}

# Export function for use with find command
export -f encrypt_file
export RECIPIENT_EMAIL

# Find and process all files in the specified directory
find "$TARGET_DIRECTORY" -type f -exec bash -c 'encrypt_file "$0"' {} \;

echo "Encryption process complete."
