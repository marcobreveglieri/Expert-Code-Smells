unit CodeSmells.Services.FartPlayer;

interface

uses
  System.Classes, System.Math, System.IOUtils, System.Rtti, System.SysUtils,
  Vcl.Forms, Vcl.MPlayer, CodeSmells.Entities.FartTypes;

type

  TFartPlayer = class
  private
    FMediaPlayer: TMediaPlayer;
    FMediaSurface: TForm;
    function PrepareFileFor(const AFartName: string): string;
  public
    constructor Create;
    destructor Destroy; override;
    function GetMessage: string;
    procedure PlayFart(AFartType: TFartType);
  end;

implementation

uses
  CodeSmells.Resources.FartMessages;

constructor TFartPlayer.Create;
begin
  inherited Create;
  FMediaSurface := TForm.Create(nil);
  FMediaSurface.Visible := False;
  FMediaPlayer := TMediaPlayer.Create(nil);
  FMediaPlayer.Visible := False;
  FMediaPlayer.Parent := FMediaSurface;
  Randomize;
end;

destructor TFartPlayer.Destroy;
begin
  if FMediaPlayer <> nil then
    FreeAndNil(FMediaPlayer);
  if FMediaSurface <> nil then
    FreeAndNil(FMediaSurface);
  inherited Destroy;
end;

function TFartPlayer.GetMessage: string;
var
  LMessageIndex: Integer;
begin
  LMessageIndex := RandomRange(Low(FartMessages), High(FartMessages) + 1);
  Result := FartMessages[LMessageIndex];
end;

procedure TFartPlayer.PlayFart(AFartType: TFartType);
var
  LFartName, LFartPath: string;
begin
  if AFartType = TFartType.SilentButDeadly then
    Exit;

  if AFartType = TFartType.RandomFart then
  begin
    AFartType := TFartType(RandomRange(Integer(Low(TFartType)) + 1,
      Integer(High(TFartType)) + 1));
  end;

  LFartName := TRttiEnumerationType.GetName(AFartType);

  LFartPath := PrepareFileFor(LFartName);

  try
    FMediaPlayer.FileName := LFartPath;
    FMediaPlayer.Open;
    FMediaPlayer.Wait := True;
    FMediaPlayer.Play;
    FMediaPlayer.Close;
  finally
    TFile.Delete(LFartPath);
  end;
end;

function TFartPlayer.PrepareFileFor(const AFartName: string): string;
var
  LResourceName: string;
  LResourceStream: TResourceStream;
  LTempFilePath: string;
begin
  LResourceName := Format('MP3_%s', [AFartName]);
  LResourceStream := TResourceStream.Create(HInstance, LResourceName, 'MPEG3');
  try
    LTempFilePath := TPath.GetTempFileName;
    Result := LTempFilePath + '.mp3';
    TFile.Move(LTempFilePath, Result);
    LResourceStream.SaveToFile(Result);
  finally
    LResourceStream.Free;
  end;
end;

end.
