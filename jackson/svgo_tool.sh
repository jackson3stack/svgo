find minified_symbols/* -type d |
while read folder_name
do
	echo "$folder_name"
    svgo -f "$folder_name" -p 2
done

svgo -f minified_symbols -p 2
