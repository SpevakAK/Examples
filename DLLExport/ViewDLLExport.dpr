program ViewDLLExport;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {frmDLLExport};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmDLLExport, frmDLLExport);
  Application.Run;
end.
