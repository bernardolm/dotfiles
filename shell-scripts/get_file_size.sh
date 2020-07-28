function get_file_size () {
    command ls -lh $1 | cut -d' ' -f 5
}
