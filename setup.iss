; 最简化的 Inno Setup 脚本

#define AppName "{MyAppName}"
#define AppVersion "{MyAppVersion}"
#define OutputDir "release"

[Languages]
Name: "zh_CN"; MessagesFile: "config\InnoSetUp6\languages\ChineseSimplified.isl.txt"

[Setup]
; 应用程序的基本信息
AppName={#AppName}
AppVersion={#AppVersion}
DefaultDirName={pf}\{#AppName}
DefaultGroupName={#AppName}
OutputDir={#OutputDir}
OutputBaseFilename=release-{#AppName}-{#AppVersion}
Compression=lzma
SolidCompression=yes
UsePreviousLanguage=no

[Files]
; 假设你的应用构建输出在 build\windows\x64\runner\Release 目录下
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
; 在开始菜单中创建快捷方式
Name: "{group}\{#AppName}"; Filename: "{app}\{#AppName}.exe"
; 在桌面上创建快捷方式
Name: "{userdesktop}\{#AppName}"; Filename: "{app}\{#AppName}.exe"
