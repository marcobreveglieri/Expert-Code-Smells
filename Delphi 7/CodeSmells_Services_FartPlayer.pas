unit CodeSmells_Services_FartPlayer;

interface

uses
  Dialogs,
  Windows, Classes, Math, SysUtils, TypInfo,
  Forms, MPlayer, CodeSmells_Entities_FartTypes;

type

  TFartPlayer = class(TThread)
  private
    FFartType: TFartType;
    FMediaPlayer: TMediaPlayer;
    FMediaSurface: TForm;
    function PrepareFileFor(const AFartName: string): string;
    procedure PlayFart(AFartType: TFartType);
  public
    constructor Create(FartType: TFartType);
    destructor Destroy; override;
    procedure Execute; override;
    class function GetMessage: string;
  end;

implementation

uses
  CodeSmells_Resources_FartMessages;

constructor TFartPlayer.Create;
begin
  FFartType := FartType;
  FreeOnTerminate := True;
  FMediaSurface := TForm.Create(nil);
  FMediaSurface.Visible := False;
  FMediaPlayer := TMediaPlayer.Create(nil);
  FMediaPlayer.Visible := False;
  FMediaPlayer.Parent := FMediaSurface;
  Randomize;
  inherited Create(False);
end;

destructor TFartPlayer.Destroy;
begin
  if FMediaPlayer <> nil then
    FreeAndNil(FMediaPlayer);
  if FMediaSurface <> nil then
    FreeAndNil(FMediaSurface);
  inherited Destroy;
end;

procedure TFartPlayer.Execute;
begin
  PlayFart(FFartType);
end;

class function TFartPlayer.GetMessage: string;
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
  if AFartType = SilentButDeadly then
    Exit;

  if AFartType = RandomFart then
  begin
    AFartType := TFartType(RandomRange(Integer(Low(TFartType)) + 1,
      Integer(High(TFartType))));
  end;

  LFartName := GetEnumName(TypeInfo(TFartType), Ord(AFartType));

  LFartPath := PrepareFileFor(LFartName);
  try
    FMediaPlayer.FileName := LFartPath;
    FMediaPlayer.Open;
    FMediaPlayer.Wait := true;
    FMediaPlayer.Play;
    FMediaPlayer.Close;
  finally
    DeleteFile(LFartPath);
  end;
end;

function GetTempFile(const Extension: string): string;
var
  Buffer: array[0..MAX_PATH] of Char;
begin
  repeat
    GetTempPath(SizeOf(Buffer) - 1, Buffer);
    GetTempFileName(Buffer, '~', 0, Buffer);
    Result := ChangeFileExt(Buffer, Extension);
  until not FileExists(Result);
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
    LTempFilePath := GetTempFile('.mp3');
    Result := LTempFilePath;
    LResourceStream.SaveToFile(Result);
  finally
    LResourceStream.Free;
  end;
end;

end.
