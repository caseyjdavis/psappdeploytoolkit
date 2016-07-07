<#
.SYNOPSIS
	This script performs the installation or uninstallation of an application(s).
.DESCRIPTION
	The script is provided as a template to perform an install or uninstall of an application(s).
	The script either performs an "Install" deployment type or an "Uninstall" deployment type.
	The install deployment type is broken down into 3 main sections/phases: Pre-Install, Install, and Post-Install.
	The script dot-sources the AppDeployToolkitMain.ps1 script which contains the logic and functions required to install or uninstall an application.
.PARAMETER DeploymentType
	The type of deployment to perform. Default is: Install.
.PARAMETER DeployMode
	Specifies whether the installation should be run in Interactive, Silent, or NonInteractive mode. Default is: Interactive. Options: Interactive = Shows dialogs, Silent = No dialogs, NonInteractive = Very silent, i.e. no blocking apps. NonInteractive mode is automatically set if it is detected that the process is not user interactive.
.PARAMETER AllowRebootPassThru
	Allows the 3010 return code (requires restart) to be passed back to the parent process (e.g. SCCM) if detected from an installation. If 3010 is passed back to SCCM, a reboot prompt will be triggered.
.PARAMETER TerminalServerMode
	Changes to "user install mode" and back to "user execute mode" for installing/uninstalling applications for Remote Destkop Session Hosts/Citrix servers.
.PARAMETER DisableLogging
	Disables logging to file for the script. Default is: $false.
.EXAMPLE
    powershell.exe -Command "& { & '.\Deploy-Application.ps1' -DeployMode 'Silent'; Exit $LastExitCode }"
.EXAMPLE
    powershell.exe -Command "& { & '.\Deploy-Application.ps1' -AllowRebootPassThru; Exit $LastExitCode }"
.EXAMPLE
    powershell.exe -Command "& { & '.\Deploy-Application.ps1' -DeploymentType 'Uninstall'; Exit $LastExitCode }"
.EXAMPLE
    Deploy-Application.exe -DeploymentType "Install" -DeployMode "Silent"
.NOTES
	Toolkit Exit Code Ranges:
	60000 - 68999: Reserved for built-in exit codes in Deploy-Application.ps1, Deploy-Application.exe, and AppDeployToolkitMain.ps1
	69000 - 69999: Recommended for user customized exit codes in Deploy-Application.ps1
	70000 - 79999: Recommended for user customized exit codes in AppDeployToolkitExtensions.ps1
.LINK 
	http://psappdeploytoolkit.com
#>
[CmdletBinding()]
Param (
	[Parameter(Mandatory=$false)]
	[ValidateSet('Install','Uninstall')]
	[string]$DeploymentType = 'Install',
	[Parameter(Mandatory=$false)]
	[ValidateSet('Interactive','Silent','NonInteractive')]
	[string]$DeployMode = 'Interactive',
	[Parameter(Mandatory=$false)]
	[switch]$AllowRebootPassThru = $false,
	[Parameter(Mandatory=$false)]
	[switch]$TerminalServerMode = $false,
	[Parameter(Mandatory=$false)]
	[switch]$DisableLogging = $false
)

