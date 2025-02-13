; 最简化的 Inno Setup 脚本

#define MyAppName "{%MyAppName}"
#define MyAppVersion "{%MyAppVersion}"
#define OutputDir "release"

[Languages]
Name: "zh_CN"; MessagesFile: ".\languages\ChineseSimplified.isl.txt"

[Setup]
; 应用程序的基本信息
AppName={#MyAppName}
AppVersion={#MyAppVersion}
DefaultDirName={pf}\{#MyAppName}
DefaultGroupName={#MyAppName}
OutputDir={#OutputDir}
OutputBaseFilename=release-{#MyAppName}-{#MyAppVersion}
Compression=lzma
SolidCompression=yes
UsePreviousLanguage=no

[Files]
; 假设你的应用构建输出在 build\windows\x64\runner\Release 目录下
Source: "{%}\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
; 在开始菜单中创建快捷方式
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppName}.exe"
; 在桌面上创建快捷方式
Name: "{userdesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppName}.exe"
