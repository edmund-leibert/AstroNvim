# Get the name of the current folder and store it as a string; not the full path
$nvimConfigProfile = Get-Location
$nvimConfigProfile = Split-Path $nvimConfigProfile -Leaf

Write-Host "Running the script: $($MyInvocation.MyCommand.Name)"

# Delete all files currently in the relevant nvims config folder
Remove-Item -Path "C:\\Users\\edmun\\AppData\\Local\\nvims\\$($nvimConfigProfile)\\*" -Recurse -Force

# Get the current directory
$currentDirectory = Get-Location

# Create a directory in the nvims folder called $nvimConfigProfile, if the folder does not exist
New-Item -ItemType Directory -Path "C:\\Users\\edmun\\AppData\\Local\\nvims\\$($nvimConfigProfile)"

# Get all items in the current folder
$CONFIG_ITEMS = Get-ChildItem -Path *

foreach ($CONFIG_ITEM in $CONFIG_ITEMS) {


	# If object is the file init.lua, create a symbolic link
	if($CONFIG_ITEM.Name -eq "init.lua") {
		Write-Host "Creating a symbolic for the following files... $($CONFIG_ITEM.name)"
		Write-Host "C:\\Users\\edmun\\AppData\\Local\\nvims\\$($nvimConfigProfile)\\$($CONFIG_ITEM.name)"
		New-Item -ItemType SymbolicLink -Path "C:\\Users\\edmun\\AppData\\Local\\nvims\\$($nvimConfigProfile)\\$($CONFIG_ITEM.name)" -Target "$($currentDirectory.Path)\\$($CONFIG_ITEM.name)"
	}
	# If object is a folder and the name is lua, create a symbolic link
	if($CONFIG_ITEM.PSIsContainer -AND $CONFIG_ITEM.Name -eq "lua") {
		Write-Host "Creating a symbolic for the following files... $($CONFIG_ITEM.name)"
		New-Item -ItemType Junction -Path "C:\\Users\\edmun\\AppData\\Local\\nvims\\$($nvimConfigProfile)\\$($CONFIG_ITEM.name)" -Target "$($currentDirectory.Path)\\$($CONFIG_ITEM.name)"
	}
}
