#!/bin/bash

# default to index.md
markdown_file=${1:-index.md}
if [[ ! -f $markdown_file ]]; then
    echo "Error: File $markdown_file does not exist."
    exit 1
fi

# image save directory
image_dir="./images"
mkdir -p $image_dir

# # Temporary file for sed replace
# temp_file=$(mktemp)

while IFS= read -r line; do
    # Match line pattern for ![<filename>](https://i.imgur.com/<image-id>.png)
    if [[ $line == !\[*\]\(https://i.imgur.com/*.png\) ]]; then

        # Extract filename and image-id
        filename=$(echo $line | sed -n 's/.*!\[\(.*\)\](https:\/\/i.imgur.com\/.*.png).*/\1/p')
        image_id=$(echo $line | sed -n 's/.*!\[.*\](https:\/\/i.imgur.com\/\(.*\).png).*/\1/p')

        # Download image
        if ! wget -O $image_dir/$filename.png https://i.imgur.com/$image_id.png; then
            echo "Error: Failed to download image https://i.imgur.com/$image_id.png"
            continue
        fi

        # Replace image URL with local file
        # sed "s|!\[$filename\](https://i.imgur.com/$image_id.png)|!\[$filename\](./images/$filename.png)|g" "$markdown_file" > "$temp_file" && mv "$temp_file" "$markdown_file"

        if ! sed -i "s|!\[$filename\](https://i.imgur.com/$image_id.png)|!\[$filename\](./images/$filename.png)|g" "$markdown_file"; then
            echo "Error: Failed to update the markdown file for $filename"
            continue
        fi
    fi
done <"$markdown_file"

#################################################################################
# Potential fix for read and writes in teh same pipeline, save lines to an array
#################################################################################


# # default to index.md
# markdown_file=${1:-index.md}
# if [[ ! -f $markdown_file ]]; then
#     echo "Error: File $markdown_file does not exist."
#     exit 1
# fi

# # image save directory
# image_dir="./images"
# mkdir -p $image_dir

# # Read the markdown file into an array
# mapfile -t lines <"$markdown_file"

# # Process each line
# for line in "${lines[@]}"; do
#     # Match line pattern for ![<filename>](https://i.imgur.com/<image-id>.png)

#     if [[ $line == !\[*\]\(https://i.imgur.com/*.png\) ]]; then

#         # Extract filename and image-id
#         filename=$(echo $line | sed -n 's/.*!\[\(.*\)\](https:\/\/i.imgur.com\/.*.png).*/\1/p')
#         image_id=$(echo $line | sed -n 's/.*!\[.*\](https:\/\/i.imgur.com\/\(.*\).png).*/\1/p')

#         # Download  image
#         if ! wget -O $image_dir/$filename.png https://i.imgur.com/$image_id.png; then
#             echo "Error: Failed to download image https://i.imgur.com/$image_id.png"
#             continue
#         fi

#         # Replace image URL with local file
#         if ! sed -i "s|!\[$filename\](https://i.imgur.com/$image_id.png)|!\[$filename\](./images/$filename.png)|g" "$markdown_file"; then
#             echo "Error: Failed to update the markdown file"
#             continue
#         fi
#     fi
# done
