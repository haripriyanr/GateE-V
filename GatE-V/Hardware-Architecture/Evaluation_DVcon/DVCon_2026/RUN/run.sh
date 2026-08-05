#!/bin/bash
###########

echo -e "\n\n"
echo -e "\e[1;31m"
echo -e "                                      (    (        )               (    (        )   (     "
echo -e "                     (        (       )\\ ) )\\ )  ( /(     (         )\\ ) )\\ )  ( /(   )\\ )  "
echo -e "        (   (   (    )\\ )     )\\     (()/((()/(  )\\())    )\\   (   (()/((()/(  )\\()) (()/(  "
echo -e "        )\\  )\\  )\\  (()/(  ((((_)(    /(_))/(_))((_)\   (((_)  )\\   /(_))/(_))((_)\   /(_)) "
echo -e "\e[1;31m       ((_)((_)((_)  /(_))_ )\\ _ )\\  (_)) (_))    ((_)  )\\___ ((_) (_)) (_))    ((_) (_))   \e[0m"
echo -e "\e[1;33m       \\ \\ / / | __|\e[1;31m(_)\e[0m\e[1;33m) __|\e[1;31m(_\e[1;33m)_\\e[1;31m(_) \e[0m\e[1;33m | _ \\| _ \\  / _ \\\ \e[1;31m((\e[0m\e[1;33m/ __|| __|/ __|/ __|  / _ \\ | _ \\  "
echo -e "        \\ V /  | _|   | (_ | / _ \\   |  _/|   / | (_) | | (__ | _| \\__ \\\\\__ \ | (_) ||   /  "
echo -e "         \\_/   |___|   \\___|/_/ \\_\\  |_|  |_|_\\  \\___/   \\___||___||___/|___/  \\___/ |_|_\\  "
echo -e "\e[0m"

echo -e "\e[1;34m --------------------------------------------------------------------------------------------------\e[0m" 
echo -e "\e[1;34m|\e[1;32m                       !! Design & Verification Challenge 2026 !!                                \e[0m \e[1;34m|\e[0m"
echo -e "\e[1;34m --------------------------------------------------------------------------------------------------\e[0m\n" 

rm -rf *.log *.jou *.str .Xil unisims_ver work transcript modelsim.ini

# Define colors
GREEN='\033[0;32m'
NC='\033[0m' # No Color
current_dir=$(pwd)
parent_dir=$(dirname "$current_dir")
MDIR_PATH=$parent_dir
# Prompt for main directory
echo -e "\nYour Main Directory Path: $MDIR_PATH\n"

# Validate directory
if [ ! -d "$MDIR_PATH" ]; then
    echo -e "\n${RED}Directory does not exist. Please check the path.${NC}"
    exit 1
fi

sed -i "s|set MDIR_PATH \".*\"|set MDIR_PATH \"$MDIR_PATH\"|" "$MDIR_PATH/TCL/DVCon_SIM.tcl" 
sed -i "s|set MDIR_PATH \".*\"|set MDIR_PATH \"$MDIR_PATH\"|" "$MDIR_PATH/TCL/DVCon_SYN.tcl" 

while true; do
    echo -e "${GREEN}"
    echo "==========================================="
    echo "        FPGA Project Tool Menu"
    echo " Main Directory: $MDIR_PATH"
    echo "==========================================="
    echo "1) Simulation"
    echo "2) FPGA Implementation"
    echo "3) FPGA Programming"
    echo "4) Exit"
    echo "==========================================="
    echo -e "${NC}"
    read -p "Select an option [1-4]: " choice

    case $choice in
        1)
            echo ""
            echo -e "${GREEN}"
            echo "-------------------------------------------"
            echo "         Choose Simulation Type"
            echo "-------------------------------------------"
            echo "  1)  Vivado Simulation"
            echo "  2)  QuestaSim Simulation"
            echo "-------------------------------------------"
            echo -e "${NC}"
            read -p "Enter your choice [1-2]: " sim_choice
            echo ""
            case $sim_choice in
                1)
                    echo "Running Vivado Simulation..."
                    vivado -source $MDIR_PATH/TCL/DVCon_SIM.tcl
                    ;;
                2)
                    echo "Running QuestaSim Simulation..."
                    vsim -do $MDIR_PATH/TCL/QuestaSim_SIM.do
                    ;;
                *)
                    echo "Invalid simulation option. Please choose 1 or 2."
                    ;;
            esac
            ;;
        2)
            echo ""
            echo -e "${GREEN}"
            echo "-------------------------------------------"
            echo "      FPGA Implementation Options"
            echo "-------------------------------------------"
            echo "  1)  Synthesis Only"
            echo "  2)  Full Implementation (Synthesis + Implementation + Bitstream)"
            echo "-------------------------------------------"
            echo -e "${NC}"
            read -p "Enter your choice [1-2]: " imp_choice
            echo ""
            case $imp_choice in
                1)
                    echo "Running Synthesis Only..."
                    vivado -mode batch -source $MDIR_PATH/TCL/DVCon_SYN.tcl
                    ;;
                2)
                    echo "Running Full Implementation..."
                    echo " ================================================"
                    echo "|-> Option 2 Will be provide in the Next Stage...|"
                    echo " ================================================"
                    ;;
                *)
                    echo "Invalid implementation option. Please choose 1 or 2."
                    ;;
            esac
            ;;
        3)
            echo "Programming FPGA..."
            echo " ================================================"
            echo "|-> Option 3 Will be provide in the Next Stage...|"
            echo " ================================================"
            ;;
        4)
            echo "Exiting..."
            break
            ;;
        *)
            echo "Invalid option. Please choose between 1 and 4."
            ;;
    esac
    echo ""
done
