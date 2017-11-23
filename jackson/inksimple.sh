find symbols/* -name *.svg |
while read filename
do
	echo "$filename"
	inkscape --file="$filename" --verb=EditSelectAll --verb=SelectionCombine --verb=SelectionSimplify --verb=FileSave --verb=FileQuit
done
