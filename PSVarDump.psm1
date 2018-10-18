function Show-Hex {
	[CmdletBinding()]
	Param(
		[Parameter(
			ValueFromPipeline = $True
			)]
		$Hex = 0
		)
	Process {
		Write-Output ("Hex (Int):  0x{0:x}" -f [Int64]$Hex)
	}
}

function Show-Number {
	[CmdletBinding()]
	Param(
		[Parameter(
			ValueFromPipeline = $True
			)]
		$Number = 0
		)
	Process {
		Write-Output ("Decimal:    {0:G}" -f $Number)
		Write-Output ("Scientific: {0:e}" -f $Number)
		Show-Hex $Number
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
		ForEach($Char in $CharArray) {
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

function Show-Array {
	[CmdletBinding()]
	Param(
		[Parameter(
			ValueFromPipeline = $True
			)]
		$Array,

		[Int]$Tabs = 0,
		[String]$Prefix = ""
		)
	Begin {
		$TabsString = "    "*$Tabs
	}

	Process {
		If($Array.Count -le 1) {
			Write-Output "(Input variable is not an array)"
			Break
		}

		For($i = 0; $i -lt $Array.Count; $i++) {
			Write-Output ( "$($TabsString)$Prefix[$i]: $($Array[$i]) ($($Array[$i].GetType().Name))" )
			If($Array[$i].Count -gt 1) {
				Show-Array ($Array[$i]) -Tabs ($Tabs + 1) -Prefix "[$i]"
			} Else {
				"`n$(Show-Variable $Array[$i] -Short)" | Write-Verbose
			}
		}
	}
}

function Show-Properties {
	[CmdletBinding()]
	Param(
		[Parameter(
			ValueFromPipeline = $True
			)]
		$Variable
		)
	Process {
		(Select-Object -InputObject $Variable -Property * | Out-String).Trim() | Write-Output
	}
}

function Test-Match {
	[CmdletBinding()]
	Param(
		$Match,

		[Parameter(
			ValueFromPipeline = $True
			)]
		$Array
	)

	Process {
		$Matched = $False
		$Array | ForEach-Object {
			If($_ -eq $Match) {
				$Matched = $True
			}
		}
		Return $Matched
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
		If( $Variable -eq $Null ) {
			Write-Output "Null"
		} ElseIf( $Variable.Count -eq 0) {
			Write-Output "Empty Array"
		} Else {
			$Variable = $Variable[0]
			$Type =  $Variable.GetType()
			Write-Output "Type: $($Type.Name)"
			If( ! $Short ) {
				$Type | Show-Properties | Write-Verbose
			}

			If(
				(@("UInt64", "UInt32", "UInt16", "Int32", "Int64", "Int16", "Short", "UShort", "SByte") |
				Test-Match $Type.Name) -eq $True
			) {
				Show-Number $Variable
			}
			ElseIf(
				("Byte" |
				Test-Match $Type.Name) -eq $True
			) {
				Show-Number $Variable
				Show-Char $Variable
			}
			ElseIf(
				(@("Single", "Float", "Double", "Long", "Decimal") |
				Test-Match $Type.Name) -eq $True
			) {
				Show-Number $Variable
			}
			ElseIf(
				("String" |
				Test-Match $Type.Name) -eq $True
			) {
				Show-String $Variable
			}
			#Arrays
			ElseIf(
				#(@("Hashtable", "Array", "Object[]", "ArrayList") |
				#Test-Match $Type.Name) -eq $True
				$Type.IsArray -eq $True
			) {
				Show-Array $Variable
			}
			ElseIf(
				("PSCustomObject" |
				Test-Match $Type.Name) -eq $True
			) {
				(Format-Table $Variable | Out-String).Trim() | Write-Output
			}
			#Misc
			ElseIf(
				("FileInfo" | Test-Match $Type.Name) -eq $True
			) {
				Show-FileInfo $Variable
			}
			ElseIf(
				("DirectoryInfo" | Test-Match $Type.Name) -eq $True
			) {
				($Variable | Out-String).Trim() | Write-Output
			}
			ElseIf(
				(@("MatchInfo", "RuntimeType") | Test-Match $Type.Name) -eq $True
			) {
				$Variable | Show-Properties
			}
			Else {
				Write-Output "No specific instructions found for this type."
				Try {
					Write-Output "`n`rTable:"
					(Format-Table $Variable | Out-String).Trim() | Write-Output
				} Catch {}
				Write-Output "`n`rOut-String:"
				($Variable | Out-String).Trim() | Write-Output
				Write-Output "`n`rProperties:"
				$Variable | Show-Properties
				Write-Output "`n`rStructure:"
				Show-Array $Variable
			}
			Show-Properties | Write-Verbose
		}
	}
}

New-Alias show Show-Variable -ErrorAction SilentlyContinue
