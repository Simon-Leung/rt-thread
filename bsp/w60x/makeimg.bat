@rem ����0: exe
@rem ����1: ����bin�ļ� ,ԭʼ�ļ�����ѹ�����ļ�
@rem ����2: ����ļ�(Ŀ�������ļ���
@rem ����3: �����ļ�����,0�Ǿɲ������ֵ�image�ļ���3���²������ֵ�image�ļ�
@rem ����4: �Ƿ�ѹ���ļ���0��plain�ļ���1��ѹ�������ļ�
@rem ����5: �汾���ļ�
@rem ����6�������ļ���FLASH��Ĵ��λ�ã����λ�ã�
@rem ����7����������ļ�����λ�ã����λ�ã�
@rem ����8��ԭʼbin�ļ�

@echo off

@rem if debug_info=1, Debugging Print Information will be turned on
set debug_info=0
@rem Setting firmware output directory
set out_path=.\Bin
@rem Setting the bin file path
set bin_file=.\rtthread.bin

@rem Setting the version.txt file path
set version_file=.\tools\version.txt
@rem Setting the secboot.img file path
set secboot_file=.\tools\secboot.img
@rem Setting the wm_gzip.exe file path
set wm_gzip_file=.\tools\wm_gzip.exe
@rem Setting the makeimg.exe file path
set makeimg_file=.\tools\makeimg.exe
@rem Setting the makeimg_all.exe file path
set makeimg_all_file=.\tools\makeimg_all.exe

@rem Prepare to generate firmware
if "%out_path:~0,1%" == "." (set out_path=%~dp0%out_path%)
if "%bin_file:~0,1%" == "." (set bin_file=%~dp0%bin_file%)
if "%version_file:~0,1%" == "." (set version_file=%~dp0%version_file%)
if "%secboot_file:~0,1%" == "." (set secboot_file=%~dp0%secboot_file%)
if "%wm_gzip_file:~0,1%" == "." (set wm_gzip_file=%~dp0%wm_gzip_file%)
if "%makeimg_file:~0,1%" == "." (set makeimg_file=%~dp0%makeimg_file%)
if "%makeimg_all_file:~0,1%" == "." (set makeimg_all_file=%~dp0%makeimg_all_file%)

@rem Create output folder
if not exist "%out_path%" (md "%out_path%")

@rem Copy the required files
if exist "%bin_file%" (copy "%bin_file%" "%out_path%") else (echo makeimg err! No bin file found: %bin_file% & goto end)
if exist "%version_file%" (copy "%version_file%" "%out_path%") else (echo makeimg err! No version file found: %version_file% & goto end)
if exist "%secboot_file%" (copy "%secboot_file%" "%out_path%") else (echo makeimg err! No secboot file found: %secboot_file% & goto end)

@rem Check the existence of firmware generation tools
if not exist "%wm_gzip_file%" (echo makeimg err! No wm_gzip file found: "%wm_gzip_file%" & goto end)
if not exist "%makeimg_file%" (echo makeimg err! No makeimg file found: "%makeimg_file%" & goto end)
if not exist "%makeimg_all_file%" (echo makeimg err! No makeimg_all file found: "%makeimg_all_file%" & goto end)

@rem Get File Names and File Extensions
for /f "delims=" %%A in ('dir /b %bin_file%') do set "bin_file_name=%%A"
for /f "delims=." %%A in ('dir /b %bin_file%') do set bin_name=%%A
for /f "delims=%bin_name%" %%A in ('dir /b %bin_file%') do set bin_extend=%%A
for /f "delims=" %%A in ('dir /b %version_file%') do set "version_file_name=%%A"
for /f "delims=" %%A in ('dir /b %secboot_file%') do set "secboot_file_name=%%A"

@rem Print Debug Information
if not "%debug_info%"=="0" (echo bin_file_name:%bin_file_name% & echo bin_name:%bin_name% & echo bin_extend:%bin_extend% & echo version_file_name:%version_file_name% & echo secboot_file_name:%secboot_file_name%)

echo makeimg 1M Flash...

@rem Start making 1M flash firmware
set file_pos=_1M

@rem Create command parameters
set wm_gzip_cmd="%out_path%\%bin_file_name%"
set makeimg_img_cmd="%out_path%\%bin_file_name%" "%out_path%\%bin_name%%file_pos%.img" 0 0 "%out_path%\%version_file_name%" 90000 10100
set makeimg_gz_img_cmd="%out_path%\%bin_file_name%.gz" "%out_path%\%bin_name%_GZ%file_pos%.img" 0 1 "%out_path%\%version_file_name%" 90000 10100 "%out_path%\%bin_file_name%"
set makeimg_sec_img_cmd="%out_path%\%bin_file_name%" "%out_path%\%bin_name%_SEC%file_pos%.img" 0 0 "%out_path%\%version_file_name%" 90000 10100
set makeimg_all_cmd="%out_path%\%secboot_file_name%" "%out_path%\%bin_name%%file_pos%.img" "%out_path%\%bin_name%%file_pos%.FLS"

@rem Print command Information
if not "%debug_info%"=="0" (echo wm_gzip %wm_gzip_cmd%)
if not "%debug_info%"=="0" (echo makeimg %makeimg_img_cmd%)
if not "%debug_info%"=="0" (echo makeimg %makeimg_gz_img_cmd%)
if not "%debug_info%"=="0" (echo makeimg %makeimg_sec_img_cmd%)
if not "%debug_info%"=="0" (echo makeimg_all %makeimg_all_cmd%)

@rem Execute firmware generation commands
"%wm_gzip_file%" %wm_gzip_cmd%
"%makeimg_file%" %makeimg_img_cmd%
"%makeimg_file%" %makeimg_gz_img_cmd%
"%makeimg_file%" %makeimg_sec_img_cmd%
"%makeimg_all_file%" %makeimg_all_cmd%

@rem Delete temporary files
if exist "%out_path%\%bin_name%%file_pos%.img" (del "%out_path%\%bin_name%%file_pos%.img")
if exist "%out_path%\%bin_file_name%.gz" (del "%out_path%\%bin_file_name%.gz")

@rem Start making 2M flash firmware
echo makeimg 2M Flash...

set file_pos=_2M

@rem Create command parameters
set wm_gzip_cmd="%out_path%\%bin_file_name%"
set makeimg_img_cmd="%out_path%\%bin_file_name%" "%out_path%\%bin_name%%file_pos%.img" 3 0 "%out_path%\%version_file_name%" 90000 10100
set makeimg_gz_img_cmd="%out_path%\%bin_file_name%.gz" "%out_path%\%bin_name%_GZ%file_pos%.img" 3 1 "%out_path%\%version_file_name%" 90000 10100 "%out_path%\%bin_file_name%"
set makeimg_sec_img_cmd="%out_path%\%bin_file_name%" "%out_path%\%bin_name%_SEC%file_pos%.img" 3 0 "%out_path%\%version_file_name%" 90000 10100
set makeimg_all_cmd="%out_path%\%secboot_file_name%" "%out_path%\%bin_name%%file_pos%.img" "%out_path%\%bin_name%%file_pos%.FLS"

@rem Print command Information
if not "%debug_info%"=="0" (echo wm_gzip %wm_gzip_cmd%)
if not "%debug_info%"=="0" (echo makeimg %makeimg_img_cmd%)
if not "%debug_info%"=="0" (echo makeimg %makeimg_gz_img_cmd%)
if not "%debug_info%"=="0" (echo makeimg %makeimg_sec_img_cmd%)
if not "%debug_info%"=="0" (echo makeimg_all %makeimg_all_cmd%)

@rem Execute firmware generation commands
"%wm_gzip_file%" %wm_gzip_cmd%
"%makeimg_file%" %makeimg_img_cmd%
"%makeimg_file%" %makeimg_gz_img_cmd%
"%makeimg_file%" %makeimg_sec_img_cmd%
"%makeimg_all_file%" %makeimg_all_cmd%

@rem Delete temporary files
if exist "%out_path%\%bin_name%%file_pos%.img" (del "%out_path%\%bin_name%%file_pos%.img")
if exist "%out_path%\%bin_file_name%.gz" (del "%out_path%\%bin_file_name%.gz")

:end
echo end
