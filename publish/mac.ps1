$appName = "caspi" # 默认值，在解析 pubspec.yaml 后会被覆盖
$appVersion = "0.0.1" # 默认值，在解析 pubspec.yaml 后会被覆盖
$appMode = "release";

$pubspecPath = "$PSScriptRoot/../pubspec.yaml"
if (-Not (Test-Path $pubspecPath)) {
    Write-Error "pubspec.yaml not found."
    exit 1
}

# Write-Host "Project pubspecPath: $pubspecPath"

# 尝试导入 powershell-yaml 模块，如果未安装则提示用户安装
try {
    Import-Module powershell-yaml -ErrorAction Stop
} catch {
    Write-Host "powershell-yaml module not found. Installing..."
    Install-Module -Name powershell-yaml -Scope CurrentUser -Force
    Import-Module powershell-yaml
}

# 解析 pubspec.yaml 并提取应用程序名称和版本号
$pubspec = Get-Content -Raw -Path $pubspecPath | ConvertFrom-Yaml

if (-Not $pubspec.name -or -Not $pubspec.version) {
    Write-Error "Name or version not found in pubspec.yaml."
    Pop-Location
    exit 1
}

$appName = $pubspec.name
$appVersion = $pubspec.version

Write-Host "Using app name: $appName"
Write-Host "Using version: $appVersion"


$buildPath = "$PSScriptRoot/../build/macos/Build/Products/Release/$appName.app"
$outputDmg = "$PSScriptRoot/../dist/$appMode/$appName-$appVersion.dmg"
$tempAppPath = "$PSScriptRoot/../temp/$appName.app"
$installBackgroundPath = "$PSScriptRoot/../assets/images/install_background.png"

# 清理旧的构建文件
if (Test-Path $tempAppPath) {
    Remove-Item -Recurse -Force $tempAppPath
}
if (Test-Path $outputDmg) {
    Remove-Item -Force $outputDmg
}

# 确保输出目录存在
$outputDir = Split-Path -Parent $outputDmg
if (-Not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

# 构建 macOS 应用程序
Write-Host "Building macOS application..."
flutter build macos --${appMode}

# 检查构建命令的退出状态码
if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to build the application."
    Pop-Location
    exit 1
}

# 创建应用程序的副本
Write-Host "Copying app to temporary location..."
Copy-Item -Path $buildPath -Destination $tempAppPath -Recurse -Force

# 使用 create-dmg 创建 DMG 文件
Write-Host "Creating DMG file..."
create-dmg `
  --volname "$appName Installer" `
  --background "$installBackgroundPath" `
  --window-pos 200 120 `
  --window-size 800 400 `
  --icon "$appName.app" 200 190 `
  --hide-extension "$appName.app" `
  --app-drop-link 600 185 `
  $outputDmg `
  $tempAppPath

# 对 DMG 文件进行签名
codesign --sign "com.gdj.build" --verbose --timestamp --options runtime --entitlements "$PSScriptRoot/entitlements.plist" $outputDmg

# 检查 DMG 是否创建成功
if (Test-Path $outputDmg) {
    Write-Host "DMG created successfully at $outputDmg"
} else {
    Write-Error "Failed to create DMG file."
}

# 清理临时文件
Remove-Item -Recurse -Force $tempAppPath
