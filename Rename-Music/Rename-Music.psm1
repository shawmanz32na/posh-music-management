# ----------------------------------------------------------------------------- 
# Script: Get-FileMetaDataReturnObject.ps1 
# Author: ed wilson, msft 
# Date: 01/24/2014 12:30:18 
# Keywords: Metadata, Storage, Files 
# comments: Uses the Shell.APplication object to get file metadata 
# Gets all the metadata and returns a custom PSObject 
# it is a bit slow right now, because I need to check all 266 fields 
# for each file, and then create a custom object and emit it. 
# If used, use a variable to store the returned objects before attempting 
# to do any sorting, filtering, and formatting of the output. 
# To do a recursive lookup of all metadata on all files, use this type 
# of syntax to call the function: 
# Get-FileMetaData -folder (gci e:\music -Recurse -Directory).FullName 
# note: this MUST point to a folder, and not to a file. 
# ----------------------------------------------------------------------------- 
Function Rename-Music {
    <# 
   .Synopsis 
    This function gets file metadata and returns it as a custom PS Object  
   .Description 
    This function gets file metadata using the Shell.Application object and 
    returns a custom PSObject object that can be sorted, filtered or otherwise 
    manipulated. 
   .Example 
    Get-FileMetaData -folder "e:\music" 
    Gets file metadata for all files in the e:\music directory 
   .Example 
    Get-FileMetaData -folder (gci e:\music -Recurse -Directory).FullName 
    This example uses the Get-ChildItem cmdlet to do a recursive lookup of  
    all directories in the e:\music folder and then it goes through and gets 
    all of the file metada for all the files in the directories and in the  
    subdirectories.   
   .Example 
    Get-FileMetaData -folder "c:\fso","E:\music\Big Boi" 
    Gets file metadata from files in both the c:\fso directory and the 
    e:\music\big boi directory. 
   .Example 
    $meta = Get-FileMetaData -folder "E:\music" 
    This example gets file metadata from all files in the root of the 
    e:\music directory and stores the returned custom objects in a $meta  
    variable for later processing and manipulation. 
   .Parameter Folder 
    The folder that is parsed for files  
   .Notes 
    NAME:  Get-FileMetaData 
    AUTHOR: ed wilson, msft 
    LASTEDIT: 01/24/2014 14:08:24 
    KEYWORDS: Storage, Files, Metadata 
    HSG: HSG-2-5-14 
   .Link 
     Http://www.ScriptingGuys.com 
 #Requires -Version 2.0 
 #> 
    Param(
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [Alias("Path")]
        [String[]]
        $FullName,

        [String]
        $Destination
    )
    Begin {
        [String[]]$WindowsFileNameReservedCharacters = '<','>',':','"','/','\','|','?','*'
    }
    Process {
        # TODO: Refactor this to a common library, since it's used in multiple places
        # If provided a directory, process all files in the directory (recursively)
        [System.IO.FileInfo[]]$Files = @()
        $Path = Get-Item $FullName
        If ($Path -Is [System.IO.DirectoryInfo]) {
            # We were given a directory
            # Find all the files in the directory and queue them for processing
            ForEach ($File in (Get-ChildItem -Path $Path -Recurse | Where-Object { $_ -Is [System.IO.FileInfo] })) {
                $Files += $File
            }
        }
        ElseIf ($Path -Is [System.IO.FileInfo]) {
            # We were given a file
            $Files += $Path
        }

        # If no $Destination was provided, use the $Path directory (or its parent directory if a file)
        If ($Destination -eq $null) {
            If ($Path -Is [System.IO.DirectoryInfo]) {
                $Destination = $Path.FullName
            } ElseIf ($Path -Is [System.IO.FileInfo]) {
                $Destination = $Path.Directory.FullName
            }
        }

        ForEach ($File in $Files) {
            $FileMetadata = Get-MusicMetadata $File

            # Eventually, we'll provide a way to specify a format. Until then, we'll standardize naming to `Artist(s) - Title`

            # Sanitize the metadata we'll use
            $ContributingArtists = $FileMetadata.'Contributing artists'.Split([IO.Path]::GetInvalidFileNameChars()) | ForEach-Object { $_.Trim() } | Join-String -Separator ' _ '
            $Title = $FileMetadata.Title.Split([IO.Path]::GetInvalidFileNameChars()) | ForEach-Object { $_.Trim() } | Join-String -Separator ' _ '
            $Extension = Split-Path -Path $FileMetadata.Path -Extension

            Rename-Item -Path $File -NewName (-Join (($ContributingArtists, $Title -Join " - "), $Extension))
        }
    }
}

Export-ModuleMember -Function Rename-Music