unit uFTP;

interface

uses
  System.SysUtils, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdFTP;

Function FTPSimpleUploadFile(const AFileName: TFileName;
  const AHost: string; APort: Word;
  const AUsername: string; APassword: string;
  const ADestFile: string = '';
  const ATransferBinary: Boolean = True): Integer;


implementation

uses IdFTPCommon;


Function FTPSimpleUploadFile(const AFileName: TFileName;
  const AHost: string; APort: Word;
  const AUsername: string;  APassword: string;
  const ADestFile: string = '';
  const ATransferBinary: Boolean = True): Integer;

var FTP: TIdFTP;
begin
  Result:= -1;
  if not FileExists(AFileName) or
    (Trim(AHost) = EmptyStr) or
    (APort = 0) or
    (Trim(AUsername) = EmptyStr) or
    (Trim(APassword) = EmptyStr) then Exit;

  Result:= 0;
  FTP:= TIdFTP.Create(nil);
  try
    FTP.Host:= AHost;
    FTP.Port:= APort;

    FTP.Username:= AUsername;
    FTP.Password:= APassword;

    FTP.Passive:= True;

    FTP.TransferType:= ftASCII;
    if ATransferBinary then
     FTP.TransferType:= ftBinary;

    try
     FTP.Connect;
    except
      Result:= 1;
    end;

    if Result = 0 then
     try
      FTP.Put(AFileName, ADestFile);
     except
      Result:= 2;
     end;

  finally
   FTP.Disconnect;
   FTP.Free;
  end;

End;

end.
