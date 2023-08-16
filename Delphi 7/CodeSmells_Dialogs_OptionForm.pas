unit CodeSmells_Dialogs_OptionForm;

interface

uses

  SysUtils,
  Variants,
  Classes, Graphics,
  Windows, Messages,
  Controls, Forms, Dialogs, {pngimage,} ExtCtrls,
  StdCtrls,
  CodeSmells_Entities_FartOptions,
  CodeSmells_Entities_FartTypes;

type

  TOptionForm = class(TForm)
    LogoImage: TImage;
    SaveButton: TButton;
    CancelButton: TButton;
    EnabledCheckBox: TCheckBox;
    FartTypeBox: TComboBox;
    EnabledLabel: TLabel;
    FartTypeLabel: TLabel;
    procedure SaveButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
  private
    procedure InitializeFartTypes;
  public
    class function Configure(var AOptions: TFartOptions): Boolean;
    constructor Create(AOwner: TComponent); override;
    procedure PopOptions(var AOptions: TFartOptions);
    procedure PushOptions(const AOptions: TFartOptions);
  end;

implementation

{$R *.dfm}

uses
  TypInfo;

class function TOptionForm.Configure(var AOptions: TFartOptions): Boolean;
var
  LForm: TOptionForm;
begin
  LForm := TOptionForm.Create(nil);
  try
    LForm.PushOptions(AOptions);
    if LForm.ShowModal <> mrOk then
    begin
      Result := False;
      Exit;
    end;
    LForm.PopOptions(AOptions);
    Result := True;
  finally
    LForm.Free;
  end;
end;

constructor TOptionForm.Create;
begin
  inherited Create(AOwner);
  InitializeFartTypes;
end;

procedure TOptionForm.InitializeFartTypes;
var
  LFartType: TFartType;
begin
  FartTypeBox.Items.BeginUpdate;
  try
    FartTypeBox.Items.Clear;
    for LFartType := Low(TFartType) to High(TFartType) do
      FartTypeBox.Items.Add(GetEnumName(TypeInfo(TFartType),Ord(LFartType)){ TRttiEnumerationType.GetName(LFartType)});
  finally
    FartTypeBox.Items.EndUpdate;
  end;
end;

procedure TOptionForm.PopOptions(var AOptions: TFartOptions);
var
  LFartTypeIndex: Integer;
  LFartTypeName: string;
begin
  // Options.Enabled
  AOptions.Enabled := EnabledCheckBox.Checked;
  // Options.FartType
  LFartTypeIndex := FartTypeBox.ItemIndex;
  if LFartTypeIndex >= 0 then
    LFartTypeName := FartTypeBox.Items[LFartTypeIndex]
  else
    LFartTypeName := GetEnumName(TypeInfo(TFartType),Ord(RandomFart)); //TRttiEnumerationType.GetName(TFartType.RandomFart);
  AOptions.FartType := TFartType(GetEnumValue(TypeInfo(TFartType),LFartTypeName));//TRttiEnumerationType.GetValue<TFartType>(LFartTypeName);
end;

procedure TOptionForm.PushOptions(const AOptions: TFartOptions);
var
  LFartTypeName: string;
begin
  // Options.Enabled
  EnabledCheckBox.Checked := AOptions.Enabled;
  // Options.FartType
  LFartTypeName := GetEnumName(TypeInfo(TFartType),Ord(AOptions.FartType)); //TRttiEnumerationType.GetName(AOptions.FartType);
  FartTypeBox.ItemIndex := FartTypeBox.Items.IndexOf(LFartTypeName);
end;

procedure TOptionForm.CancelButtonClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TOptionForm.SaveButtonClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.
