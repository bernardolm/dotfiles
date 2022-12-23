#!/usr/bin/env zsh

local base_path="$(dirname $0)"

source $base_path/init/30_env.zsh

find "$SYNC_PATH/zsh/init" -name '*.zsh' | while read -r file; do
    source "$file"
done

local calendars=""

for item in "${GCALCLI_CALENDARS[@]}"; do
    calendars="$calendars --calendar=\"$item\""
done

local agenda="$@"
test -z $DEBUG || echo "agenda is $agenda"

local agenda_cmd=""

if [ ! -z $DEBUG ]; then
    local tmp_file="/tmp/gcalcli.cache"

    if [ ! -f "$tmp_file" ]; then
        /home/bernardo/workspaces/bernardolm/dotfiles/zsh/gcalcli.sh > "$tmp_file"
    fi

    agenda_cmd+=" cat $tmp_file "
else
    agenda_cmd+=" PYTHONIOENCODING=utf8 "
    agenda_cmd+=" gcalcli --lineart=ascii --logging_level DEBUG "
    agenda_cmd+=" --nocolor --conky "
    agenda_cmd+=" $calendars "
    agenda_cmd+=" agenda --tsv --military --details=end $agenda "
fi

agenda_cmd+=" | awk -F'\t' '{ printf ( \"%s\t%s %s\t%s\n\", \$1, \$2, \$4, \$5 ) }' "
agenda_cmd+=" | sed 's/00:00 00:00/\\t/g' "
agenda_cmd+=" | sed 's/🎂 /[bd] /g' "
agenda_cmd+=" | sed 's/🏖 /[vct] /g' "
agenda_cmd+=" | sed 's/💼 /[wbd] /g' "
agenda_cmd+=" | sed 's/🩴 /[dof] /g' "
agenda_cmd+=" | sed 's/📅 /[evt] /g' "
agenda_cmd+=" | sed 's/🗺️ //g' "

test -z $DEBUG || echo " $agenda_cmd "
eval " $agenda_cmd "
