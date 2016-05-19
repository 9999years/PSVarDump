function Show-Hex {
	[CmdletBinding()]
	Param(
		[Parameter(
			ValueFromPipeline = $True
			)]
		$Hex = 0
		)
	Process {
		Write-Output ("Hex:     0x{0:x}" -f [Int64]$Hex)
	}
}

function Show-Int {
	[CmdletBinding()]
	Param(
		[Parameter(
			ValueFromPipeline = $True
			)]
		$Int = 0
		)
	Process {
		Write-Output ("Decimal: {0:G}`n`r$(Show-Hex $Int)" -f $Int)
	}
}

function Show-Char {
	[CmdletBinding()]
	Param(
		[Parameter(
			ValueFromPipeline = $True
			)]
		$Char = [char]0x00
		)
	Process {
		Write-Output ("Char:    ``$([char]$Char)`` = 0x{0:x}" -f ([Int]$Char))
	}
}

function Show-String {
	[CmdletBinding()]
	Param(
		[Parameter(
			ValueFromPipeline = $True
			)]
		$String
		)
	Process {
		Write-Output "Length:  $($String.Length)"
		Write-Output "String: ``$($String)``"
		$CharArray = $String.toCharArray()
		ForEach($Char in $CharArray)
		{
			Show-Char $Char | Write-Verbose
		}
	}
}

function Show-FileInfo {
	[CmdletBinding()]
	Param(
		[Parameter(
			ValueFromPipeline = $True
			)]
		$Files
		)
	Process {
		($Files | Format-Table -HideTableHeaders -Property FullName | Out-String).Trim() | Write-Output
	}
}

function Show-ArrayStructure {
	[CmdletBinding()]
	Param(
		[Parameter(
			ValueFromPipeline = $True
			)]
		$Array,

		[Int]$Tabs = 0
		)
	Begin {
		$TabsString = ""
		For($i = 0; $i -lt $Tabs; $i++) {
			$TabsString += "  "
		}
	}

	Process {
		Write-Output "$($TabsString)Count:   $($Array.Count)"
		$i = 0
		ForEach($Key in $Array)
		{
			Write-Output ( "$($TabsString)[$i]: $($Key.GetType().Name)" )
			If($Key.Count -gt 1)
			{
				Show-ArrayStructure ($Key) -Tabs ($Tabs + 1)
			}
			$i += 1
		}
	}
}

function Show-Array {
	[CmdletBinding()]
	Param(
		[Parameter(
			ValueFromPipeline = $True
			)]
		$Array
		)
	Begin{
		$i = 0
	}

	Process {
		Write-Output "Count:   $($Variable.Count)"
		ForEach($Key in $Array)
		{
			Write-Output ( "`n`r[$i]:" )
			Show-Variable $Key -Short
			$i += 1
		}
	}
}

function Show-Variable {
	[CmdletBinding()]
	Param(
		[Parameter(
			Mandatory = $True,
			ValueFromPipeline = $True,
			ValueFromRemainingArguments = $True
			)]
		[AllowNull()]
		#[AllowEmptyString()]
		#[AllowEmptyCollection()]
		$Variable,

		[Switch]$Short
		)
	Process {
		$Variable = $Variable[0]
		If( $Variable -eq $Null )
		{
			Write-Output "Null"
		}
		Else
		{
			$Type =  $Variable.GetType()
			If( $Short -and ! $Verbose )
			{
				Write-Output ($Type.Name)
			}
			Else
			{
				($Type | Format-Table | Out-String).Trim() | Write-Output
			}

			Switch( $Type.Name )
			{

				#Int values:
				"UInt64" { Show-Int $Variable }
				"UInt32" { Show-Int $Variable }
				"UInt16" { Show-Int $Variable }
				"Int32" { Show-Int $Variable }
				"Int64" { Show-Int $Variable }
				"Int16" { Show-Int $Variable }
				"Short" { Show-Int $Variable }
				"UShort" { Show-Int $Variable }
				"Byte" { Show-Int $Variable
						Show-Char $Variable }
				"SByte" { Show-Int $Variable }

				#Float values:
				"Single" { Show-Float $Variable }
				"Float" { Show-Float $Variable }
				"Double" { Show-Float $Variable }
				"Long" { Show-Float $Variable }
				"Decimal" { Show-Float $Variable }

				"String" { Show-String $Variable }

				#Arrays
				"PSCustomObject" { (Format-Table $Variable | Out-String).Trim() | Write-Output }
				"Hashtable" { Show-Array $Variable }
				"Array" { Show-Array $Variable }
				"Object[]" { Show-Array $Variable }
				"ArrayList" { Show-Array $Variable }

				#Misc
				"FileInfo" { Show-FileInfo $Variable }
				"DirectoryInfo" { ($Variable | Out-String).Trim() | Write-Output }

				default {
						Write-Output "No specific instructions found."
						try
						{
							Write-Output "`n`rTable:"
							(Format-Table $Variable | Out-String).Trim() | Write-Output
						} catch {}
						Write-Output "`n`rOut-String:"
						($Variable | Out-String).Trim() | Write-Output
					}
			}
			(Select-Object -InputObject $Variable -Property * | Out-String).Trim() | Write-Verbose
		}
	}
}

New-Alias show Show-Variable
