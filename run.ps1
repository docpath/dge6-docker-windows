cd 'C:\DocPath\DocPath License Server\DocPath License Server\Bin'
start-process -NoNewWindow java.exe -ArgumentList '-jar','dplicenseserver.jar','-start'
start-sleep -s 3
cd 'C:\DocPath\DocGeneration Pack 6'
java.exe -jar dge.war
