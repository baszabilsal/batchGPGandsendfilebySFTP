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
::set yesterday=20170503
::set today=20170504
echo %yesterday%
echo %today%
:: ------ set today and yesterday date -----

:: 1-----------------
for %%f in ("C:\FTP\CarrotFTP\CampaignOutput\OLD\CAM_152_001987_%yesterday%*") DO (
set aaa=%%f
)
Set _File=%aaa%
copy "%_File%" C:\BE\tmp\MIS

:: 2-----------------
for %%f in ("C:\FTP\CarrotFTP\Daily Transaction Report\OLD\crw_transaction_daily%yesterday%*") DO (
set aaa=%%f
)
Set _File=%aaa%
copy "%_File%" C:\BE\tmp\MIS
:: 3-----------------
for %%f in ("C:\FTP\CarrotFTP\Daily Transaction Detail Report\OLD\crw_transaction_detail_daily%yesterday%*") DO (
set aaa=%%f
)
Set _File=%aaa%
copy "%_File%" C:\BE\tmp\MIS
:: 4-----------------
Set _File=""
for %%f in ("C:\FTP\CarrotFTP\MemberFile\OLD\.tmp.CR_MB_%yesterday%*") DO (
set aaa=%%f
)
Set _File=%aaa%
::copy "%_File%" C:\BE\tmp\MIS

"C:\Program Files\7-Zip\7z.exe" e "%_File%" -oC:\BE\tmp\MIS


:: 5-----------------
for %%f in ("C:\FTP\CarrotFTP\CardMovement\OLD\crw_trans_trans_ident_extract%today%*") DO (
set aaa=%%f
)
Set _File=%aaa%
copy "%_File%" C:\BE\tmp\MIS
:: 6-----------------

copy C:\FTP\CarrotFTP\MasterData\crw_master_title%today%.txt C:\BE\tmp\MIS
copy C:\FTP\CarrotFTP\MasterData\crw_master_trader_source%today%.txt C:\BE\tmp\MIS
copy C:\FTP\CarrotFTP\MasterData\crw_master_trader_status%today%.txt C:\BE\tmp\MIS
copy C:\FTP\CarrotFTP\MasterData\crw_master_trader_type%today%.txt C:\BE\tmp\MIS
copy C:\FTP\CarrotFTP\MasterData\crw_master_transaction_type%today%.txt C:\BE\tmp\MIS
copy C:\FTP\CarrotFTP\MasterData\crw_master_customer_Marital%today%.txt C:\BE\tmp\MIS
copy C:\FTP\CarrotFTP\MasterData\crw_master_customer_Occupation%today%.txt C:\BE\tmp\MIS
copy C:\FTP\CarrotFTP\MasterData\crw_master_customer_Religion%today%.txt C:\BE\tmp\MIS
copy C:\FTP\CarrotFTP\MasterData\crw_master_gender%today%.txt C:\BE\tmp\MIS
copy C:\FTP\CarrotFTP\MasterData\crw_master_mailing_Preference%today%.txt C:\BE\tmp\MIS
copy C:\FTP\CarrotFTP\MasterData\crw_master_custome2%today%.txt C:\BE\tmp\MIS
copy C:\FTP\CarrotFTP\MasterData\crw_master_customer_education%today%.txt C:\BE\tmp\MIS
copy C:\FTP\CarrotFTP\MasterData\crw_master_customer_Ethnicity%today%.txt C:\BE\tmp\MIS
copy C:\FTP\CarrotFTP\MasterData\crw_master_customer_income%today%.txt C:\BE\tmp\MIS

copy C:\FTP\CarrotFTP\Campaign\crw_campaign_daily%today%.txt C:\BE\tmp\MIS
copy C:\FTP\CarrotFTP\Product\crw_product_group_daily%today%.txt C:\BE\tmp\MIS
copy C:\FTP\CarrotFTP\Product\crw_product_daily%today%.txt C:\BE\tmp\MIS



