unit CodeSmells.Experts.FartNotifier;

interface

uses
  System.IOUtils, System.SysUtils, ToolsAPI,
  CodeSmells.Entities.FartTypes, CodeSmells.Services.FartPlayer,
  CodeSmells.Experts.MenuWizard;

type

  TFartNotifier = class(TNotifierObject, IOTAIDENotifier, IOTAIDENotifier50,
    IOTAIDENotifier80)
  private
    FFartPlayer: TFartPlayer;
    FMenuWizard: TMenuWizard;
    procedure ShowFartMessage();
  public
    constructor Create(AMenuWizard: TMenuWizard);
    destructor Destroy; override;
    { IOTAIDENotifier }
    procedure FileNotification(NotifyCode: TOTAFileNotification;
      const FileName: string; var Cancel: Boolean);
    procedure BeforeCompile(const Project: IOTAProject;
      var Cancel: Boolean); overload;
    procedure AfterCompile(Succeeded: Boolean); overload;
    { IOTAIDENotifier50 }
    procedure BeforeCompile(const Project: IOTAProject; IsCodeInsight: Boolean;
      var Cancel: Boolean); overload;
    procedure AfterCompile(Succeeded: Boolean; IsCodeInsight: Boolean);
      overload;
    { IOTAIDENotifier80 }
    procedure AfterCompile(const Project: IOTAProject; Succeeded: Boolean;
      IsCodeInsight: Boolean); overload;
  end;

implementation

constructor TFartNotifier.Create(AMenuWizard: TMenuWizard);
begin
  inherited Create;
  FFartPlayer := TFartPlayer.Create;
  FMenuWizard := AMenuWizard;
end;

destructor TFartNotifier.Destroy;
begin
  if FFartPlayer <> nil then
    FreeAndNil(FFartPlayer);
  inherited Destroy;
end;

procedure TFartNotifier.AfterCompile(Succeeded, IsCodeInsight: Boolean);
begin
  // Not used.
end;

procedure TFartNotifier.AfterCompile(const Project: IOTAProject;
  Succeeded, IsCodeInsight: Boolean);
begin
  if IsCodeInsight then
    Exit;
  if Succeeded then
    Exit;
  if not FMenuWizard.Options.Enabled then
    Exit;
  FFartPlayer.PlayFart(FMenuWizard.Options.FartType);
  ShowFartMessage;
end;

procedure TFartNotifier.AfterCompile(Succeeded: Boolean);
begin
  // Not used.
end;

procedure TFartNotifier.BeforeCompile(const Project: IOTAProject;
  var Cancel: Boolean);
begin
  // Not used.
end;

procedure TFartNotifier.BeforeCompile(const Project: IOTAProject;
  IsCodeInsight: Boolean; var Cancel: Boolean);
begin
  // Not used.
end;

procedure TFartNotifier.FileNotification(NotifyCode: TOTAFileNotification;
  const FileName: string; var Cancel: Boolean);
begin
  // Not used.
end;

procedure TFartNotifier.ShowFartMessage;
begin
  with (BorlandIDEServices As IOTAMessageServices) do
    AddTitleMessage(Format('[Fart] %s', [FFartPlayer.GetMessage]));
end;

end.
