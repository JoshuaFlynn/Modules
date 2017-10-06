#!/bin/bash
#Version 1.0
#YOU. WILL. BE. ASSIMILATED.

#CONFIRM. SUBJECT. STATUS.
[ $uid -ne 0 ] && { echo "Resistance without root is futile."; exit 1; }

ASSIMILATION=()
NON_ASSIMILATION=()

#ACTIVATE. COLOUR. IDENTIFIERS.
RED='\033[0;31m'
GREEN='\033[1;32m'
NO_COLOUR='\033[0m'
ON_BLACK='\033[40m' 


#BEGIN. ANALYSIS. OF. TARGET.
while IFS='' read -r line || [[ -n "$line" ]]; do
    
     #ANALYSE. PACKAGE.
     PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $line|grep "install ok installed") 2> /dev/null
    
    
     if [ "" == "$PKG_OK" ]; then
        
        #NO PACKAGE TO ASSIMILATE
        NON_ASSIMILATION+=("$line")
        echo -e "[${ON_BLACK}${RED}NO ASSIMILATION${NO_COLOUR}] $line"
        
     else
        
        #PACKAGE REQUIRES ASSIMILATION
        ASSIMILATION+=("$line")
        echo -e "[${ON_BLACK}${GREEN}ASSIMILATE${NO_COLOUR}] $line"
        
     fi

done < "$1"

#PACKAGES. TO. ASSIMILATE. HAVE. BEEN. IDENTIFIED.

exit 0;