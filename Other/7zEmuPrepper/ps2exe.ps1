[CmdletBinding()]
param(
  [Parameter(Mandatory)] [string]$InputFile,
  [Parameter(Mandatory)] [string]$OutputFile,
  [string]$IconFile,
  [string]$Title,
  [string]$Description,
  [string]$Company,
  [string]$Product,
  [string]$Copyright,
  [string]$Trademark,
  [string]$Version = "1.0.0.0",
  [switch]$RequireAdmin,
  [switch]$NoConsole,
  [ValidateSet("AnyCpu","x86","x64")] [string]$Platform = "AnyCpu",
  [ValidateSet("MTA","STA")] [string]$Apartment = "MTA"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $InputFile -PathType Leaf)) { throw "Input file not found: $InputFile" }
$scriptText = Get-Content -LiteralPath $InputFile -Raw
$scriptB64  = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($scriptText))
$outPath    = [IO.Path]::GetFullPath($OutputFile)

$refAsm = @(
  "System.dll",
  "System.Core.dll",
  "System.Management.Automation.dll"
)

$win32res = $null
if ($IconFile) {
  if (-not (Test-Path $IconFile -PathType Leaf)) { throw "Icon file not found: $IconFile" }
}

$appType = $NoConsole.IsPresent ? "winexe" : "exe"
$uacManifest = if ($RequireAdmin) {
@"
<?xml version="1.0" encoding="utf-8"?>
<assembly manifestVersion="1.0" xmlns="urn:schemas-microsoft-com:asm.v1">
  <trustInfo xmlns="urn:schemas-microsoft-com:asm.v3">
    <security>
      <requestedPrivileges>
        <requestedExecutionLevel level="requireAdministrator" uiAccess="false" />
      </requestedPrivileges>
    </security>
  </trustInfo>
</assembly>
"@
} else { "" }

$assemblyAttrs = @"
using System;
using System.Reflection;
[assembly: AssemblyTitle("$Title")]
[assembly: AssemblyDescription("$Description")]
[assembly: AssemblyCompany("$Company")]
[assembly: AssemblyProduct("$Product")]
[assembly: AssemblyCopyright("$Copyright")]
[assembly: AssemblyTrademark("$Trademark")]
[assembly: AssemblyVersion("$Version")]
"@

$stub = @"
using System;
using System.Text;
using System.Management.Automation;
using System.Collections.ObjectModel;

class Entry {
  static int Main(string[] args) {
    var b64 = "$scriptB64";
    var script = Encoding.UTF8.GetString(Convert.FromBase64String(b64));
    using (var ps = PowerShell.Create()) {
      ps.AddScript(script);
      if (args.Length > 0) ps.AddArgument(args);
      Collection<PSObject> results = ps.Invoke();
      if (ps.Streams.Error.Count > 0) {
        foreach (var e in ps.Streams.Error) Console.Error.WriteLine(e.ToString());
        return 1;
      }
    }
    return 0;
  }
}
"@

$code = $assemblyAttrs + "`n" + $stub

$provider = New-Object Microsoft.CSharp.CSharpCodeProvider
$params = New-Object System.CodeDom.Compiler.CompilerParameters
$params.ReferencedAssemblies.AddRange($refAsm)
$params.GenerateExecutable = $true
$params.OutputAssembly = $outPath
$params.CompilerOptions = "/target:$appType /platform:$Platform"
if ($IconFile) { $params.CompilerOptions += " /win32icon:`"$IconFile`"" }
if ($uacManifest) {
  $manifestPath = [IO.Path]::GetTempFileName()
  Set-Content -LiteralPath $manifestPath -Value $uacManifest -Encoding ASCII
  $params.CompilerOptions += " /win32manifest:`"$manifestPath`""
}
$result = $provider.CompileAssemblyFromSource($params, $code)

if ($uacManifest) { Remove-Item -LiteralPath $manifestPath -ErrorAction SilentlyContinue }

if ($result.Errors.Count) {
  $result.Errors | ForEach-Object { Write-Error $_.ToString() }
  throw "Compilation failed."
}

Write-Host "Built: $outPath ($Platform, $(if($NoConsole){"WinExe"}else{"Console"}))"
if ($IconFile) { Write-Host "Icon: $IconFile" }
if ($RequireAdmin) { Write-Host "UAC: requireAdministrator" }