Try {
	## Set the script execution policy for this process
	Try { Set-ExecutionPolicy -ExecutionPolicy 'ByPass' -Scope 'Process' -Force -ErrorAction 'Stop' } Catch {}
	
	##*===============================================
	##* VARIABLE DECLARATION
	##*===============================================
	## Variables: Application PLEASE FILL OUT EACH VALUE
	[string]$appVendor = 'Oracle'
	[string]$appName = 'Java'
	[string]$appVersion = '1.8.0_91'
	[string]$appArch = 'x86x64'
	[string]$appLang = 'EN'
	[string]$appRevision = '01'
	[string]$appScriptVersion = '1.0.0'
	[string]$appScriptDate = '7/7/2016'
	[string]$appScriptAuthor = 'Casey Davis'
	##*===============================================
	## Variables: Install Titles (Only set here to override defaults set by the toolkit)
	[string]$installName = ''
	[string]$installTitle = ''
	
	##* Do not modify section below
	#region DoNotModify
	
	## Variables: Exit Code
	[int32]$mainExitCode = 0
	
	## Variables: Script
	[string]$deployAppScriptFriendlyName = 'Deploy Application'
	[version]$deployAppScriptVersion = [version]'3.6.8'
	[string]$deployAppScriptDate = '02/06/2016'
	[hashtable]$deployAppScriptParameters = $psBoundParameters
	
	## Variables: Environment
	If (Test-Path -LiteralPath 'variable:HostInvocation') { $InvocationInfo = $HostInvocation } Else { $InvocationInfo = $MyInvocation }
	[string]$scriptDirectory = Split-Path -Path $InvocationInfo.MyCommand.Definition -Parent
	
	## Dot source the required App Deploy Toolkit Functions
	Try {
		[string]$moduleAppDeployToolkitMain = "$scriptDirectory\AppDeployToolkit\AppDeployToolkitMain.ps1"
		If (-not (Test-Path -LiteralPath $moduleAppDeployToolkitMain -PathType 'Leaf')) { Throw "Module does not exist at the specified location [$moduleAppDeployToolkitMain]." }
		If ($DisableLogging) { . $moduleAppDeployToolkitMain -DisableLogging } Else { . $moduleAppDeployToolkitMain }
	}
	Catch {
		If ($mainExitCode -eq 0){ [int32]$mainExitCode = 60008 }
		Write-Error -Message "Module [$moduleAppDeployToolkitMain] failed to load: `n$($_.Exception.Message)`n `n$($_.InvocationInfo.PositionMessage)" -ErrorAction 'Continue'
		## Exit the script, returning the exit code to SCCM
		If (Test-Path -LiteralPath 'variable:HostInvocation') { $script:ExitCode = $mainExitCode; Exit } Else { Exit $mainExitCode }
	}
	
	#endregion
	##* Do not modify section above
	##*===============================================
	##* END VARIABLE DECLARATION
	##*===============================================
		
	If ($deploymentType -ine 'Uninstall') {
		##*===============================================
		##* PRE-INSTALLATION
		##*===============================================
		[string]$installPhase = 'Pre-Installation'
		
		## Show Welcome Message, closes the specified app if required, allow up to 3 deferrals, verify there is enough disk space to complete the install, and persist the prompt
		Show-InstallationWelcome -CloseApps 'jqs,iexplore,firefox' -Silent
		
		## Show Progress Message (with the default message)
		Show-InstallationProgress
		
		## <Perform Pre-Installation tasks here>
		
        


		
		##*===============================================
		##* INSTALLATION 
		##*===============================================
		[string]$installPhase = 'Installation'
		
		## Handle Zero-Config MSI Installations
		If ($useDefaultMsi) {
			[hashtable]$ExecuteDefaultMSISplat =  @{ Action = 'Install'; Path = $defaultMsiFile }; If ($defaultMstFile) { $ExecuteDefaultMSISplat.Add('Transform', $defaultMstFile) }
			Execute-MSI @ExecuteDefaultMSISplat; If ($defaultMspFiles) { $defaultMspFiles | ForEach-Object { Execute-MSI -Action 'Patch' -Path $_ } }
		}
		
		## <Perform Installation tasks here>
		
        ## Installs the MSI file using the *.msi located in the Files directory
        Show-InstallationProgress -StatusMessage "Installing $appVendor $appName $appVersion ..."
        Write-Log -Message "Installing $appVendor $appName $appVersion ..."
        Execute-MSI -Action Install -Path 'jre1.8.0_91\jre1.8.0_91.msi' -AddParameters 'JU=0 JAVAUPDATE=0 AUTOUPDATECHECK=0 RebootYesNo=No WEB_JAVA=1 /q'

        #// Repeat as necessary
        ## Installs the MSI file using the *.msi located in the Files directory
        Show-InstallationProgress -StatusMessage "Installing $appVendor $appName $appVersion ..."
        Write-Log -Message "Installing $appVendor $appName $appVersion ..."
        Execute-MSI -Action Install -Path 'jre1.8.0_91_x64\jre1.8.0_91.msi' -AddParameters 'JU=0 JAVAUPDATE=0 AUTOUPDATECHECK=0 RebootYesNo=No WEB_JAVA=1 /q'	    

		##*===============================================
		##* POST-INSTALLATION
		##*===============================================
		[string]$installPhase = 'Post-Installation'
		
		## <Perform Post-Installation tasks here>
        
        # Insert any post-install steps here (delete a desktop shortcut or copy item to startup etc.
        # Set registry key to disable automatic updating of Java 8
        If (!(Test-RegistryValue -Key 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Value 'SunJavaUpdateSched' -Verbose)){
                      Remove-RegistryKey -Key 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name 'SunJavaUpdateSched'; Write-Log "Removed Java 8 Registry Key to Disable Autoupdate" }

        # Unregisters the Java Quick Starter
        If (Test-Path "$env:ProgramFiles\Java\jre1.8.0_91\bin\jqs.exe") {Execute-Process "$env:ProgramFiles\Java\jre1.8.0_91\bin\jqs.exe" -Parameters '-unregister'}

        # Unregisters the Java Quick Starter
        If (Test-Path "$env:ProgramFiles(x86)\Java\jre1.8.0_91\bin\jqs.exe") {Execute-Process "$env:ProgramFiles(x86)\Java\jre1.8.0_91\bin\jqs.exe" -Parameters '-unregister'}
        
        # Sets a custom registry value to indicate that this application was installed using the psappdeploytoolkit
        If (!(Test-RegistryValue -Key 'HKLM:\SOFTWARE\Poudre School District\Applications' -Value $appName $appVersion -Verbose)){
              Set-RegistryKey -Key 'HKLM:\SOFTWARE\Poudre School District\Applications' -Value $appVersion $appName -Type String; Write-Log "Added $appname $appVersion to Registry branding" }		

		## Display a message at the end of the install
		If (-not $useDefaultMsi) { Show-InstallationPrompt -Message "$Appname has been installed successfully. Please reboot your system to continue.  If you have problems or questions about this software, please call the PSD Help Desk at x3456 or open a Help Desk ticket at help.psdschools.org" -ButtonRightText 'OK' -Icon Information -NoWait }
	    }
	        ElseIf ($deploymentType -ieq 'Uninstall')
	    {

		##*===============================================
		##* PRE-UNINSTALLATION
		##*===============================================
		[string]$installPhase = 'Pre-Uninstallation'
		
		## Show Welcome Message, close MMC with a 60 second countdown before automatically closing
		Show-InstallationWelcome -CloseApps 'jqs,iexplore,firefox' -CloseAppsCountdown 60 #// Specify the process name of any app or apps (seperated by a comma) that you would like to be closed before this app is uninstalled
		
        ## Show Progress Message (with the default message)
		Show-InstallationProgress #//Custom messgae if desired
		
		## <Perform Pre-Uninstallation tasks here>





		##*===============================================
		##* UNINSTALLATION
		##*===============================================
		[string]$installPhase = 'Uninstallation'
		
		## Handle Zero-Config MSI Uninstallations
		If ($useDefaultMsi) {
			[hashtable]$ExecuteDefaultMSISplat =  @{ Action = 'Uninstall'; Path = $defaultMsiFile }; If ($defaultMstFile) { $ExecuteDefaultMSISplat.Add('Transform', $defaultMstFile) }
			Execute-MSI @ExecuteDefaultMSISplat
		}
		
		# <Perform Uninstallation tasks here>
		




        ## Uninstalls the MSI file using the *.msi located in the Files directory
        Show-InstallationProgress -StatusMessage "Uninstalling $appVendor $appName $appVersion ..."
        Write-Log -Message "Uninstalling $appVendor $appName $appVersion ..."
        Execute-MSI -Action Uninstall -Path 'jre1.8.0_91_x64\jre1.8.0_91.msi'

        ## Uninstalls the MSI file using the *.msi located in the Files directory
        Show-InstallationProgress -StatusMessage "Uninstalling $appVendor $appName $appVersion ..."
        Write-Log -Message "Uninstalling $appVendor $appName $appVersion ..."
        Execute-MSI -Action Uninstall -Path 'jre1.8.0_91\jre1.8.0_91.msi'

		##*===============================================
		##* POST-UNINSTALLATION
		##*===============================================
		[string]$installPhase = 'Post-Uninstallation'
		
		## <Perform Post-Uninstallation tasks here>





        ## Removes the custom registry key value if it exists from the registry
		If (Test-RegistryValue -Key 'HKLM:\SOFTWARE\Poudre School District\Applications' -Value $appName $appVersion -Verbose) {
            Remove-RegistryKey -Key 'HKLM:\SOFTWARE\Poudre School District\Applications' -Name $appName; Write-Log "Removed $appname from Registry branding"}
		
	    }
	
	##*===============================================
	##* END SCRIPT BODY
	##*===============================================
	
	## Call the Exit-Script function to perform final cleanup operations
	Exit-Script -ExitCode $mainExitCode
}
Catch {
	[int32]$mainExitCode = 60001
	[string]$mainErrorMessage = "$(Resolve-Error)"
	Write-Log -Message $mainErrorMessage -Severity 3 -Source $deployAppScriptFriendlyName
	Show-DialogBox -Text $mainErrorMessage -Icon 'Stop'
	Exit-Script -ExitCode $mainExitCode
}