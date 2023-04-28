#!/usr/bin/env zsh
source ~/.zshrc

function search() {
	sudo find $HOME/Downloads/recovery \
		-name "*.java" \
		-o -name "*.a" \
		-o -name "*.ai" \
		-o -name "*.aif" \
		-o -name "*.asf" \
		-o -name "*.bmp" \
		-o -name "*.sys" \
		-o -name "*.DLL" \
		-o -name "*.MUI" \
		-o -name "*.EXE" \
		-o -name "*.c" \
		-o -name "*.cab" \
		-o -name "*.caf" \
		-o -name "*.chm" \
		-o -name "*.class" \
		-o -name "*.csv" \
		-o -name "*.db" \
		-o -name "*.dll" \
		-o -name "*.diskimage" \
		-o -name "*.doc" \
		-o -name "*.wim" \
		-o -name "*.sqlite" \
		-o -name "*.Dll" \
		-o -name "*.edb" \
		-o -name "*.docx" \
		-o -name "*.elf" \
		-o -name "*.bat" \
		-o -name "*.sqm" \
		-o -name "*.f" \
		-o -name "*.exe" \
		-o -name "*.frm" \
		-o -name "*.cpl" \
		-o -name "*.pcx" \
		-o -name "*.gif" \
		-o -name "*.gz" \
		-o -name "*.h" \
		-o -name "*.html" \
		-o -name "*.icc" \
		-o -name "*.ico" \
		-o -name "*.ini" \
		-o -name "*.ini" \
		-o -name "*.jp2" \
		-o -name "*.jsp" \
		-o -name "*.lnk" \
		-o -name "*.mobi" \
		-o -name "*.vdi" \
		-o -name "*.vdm" \
		-o -name "*.mp3" \
		-o -name "*.mui" \
		-o -name "*.MYI" \
		-o -name "*.ogg" \
		-o -name "*.pdf" \
		-o -name "*.php" \
		-o -name "*.pl" \
		-o -name "*.plist" \
		-o -name "*.pm" \
		-o -name "*.png" \
		-o -name "*.ppt" \
		-o -name "*.ps" \
		-o -name "*.psd" \
		-o -name "*.py" \
		-o -name "*.pyc" \
		-o -name "*.pyc" \
		-o -name "*.reg" \
		-o -name "*.rtf" \
		-o -name "*.skp" \
		-o -name "*.xz" \
		-o -name "*.pst" \
		-o -name "*.deb" \
		-o -name "*.svg" \
		-o -name "*.sxw" \
		-o -name "*.odt" \
		-o -name "*.tif" \
		-o -name "*.ttf" \
		-o -name "*.txt" \
		-o -name "*.tz" \
		-o -name "*.wav" \
		-o -name "*.wma" \
		-o -name "*.woff" \
		-o -name "*.xls" \
		-o -name "*.xlsx" \
		-o -name "*.xml" \
		-o -name "*.pfx" \
		-o -name "*.xpt" \
		-o -name "*.gpg" \
		-o -name "*.torrent" \
		-o -name "*.mid" \
		-o -name "*.xmp" \
		-o -name "*.winmdobj" \
		-o -name "*.m4p" \
		-o -name "*.tmp" \
		-o -name "*.apple" \
		-o -name "*.vsd" \
		-o -name "*.mbox" \
		-o -name "*.jar" \
		-o -name "*.json" \
		-o -name "*.sh" \
		-o -name "*.bz2" \
		-o -name "*.swf"
}

echo $(search | grep -v 'clean.sh' | grep -c \/)

# search -print0 | xargs -I{} -0 sudo rm {}

for file in $(search | grep -v 'clean.sh')
do
	sudo rm "$file"
done
