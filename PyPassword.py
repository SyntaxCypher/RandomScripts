import argparse
import os
import base64
import hashlib
from getpass import getpass
from cryptography.fernet import Fernet
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC

# Function to derive a key from a password
def derive_key_from_password(password):
    salt = b'salt_'  # In a real application, use a secure, random salt and store it securely
    kdf = PBKDF2HMAC(
        algorithm=hashlib.sha256(),
        length=32,
        salt=salt,
        iterations=100000
    )
    key = base64.urlsafe_b64encode(kdf.derive(password.encode()))
    return key

# Function to encrypt the file
def encrypt_file(filename, password):
    key = derive_key_from_password(password)
    fernet = Fernet(key)
    with open(filename, 'rb') as file:
        original = file.read()
    if original:
        encrypted = fernet.encrypt(original)
        with open(filename, 'wb') as encrypted_file:
            encrypted_file.write(encrypted)
    else:
        print(f"The file {filename} is empty and cannot be encrypted.")

# Function to decrypt the file
def decrypt_file(filename, password):
    key = derive_key_from_password(password)
    fernet = Fernet(key)
    with open(filename, 'rb') as encrypted_file:
        encrypted = encrypted_file.read()
    if encrypted:
        try:
            decrypted = fernet.decrypt(encrypted)
            with open(filename, 'wb') as decrypted_file:
                decrypted_file.write(decrypted)
        except (cryptography.fernet.InvalidToken, ValueError):
            print(f"The file {filename} is not encrypted or the encryption key is invalid.")
    else:
        print(f"The file {filename} is empty or not encrypted.")

# Function to view the file
def view_file(filename, password):
    key = derive_key_from_password(password)
    fernet = Fernet(key)
    with open(filename, 'rb') as encrypted_file:
        encrypted = encrypted_file.read()
    if encrypted:
        try:
            decrypted = fernet.decrypt(encrypted)
            print(decrypted.decode('utf-8'))
        except (cryptography.fernet.InvalidToken, ValueError):
            print(f"The file {filename} is not encrypted or the encryption key is invalid.")
    else:
        print(f"The file {filename} is empty or not encrypted.")

# Function to create a new file
def create_file(filename, password):
    with open(filename, 'w') as new_file:
        new_file.write("")
    encrypt_file(filename, password)
    print("Password set")

# Function to edit the file with nano
def edit_file(filename):
    os.system(f'nano {filename}')

# Main function to handle arguments and logic
def main():
    parser = argparse.ArgumentParser(description="Encrypt, decrypt, and edit a file.")
    parser.add_argument('-e', '--encrypt', help="Encrypt the file", action='store_true')
    parser.add_argument('-d', '--decrypt', help="Decrypt and edit the file with nano", action='store_true')
    parser.add_argument('-v', '--view', help="View the decrypted file content", action='store_true')
    parser.add_argument('-c', '--create', help="Create a new file", action='store_true')
    parser.add_argument('-n', '--nano', help="Edit the file with nano", action='store_true')
    parser.add_argument('filename', nargs='?', help="The file to operate on")

    args = parser.parse_args()

    if args.create:
        if args.filename:
            password = getpass("Enter password for the new file: ")
            create_file(args.filename, password)
        else:
            print("Please provide a filename for the new file.")
    elif args.filename:
        if args.encrypt:
            password = getpass("Enter password for encryption: ")
            encrypt_file(args.filename, password)
        elif args.decrypt:
            password = getpass("Enter password for decryption: ")
            decrypt_file(args.filename, password)
            os.system(f'nano {args.filename}')
            encrypt_file(args.filename, password)
        elif args.view:
            password = getpass("Enter password for viewing: ")
            view_file(args.filename, password)
        elif args.nano:
            edit_file(args.filename)
        else:
            parser.print_help()
    else:
        print("Please provide a filename for the operation.")
        parser.print_help()

if __name__ == '__main__':
    main()
