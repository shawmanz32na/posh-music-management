# posh-music-management

PowerShell utilities for managing music

Holdouts that prefer to purchase their music rather than subscribe to a streaming service, be them DJs, audiophiles, or just plain stubborn, this library is for you. 

| Command | Description |
| --- | --- |
| Get-MusicMetaData | Retrieves a file's metadata as viewable by Windows, e.g artist, album, genre, length |
| Move-Music | Moves a file or directory to a "standardized" directory tree, e.g. <location>\<artist>\<album>\<song> |
| Find-DuplicateSongs | Locates duplicate songs in a directory tree |

## Usage

Before using any posh-music-management utility, it must be imported into the PowerShell session using `Import-Module`.


### Get-MusicMetaData

_**This utility is not yet built - the tool in place is just a placeholder**_

```
Import \path\to\posh-music-management\Get-MusicMetaData
Get-MusicMetaData -Path \path\to\music
```


### Move-Music

_**This utility is not yet built - the tool in place is just a placeholder**_

```
Import \path\to\posh-music-management\Move-Music
Move-Music -Path \path\to\music -Destination \path\to\organized\music
```


### Find-DuplicateSongs

```
Import \path\to\posh-music-management\Find-DuplicateSongs
Find-DuplicateSongs -Path \path\to\music -Recurse
```
e.g.:
```
C:\Users\Developer\Source\music-management> Find-DuplicateSongs -Path F: -Recurse

Song                                                                           Locations
----                                                                           --------- 
Black Loops - Sex (Bonus Track).mp3                                            {F:\Unsorted\Black Loops - Sex (Bonus Track).mp3, F:\Black Loops\Red Light - EP\Black Loops - Sex (Bonus Track).mp3}
Dusky - Cold Heart.mp3                                                         {F:\Dusky\Cold Heart EP\Dusky - Cold Heart.mp3, F:\Unsorted\Dusky - Cold Heart.mp3}
Subb-an - Self Control.mp3                                                     {F:\Unsorted\Subb-an - Self Control.mp3, F:\Subb-an\Self Control\Only Now\Subb-an - Self Control.mp3}
```


## Note from the author

This is **very much** a work-in-progress. These Functions are known to have bugs, but have allowed me to keep my music library somewhat manageable for the last few years.
