function replace_str() {
    if [ "$#" -ne 3 ]; then
	echo -e "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	echo -e "usage: replace_str fileLoc oldText newText"
	echo -e "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

	return 255
    fi

    fileLoc="$1"
    oldText="$2"
    newText="$3"

    sed -i "s#${oldText}#${newText}#g" ${fileLoc}
}
