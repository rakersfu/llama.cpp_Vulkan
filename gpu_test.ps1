# 获取显存数值
$memfree = nvidia-smi --query-gpu=memory.free --format=csv,nounits | Select-Object -Skip 1

Write-Host "Captured MEMFREE = $memfree"

# 根据显存大小调整层数
$nlayers = 0
if ($memfree -ge 6000) {
    $nlayers = 40
} elseif ($memfree -ge 4000) {
    $nlayers = 20
}

Write-Host "Free GPU memory: $memfree MiB"
Write-Host "Using --n-gpu-layers $nlayers"
