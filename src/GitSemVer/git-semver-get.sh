main_get()
{
    VERSION="";

    DESCRIBE="$(git describe 2> /dev/null)";
    #if [ $VERBOSE ]
    #then
        echo "git describe exited with code $?";
    #fi

    if [ $? -eq 128 ]
    then
        VERSION="0.0.0";
    fi

    echo $VERSION;
    exit 0;
}