unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IdWebDAV,
  System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent,
  Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    btnWebDAV: TButton;
    btnNetHTTPClient: TButton;
    edUsername: TEdit;
    edPassword: TEdit;
    lbPassword: TLabel;
    lbUsername: TLabel;
    Panel2: TPanel;
    btnCloudAPI: TButton;
    edToken: TEdit;
    lbToken: TLabel;
    OpenDialog1: TOpenDialog;
    Edit1: TEdit;
    Edit2: TEdit;
    procedure btnWebDAVClick(Sender: TObject);
    procedure btnNetHTTPClientClick(Sender: TObject);
    procedure btnCloudAPIClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    procedure Log(AText: string);

    procedure ReadSettings;
    procedure WriteSettings;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses IdStack, System.IniFiles, UMultiHash, System.NetEncoding,
     uYandexDiskCloudApi;

const
  cWebDavYandexHost = 'https://webdav.yandex.ru';
  cHost = 'webdav.yandex.ru';

procedure TForm1.btnNetHTTPClientClick(Sender: TObject);
var
  fStream: TFileStream;
  AHashs: THashsDictionary;
  RemoteFile: string;
  Client: TNetHTTPClient;
  token: string;
begin

  if (Trim(edUsername.Text) <> EmptyStr) and
     (Trim(edPassword.Text) <> EmptyStr) and
     OpenDialog1.Execute then
  Begin

    RemoteFile:= cWebDavYandexHost +'/' + ExtractFileName(OpenDialog1.FileName);
    token:= TNetEncoding.Base64.Encode(edUsername.Text + ':' + edPassword.Text);

    Client := TNetHTTPClient.Create(nil);
    AHashs:= THashsDictionary.Create(2);
    fStream := TFileStream.Create(OpenDialog1.FileName, fmOpenRead);
    try
      if not CalcHash(fStream, [ahMD5, ahSHA256], AHashs) then
       Exit;

      Client.HandleRedirects:= True;

      Client.AcceptCharSet := 'utf-8';
      Client.Accept := '*/*';
      Client.ContentType := 'application/binary';

      Client.CustomHeaders['Host'] := cHost;
      Client.CustomHeaders['Authorization'] := 'Basic ' + token;
  //    Client.CustomHeaders['Accept'] := '*/*';
      Client.CustomHeaders['Etag'] :=  AHashs.ToString(ahMD5);
      Client.CustomHeaders['Sha256'] :=  AHashs.ToString(ahSHA256);
      Client.CustomHeaders['Expect'] := '100-continue';
      Client.CustomHeaders['Content-Type'] := 'application/binary';
  //    Client.CustomHeaders['Content-Length'] := fStream.Size.ToString;
      Client.CustomHeaders['Content-Length'] := 'Transfer-Encoding: chunked';

      fStream.Position:= 0;

      Log('================================');
      Log('');
      Log('TNetHTTPClient Uploading...');
      Log('File: ' + OpenDialog1.FileName);
      Log('RemoteFile: ' + RemoteFile);

      try
       Client.Put(RemoteFile, fStream);
      except
       on E: Exception do
        Log( E.ToString );
      end;
      Log('TNetHTTPClient Upload finished');

    finally
     fStream.Free;
     AHashs.Free;
     Client.Free;
    end;

  End;

end;

procedure TForm1.btnWebDAVClick(Sender: TObject);
var
  fStream: TFileStream;
  AHashs: THashsDictionary;
  WebDAV: TIdWebDAV;
  RemoteFile: string;
  TLS: TIdSSLIOHandlerSocketOpenSSL;
begin

  if (Trim(edUsername.Text) <> EmptyStr) and
     (Trim(edPassword.Text) <> EmptyStr) and
     OpenDialog1.Execute then
  Begin
    RemoteFile:= cWebDavYandexHost +'/' + ExtractFileName(OpenDialog1.FileName);

    WebDAV:= TIdWebDAV.Create(nil);
    TLS:= TIdSSLIOHandlerSocketOpenSSL.Create(WebDAV);
    AHashs:= THashsDictionary.Create(2);
    fStream := TFileStream.Create(OpenDialog1.FileName, fmOpenRead);
    try
      TLS.SSLOptions.SSLVersions:= [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];
      WebDAV.IOHandler:= TLS;

      if not CalcHash(fStream, [ahMD5, ahSHA256], AHashs) then
        Exit;

      WebDAV.Request.Clear;
      WebDAV.HandleRedirects:= True;

      WebDAV.Request.CharSet := 'utf-8';
      WebDAV.Request.Host:= cHost;
      WebDAV.Request.Username:= edUsername.Text;
      WebDAV.Request.Password:= edPassword.Text;
      WebDAV.Request.BasicAuthentication := True;

      WebDAV.Request.CustomHeaders.Add('Accept: */*');
      WebDAV.Request.CustomHeaders.Add('Expect: 100-continue');
      WebDAV.Request.CustomHeaders.Add('Content-Type: application/binary');
      WebDAV.Request.CustomHeaders.Add('Etag: ' + AHashs.ToString(ahMD5) );
      WebDAV.Request.CustomHeaders.Add('Sha256: ' + AHashs.ToString(ahSHA256) );

      Log('================================');
      Log('');
      Log('TidWebDAV Uploading...');
      Log('File: ' + OpenDialog1.FileName);
      Log('RemoteFile: ' + RemoteFile);

      try
       WebDAV.DAVPut(RemoteFile , fStream, '');
      except
       on E: EIdSocketError do
        if E.LastError = 10054  then
         WebDAV.Disconnect;

       on E: Exception do
        Log( E.ToString );
      end;
      Log('TidWebDAV Upload finished');

    finally
     fStream.Free;
     AHashs.Free;
     TLS.Free;
     WebDAV.Free;
    end;

  End;

end;

procedure TForm1.btnCloudAPIClick(Sender: TObject);
var Uploader: TYandexDisk_CloudAPI;
begin

  if (Trim(edToken.Text) <> EmptyStr) and
     OpenDialog1.Execute then
  Begin

    Uploader:= TYandexDisk_CloudAPI.Create;
    try
      //Можно получить по ссылке: https://yandex.ru/dev/disk/poligon/#
      Uploader.AuthToken:= edToken.Text;

      Log('================================');
      Log('');
      Log('CloudAPI Uploading...');
      Log('File: ' + OpenDialog1.FileName);

      try
       Uploader.UploadFile( OpenDialog1.FileName, '' );
      except
       on E: Exception do
        Log( E.ToString );
      end;
      Log('CloudAPI Upload finished');

    finally
     Uploader.Free;
    end;

  End;

end;

procedure TForm1.Log(AText: string);
begin
  Memo1.Lines.Add( AText );
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ReadSettings;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  WriteSettings;
end;

procedure TForm1.ReadSettings;
var
  Ini: Tinifile;
begin
  Ini:= Tinifile.Create(ExtractFilePath(ParamStr(0)) + 'Settings.ini');
  try
   edUsername.Text:= Ini.ReadString('WebDav',   'Username', '');
   edToken.Text:=    Ini.ReadString('CloudAPI', 'Token',    '');
  finally
   Ini.Free;
  end;
end;

procedure TForm1.WriteSettings;
var
  Ini: Tinifile;
begin
  Ini:= Tinifile.Create(ExtractFilePath(ParamStr(0))+'Settings.ini');
  try
   Ini.WriteString('WebDav',    'Username', edUsername.Text);
   Ini.WriteString('CloudAPI',  'Token',    edToken.Text);
  finally
   Ini.Free;
  end;
end;




end.
