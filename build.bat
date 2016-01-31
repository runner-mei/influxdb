set influxdb_dir=%~dp0
pushd %cd%

@if /i "%1"=="help" goto help
@if /i "%1"=="--help" goto help
@if /i "%1"=="-help" goto help
@if /i "%1"=="/help" goto help
@if /i "%1"=="-h" goto help
@if /i "%1"=="/h" goto help
@if /i "%1"=="?" goto help
@if /i "%1"=="-?" goto help
@if /i "%1"=="--?" goto help
@if /i "%1"=="/?" goto help

@rem Process arguments.
@set is_update=
@set is_build=
@set is_test=
@set is_install=


@if "%1"=="" (
  @set is_build=1
  @set is_test=1
)

:next-arg

@if "%1"=="" goto args-done
@if /i "%1"=="update"     set is_update=1&goto arg-ok
@if /i "%1"=="test"       set is_test=1&goto arg-ok
@if /i "%1"=="build"      set is_build=1&goto arg-ok

:arg-ok
shift
goto next-arg
:args-done


@if not defined is_update (
  @if "%GOGET%" EQU "" set GOGET=go get
) else (
  @if "%GOGET%" EQU "" set GOGET=go get -u
)


%GOGET% golang.org/x/tools
%GOGET% github.com/sparrc
gdm restore
:update_ok


@if not defined is_test goto test_ok

:test
cd %influxdb_dir%pkg\escape
go test -v
@if errorlevel 1 goto failed

cd %influxdb_dir%models
go test -v
@if errorlevel 1 goto failed

cd %influxdb_dir%influxql
go test -v
@if errorlevel 1 goto failed

cd %influxdb_dir%tcp
go test -v
@if errorlevel 1 goto failed

cd %influxdb_dir%toml
go test -v
@if errorlevel 1 goto failed

cd %influxdb_dir%tsdb
go test -v
@if errorlevel 1 goto failed

cd %influxdb_dir%tsdb/engine/tsm1
go test -v
@if errorlevel 1 goto failed

cd %influxdb_dir%snapshot
go test -v
@if errorlevel 1 goto failed

cd %influxdb_dir%client
go test -v
@if errorlevel 1 goto failed

cd %influxdb_dir%cluster
go test -v
@if errorlevel 1 goto failed

cd %influxdb_dir%monitor
go test -v
@if errorlevel 1 goto failed

cd %influxdb_dir%services\meta
go test -v
@if errorlevel 1 goto failed

cd %influxdb_dir%services\admin
go test -v
@if errorlevel 1 goto failed

cd %influxdb_dir%services\precreator
go test -v
@if errorlevel 1 goto failed

cd %influxdb_dir%services\snapshotter
go test -v
@if errorlevel 1 goto failed

cd %influxdb_dir%services\retention
go test -v
@if errorlevel 1 goto failed

cd %influxdb_dir%services\continuous_querier
go test -v
@if errorlevel 1 goto failed

cd %influxdb_dir%services\copier
go test -v
@if errorlevel 1 goto failed

cd %influxdb_dir%services\httpd
go test -v
@if errorlevel 1 goto failed

cd %influxdb_dir%services\udp
go test -v
@if errorlevel 1 goto failed

cd %influxdb_dir%services\collectd
go test -v
@if errorlevel 1 goto failed

cd %influxdb_dir%services\opentsdb
go test -v
@if errorlevel 1 goto failed

cd %influxdb_dir%services\subscriber
go test -v
@if errorlevel 1 goto failed

cd %influxdb_dir%services\graphite
go test -v
@if errorlevel 1 goto failed

cd %influxdb_dir%cmd\influx
go test -v
@if errorlevel 1 goto failed

cd %influxdb_dir%cmd\influxd\run
go test -v
@if errorlevel 1 goto failed

cd %influxdb_dir%cmd\influxd\restore
go test -v
@if errorlevel 1 goto failed

cd %influxdb_dir%cmd\influxd\backup
go test -v
@if errorlevel 1 goto failed
:test_ok


@if not defined is_build goto build_ok

:build
cd %influxdb_dir%cmd\influx
go build
@if errorlevel 1 goto failed

cd %influxdb_dir%cmd\influxd
go build
@if errorlevel 1 goto failed

:build_ok
@cd %influxdb_dir%
popd
@echo "====================================="
@echo "success!"
@goto :eof

:failed
@cd %influxdb_dir%
popd
@echo "====================================="
@date /T
@time /T
@echo "ooooooooo, failed!"
@exit /b -1


:help
@echo build.bat update test build
@echo Examples:
@echo   build.bat build test     : build and test
@echo   build.bat build          : only build
@echo   build.bat test           : only test
@echo   build.bat update         : update 3td library
@goto :eof