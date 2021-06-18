#!/usr/bin/env bash
#
# Date:   18/06/2021
# Author: Daniel Zapico
# Desc:   Script to convert exported trades from FTX into a format compatible with Accointing.com
#________________________________________________________________________________________________

# FTX exported trades file
FTXTRADESCSV="ftxTradesExport.csv"

# Input file with trades to be imported into Accointing.com
ACCOINTINGTRADESCSV="accointingTradesImport.csv"

# Force new line characters to be in Unix format
unix2dos $FTXTRADESCSV

# AWK core transformation logic
awk 'BEGIN{
            print "transactionType,date,inBuyAmount,inBuyAsset,outSellAmount,outSellAsset,feeAmount (optional),feeAsset (optional),classification (optional),operationId (optional)";
            FS=",";
            OFMT="%f";
          }
    NR>1  {
            gsub(/"/,"");
            ID=$1;
            TIME=$2;
            YEAR=$2;
            MONTH=$2;
            DAY=$2;
            PAIR=$3;
            SIDE=$4;
            TYPE=$5;
            SIZE=$6;
            PRICE=$7;
            FEE=$8;
            FEECURRENCY=$9;
            INASSET=PAIR;
            OUTASSET=PAIR;
            if(match(PAIR,/\//))
            {
              gsub(/\/.*/,"",INASSET);
              gsub(/.*\//,"",OUTASSET);
            }
            else
            {
              OUTASSET="USD";
            }
            gsub(/.*T|\+.*/,"",TIME);
            gsub(/-.*/,"",YEAR);
            gsub(/[0-9]{4}-/,"",MONTH);
            gsub(/-.*/,"",MONTH);
            gsub(/.*-|T.*/,"",DAY);
            if(match(SIDE,/sell/))
            {
              X=INASSET;
              INASSET=OUTASSET;
              OUTASSET=X;
            }
            gsub(/\..*/,"",TIME);
            printf "order,"MONTH"/"DAY"/"YEAR" "TIME",";
            if(match(SIDE,/sell/))
            {
              printf SIZE*PRICE","INASSET","SIZE","OUTASSET","
            }
            else
            {
              printf SIZE","INASSET","SIZE*PRICE","OUTASSET","
            }
            print FEE","FEECURRENCY","
          }' $FTXTRADESCSV > $ACCOINTINGTRADESCSV

# Force new line characters to be in Windows format
unix2dos $ACCOINTINGTRADESCSV