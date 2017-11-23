find to_input_symbols/* -type d |
while read folder_name
do  
	echo "$folder_name"
	echo "${folder_name##*/}.json"
    python svg2json.py files "$folder_name"/*.svg --kind "${folder_name##*/}" > "${folder_name##*/}".json
done
