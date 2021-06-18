# FTX2Accointing

Bash wrapper for AWK scripts to convert FTX "funding" and "trades" into Accointing-compatible format

The main purpuse of this script is to allow users to import their subaccount data into their Accointing.com account as subaccounts are not supported yet

## How to use the scripts

### ftxTrades2Accointing.sh

* Select a start and end dates to be exported to CSV in FTX

* Execute the relevant script providing the exported file from FTX as input 

Example:

```
bash ftxTrades2Accointing.sh ftxTradesExport.csv 
```

The above command will create the output file `ftxTradesExport_Accointing.csv` that can be manually imported into the target Accointing.com account