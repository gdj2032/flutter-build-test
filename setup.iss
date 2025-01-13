#define MyAppName "flutter_build_test"
#define MyAppVersion "0.0.1"

[Setup]
AppName={#MyAppName}
AppVersion={#MyAppVersion}
DefaultDirName={pf}\{#MyAppName}

[Files]
Source: "build\windows\x64\Release\{#MyAppName}.exe"; DestDir: "{app}";

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppName}.exe"

[Run]
Filename: "{app}\{#MyAppName}.exe"; Description: "{cm:LaunchProgram,{#MyAppName}}";