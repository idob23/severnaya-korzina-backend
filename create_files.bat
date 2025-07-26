# create_files.bat - Для Windows
@echo off
echo Создаем недостающие директории и файлы...

REM Создаем директории
if not exist "src\middleware" mkdir src\middleware
if not exist "src\routes" mkdir src\routes
if not exist "uploads" mkdir uploads
if not exist "logs" mkdir logs

echo. > uploads\.gitkeep
echo. > logs\.gitkeep

echo Файлы и директории созданы!
echo Теперь нужно создать файлы middleware и routes...