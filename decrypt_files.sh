#!/bin/bash

# Define the directory to search for files
TARGET_DIRECTORY="/Users/directory/with/gpg/files"

# Check if gpg is installed
if ! command -v gpg &> /dev/null
then
    echo "GPG could not be found. Please install it first."
    exit 1
fi

# Function to decrypt a file
decrypt_file() {
    local file="$1"
    # Check if the file ends with .gpg
    if [[ "$file" == *.gpg ]]; then
        # Remove the .gpg extension for the output filename
        local output_file="${file%.gpg}"
        gpg --output "$output_file" --decrypt "$file"
        if [[ $? -eq 0 ]]; then
            echo "Decrypted: $file"
            # Optional: Remove the .gpg file after decryption
            rm "$file"
        else
            echo "Failed to decrypt: $file"
        fi
    fi
}

# Export function for use with find command
export -f decrypt_file

# Find and process all .gpg files in the specified directory
find "$TARGET_DIRECTORY" -type f -name "*.gpg" -exec bash -c 'decrypt_file "$0"' {} \;

echo "Decryption process complete."
