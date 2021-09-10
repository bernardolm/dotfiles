function success_indicator() {
    if [ $? -eq 0 ] ; then
        echo "😉"
    else
        echo "🤬"
    fi
}
