echo "Minimising Symbols... InkScape phase -----"

PRECISION=2
SYMBOL_FOLDER=symbols
JSON_FOLDER=json_symbols

find "$SYMBOL_FOLDER"/* -name *.svg |
while read filename
do
	echo "$filename"
	inkscape --file="$filename" --verb=EditSelectAll --verb=SelectionCombine --verb=SelectionSimplify --verb=FileSave --verb=FileQuit
done

echo "Minimising Symbols... SVGO phase -----"

find $SYMBOL_FOLDER/* -type d |
while read folder_name
do
	echo "$folder_name"
    svgo -f "$folder_name" -p $PRECISION
done

svgo -f "$SYMBOL_FOLDER" -p $PRECISION

echo "Minimising Symbols... JSON phase -----"

find "$SYMBOL_FOLDER"/* -type d |
while read folder_name
do  
    JSON=`python svg2json.py files "$folder_name"/*.svg --kind "${folder_name##*/}"`
    
    if [ "$JSON" != "{}" ]
    then
        mkdir "$JSON_FOLDER" -p
        echo "$folder_name"
        echo "${folder_name##*/}.json"
        echo "$JSON" > "$JSON_FOLDER/${folder_name##*/}.json"
    fi
done

echo "----- DONE -----"
