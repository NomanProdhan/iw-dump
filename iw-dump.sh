#!/usr/bin/env bash
welcome_banner() {
    YELLOW="\033[33m"
    NORMAL="\033[0;39m"
    echo -e "$YELLOW"
    printf "\t\t\t\t------------------------------------\n"
    printf "\t\t\t\t|\t\tiw-dump\t\t   |\n"
    printf "\t\t\t\t------------------------------------\n"
    printf "\t\t\t\t|\tAuthor : Noman Prodhan\t   |\n"
    printf "\t\t\t\t|\tGitHub : @NomanProdhan\t   |\n"
    printf "\t\t\t\t|\twww.nomantheking.com\t   |\n"
    printf "\t\t\t\t|\twww.nomanprodhan.com\t   |\n"
    printf "\t\t\t\t------------------------------------"
    echo -e "$NORMAL"
}

dump_networks() {
    iw_scan_raw=$(sudo iw dev $1 scan)
    echo "$iw_scan_raw" | awk 'BEGIN{ FS=":" } 
    /^BSS / {
        MAC = $0
        wifi_networks[MAC]["bssid"]=substr(MAC,5,17)
    }
    /SSID/ {
        wifi_networks[MAC]["ssid"] = $2
    }
    /primary channel/ {
        wifi_networks[MAC]["channel"] = $2
    }
    /freq/ {
        wifi_networks[MAC]["freq"] = $2
    }

    /signal/ {
        wifi_networks[MAC]["signal"] = $2
    }

    /WPS/ {
        wifi_networks[MAC]["wps"] = $3
    }

    /Authentication suites/ {
        wifi_networks[MAC]["auth"] = $2
    }


    END {
        if(wifi_networks[MAC]["bssid"] != ""){
            print("\n")
            print("\t--------------------------------------------------------------------------------------------------")
            print("\t\tBSSID\t\tChannel\t\tFrequency\t  Signal\tAuth\tWPS\tSSID")
            print("\t--------------------------------------------------------------------------------------------------")
            for (ns in wifi_networks) {
                print("\t"wifi_networks[ns]["bssid"] "\t" wifi_networks[ns]["channel"] "\t\t" wifi_networks[ns]["freq"] "\t\t" wifi_networks[ns]["signal"] "\t" wifi_networks[ns]["auth"] "\t" wifi_networks[ns]["wps"] "\t" wifi_networks[ns]["ssid"])
            } 
            print("\t--------------------------------------------------------------------------------------------------")
        }
    }'
}

if [[ $# == 1 ]]; then
    welcome_banner
    dump_networks $1
else
    welcome_banner
    printf "\tUsage : $0 <interface>\n\n"
fi
