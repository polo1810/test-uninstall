; ============================================================================
; installer.iss — Script Inno Setup pour MonAppTest
;
; Compilation : ouvre ce fichier dans Inno Setup Compiler puis Build > Compile
; (raccourci Ctrl+F9). Tu obtiens MonAppTest-Setup.exe a cote de ce script.
;
; Ce que fait l'installeur :
;   - Installe dist\mon_app.exe dans Program Files
;   - Cree un userId unique dans %APPDATA%\TestUninstall\user.txt
;   - A la desinstallation, lit cet userId et ping l'endpoint Netlify
; ============================================================================

#define MyAppName       "MonAppTest"
#define MyAppVersion    "1.0.0"
#define MyAppPublisher  "Test"
#define MyAppExeName    "mon_app.exe"

; >>> URL Netlify : change ici si tu deploies sur un autre site <<<
#define NetlifyHost     "testuninstall.netlify.app"

[Setup]
AppId={{B9F2A3F1-8C5D-4F2A-9E1B-7C6D5E4F3A2B}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
OutputBaseFilename=MonAppTest-Setup
Compression=lzma2
SolidCompression=yes
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
UninstallDisplayIcon={app}\{#MyAppExeName}
WizardStyle=modern
CloseApplications=force
RestartApplications=no

[Languages]
Name: "french"; MessagesFile: "compiler:Languages\French.isl"

[Tasks]
Name: "desktopicon"; Description: "Creer une icone sur le Bureau"; GroupDescription: "Raccourcis :"

[Files]
Source: "dist\mon_app.exe"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\Desinstaller {#MyAppName}"; Filename: "{uninstallexe}"
Name: "{userdesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "Lancer {#MyAppName}"; Flags: nowait postinstall skipifsilent

[UninstallRun]
; Lit %APPDATA%\TestUninstall\user.txt, ping l'endpoint Netlify (timeout 5s),
; puis ouvre la page de questionnaire dans le navigateur par defaut.
; Le PowerShell tourne en arriere-plan, toute erreur est ignoree.
Filename: "powershell.exe"; \
  Parameters: "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command ""try {{ $f=Join-Path $env:APPDATA 'TestUninstall\user.txt'; if (Test-Path $f) {{ $u=(Get-Content -Raw $f).Trim() } else {{ $u='unknown' }; $e=[Uri]::EscapeDataString($u); Invoke-WebRequest -Uri ('https://{#NetlifyHost}/.netlify/functions/uninstalled?userId=' + $e) -UseBasicParsing -TimeoutSec 5 | Out-Null; Start-Process ('https://{#NetlifyHost}/survey.html?userId=' + $e) } catch {{ }"""; \
  RunOnceId: "PingAndSurvey"; \
  Flags: runhidden

[Code]
// A l'installation : cree %APPDATA%\TestUninstall\user.txt avec un userId unique
procedure CurStepChanged(CurStep: TSetupStep);
var
  DataDir, UserFile, UserId: String;
begin
  if CurStep = ssPostInstall then
  begin
    DataDir := ExpandConstant('{userappdata}\TestUninstall');
    if not DirExists(DataDir) then
      ForceDirectories(DataDir);
    UserFile := DataDir + '\user.txt';
    if not FileExists(UserFile) then
    begin
      UserId := ExpandConstant('{computername}') + '-' + GetDateTimeString('yyyymmddhhnnss', #0, #0);
      SaveStringToFile(UserFile, UserId, False);
    end;
  end;
end;

// Apres le ping de desinstallation : on nettoie le dossier %APPDATA%\TestUninstall
procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
var
  DataDir: String;
begin
  if CurUninstallStep = usPostUninstall then
  begin
    DataDir := ExpandConstant('{userappdata}\TestUninstall');
    if DirExists(DataDir) then
      DelTree(DataDir, True, True, True);
  end;
end;
