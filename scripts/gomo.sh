#!/bin/bash
gomodir="$HOME/.gomo"
suitesdir="./automation/test"
screenrc="$gomodir/app/screenrc"
configfile="$gomodir/app/config.js"

# screen label names
rn="rn"
wdio="wdio"
appi="appium"
devtools="devtools"

socket=""
resetappflag=0
debugger=0
wdioflags=""
appname=""
appdirectory=""

source "$gomodir/app/scripts/help_scripts.sh"
source "$gomodir/app/scripts/animations.sh"

function gomo (){
  if [[ $1 = 'config' ]]; then
    choose_config "$@"
  elif [[ $1 = 'run' ]]; then
    run "$@"
  elif [[ $1 = 'kill' ]]; then
    kill_mob "$@"
  elif [[ $1 = 'cd' ]]; then
    screen -r "$2" | sed s/screen/socket/g
  elif [[ $1 = 'ls' ]]; then
    screen -ls | sed 's/^[0-1] Socket in.*$//g' | awk '1' RS=''
  elif [[ $1 = 'help' || $1 = '-h' || $1 = '--help' ]]; then
    show_help
  else
    echo Unkown gomo command! Try the following options:
    show_help
  fi
}

function show_config (){
  echo
  echo Gomo Configuration:
  echo
  awk '/^ *app:/ {print $0}' $configfile | sed "s/[',]//g" | sed "s/^ *app:/App Directory:/"
  awk '/^ *platformVersion:/ {print $0}' $configfile | sed "s/[',]//g" | sed "s/^ *platformVersion:/Platform Version:/"
  echo
}

function choose_config (){
  arg_len=${#2}

  if [[ $arg_len -lt 1 ]]; then
    show_config
    exit
  fi

  while [ ! -z "$2" ]; do
    case "$2" in
      --app)
        shift
        appname="$2"

        # Do a search in the DerivedData directory for an app with the given name...
        appdirectory=$(find ~/Library/Developer/Xcode/DerivedData -type d -name "$2.app" | tr '\n' ' ')
        # Turn the result into an array...
        dirarr=($appdirectory)

        # If the array is longer than 1 the user will have to select one...
        if [[ ${#dirarr[@]} -gt 1 ]]; then

          PS3="More than one directory found for a $appname app, please choose one: "
          select opt in ${dirarr[@]}
          do
            case $opt in
              *) 
                sed -i '' "s|\(^ *app: \).*$|\1'$opt',|" $configfile
                break
                ;;
            esac
          done
        fi
        ;;
      --platform-version)
        shift
        sed -i '' "s|\(^ *platformVersion: \).*$|\1'$2',|" $configfile
        ;;
      *)
        echo Incorrect options, add either of the two items to the config for example:
        echo
        echo gomo config --app \"myappname\" --platform-version \"13.5\"
        echo
        exit
    esac
    shift
  done
  show_config
}

function check_config (){
  apppath=$(awk '/^ *app:/ {print $0}' $configfile | sed "s/^ *app: \(.*\),/\1/")
  appversion=$(awk '/^ *platformVersion:/ {print $0}' $configfile | sed "s/^ *platformVersion: \(.*\),/\1/")
  pathlen=${#apppath}
  versionlen=${#appversion}

  if [[ $pathlen -gt 0 && $versionlen -gt 0 ]]; then
    return 0
  else
    echo Please configure gomo first by adding your app\'s name:
    echo Example: gomo config --app \"myappname\"
    exit
  fi
}

function kill_mob (){

  kill -9 `pgrep -f react-native` 2> /dev/null
  kill -9 `pgrep -f appium` 2> /dev/null
  kill -9 `pgrep -f wdio` 2> /dev/null

  screen -wipe 2> /dev/null

  echo "Gomo sockets closed"
  echo
}

function kill_wdio (){
  kill -9 $(pgrep -f $wdio)
  screen -wipe $wdio 2> /dev/null
}

function run_rn (){
  screen -c $screenrc -dmS $rn npx react-native start --reset-cache
}

function run_wdio (){
  (cd $gomodir/app; screen -c $screenrc -dmS $wdio npm run wdio config.js $1)
}

function run_appium (){
  (cd $gomodir/app; screen -c $screenrc -dmS $appi npm run appium)
}

function set_options (){
  while [ ! -z "$2" ]; do
    case "$2" in
      --reset|-r)
        #TODO: does this need a shift here?
        resetappflag=1
        ;;
      --debugger|-d)
        shift
        # Only set this if on macos
        if [[ uname = "Darwin" ]]; then
          debugger=1
        fi
        ;;
      --socket|-s)
        shift
        if [[ "$2" != $rn && "$2" != $wdio && "$2" != $appi ]]; then
          echo Bad --socket argument use one of: \"$wdio\", \"$rn\" or \"$appi\"
          exit;
        else
          socket="$2"
        fi
        ;;
      --suite|-S)
        shift
        find_suite_path "$2"
        wdioflags+=" --suite $suitepath"
        ;;
      --watch|-w)
        shift
        wdioflags+=" --watch"
        ;;
      *)
        show_run_help
        exit
        ;;
    esac
    shift
  done
}

function find_suite_path (){
  path=$(find $suitesdir -name "$1.*js" | tr '\n' ' ')
  echo $path
  pathlen=($path)
  if [[ ${#pathlen[@]} -gt 1 ]]; then
    echo
    echo Error, more than one spec matching \"$1\"
    echo
    exit
  fi
  echo
  echo Finding suite: $1
  echo
  echo Found: $path
  suitepath=$path
}

function run (){
  check_config

  set_options "$@"

  # Open the RN debugger (macos only)
  if [[ $debugger -gt 0 ]]; then
    open -ga React\ Native\ Debugger
  fi

  # Note that these commands rely on resetApp and noReset already being in the config...
  if [[ $resetappflag -gt 0 ]]; then
    kill_mob
    sed -i '' "s|\(^ *resetApp: \).*$|\1true,|" $configfile
    sed -i '' "s|\(^ *noReset: \).*$|\1false,|" $configfile
  else
    sed -i '' "s|\(^ *resetApp: \).*$|\1false,|" $configfile
    sed -i '' "s|\(^ *noReset: \).*$|\1true,|" $configfile
  fi

  # We do a yarn install every time.
  yarnoutput=$(yarn | grep 'success Already up-to-date.')
  wait
  if [[ $yarnoutput != "success Already up-to-date." ]]; then
    echo "No modules installed running a fresh environment..."
    npx pod-install
    wait
  else
    echo "Modules Already up-to-date"
  fi

  # We also restart webdriver every time.
  kill_wdio

  # Only start appium if it's not already running.
  if pgrep -f 'appium' > /dev/null 2>&1; then
    echo "Appium server running"
  else
    echo "Starting Appium server"
    run_appium
  fi

  # Only start metro if it's not already running.
  if pgrep -f 'react-native' > /dev/null 2>&1; then
    echo "Metro server running"
  else
    echo "Starting Metro server"
    run_rn
  fi

  echo "Starting Web Driver"
  run_wdio $wdioflags
  echo

  waiting_lines "Brace yourself"
  echo

  if [[ $socket ]]; then
    screen -r $socket
  else
    banner $rn $wdio $appi
  fi

}

gomo "$@"
