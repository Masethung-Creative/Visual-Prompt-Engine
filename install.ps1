<#
.SYNOPSIS
  visual-prompt-engine installer for Windows (PowerShell 5.1+ or PowerShell 7).

.EXAMPLE
  irm https://raw.githubusercontent.com/Masethung-Creative/Visual-Prompt-Engine/main/install.ps1 | iex

.EXAMPLE
  & ([scriptblock]::Create((irm https://raw.githubusercontent.com/Masethung-Creative/Visual-Prompt-Engine/main/install.ps1))) -Agent all

.EXAMPLE
  .\install.ps1 -Agent codex -Project

.EXAMPLE
  .\install.ps1 -Uninstall

.PARAMETER Agent
  claude | codex | copilot | all  (comma-separated, default: claude)

.PARAMETER Project
  Install into the current project folder instead of your user profile.

.PARAMETER Uninstall
  Remove the skill.
#>
[CmdletBinding()]
param(
  [string]$Agent = "claude",
  [switch]$Project,
  [switch]$Uninstall
)

$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$Repo   = if ($env:VPE_REPO)   { $env:VPE_REPO }   else { "Masethung-Creative/Visual-Prompt-Engine" }
$Branch = if ($env:VPE_BRANCH) { $env:VPE_BRANCH } else { "main" }
$Skill  = "visual-prompt-engine"
$SubPath = Join-Path "plugins\$Skill\skills" $Skill

function Write-Info($m) { Write-Host "==> $m" -ForegroundColor Cyan }
function Write-Ok($m)   { Write-Host " v  $m" -ForegroundColor Green }
# throw (not exit) so a failure under "irm | iex" does not close the user's PowerShell window
function Stop-WithError($m) { Write-Host " x  $m" -ForegroundColor Red; throw $m }

function Get-SkillsDir([string]$name) {
  $base = if ($Project) { (Get-Location).Path } else { $HOME }
  switch ($name) {
    "claude"  { return Join-Path $base ".claude\skills" }
    "codex"   { return Join-Path $base ".agents\skills" }
    "copilot" { if ($Project) { return Join-Path $base ".github\skills" } else { return Join-Path $base ".copilot\skills" } }
    default   { return $null }
  }
}

$agents = if ($Agent -eq "all") { @("claude", "codex", "copilot") } else { $Agent.Split(",") | ForEach-Object { $_.Trim().ToLower() } }

$src = $null
$tmp = $null
try {
  if (-not $Uninstall) {
    $here = if ($PSScriptRoot) { $PSScriptRoot } else { $null }
    if ($here -and (Test-Path (Join-Path $here "$SubPath\SKILL.md"))) {
      $src = Join-Path $here $SubPath
    } else {
      $tmp = Join-Path ([IO.Path]::GetTempPath()) ("vpe-" + [guid]::NewGuid())
      New-Item -ItemType Directory -Path $tmp | Out-Null
      $zip = Join-Path $tmp "repo.zip"
      Write-Info "Downloading $Repo@$Branch"
      try {
        Invoke-WebRequest -UseBasicParsing -Uri "https://codeload.github.com/$Repo/zip/refs/heads/$Branch" -OutFile $zip
      } catch {
        Stop-WithError "Download failed - check the repository name and your internet connection"
      }
      Expand-Archive -Path $zip -DestinationPath $tmp -Force
      $root = Get-ChildItem -Path $tmp -Directory | Select-Object -First 1
      $src = Join-Path $root.FullName $SubPath
      if (-not (Test-Path (Join-Path $src "SKILL.md"))) { Stop-WithError "SKILL.md not found in downloaded archive" }
    }
  }

  foreach ($a in $agents) {
    $dir = Get-SkillsDir $a
    if (-not $dir) { Stop-WithError "Unknown agent '$a' (use claude, codex, copilot or all)" }
    $target = Join-Path $dir $Skill
    if ($Uninstall) {
      if (Test-Path $target) { Remove-Item -Recurse -Force $target; Write-Ok "Removed from ${a}: $target" }
      else { Write-Info "Not installed for $a ($target)" }
    } else {
      New-Item -ItemType Directory -Force -Path $dir | Out-Null
      if (Test-Path $target) { Remove-Item -Recurse -Force $target }
      Copy-Item -Recurse -Path $src -Destination $target
      Write-Ok "Installed for ${a}: $target"
    }
  }

  if (-not $Uninstall) { Write-Info "Done. Restart your agent, then ask for a cinematic image or video prompt." }
}
finally {
  if ($tmp -and (Test-Path $tmp)) { Remove-Item -Recurse -Force $tmp }
}
