unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.CheckLst, UMultiHash;

type
  TForm1 = class(TForm)
    btnCalcHash: TButton;
    Memo1: TMemo;
    ProgressBar1: TProgressBar;
    OpenDialog1: TOpenDialog;
    clbHash: TCheckListBox;
    btnStop: TButton;
    procedure btnCalcHashClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnStopClick(Sender: TObject);
  private
    function GeHashs: TAlgoHashs;
    procedure OnProgress(const Position, Max: UInt64; var Abort: Boolean);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

const
  c1Mb = 1024*1024;

var
  GAbort: Boolean = False;

procedure TForm1.btnStopClick(Sender: TObject);
begin
  GAbort:= True;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  GAbort:= True;
end;

procedure TForm1.FormCreate(Sender: TObject);
var i: TAlgoHash;
begin
  clbHash.Clear;
  for i := Low(TAlgoHash) to High(TAlgoHash) do
   clbHash.Items.AddObject(cAlgoHashName[i], TObject(i) );
end;

function TForm1.GeHashs: TAlgoHashs;
var i: integer;
    Hash: TAlgoHash;
begin
  Result:= [];
  for i := 0 to clbHash.Count-1 do
   if clbHash.Checked[i] then
    Begin
     Hash:= TAlgoHash( clbHash.Items.Objects[i] );
     if Hash in [ahMD5, ahSHA1, ahSHA224, ahSHA256, ahSHA384, ahSHA512, ahBobJenkins] then
      Include(Result, Hash);
    End;
end;

procedure TForm1.OnProgress(const Position, Max: UInt64; var Abort: Boolean);
begin
  ProgressBar1.Max:= Max div 1024;
  ProgressBar1.Position:= Position div 1024;

  Application.ProcessMessages;

  if GAbort or (Position = Max) then
  Begin
   Abort:= GAbort;
   GAbort:= False;
   Memo1.Lines.Clear;
  End;

end;

procedure TForm1.btnCalcHashClick(Sender: TObject);
var Hashs: THashsDictionary;
begin
  if not OpenDialog1.Execute then Exit;

  btnCalcHash.Enabled:= False;
  btnStop.Enabled:= True;
  Hashs:= THashsDictionary.Create;
  try

    if CalcHash(OpenDialog1.FileName, GeHashs, Hashs, OnProgress, c1Mb) then
     Memo1.Text:= Hashs.ToString;

  finally
   Hashs.Free;
   GAbort:= False;
   btnStop.Enabled:= False;
   btnCalcHash.Enabled:= True;
  end;

end;


end.
