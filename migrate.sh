CD=`dirname $0`
COMMAND=mogenerator
if `which $COMMAND` > /dev/null 2>&1; then
    $COMMAND -m $CD/Qwi/Qwi.xcdatamodeld/Qwi.xcdatamodel -O $CD/Qwi/Model/ --template-var arc=true
else
    echo "$COMMAND" is not found. Please execute "brew install $COMMAND"
fi
