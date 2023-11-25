unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Samples.Spin, Vcl.ComCtrls, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdCoder, IdCoder3to4, IdCoderBinHex4,
  Vcl.Buttons;

type

  TForm1 = class(TForm)
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    edURL: TEdit;
    edUserName: TEdit;
    edPassword: TEdit;
    btnFTP: TButton;
    sePort: TSpinEdit;
    ProgressBar1: TProgressBar;
    btnsFTP: TButton;
    Button1: TButton;
    Memo1: TMemo;
    lbFileName: TLabel;
    edFIleName: TEdit;
    sbSelectFile: TSpeedButton;
    OpenDialog1: TOpenDialog;
    procedure btnFTPClick(Sender: TObject);
    procedure btnsFTPClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure sbSelectFileClick(Sender: TObject);
  private
    procedure Log(const AText: string);

  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses uFTP, uSFTP, tgputtylib, tgputtysftp;

const
  cFile = 'D:\db\NEW_CINEMA_5.6.1_UTF8.FDB';

{$R *.dfm}

procedure TForm1.btnFTPClick(Sender: TObject);
begin
  if FTPSimpleUploadFile(cFile, '192.168.8.1', 21, 'anonymous', 'anonymous') = 0
  then
    Log('File uploaded');
end;

procedure TForm1.btnsFTPClick(Sender: TObject);
begin
  if SFTPSimpleUploadFile(cFile, '192.168.8.1', 22, 'anonymous', 'anonymous') = 0
  then
    Log('File uploaded');
end;


procedure TForm1.Button1Click(Sender: TObject);
begin
 if CheckSFTPPort('192.168.8.1', 21) then
  Log('ssh 2.0')
 else
  Log('not ssh 2.0');

end;

procedure TForm1.Log(const AText: string);
begin
  Memo1.Lines.Add(AText);
end;


procedure TForm1.sbSelectFileClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
   edFIleName.Text:= OpenDialog1.FileName;
end;

end.
