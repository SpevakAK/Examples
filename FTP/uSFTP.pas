unit uSFTP;

interface

uses
  System.SysUtils, tgputtylib, tgputtysftp;


function CheckSFTPPort(const AHost: string; APort: Word): Boolean;

Function SFTPSimpleUploadFile(const AFileName: TFileName;
  const AHost: string; APort: Word;
  const AUsername: string; APassword: string;
  const ADestFile: string = '';
  const ATransferBinary: Boolean = True): Integer;

implementation

uses Winapi.Windows, Vcl.Forms, IdTCPConnection, IdTCPClient;


type
  TCallback = class
  public
   class function VerifyHostKey ( const host: PAnsiChar; const port: Integer;
      const fingerprint: PAnsiChar; const verificationstatus: Integer;
      var storehostkey: Boolean): Boolean;
  end;


function CheckSFTPPort(const AHost: string; APort: Word): Boolean;
var
  client: TIdTCPClient;
  ReceivedStr: string;
begin
  Result:= False;
  client := TIdTCPClient.Create(nil);
  try
    client.host := AHost;
    client.port := APort;

    try
     client.Connect;
     ReceivedStr:= AnsiUpperCase(client.IOHandler.ReadLn );
     Result:= AnsiPos('SSH-2.0', UpperCase(ReceivedStr)) > 0;
    except
    end;

    client.Disconnect;
  finally

    client.Free;
  end;

End;



Function SFTPSimpleUploadFile(const AFileName: TFileName;
  const AHost: string; APort: Word;
  const AUsername: string; APassword: string;
  const ADestFile: string = '';
  const ATransferBinary: Boolean = True): Integer;

var SFTP: TTGPuttySFTP;
    OnlyFileName: AnsiString;
Begin
  Result:= -1;
  if not FileExists(AFileName) or
    (Trim(AHost) = EmptyStr) or
    (APort = 0) or
    (Trim(AUsername) = EmptyStr) or
    (Trim(APassword) = EmptyStr) then Exit;

  Result:= -2;
  if not CheckSFTPPort(AHost, APort) then Exit;

  Result:= 0;
  SFTP:= TTGPuttySFTP.Create(False);
  try
    SFTP.OnVerifyHostKey := TCallback.VerifyHostKey;

    SFTP.TimeoutTicks:= 5000;

    SFTP.UserName:= AnsiString(AUsername);
    SFTP.Password:= AnsiString(APassword);
    SFTP.HostName:= AnsiString(AHost);
    SFTP.port:= APort;

    try
      SFTP.Connect;
    except
     Result:= 1;
    end;

   if Result = 0  then
    try
      OnlyFileName:= AnsiString( ExtractFileName(AFileName) );
      SFTP.UploadFile(AnsiString(AFileName), OnlyFileName, False);
    except
     Result:= 1;
    end;

  finally
    SFTP.Disconnect;
    SFTP.Free;
  end;


End;

{ TSFTP }

class function TCallback.VerifyHostKey(const host: PAnsiChar; const port: Integer;
  const fingerprint: PAnsiChar; const verificationstatus: Integer;
  var storehostkey: Boolean): Boolean;
var AText: string;
begin
  if verificationstatus = 0 then
  begin
    Result := true;
    Exit;
  end;

  AText:= 'Please confirm the SSH host key fingerprint for ' +
    UTF8ToString(host) + ', port ' + IntToStr(port) + ':' +
    sLineBreak + Utf8ToString(AnsiString(fingerprint));

  Result := Application.MessageBox(
                                    PChar(AText),
                                    'Server Verification',
                                    MB_YESNO or MB_ICONQUESTION
                                   ) = IDYES;
  storehostkey := Result;
end;

end.
