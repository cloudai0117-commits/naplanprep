@REM ----------------------------------------------------------------------------
@REM Licensed to the Apache Software Foundation (ASF) under one
@REM or more contributor license agreements.  See the NOTICE file
@REM distributed with this work for additional information
@REM regarding copyright ownership.  The ASF licenses this file
@REM to you under the Apache License, Version 2.0 (the
@REM "License"); you may not use this file except in compliance
@REM with the License.  You may obtain a copy of the License at
@REM
@REM    https://www.apache.org/licenses/LICENSE-2.0
@REM
@REM Unless required by applicable law or agreed to in writing,
@REM software distributed under the License is distributed on an
@REM "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
@REM KIND, either express or implied.  See the License for the
@REM specific language governing permissions and limitations
@REM under the License.
@REM ----------------------------------------------------------------------------

@REM ----------------------------------------------------------------------------
@REM Apache Maven Wrapper startup batch script, version 3.2.0
@REM ----------------------------------------------------------------------------

@IF "%__MVNW_ARG0_NAME__%"=="" (SET "BASE_DIR=%~dp0") ELSE (SET "BASE_DIR=%__MVNW_ARG0_NAME__%")
@SET "MAVEN_PROJECTBASEDIR=%BASE_DIR%"

@IF "%JAVA_HOME%"=="" (
    @SET "JAVACMD=java"
) ELSE (
    @SET "JAVACMD=%JAVA_HOME%\bin\java"
)

@SET "WRAPPER_PROPERTIES=%MAVEN_PROJECTBASEDIR%\.mvn\wrapper\maven-wrapper.properties"

@FOR /F "usebackq tokens=1,2 delims==" %%a IN ("%WRAPPER_PROPERTIES%") DO (
    @IF "%%a"=="distributionUrl" SET "DISTRIBUTION_URL=%%b"
)

@IF "%DISTRIBUTION_URL%"=="" (
    @ECHO No distributionUrl found in maven-wrapper.properties
    @EXIT /B 1
)

@FOR /F "tokens=* delims=" %%v IN ('echo %DISTRIBUTION_URL%') DO @SET "DISTRIBUTION_URL_CLEAN=%%v"

@SET "MAVEN_USER_HOME=%USERPROFILE%\.m2\wrapper"
@SET "MAVEN_HOME=%MAVEN_USER_HOME%\dists\apache-maven-3.9.6"

@IF NOT EXIST "%MAVEN_HOME%\bin\mvn.cmd" (
    @ECHO Downloading Apache Maven 3.9.6...
    @MD "%MAVEN_HOME%" 2>NUL
    @POWERSHELL -Command "Invoke-WebRequest -Uri '%DISTRIBUTION_URL%' -OutFile '%MAVEN_HOME%\maven.zip'"
    @POWERSHELL -Command "Expand-Archive -Path '%MAVEN_HOME%\maven.zip' -DestinationPath '%MAVEN_USER_HOME%\dists\' -Force"
    @DEL "%MAVEN_HOME%\maven.zip"
)

@"%MAVEN_HOME%\bin\mvn.cmd" %*
