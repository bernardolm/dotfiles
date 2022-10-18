function todo_zsh() {
    source $TODO_DIR/zsh.cfg
    todo.sh $@ | \
        todotxt_hide_create_date | \
        todotxt_highlight_project_and_context | \
        todotxt_hide_project_and_context_symbols
}

function todo_conky() {
    source $TODO_DIR/conky.cfg
    todo.sh $@ | \
        todotxt_hide_footer | \
        todotxt_hide_create_date | \
        todotxt_hide_project_and_context_symbols
}

function todotxt_hide_create_date() {
    local line
    while IFS= read -r line; do
        echo "$line" | sed -E 's/[0-9]{4,4}-[0-9]{2,2}-[0-9]{2,2}\s//g'
    done
}

function todotxt_hide_projects() {
    local line
    while IFS= read -r line; do
        echo "$line" | sed -E 's/([@]\w)//g'
    done
}

function todotxt_hide_footer() {
    local line
    while IFS= read -r line; do
        echo "$line" | grep -vE '^(--|TODO:)'
    done
}

function todotxt_highlight_project_and_context() {
    local line
    while IFS= read -r line; do
        echo "$line" | sed -E 's/[@\+](\w)/🏷 \1/g'
    done
}

function todotxt_hide_project_and_context_symbols() {
    local line
    while IFS= read -r line; do
        echo "$line" | sed -E 's/[@\+](\w)/\1/g'
    done
}
