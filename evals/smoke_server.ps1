param(
    [int]$Port = 8793,
    [string]$BindHost = "127.0.0.1"
)

$ErrorActionPreference = "Stop"
$root = (Resolve-Path (Join-Path $PSScriptRoot "..\")).Path
$binary = Join-Path $root "target\release\openfab.exe"
$policy = Join-Path $root "policy\trust.json"
$repo = Join-Path ([System.IO.Path]::GetTempPath()) ("flowforge-server-smoke-" + $PID)
$proc = $null

if (-not (Test-Path -LiteralPath $binary)) {
    throw "Release binary not found at $binary. Run cargo build --release first."
}

try {
    [System.IO.Directory]::CreateDirectory($repo) | Out-Null
    $arguments = @("serve", "--repo", $repo, "--host", $BindHost, "--port", "$Port", "--policy", $policy)
    $proc = Start-Process -FilePath $binary -ArgumentList $arguments -WindowStyle Hidden -PassThru
    $base = "http://127.0.0.1:$Port"
    $paths = @("/health", "/", "/api/bases", "/api/forges")
    $responses = @{}

    foreach ($path in $paths) {
        $response = $null
        for ($attempt = 0; $attempt -lt 30; $attempt++) {
            if ($proc.HasExited) {
                throw "server exited before $path was reachable (exit code $($proc.ExitCode))"
            }
            try {
                $response = Invoke-WebRequest -UseBasicParsing ($base + $path)
                break
            } catch {
                Start-Sleep -Milliseconds 250
            }
        }
        if (-not $response -or $response.StatusCode -ne 200) {
            throw "expected HTTP 200 from $path"
        }
        $responses[$path] = $response
    }

    $health = $responses["/health"].Content | ConvertFrom-Json
    if ($health.status -ne "ok" -or $health.service -ne "flowforge") {
        throw "health payload did not report FlowForge as healthy"
    }
    if ($responses["/"].RawContentLength -lt 1000) {
        throw "root UI response was unexpectedly small"
    }
    Write-Output "SERVER_SMOKE_PASS: /health, /, /api/bases, and /api/forges returned HTTP 200"
}
finally {
    if ($proc -and -not $proc.HasExited) {
        Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
        $proc.WaitForExit()
    }
    if ([System.IO.Directory]::Exists($repo)) {
        foreach ($file in [System.IO.Directory]::GetFiles($repo, "*", [System.IO.SearchOption]::AllDirectories)) {
            [System.IO.File]::SetAttributes($file, [System.IO.FileAttributes]::Normal)
        }
        [System.IO.Directory]::Delete($repo, $true)
    }
}
