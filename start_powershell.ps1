function Show-Models {
    $models = Get-ChildItem "$PSScriptRoot\models" -Filter *.gguf | Select-Object -ExpandProperty Name
    if ($models.Count -eq 0) {
        Write-Host "No GGUF models found in $PSScriptRoot\models!"
        exit
    }
    Write-Host "`nAvailable models:"
    for ($i=0; $i -lt $models.Count; $i++) {
        Write-Host "$($i+1). $($models[$i])"
    }
    return $models
}

function Detect-GpuLayers {
    $memfree = nvidia-smi --query-gpu=memory.free --format=csv,nounits | Select-Object -Skip 1
    Write-Host "Detected Free GPU Memory = $memfree MiB"
    $nlayers = 0
    if ($memfree -ge 6000) {
        $nlayers = 40
    } elseif ($memfree -ge 4000) {
        $nlayers = 20
    }
    Write-Host "Using --n-gpu-layers $nlayers"
    return $nlayers
}

while ($true) {
    $models = Show-Models
    $choice = Read-Host "Enter model number (or q to quit)"
    if ($choice -eq "q") { break }

    if ($choice -match '^\d+$' -and [int]$choice -ge 1 -and [int]$choice -le $models.Count) {
        $model = $models[$choice-1]
        Write-Host "`nSelected model: $model"

        $nlayers = Detect-GpuLayers

        $exePath = "$PSScriptRoot\build\bin\Release\llama-server.exe"
        $modelPath = "$PSScriptRoot\models\$model"

        Write-Host "`nStarting llama-server..."
        & $exePath -m $modelPath --n-gpu-layers $nlayers
    } else {
        Write-Host "Invalid input, please try again."
    }
}
