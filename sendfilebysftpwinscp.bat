:: Subject : EAS SEND Instruction files 
:: Author : Prasit S.
:: ------ set today and yesterday date -----
set today=%date:~-4,4%%date:~-7,2%%date:~-10,2%
set yyyy=
set $tok=1-3
for /f "tokens=1 delims=.:/-, " %%u in ('date /t') do set $d1=%%u
if "%$d1:~0,1%" GTR "9" set $tok=2-4
for /f "tokens=%$tok% delims=.:/-, " %%u in ('date /t') do (
for /f "skip=1 tokens=2-4 delims=/-,()." %%x in ('echo.^|date') do (
set %%x=%%u
set %%y=%%v
set %%z=%%w
set $d1=
set $tok=))
if "%yyyy%"=="" set yyyy=%yy%
if /I %yyyy% LSS 100 set /A yyyy=2000 + 1%yyyy% - 100
set CurDate=%mm%/%dd%/%yyyy%
set dayCnt=%1
if "%dayCnt%"=="" set dayCnt=1
REM Substract your days here
set /A dd=1%dd% - 100 - %dayCnt%
set /A mm=1%mm% - 100
:CHKDAY
if /I %dd% GTR 0 goto DONE
set /A mm=%mm% - 1
if /I %mm% GTR 0 goto ADJUSTDAY
set /A mm=12
set /A yyyy=%yyyy% - 1
:ADJUSTDAY
if %mm%==1 goto SET31
if %mm%==2 goto LEAPCHK
if %mm%==3 goto SET31
if %mm%==4 goto SET30
if %mm%==5 goto SET31
if %mm%==6 goto SET30
if %mm%==7 goto SET31
if %mm%==8 goto SET31
if %mm%==9 goto SET30
if %mm%==10 goto SET31
if %mm%==11 goto SET30
REM ** Month 12 falls through
:SET31
set /A dd=31 + %dd%
goto CHKDAY
:SET30
set /A dd=30 + %dd%
goto CHKDAY
:LEAPCHK
set /A tt=%yyyy% %% 4
if not %tt%==0 goto SET28
set /A tt=%yyyy% %% 100
if not %tt%==0 goto SET29
set /A tt=%yyyy% %% 400
if %tt%==0 goto SET29
:SET28
set /A dd=28 + %dd%
goto CHKDAY
:SET29
set /A dd=29 + %dd%
goto CHKDAY
:DONE
if /I %mm% LSS 10 set mm=0%mm%
if /I %dd% LSS 10 set dd=0%dd%
REM Set IIS and AWS date variables
set IISDT=%yyyy:~2,2%%mm%%dd%
set yesterday=%yyyy%%mm%%dd%
::set yesterday=20160428
::set today=20160429
echo %yesterday%
echo %today%
:: ------ set today and yesterday date -----


:: --- Prepare Environment

for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /format:list') do set datetime=%%I
set datetime=%datetime:~0,14%
set date=%datetime:~0,8%
echo %date%
echo %datetime%
:: --- Set parameter --
set BASE=C:\BE\data\MIS\
set log_file=C:\BE\MIS_SFTP.log
set winscp_put_to_server=C:\BE\scripts\winscp_put_to_server.txt

set sftp_user=#
set sftp_password=#
set sftp_server=#
set sftp_ssh=#

echo %Date% %Time% "========================= Start PEM Process ====================" >> %log_file%

::=======================



set put_file=%BASE%MIS_REWARD_%yesterday%.zip.gpg
set put_location=/


"C:\Program Files (x86)\WinSCP\WinSCP.com" /script=%put% >> %log_file%
if %ERRORLEVEL% neq 0 goto error_put
echo Upload succeeded >> %log_file%
goto finish_put
:error_put
echo Upload failed, moving files back to orinal folder  >> %log_file%
:finish_put

