FROM mcr.microsoft.com/windows/servercore:1909

# $ProgressPreference: https://github.com/PowerShell/PowerShell/issues/2138#issuecomment-251261324
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV JAVA_HOME C:\\ojdkbuild
RUN $newPath = ('{0}\bin;{1}' -f $env:JAVA_HOME, $env:PATH); \
	Write-Host ('Updating PATH: {0}' -f $newPath); \
# Nano Server does not have "[Environment]::SetEnvironmentVariable()"
	setx /M PATH $newPath;

# https://github.com/ojdkbuild/ojdkbuild/releases
ENV JAVA_VERSION 8u121
ENV JAVA_OJDKBUILD_VERSION 1.8.0.121-1
ENV JAVA_OJDKBUILD_ZIP java-1.8.0-openjdk-1.8.0.121-1.b13.ojdkbuild.windows.x86_64.zip
ENV JAVA_OJDKBUILD_SHA256 68476588b135a2ad9030567ab90368c36f5eb1f20bedffac9619bbcda5e3575b

RUN $url = ('https://github.com/ojdkbuild/ojdkbuild/releases/download/{0}/{1}' -f $env:JAVA_OJDKBUILD_VERSION, $env:JAVA_OJDKBUILD_ZIP); \
	Write-Host ('Downloading {0} ...' -f $url); \
	Invoke-WebRequest -Uri $url -OutFile 'ojdkbuild.zip'; \
	Write-Host ('Verifying sha256 ({0}) ...' -f $env:JAVA_OJDKBUILD_SHA256); \
	if ((Get-FileHash ojdkbuild.zip -Algorithm sha256).Hash -ne $env:JAVA_OJDKBUILD_SHA256) { \
		Write-Host 'FAILED!'; \
		exit 1; \
	}; \
	\
	Write-Host 'Expanding ...'; \
	Expand-Archive ojdkbuild.zip -DestinationPath C:\; \
	\
	Write-Host 'Renaming ...'; \
	Move-Item \
		-Path ('C:\{0}' -f ($env:JAVA_OJDKBUILD_ZIP -Replace '.zip$', '')) \
		-Destination $env:JAVA_HOME \
	; \
	\
	Write-Host 'Verifying install ...'; \
	Write-Host '  java -version'; java -version; \
	Write-Host '  javac -version'; javac -version; \
	\
	Write-Host 'Removing ...'; \
	Remove-Item ojdkbuild.zip -Force; \
	\
	Write-Host 'Install NanoServer with OpenJDK Complete.';


RUN mkdir C:/source
COPY docgenerationpackv6-6.29.1.0-java.jar C:/source/
WORKDIR C:/source
RUN java -jar docgenerationpackv6-6.29.1.0-java.jar -solname'DocPath DocGeneration Engine Pack v6' -install -solution'C:\DocPath\DocGeneration Pack 6' -silentmode -console -licserverpath'C:\DocPath\DocPath License Server' -licserverport1765
COPY DocPathDocGenerationEnginePack_TEMP_DOCPATH_20200401.lic C:/DocPath/Licenses/
COPY run.ps1 C:/DocPath/

EXPOSE 8084
WORKDIR C:/DocPath
ENTRYPOINT ["powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass", "C:\\DocPath\\run.ps1"]
