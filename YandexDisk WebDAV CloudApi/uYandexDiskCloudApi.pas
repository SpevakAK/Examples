{
  ����������� � https://github.com/Gertsog/YandexDiskUploader
}


unit uYandexDiskCloudApi;

interface

uses
  System.Classes,Dialogs, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent, System.Net.HttpClient.Win;

type
 TYandexDisk_CloudAPI = class
 private
    FAuthToken: string;
    FErrorText: string;

    Function createSimpleRequestGet(const AUrl: string): IHTTPResponse;
    function createSimpleRequestPut(const AUrl: string; const ASource: TStream = nil): IHTTPResponse;
 public
    Constructor Create;

    procedure UploadFile(localFile: string; diskFolder: string);

    property AuthToken: string read FAuthToken write FAuthToken;

 end;


implementation

uses
  Winapi.Windows, System.Types, System.StrUtils, System.SysUtils, System.IOUtils,
  System.JSON, Web.HTTPApp;

const
 cBaseUrl = 'https://cloud-api.yandex.net/v1/disk/';


  { TYandexDiskUploader }

constructor TYandexDisk_CloudAPI.Create;
begin
  inherited;
  FAuthToken:= '';
end;

function TYandexDisk_CloudAPI.createSimpleRequestGet(const AUrl: string): IHTTPResponse;
var Client: TNetHTTPClient;
    Headers: TNetHeaders;
begin
  SetLength(Headers, 1);
  Headers[0].Name:= 'Authorization';
  Headers[0].Value:= authToken;

  Client:= TNetHTTPClient.Create(nil);
  try
    Result:= Client.Get(AUrl, nil, Headers);
  finally
   Client.Free;
  end;
end;

function TYandexDisk_CloudAPI.createSimpleRequestPut(const AUrl: string; const ASource: TStream = nil): IHTTPResponse;
var Client: TNetHTTPClient;
    Headers: TNetHeaders;
begin
  SetLength(Headers, 1);
  Headers[0].Name:= 'Authorization';
  Headers[0].Value:= authToken;

  Client:= TNetHTTPClient.Create(nil);
  try
//    Client.Accept:= '*/*';
//    Client.ContentType:='application/binary';

    Result:= Client.Put(AUrl, ASource, nil, Headers);
//    Result:= Client.Put(AUrl, nil, ASource, Headers);
  finally
   Client.Free;
  end;

end;

// https://yandex.ru/dev/disk/api/reference/upload.html

procedure TYandexDisk_CloudAPI.UploadFile(localFile, diskFolder: string);
var FolderRequestUrl: string;
    FolderRequest: IHTTPResponse; //THTTPRequest;

    FileRequestUrl: string;
    FileResponse: IHTTPResponse;

    responseString: string;
    uploadLink: string;
    FStream: TFileStream;

    fileUploadRequest: IHTTPResponse;
begin
  if not FileExists(localFile) then
   Exit;

  FErrorText:= EmptyStr;
  uploadLink := EmptyStr;

  diskFolder:= Trim(diskFolder);
  if diskFolder <> EmptyStr then
   try
    FolderRequestUrl := cBaseUrl + 'resources?path=' + diskFolder;
    FolderRequest := createSimpleRequestPut(FolderRequestUrl);
   except
    on E: Exception do
     FErrorText:= E.Message;
   end;

  try
   FileRequestUrl := cBaseUrl + 'resources/upload?path=' + IfThen(diskFolder <> EmptyStr, diskFolder + '%2F')+ ExtractFileName(localFile)+'&overwrite=True';
   FileResponse := createSimpleRequestGet(FileRequestUrl);
  except
   on E: Exception do
    FErrorText:= E.Message;
  end;

  with TStreamReader.Create(FileResponse.ContentStream) do
   try
    responseString := ReadToEnd;
   finally
    Free;
   end;

  if Pos('"href":', responseString) > 0 then
   uploadLink := TJSonObject.ParseJSONValue(responseString).GetValue<string>('href')
  else if Pos('"message":', responseString) > 0 then
   Begin
    FErrorText:= TJSonObject.ParseJSONValue(responseString).GetValue<string>('message');
    Exit;
   End;

  FStream:= TFileStream.Create(localFile, fmOpenRead);
  try
   fileUploadRequest := createSimpleRequestPut(uploadLink, FStream);
//   fileUploadRequest.StatusCode
  finally
   FStream.Free;
  end;

// API �������� ����� 201 Created, ���� ���� ��� �������� ��� ������.
// 202 Accepted � ���� ������ ��������, �� ��� �� ��� ��������� ��������������� � ������.����.
// 412 Precondition Failed � ��� ���������� ����� ��� ������� �������� �������� � ��������� Content-Range.
// 413 Payload Too Large � ������ ����� ������ �����������. ���� � ��� ���� �������� �� ������ 360, ����� ��������� ����� �������� �� 50 ��, ���� �������� ��� � �� 1 ��.
// 500 Internal Server Error ��� 503 Service Unavailable � ������ �������, ���������� ��������� ��������.
// 507 Insufficient Storage � ��� �������� ����� �� ������� ����� �� ����� ������������.

end;

end.
