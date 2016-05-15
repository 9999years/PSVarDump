## PowerShell Variable Dump

Here’s the skinny of it: Pipe or pass anything into `Show-Variable` to get a detailed output. Mostly works, more features coming soon.
I’d *love* help developing this thing, feel free to send pull requests my way.

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
