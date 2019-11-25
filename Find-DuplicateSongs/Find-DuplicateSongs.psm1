Function Find-DuplicateSongs { 
  <# 
    .Synopsis
      Finds all files with the same file name
    .Description

    # .Example 
    #   Get-FileMetaData -folder "e:\music" 
    #   Gets file metadata for all files in the e:\music directory 
    # .Example 
    #   Get-FileMetaData -folder (gci e:\music -Recurse -Directory).FullName 
    #   This example uses the Get-ChildItem cmdlet to do a recursive lookup of  
    #   all directories in the e:\music folder and then it goes through and gets 
    #   all of the file metada for all the files in the directories and in the  
    #   subdirectories.   
    # .Parameter Path
    #   The directory to search for duplicate files
    # .Parameter Recurse
    # .Notes 
    #   NAME:  Get-FileMetaData 
    #   AUTHOR: ed wilson, msft 
    #   LASTEDIT: 01/24/2014 14:08:24 
    #   KEYWORDS: Storage, Files, Metadata 
    #   HSG: HSG-2-5-14 
    # .Link 
    #   Http://www.ScriptingGuys.com 
    #   #Requires -Version 2.0 
  #> 
  Param (
    [string[]] $Path,
    [Switch] $Recurse
  )
  Process {
    # Get the files in the current directory per the input parameters
    If ($Recurse.IsPresent) {
      $ChildItems = Get-ChildItem -Path $Path -File -Recurse
    } Else {
      $ChildItems = Get-ChildItem -Path $Path -File
    }
    # Find any duplicate files by comparing the file names
    $GroupedDuplicateSongs = $ChildItems | Group-Object -Property Name | Where-Object { $_.Count -gt 1 }
    # Convert the ouptut to the promised output
    $SongSelectConfig = @{label = "Song"; expression = { $_.Name } }
    $LocationsSelectConfig = @{label = "Locations"; expression = { $_.Group }}
    $DuplicateSongs = $GroupedDuplicateSongs | Select-Object $SongSelectConfig, $LocationsSelectConfig
    # And return them
    $DuplicateSongs
  }
}

Export-ModuleMember -Function Find-DuplicateSongs