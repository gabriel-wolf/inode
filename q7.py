import os
import csv
from datetime import datetime

def process_entry(entry, parent_path, output_file):
    if os.path.exists(entry):
        if os.path.isfile(entry):
            # Process regular file
            filename = os.path.basename(entry)
            inode = os.stat(entry).st_ino
            birth_time = datetime.fromtimestamp(os.stat(entry).st_birthtime)
            access_time = datetime.fromtimestamp(os.stat(entry).st_atime)
            modify_time = datetime.fromtimestamp(os.stat(entry).st_mtime)
            change_time = datetime.fromtimestamp(os.stat(entry).st_ctime)

            with open(output_file, 'a', newline='') as csvfile:
                csv_writer = csv.writer(csvfile)
                csv_writer.writerow([filename, inode, parent_path, birth_time, access_time, modify_time, change_time])
        elif os.path.isdir(entry):
            # Process directory
            print(f"Processing directory: {entry}")
            for subentry in os.listdir(entry):
                subentry_path = os.path.join(entry, subentry)
                process_entry(subentry_path, entry, output_file)
        else:
            print(f"Not a regular file or directory: {entry}")
    else:
        print(f"File not found: {entry}")

if __name__ == "__main__":
    output_file = "pythonout1.csv"
    start_directory = "iCloudDrive/Documents/Classes/"

    # Initialize output file
    with open(output_file, 'w', newline='') as csvfile:
        csv_writer = csv.writer(csvfile)
        csv_writer.writerow(['Filename', 'Inode', 'Parent Path', 'Birth Time', 'Access Time', 'Modify Time', 'Change Time'])

    # Start processing from the specified directory
    process_entry(start_directory, "", output_file)

    print("CSV file created successfully.")
