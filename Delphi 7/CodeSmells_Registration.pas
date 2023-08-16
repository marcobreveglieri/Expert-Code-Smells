unit CodeSmells_Registration;

interface

uses
  //  Dialogs,
  ToolsAPI;

procedure Register;

implementation

uses
  CodeSmells_Experts_FartNotifier,
  CodeSmells_Experts_MenuWizard;

var
  NotifierIndex: Integer = -1;
  WizardIndex: Integer = -1;

procedure Register;
var
  LMenuWizard: TMenuWizard;
  LFartNotifier: TFartNotifier;
begin
  if not Assigned(BorlandIDEServices) then
    Exit;
  LMenuWizard := TMenuWizard.Create;
  LFartNotifier := TFartNotifier.Create(LMenuWizard);
  with BorlandIDEServices as IOTAWizardServices do
    WizardIndex := AddWizard(LMenuWizard);
  with BorlandIDEServices as IOTAServices do
    NotifierIndex := AddNotifier(LFartNotifier);
  //  ShowMessage('ok');
end;

procedure Unregister;
begin
  if WizardIndex >= 0 then
  begin
    with BorlandIDEServices as IOTAWizardServices do
      RemoveWizard(WizardIndex);
  end;
  if NotifierIndex >= 0 then
  begin
    with BorlandIDEServices as IOTAServices do
      RemoveNotifier(NotifierIndex);
  end;
end;

initialization

finalization
  Unregister;

end.
