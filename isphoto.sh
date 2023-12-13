#!/bin/bash

is_photo() {
    file_type=$(file -b --mime-type "$1")
    [[ $file_type == "image/"* ]]
}

directory_path="iCloudDrive/Pictures"

likely_photos=0
not_likely_photos=0

while IFS= read -r -d $'\0' file_path; do
    if is_photo "$file_path"; then
        echo "$file_path is likely a photo."
        ((likely_photos++))
    else
        echo "$file_path is not recognized as a photo."
        ((not_likely_photos++))
    fi
done < <(find "$directory_path" -type f -print0)

total_files=$((likely_photos + not_likely_photos))
percentage_likely_photos=0

if [ "$total_files" -gt 0 ]; then
    percentage_likely_photos=$((100 * likely_photos / total_files))
fi

echo "Total likely photos: $likely_photos"
echo "Total not likely photos: $not_likely_photos"
echo "Percentage of likely photos: $percentage_likely_photos%"

if [ "$percentage_likely_photos" -gt 90 ]; then
    echo "This directory is likely a Photos directory."
fi