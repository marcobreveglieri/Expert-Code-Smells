unit CodeSmells.Experts.MenuWizard;

interface

uses
  System.IOUtils, System.Rtti, System.SysUtils,
  Vcl.Menus,
  ToolsAPI, CodeSmells.Entities.FartOptions, CodeSmells.Entities.FartTypes;

type

  TMenuWizard = class(TInterfacedObject, IOTAWizard)
  private
    FIniPath: string;
    FMenuItem: TMenuItem;
    FOptions: TFartOptions;
    procedure HandleMenuClick(Sender: TObject);
  protected
    procedure InitMenuItem;
    procedure InitOptions;
    procedure LoadOptions;
    procedure SaveOptions;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Execute;
    function GetIDString: string;
    function GetName: string;
    function GetState: TWizardState;
    procedure AfterSave;
    procedure BeforeSave;
    procedure Destroyed;
    procedure Modified;
    property Options: TFartOptions read FOptions;
  end;

implementation

uses
  System.IniFiles,
  Winapi.Windows,
  CodeSmells.Dialogs.OptionForm;

constructor TMenuWizard.Create;
begin
  inherited Create;
  InitMenuItem;
  InitOptions;
  LoadOptions;
end;

destructor TMenuWizard.Destroy;
begin
  if FMenuItem <> nil then
    FreeAndNil(FMenuItem);
  inherited Destroy;
end;

procedure TMenuWizard.AfterSave;
begin
  // Not called for this wizard.
end;

procedure TMenuWizard.BeforeSave;
begin
  // Not called for this wizard.
end;

procedure TMenuWizard.Destroyed;
begin
  // Resources are freed in destructor.
end;

procedure TMenuWizard.Execute;
begin
  // Not called for this wizard.
end;

function TMenuWizard.GetIDString: string;
begin
  Result := 'CodeSmells.Experts.MenuWizard';
end;

function TMenuWizard.GetName: string;
begin
  Result := 'Code Smells Expert';
end;

function TMenuWizard.GetState: TWizardState;
begin
  Result := [wsEnabled];
end;

procedure TMenuWizard.HandleMenuClick(Sender: TObject);
begin
  if not TOptionForm.Configure(FOptions) then
    Exit;
  SaveOptions;
  LoadOptions;
end;

procedure TMenuWizard.InitMenuItem;
var
  LParentMenu, LDivMenu: TMenuItem;
begin
  with BorlandIDEServices as INTAServices do
  begin
    if MainMenu = nil then
      Exit;
    LParentMenu := MainMenu.Items.Find('Tools');
  end;
  if LParentMenu = nil then
    Exit;
  LDivMenu := LParentMenu.Find('-');
  FMenuItem := TMenuItem.Create(LParentMenu);
  try
    FMenuItem.Caption := 'Code Smells Options...';
    FMenuItem.OnClick := HandleMenuClick;
    LParentMenu.Insert(LParentMenu.IndexOf(LDivMenu), FMenuItem);
    LParentMenu.InsertNewLineBefore(FMenuItem);
  except
    FreeAndNil(FMenuItem);
    raise;
  end;
end;

procedure TMenuWizard.InitOptions;
var
  LPathValue: string;
  LPathSize: Cardinal;
begin
  // Options
  FOptions.Enabled := True;
  FOptions.FartType := TFartType.RandomFart;
  // INI path
  SetLength(LPathValue, MAX_PATH);
  LPathSize := GetModuleFileName(HInstance, PChar(LPathValue), MAX_PATH);
  SetLength(LPathValue, LPathSize);
  FIniPath := TPath.ChangeExtension(LPathValue, '.ini');
end;

procedure TMenuWizard.LoadOptions;
begin
  with TIniFile.Create(FIniPath) do
  begin
    try
      FOptions.Enabled := ReadBool('Options', 'Enabled', FOptions.Enabled);
      FOptions.FartType := TFartType(ReadInteger('Options', 'FartType', 0));
    finally
      Free;
    end;
  end;
end;

procedure TMenuWizard.Modified;
begin
  // Not called for this wizard.
end;

procedure TMenuWizard.SaveOptions;
begin
  with TIniFile.Create(FIniPath) do
  begin
    try
      WriteBool('Options', 'Enabled', FOptions.Enabled);
      WriteInteger('Options', 'FartType', Integer(FOptions.FartType));
    finally
      Free;
    end;
  end;
end;

end.
