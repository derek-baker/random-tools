
REM http://codebetter.com/jameskovacs/2009/10/12/tip-how-to-run-programs-as-a-domain-user-from-a-non-domain-computer/

REM RUN THIS AS ADMIN

runas /netonly /user:<DOMAIN>\<USERNAME> "C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\Common7\IDE\devenv.exe"