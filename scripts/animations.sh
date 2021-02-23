black='\033[0;30m'
red='\033[0;31m'
green='\033[0;32m'
brown='\033[0;33m'
blue='\033[0;34m'
purple='\033[0;35m'
cyan='\033[0;36m'
lightGray='\033[0;37m'
dark_gray='\033[1;30m'
light_red='\033[1;31m'
light_green='\033[1;32m'
yellow='\033[1;33m'
light_blue='\033[1;34m'
light_purple='\033[1;35m'
light_cyan='\033[1;36m'
white='\033[1;37m'
coloff='\033[0m'

function waiting_lines (){

  for i in {1..20}; do 
    if [[ $i = 4 || $i = 8 || $i = 12 || $i = 16 ]]; then
      dot="   "
    elif [[ $i = 5 || $i = 9 || $i = 13 || $i = 17 ]]; then
      dot="."
    else
      dot+="."
    fi
    if [[ $i = 20 ]]; then
      printf "\r%-${COLUMNS}s" "                                                                           ";
    else
      printf "\r%-${COLUMNS}s" "$1$dot";
      sleep .3
    fi
  done
}

function banner (){
  echo -e "${yellow}"
  sleep .05
  echo " *********************************************************** "
  sleep .05
  echo "*************************************************************"
  sleep .05
  echo "****            *********************************************"
  sleep .05
  echo "****            *********************************************"
  sleep .05
  echo "****  *******************************************************"
  sleep .05
  echo "****  *******************************************************"
  sleep .05
  echo "****  *******************************************************"
  sleep .05
  echo "****  ****      ***          ***           ***          *****"
  sleep .05
  echo "****  ********  ***  ******  ***  *** ***  ***  ******  *****"
  sleep .05
  echo "****  ********  ***  ******  ***  *** ***  ***  ******  *****"
  sleep .05
  echo "****  ********  ***  ******  ***  *******  ***  ******  *****"
  sleep .05
  echo "****            ***          ***  *******  ***          *****"
  sleep .05
  echo "*************************************************************"
  sleep .05
  echo " *********************************************************** "
  sleep .05
  echo -e "${coloff}"
  sleep .05
  echo
  sleep .05
  printf "${light_blue}Gomo running!${coloff}"
  sleep .05
  echo
  sleep .05
  echo
  sleep .05
  printf "Use: \"gomo cd <$1, $2, $3>\" to enter a process."
  sleep .05
  echo
  sleep .05
  echo
}


