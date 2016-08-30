# PSVarDump: PowerShell Variable Dump

PSVarDump provides verbose output of the exact contents of a variable.

## Why?

Sometimes PowerShell is too opaque when outputting variables. For example, the
output of

```
PS>@(1,2,@(3,4),@(5,6,[Decimal]7))
1
2
3
4
5
6
7
```

might lead you to believe there’s a plain 7-element array of ints (when `7` is
actually a 128-bit `Decimal`), but on further inspection:

```
PS>@(1,2,@(3,4),@(5,6,[Decimal]7)).Count
4
```

it only has *four* elements, and what’s more, the third element contains
*three* numbers:

```
PS>@(1,2,@(3,4),@(5,6,[Decimal]7))[3]
5
6
7
```

Generally, when you’re reading output, it’s good to have structure stripped
away, for aesthetic purposes.
However, when you’re debugging a script, it can get infuriating fast.

PSVarDump makes that a lot easier.

```
PS>Show-Variable @(1,2,@(3,4),@(5,6,[Decimal]7))
IsPublic IsSerial Name                                     BaseType
-------- -------- ----                                     --------
True     True     Object[]                                 System.Array
Decimal: 1

Count:   4
[0]: 1 (Int32)
[1]: 2 (Int32)
[2]: 3 4 (Object[])
    Count:   2
    [0]: 3 (Int32)
    [1]: 4 (Int32)
[3]: 5 6 7 (Object[])
    Count:   3
    [0]: 5 (Int32)
    [1]: 6 (Int32)
    [2]: 7 (Decimal)
```

##Usage

Pipe or pass anything into `Show-Variable` to get a detailed output.

I recommend adding `New-Alias show Show-Variable` to your PowerShell profile
for brevity’s sake.

Types with specific instructions currently include the following:

(Note that some non-specific output will be made even if the variable doesn’t
match any of these types, although it may feature duplicate information.)

* Integers: `UInt64`, `UInt32`, `UInt16`, `Int32`, `Int64`, `Int16`, `Short`,
  `UShort`, `Byte`, and `SByte`
* Floats: `Single`, `Float`, `Double`, `Long`, and `Decimal`
* Arrays: `PSCustomObject`, `Hashtable`, `Array`, `Object[]`, and `ArrayList`,
* Misc: `String`, `FileInfo`, `DirectoryInfo`, and `MatchInfo`

Don’t see a type you commonly work with there? Open an issue or send a pull
request!

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
