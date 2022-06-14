function which_shell() {
    ps -p $$ -ocomm=
}
