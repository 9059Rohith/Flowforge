param(
    [ValidateSet("repetitive-request-triage", "temperature-converter")]
    [string]$FixtureName = "repetitive-request-triage",
    [string]$Policy = "policy/trust.json"
)

$ErrorActionPreference = "Stop"
$root = (Resolve-Path (Join-Path $PSScriptRoot "..\")).Path
$binary = Join-Path $root "target\release\openfab.exe"
$fixture = Join-Path $root ("evals\fixtures\" + $FixtureName)
$work = Join-Path ([System.IO.Path]::GetTempPath()) ("flowforge-offline-fixture-" + $FixtureName + "-" + $PID)
$locationPushed = $false

if (-not (Test-Path -LiteralPath $binary)) {
    throw "Release binary not found at $binary. Run cargo build --release first."
}
if (-not (Test-Path -LiteralPath $fixture)) {
    throw "Unknown offline fixture at $fixture."
}

try {
    Copy-Item -LiteralPath $fixture -Destination $work -Recurse
    Push-Location $work
    $locationPushed = $true
    & git init -q
    & git config user.email "fixture@flowforge.local"
    & git config user.name "FlowForge offline fixture"
    & git add -A
    & git commit -qm "offline fixture source"
    $spec = Join-Path $work "spec.yaml"
    & $binary attest --spec $spec --repo $work --gate none --policy (Join-Path $root $Policy)
    if ($LASTEXITCODE -ne 0) { throw "offline attestation failed" }

    $attestation = Get-ChildItem -LiteralPath (Join-Path $work "provenance") -Filter "*.att.json" | Select-Object -First 1
    if (-not $attestation) { throw "offline attestation did not produce a signed attestation" }
    & $binary verify-file --repo $work --att (Join-Path $work (Join-Path "provenance" $attestation.Name)) --policy (Join-Path $root $Policy)
    if ($LASTEXITCODE -ne 0) { throw "offline forge-agnostic verification failed" }
    Write-Output "OFFLINE_FIXTURE_PASS: $FixtureName acceptance, signed provenance, and verify-file passed"
}
finally {
    if ($locationPushed) {
        Pop-Location
    }
    if (Test-Path -LiteralPath $work) {
        foreach ($file in [System.IO.Directory]::GetFiles($work, "*", [System.IO.SearchOption]::AllDirectories)) {
            [System.IO.File]::SetAttributes($file, [System.IO.FileAttributes]::Normal)
        }
        [System.IO.Directory]::Delete($work, $true)
    }
}
