unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;


const
 cTitle   = 'View DLL Export';

type
  TfrmDLLExport = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    edFilter: TEdit;
    OpenDialog1: TOpenDialog;
    btSelectDLL: TButton;
    lbView: TListBox;
    procedure btSelectDLLClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edFilterChange(Sender: TObject);
    procedure lbViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lbViewDblClick(Sender: TObject);
  private
    { Private declarations }
    FList,                     // Полный список
    FFilterList: TStringList;  // Отфильтрованный список

    Procedure LoadFile(const aFileName: string);
    Procedure FilteredList;
    Procedure SearchEngine(const aFuncName: string );

  public
    { Public declarations }
  end;

var
  frmDLLExport: TfrmDLLExport;

implementation

{$R *.dfm}

uses
   ImageHlp, ShellApi, CLIPBrd, StrUtils;

procedure ListDLLExports(aFileName: AnsiString; const aList: TStrings);
type
  TDWordArray = array [0..$FFFFF] of DWORD;
var
  imageinfo: LoadedImage;
  pExportDirectory: PImageExportDirectory;
  dirsize: Cardinal;
  pDummy: PImageSectionHeader;
  i: Cardinal;
  pNameRVAs: ^TDWordArray;
  Name: AnsiString;
begin
  if (aFileName<>'') and not Assigned(aList) then Exit;

  aList.BeginUpdate;
  aList.Clear;
  if MapAndLoad( PAnsiChar(aFileName), nil, @imageinfo, True, True) then
  begin
    try
      pExportDirectory := ImageDirectoryEntryToData(imageinfo.MappedAddress,
        False, IMAGE_DIRECTORY_ENTRY_EXPORT, dirsize);

      if (pExportDirectory <> nil) then
      begin
        pNameRVAs := ImageRvaToVa(imageinfo.FileHeader, imageinfo.MappedAddress,
          DWORD(pExportDirectory^.AddressOfNames), pDummy);

        for i := 0 to pExportDirectory^.NumberOfNames - 1 do
        begin
          Name := PAnsiChar(ImageRvaToVa(imageinfo.FileHeader, imageinfo.MappedAddress,
            pNameRVAs^[i], pDummy));
          aList.Add(String(Name));
        end;//for
      end;//if

    finally
      UnMapAndLoad(@imageinfo);
    end;//try

  end;//if
  aList.EndUpdate;
end;

Procedure TfrmDLLExport.SearchEngine(const aFuncName: string);
const
 cQuery = 'https://www.google.com/search?q=%s';
Begin
 ShellExecute( Handle, 'open', PWideChar(Format(cQuery, [aFuncName])), nil, nil, SW_NORMAL );
End;

procedure TfrmDLLExport.LoadFile(const aFileName: string);
begin
  Caption:= cTitle +' ('+ aFileName +')';
  ListDLLExports( AnsiString(aFileName), FList);
  FilteredList;
end;

Procedure TfrmDLLExport.FilteredList;
var i: Integer;
    iSearchStr: string;
Begin
 iSearchStr:= UpperCase(Trim(edFilter.Text));
 if iSearchStr <> '' then
  Begin
   FFilterList.Clear;
   for i := 0 to FList.Count-1 do
    if AnsiPos( iSearchStr, UpperCase(FList.Strings[i]) ) > 0 then
     FFilterList.Add(FList.Strings[i]);

   lbView.Items.Assign(FFilterList);
  end
 else
  lbView.Items.Assign(FList);
End;

procedure TfrmDLLExport.btSelectDLLClick(Sender: TObject);
begin
 if OpenDialog1.Execute then
  LoadFile(OpenDialog1.FileName);
end;

procedure TfrmDLLExport.edFilterChange(Sender: TObject);
begin
 FilteredList;
end;

procedure TfrmDLLExport.FormActivate(Sender: TObject);
var iFileName: String;
begin
 iFileName:= Trim( ParamStr(1) );
 if (iFileName <> '') and FileExists(iFileName) then
  LoadFile(iFileName);
end;

procedure TfrmDLLExport.FormCreate(Sender: TObject);
begin
 FList:= TStringList.Create;
 FFilterList:= TStringList.Create;

 OpenDialog1.Filter := 'Dynamic Link Library (*.dll)|*.dll|Все файлы (*.*)|*.*';
 OpenDialog1.InitialDir:= 'C:\Windows\';
end;

procedure TfrmDLLExport.FormDestroy(Sender: TObject);
begin
 FreeAndNil(FFilterList);
 FreeAndNil(FList);
end;

procedure TfrmDLLExport.lbViewDblClick(Sender: TObject);
begin
 SearchEngine(lbView.Items.Strings[lbView.ItemIndex]);
end;

procedure TfrmDLLExport.lbViewKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);

  procedure CopyInClipboard;
  var i: Integer;
      tmpStr: string;
  Begin
   tmpStr:= '';
   for i := 0 to lbView.Count-1 do
    if lbView.Selected[i] then
     tmpStr:= Concat(tmpStr, lbView.Items[i], sLineBreak);

   Clipboard.AsText:= tmpStr;
  End;

begin

 if (ssCtrl in Shift) and (Key = 67) and (lbView.ItemIndex > 0) then
  CopyInClipboard
 else if (ssCtrl in Shift) and (Key = 65 ) and (lbView.Count > 0) then
  Begin
   lbView.Items.BeginUpdate;
   lbView.SelectAll;
   lbView.Items.EndUpdate;
  end;

end;



end.
