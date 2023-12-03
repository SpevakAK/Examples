

unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses DnsResolveUnit, IdStackWindows;


procedure TForm1.Button1Click(Sender: TObject);
var tmpList: TStringList;
    i: Integer;
begin

  tmpList:= TStringList.Create;
  try

   ResolveDomainNameListIPv4('mail.ru', tmpList);
   ResolveDomainNameListIPv6('mail.ru', tmpList);

//   for i := 0 to tmpList.Count-1 do    /
//    Memo1.Lines.Add ( tmpList[i] );
   Memo1.Text:= tmpList.Text;

  finally
   tmpList.Free;
  end;



end;

end.
