program Project1;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  uFTP in 'uFTP.pas',
  uSFTP in 'uSFTP.pas',
  tgputtylib in 'Lib\tgputtylib.pas',
  tgputtysftp in 'Lib\tgputtysftp.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
