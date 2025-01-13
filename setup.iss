; 最简化的 Inno Setup 脚本

#define MyAppName "flutter_build_test"
#define MyAppVersion "0.0.1"
#define OutputDir "./release"
#define OutputBaseFilename "release-{#MyAppName}-{#MyAppVersion}"

[Setup]
; 应用程序的基本信息
AppName={#MyAppName}
AppVersion={#MyAppVersion}
DefaultDirName={pf}\{#MyAppName}
DefaultGroupName={#MyAppName}
OutputDir={#OutputDir}
OutputBaseFilename={#OutputBaseFilename}
Compression=lzma
SolidCompression=yes

[Files]
; 假设你的应用构建输出在 build\windows\runner\Release 目录下
Source: "build\windows\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
; 在开始菜单中创建快捷方式
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppName}.exe"
