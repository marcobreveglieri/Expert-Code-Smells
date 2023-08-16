unit CodeSmells.Registration;

interface

uses
  ToolsAPI;

procedure Register;

implementation

uses
  CodeSmells.Experts.FartNotifier,
  CodeSmells.Experts.MenuWizard;

var
  NotifierIndex: Integer = -1;
  WizardIndex: Integer = -1;

procedure Register;
var
  LMenuWizard: TMenuWizard;
  LFartNotifier: TFartNotifier;
begin
  LMenuWizard := TMenuWizard.Create;
  LFartNotifier := TFartNotifier.Create(LMenuWizard);
  with BorlandIDEServices as IOTAWizardServices do
    AddWizard(LMenuWizard);
  with BorlandIDEServices as IOTAServices do
    NotifierIndex := AddNotifier(LFartNotifier);
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
