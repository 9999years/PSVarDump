## PowerShell Variable Dump

Pipe or pass anything into `Show-Variable` to get a detailed output.

I recommend adding `New-Alias show Show-Variable` to your PowerShell profile for brevity’s sake.

Currently supported types are:

* Integers: `UInt64`, `UInt32`, `UInt16`, `Int32`, `Int64`, `Int16`, `Short`, `UShort`, `Byte`, and `SByte`
* Floats: `Single`, `Float`, `Double`, `Long`, and `Decimal`
* Arrays: `PSCustomObject`, `Hashtable`, `Array`, `Object[]`, and `ArrayList`,
* Misc: `String`, `FileInfo`, `DirectoryInfo`, and `MatchInfo`

Additionally, when a type isn’t recognized, some default instructions exist (namely, passing through `Out-String`, `Format-Table`, and `Select-Object -Property *`).

Don’t see a type you commonly work with there? Open an issue or send a pull request!

Examples:
```
PS>Show-Variable 12485
IsPublic IsSerial Name                                     BaseType
-------- -------- ----                                     --------
True     True     Int32                                    System.ValueType
Decimal: 12485
Hex:     0x30c5
```

```
PS>Show-Variable "hey…" -Verbose
IsPublic IsSerial Name                                     BaseType
-------- -------- ----                                     --------
True     True     String                                   System.Object
Length:  4
String: `hey…`
VERBOSE: Char:    `h` = 0x68
VERBOSE: Char:    `e` = 0x65
VERBOSE: Char:    `y` = 0x79
VERBOSE: Char:    `…` = 0x2026
VERBOSE: Length
------
     4
```

```
PS>(Get-Content var-dump.psm1 | sls "Write-Verbose")[0] | Show-Variable
IsPublic IsSerial Name                                     BaseType
-------- -------- ----                                     --------
True     False    MatchInfo                                System.Object
IgnoreCase : True
LineNumber : 54
Line       :                    Show-Char $Char | Write-Verbose
Filename   : InputStream
Path       : InputStream
Pattern    : Write-Verbose
Context    :
Matches    : {Write-Verbose}
```

```
PS>(Get-ChildItem)[0] | Show-Variable -Verbose
IsPublic IsSerial Name                                     BaseType
-------- -------- ----                                     --------
True     True     FileInfo                                 System.IO.FileSystemInfo
C:\Users\xyz\Documents\Powershell Modules\var-dump\.gitignore
VERBOSE: PSPath            :
Microsoft.PowerShell.Core\FileSystem::C:\Users\xyz\Documents\Powershell
                    Modules\var-dump\.gitignore
PSParentPath      : Microsoft.PowerShell.Core\FileSystem::C:\Users\xyz\Documents\Powershell

                    Modules\var-dump
PSChildName       : .gitignore
PSDrive           : C
PSProvider        : Microsoft.PowerShell.Core\FileSystem
PSIsContainer     : False
Mode              : -a----
VersionInfo       : File:             C:\Users\xyz\Documents\Powershell
                    Modules\var-dump\.gitignore
                    InternalName:
                    OriginalFilename:
                    FileVersion:
                    FileDescription:
                    Product:
                    ProductVersion:
                    Debug:            False
                    Patched:          False
                    PreRelease:       False
                    PrivateBuild:     False
                    SpecialBuild:     False
                    Language:

BaseName          :
Target            : {}
LinkType          :
Name              : .gitignore
Length            : 17
DirectoryName     : C:\Users\xyz\Documents\Powershell Modules\var-dump
Directory         : C:\Users\xyz\Documents\Powershell Modules\var-dump
IsReadOnly        : False
Exists            : True
FullName          : C:\Users\xyz\Documents\Powershell Modules\var-dump\.gitignore
Extension         : .gitignore
CreationTime      : 5/13/2016 9:51:43 PM
CreationTimeUtc   : 5/14/2016 1:51:43 AM
LastAccessTime    : 5/13/2016 9:51:43 PM
LastAccessTimeUtc : 5/14/2016 1:51:43 AM
LastWriteTime     : 5/13/2016 9:51:43 PM
LastWriteTimeUtc  : 5/14/2016 1:51:43 AM
Attributes        : Archive
```
