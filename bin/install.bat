@echo off

:do_prompt
  choice /C YN /M "IF THE 'fedora35' DISTRO ALREADY EXISTS IT WILL BE REMOVED!!!"
  IF ERRORLEVEL 2 goto do_exit 
  IF ERRORLEVEL 1 goto do_install
  goto do_prompt

:do_install
  wsl --terminate fedora35 >nul 2>&1
  wsl --unregister fedora35 >nul 2>&1
  wsl --import fedora35 %USERPROFILE%\WSL2\systems\fedora35 .\fedora35-wsl-container.tar

  echo fedora35 should now be available in Windows Terminal (may require restart)
  echo Otherwise you may start it manually with `wsl -d fedora35`
  echo Starting fedora35 distro..
  wsl -d fedora35

:do_exit
  echo Exiting...
  pause
  exit /b
