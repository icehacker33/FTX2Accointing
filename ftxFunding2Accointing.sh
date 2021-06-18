#!/usr/bin/env bash
#
# Date:   18/06/2021
# Author: Daniel Zapico
# Desc:   Script to convert exported funding transactions from FTX into a format compatible with Accointing.com
#______________________________________________________________________________________________________________

# FTX exported trades file
FTXFUNDINGCSV="ftxFundingExport.csv"

# Input file with trades to be imported into Accointing.com
ACCOINTINGFUNDINGCSV="accointingFundingImport.csv"

# Force new line characters to be in Unix format
unix2dos FTXFUNDINGCSV

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
unix2dos $ACCOINTINGFUNDINGCSV