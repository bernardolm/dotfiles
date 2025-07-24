#!/usr/bin/env zsh

calendars=""

for item in "${GCALCLI_CALENDARS[@]}"; do
    calendars="$calendars --default-calendar=\"$item\""
done

agenda="$@"
test -z $DEBUG || echo "agenda is $agenda"

agenda_cmd=""

if [ ! -z $DEBUG ]; then
    tmp_file="$HOME/tmp/gcalcli.cache"

    if [ ! -f "$tmp_file" ]; then
        "$DOTFILES/zsh/scripts/gcalcli.sh" > "$tmp_file"
    fi

    agenda_cmd+=" cat $tmp_file "
else
    agenda_cmd+=" PYTHONIOENCODING=utf8 "
    agenda_cmd+=" gcalcli --lineart=ascii "
    agenda_cmd+=" --nocolor --nocache --conky "
    agenda_cmd+=" $calendars "
    agenda_cmd+=" agenda --tsv --military --details=end $agenda "
fi

agenda_cmd+=" | awk -F'\t' '{ printf ( \"%s\t%s %s\t%s\n\", \$1, \$2, \$4, \$5 ) }' "
agenda_cmd+=" | sed 's/00:00 00:00/\\t/g' "
agenda_cmd+=" | sed -e 's/\xf0\x9f\x8e\x82/[bd]/g' "
agenda_cmd+=" | sed -e 's/\xf0\x9f\x8f\x96/[vct]/g' "
agenda_cmd+=" | sed -e 's/\xf0\x9f\x8f\x96\xef\xb8\x8f/[vct]/g' "
agenda_cmd+=" | sed -e 's/\xf0\x9f\x92\xbc/[wbd]/g' "
agenda_cmd+=" | sed -e 's/\xf0\x9f\x93\x85/[evt]/g' "
agenda_cmd+=" | sed -e 's/\xf0\x9f\x93\x86/[evt]/g' "
agenda_cmd+=" | sed -e 's/\xf0\x9f\x94\xae//g' "
agenda_cmd+=" | sed -e 's/\xf0\x9f\x97\xba\xef\xb8\x8f//g' "
agenda_cmd+=" | sed -e 's/\xf0\x9f\x98\xb7/[sick]/g' "
agenda_cmd+=" | sed -e 's/\xf0\x9f\xa9\xb4/[off]/g' "

test -z $DEBUG || echo " $agenda_cmd "
eval " $agenda_cmd " 2>/dev/null
