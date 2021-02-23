function show_help (){
  echo
  echo Useage: gomo [option]
  echo
  echo Options:
  echo
  echo run [-rsSwzd] ______________ Run the current react-native project \(do \"gomo run -h\" for details\).
  echo cd \<socket\> _______________ Enter a running server socket, either one of \"webdriver\",
  echo \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \"react-native\" or \"appium\"
  echo ls \ \ ______________________ View all running sockets
  echo kill ______________________ Kill all running sockets
  echo
}

function show_run_help (){
  echo
  echo This command should be run from the root dir of a react-native project.
  echo
  echo Useage: gomo run [-r -w -z -s \<socket\> -S \<suite\>]
  echo
  echo --reset \ -r _______________ Use Web Driver\'s resetApp option to build a fresh sim app.
  echo --socket -s _______________ The \"socket\" logs to view either one of \"webdriver\", 
  echo \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \"react-native\" or \"appium\" \(defaults to \"react-native\"\).
  echo --suite \ -S _______________ The pre-dev test suite to run.
  echo --watch \ -w _______________ Run Web Driver in --watch mode, this restarts any tests if the files change.
  echo --silent -z _______________ Run all socket processes in the background.
  echo --debugger -d _____________ Open the React Native Debugger \(macos only\)
  echo
}
