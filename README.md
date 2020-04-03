# Docker Configuration Files for DGE6

This is a complete example about how to deploy DocPath ® DocGeneration Engine 6 in Windows Server Core using Docker for Windows. The example must be completed with the following files in the same directory as the repositorized files:

- docgenerationpackv6-6.X.Y-java.jar: DocPath ® DocGeneration Engine 6 Installer.
- DocPath License File.lic: License file.
 
## Steps 
To successfully perform the example follow the steps as indicated below:
- Use the mcr.microsoft.com/windows/servercore:1909 image.
- Install OpenJDK 8.
- Install DocPath ® DocGeneration Engine 6.
- Copy the license file into the image.
- Use port 8084 to receive generation requests.
- Run the run1.ps file on the container entrypoint. run1.ps is performed as follows :
  - Starts the license server to allow DocPath ® DocGeneration Engine 6 execution.
  - Deploys DocPath ® DocGeneration Engine 6.

## Necessary changes
- Change the docgenerationpackv6-6.X.Y.-java.jar with the corresponding version of DocPath ® DocGeneration Engine 6.
- Change the DocPath_License_File.lic file with the corresponding license filename.
