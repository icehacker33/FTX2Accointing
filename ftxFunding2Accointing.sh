#!/usr/bin/env bash
#
# Date:   18/06/2021
# Author: Daniel Zapico
# Desc:   Script to convert exported funding transactions from FTX into a format compatible with Accointing.com
#______________________________________________________________________________________________________________

# Get script's name
SNAME="$(basename $0)"

_Usage()
{
cat << EOF
Usage: $SNAME <ftxFundingExport.csv>
EOF
}

##### MAIN #####
if [[ $# != 1 ]]; then
  _Usage;
  exit 1;
fi

FTXFUNDINGCSV=$1

if [[ ! -e $FTXFUNDINGCSV ]]; then
  exit 2;
fi

# Input file with trades to be imported into Accointing.com
ACCOINTINGFUNDINGCSV="$(echo "$FTXFUNDINGCSV" | awk '{sub(/\.csv/,"_accointing.csv",$1);print $1}')"

# Force new line characters to be in Unix format
dos2unix $FTXFUNDINGCSV &>/dev/null

# AWK core transformation logic
awk 'BEGIN{
            print "transactionType,date,inBuyAmount,inBuyAsset,outSellAmount,outSellAsset,feeAmount (optional),feeAsset (optional),classification (optional),operationId (optional)";FS=","}NR>1{gsub(/"/,"");
            TIME=$1;
            YEAR=$1;
            MONTH=$1;
            DAY=$1;
            PAIR=$2;
            PAYMENT=$3;
            gsub(/.*T|\+.*/,"",TIME);
            gsub(/-.*/,"",YEAR);
            gsub(/[0-9]{4}-/,"",MONTH);
            gsub(/-.*/,"",MONTH);
            gsub(/.*-|T.*/,"",DAY);
            if(PAYMENT < 0)
            {
              TYPE="-1";
              printf "withdraw,";
            }
            else
            {
              TYPE=1;
              printf "deposit,";
            }
            printf MONTH"/"DAY"/"YEAR" "TIME",";
            if(PAYMENT < 0)
            {
              gsub(/-/,"",PAYMENT);
              printf ",,"PAYMENT",USD"
            }
            else
            {
              printf PAYMENT",USD,,";
            }
            printf ",,,";
            if(TYPE < 0)
            {
              print "margin loss,,";
            }
            else
            {
              print "margin gain,,";
            }
          }' $FTXFUNDINGCSV > $ACCOINTINGFUNDINGCSV

# Force new line characters to be in Windows format
unix2dos $ACCOINTINGFUNDINGCSV &>/dev/null

exit 0