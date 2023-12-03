unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, SynEdit,
  SynEditHighlighter, SynHighlighterSQL, Vcl.Samples.Spin, Vcl.ComCtrls;

type
  TDB_Type = (tFirebird = 0, tOracle = 1);

  TForm1 = class(TForm)
    SynSQL: TSynSQLSyn;
    SynEdit1: TSynEdit;
    TabControl1: TTabControl;
    btnCreate: TButton;
    cbDefNull: TCheckBox;
    cbDataType: TComboBox;
    edField: TEdit;
    edTable: TEdit;
    lbTable: TLabel;
    lbField: TLabel;
    lbType: TLabel;
    rgDataBaseType: TRadioGroup;
    GroupBox1: TGroupBox;
    cbNotUseRestrictions: TCheckBox;
    lbScale: TLabel;
    lbPrecision: TLabel;
    sePrecision: TSpinEdit;
    seScale: TSpinEdit;
    cbChars: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure btnCreateClick(Sender: TObject);
    procedure rgDataBaseTypeClick(Sender: TObject);
    procedure cbDataTypeChange(Sender: TObject);
    procedure cbNotUseRestrictionsClick(Sender: TObject);
  private
    { Private declarations }

    FValue: TDB_Type;
    function UniversalCheck(const AName: string): Boolean;

    Function GetTableName(out ATableName: string): Boolean;
    Function GetFieldName(out AFieldName: string): Boolean;
    Function GetDataTypeName(out ADataTypeName: string): Boolean;

    procedure SetDB(const AValue: TDB_Type);
    Procedure CreateQuery;

    function QuotedStr2(const AStr: string): string;


  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

Uses StrUtils;

{$R *.dfm}

{ TForm1 }


type
  TField = record
   DataType: string;
   Precision: Boolean;
   PrecisionMax: Word;
   Chars: Boolean;
   UseChars: Boolean;
   Scale: Boolean;
   ScaleMax: Word;
  end;
  PField = ^TField;

 TFieldArray = array of TField;

const
  cNumberChars = '1234567890';
  cIncorrectChars = '!@#$%^&*()+-={}:|<>?[];\,./''';
  cDefNull = 'DEFAULT null';

  cFB_ADD_Query = 'EXECUTE BLOCK'                    + sLineBreak+
              'AS'                               + sLineBreak+
              'DECLARE CNT INTEGER;'             + sLineBreak+
              'BEGIN'                            + sLineBreak+
              '  Select count(*)'                + sLineBreak+
              '    from rdb$relation_fields'     + sLineBreak+
              '    where rdb$relation_name = %s' + sLineBreak+
              '        and rdb$field_name = %s'  + sLineBreak+
              '    INTO :CNT;'                   + sLineBreak+
              ''                                 + sLineBreak+
              '  IF (CNT = 0) THEN'              + sLineBreak+
              '    EXECUTE STATEMENT ''ALTER TABLE %s ADD %s %s %s'';' + sLineBreak+
              'END';

  cOracle_ADD_Query = 'DECLARE CNT NUMBER;'         + sLineBreak+
                  'BEGIN'                       + sLineBreak+
                  '  SELECT COUNT(*) INTO CNT'  + sLineBreak+
                  '    FROM user_tab_columns'   + sLineBreak+
                  '    WHERE table_name = %s'   + sLineBreak+
                  '      AND COLUMN_NAME = %s;'  + sLineBreak+
                  ''                            + sLineBreak+
                  '  IF (CNT = 0) THEN'         + sLineBreak+
                  '    EXECUTE IMMEDIATE ''ALTER TABLE %s ADD %s %s %s'';'+ sLineBreak+
                  '  END IF;'                   + sLineBreak+
                  'END;';


//  cFB_Change_Type_Query = 'EXECUTE BLOCK'                    + sLineBreak+
//              'AS'                               + sLineBreak+
//              'DECLARE CNT INTEGER;'             + sLineBreak+
//              'BEGIN'                            + sLineBreak+
//              '  Select count(*)'                + sLineBreak+
//              '    from rdb$relation_fields'     + sLineBreak+
//              '    where rdb$relation_name = %s' + sLineBreak+
//              '        and rdb$field_name = %s'  + sLineBreak+
//              '    INTO :CNT;'                   + sLineBreak+
//              ''                                 + sLineBreak+
//              '  IF (CNT = 1) THEN'              + sLineBreak+
//              '    EXECUTE STATEMENT ''alter table %s alter column %s type %s %s'';' + sLineBreak+
//              'END';
//
//  cOracle_Change_Type_Query = 'DECLARE CNT NUMBER;'         + sLineBreak+
//                  'BEGIN'                       + sLineBreak+
//                  '  SELECT COUNT(*) INTO CNT'  + sLineBreak+
//                  '    FROM user_tab_columns'   + sLineBreak+
//                  '    WHERE table_name = %s'   + sLineBreak+
//                  '      AND COLUMN_NAME = %s;'  + sLineBreak+
//                  ''                            + sLineBreak+
//                  '  IF (CNT = 1) THEN'         + sLineBreak+
//                  '    EXECUTE IMMEDIATE ''ALTER TABLE %s MODIFY (%s %s %s)'';'+ sLineBreak+
//                  '  END IF;'                   + sLineBreak+
//                  'END;';

  cFB_Change_Type_Query = 'ALTER TABLE %s ALTER COLUMN %s TYPE %s %s';
  cOracle_Change_Type_Query = 'ALTER TABLE %s MODIFY (%s %s %s)';


  cFB_Types_Arr: array[0..11] of TField =  (
                  (DataType: 'VARCHAR';     Precision: True;  PrecisionMax: 32765;  Chars: False; UseChars: False; Scale: False; ScaleMax: 0),
                  (DataType: 'SMALLINT';    Precision: False; PrecisionMax: 0;      Chars: False; UseChars: False; Scale: False; ScaleMax: 0),
                  (DataType: 'INTEGER';     Precision: False; PrecisionMax: 0;      Chars: False; UseChars: False; Scale: False; ScaleMax: 0),
                  (DataType: 'DOUBLE PRECISION'; Precision: False; PrecisionMax: 0; Chars: False; UseChars: False; Scale: False; ScaleMax: 0),
                  (DataType: 'DATE';        Precision: False; PrecisionMax: 0;      Chars: False; UseChars: False; Scale: False; ScaleMax: 0),
                  (DataType: 'TIME';        Precision: False; PrecisionMax: 0;      Chars: False; UseChars: False; Scale: False; ScaleMax: 0),

                  (DataType: 'TIMESTAMP';   Precision: False; PrecisionMax: 0;      Chars: False; UseChars: False; Scale: False; ScaleMax: 0),
                  (DataType: 'BIGINT';      Precision: False; PrecisionMax: 0;      Chars: False; UseChars: False; Scale: False; ScaleMax: 0),
                  (DataType: 'FLOAT';       Precision: False; PrecisionMax: 0;      Chars: False; UseChars: False; Scale: False; ScaleMax: 0),
                  (DataType: 'NUMERIC';     Precision: True;  PrecisionMax: 18;     Chars: False; UseChars: False; Scale: True;  ScaleMax: 18),
                  (DataType: 'DECIMAL';     Precision: True;  PrecisionMax: 18;     Chars: False; UseChars: False; Scale: True;  ScaleMax: 18),
                  (DataType: 'CHAR';        Precision: True;  PrecisionMax: 32767;  Chars: False; UseChars: False; Scale: False; ScaleMax: 0)
                  );

  cOra_Types_Arr: array[0..17] of TField = (
                  (DataType: 'numeric';     Precision: True;  PrecisionMax: 38;   Chars: False; UseChars: False; Scale: True;  ScaleMax: 127),
                  (DataType: 'varchar2';    Precision: True;  PrecisionMax: 4000; Chars: True;  UseChars: True; Scale: False; ScaleMax: 0),
                  (DataType: 'date';        Precision: False; PrecisionMax: 0;    Chars: False; UseChars: False; Scale: False; ScaleMax: 0),
                  (DataType: 'BOOLEAN';     Precision: False; PrecisionMax: 0;    Chars: False; UseChars: False; Scale: False; ScaleMax: 0),
                  (DataType: 'dec';         Precision: True;  PrecisionMax: 38;   Chars: False; UseChars: False; Scale: True;  ScaleMax: 0),
                  (DataType: 'number';      Precision: True;  PrecisionMax: 38;   Chars: False; UseChars: False; Scale: True;  ScaleMax: 127),

                  (DataType: 'decimal';     Precision: True;  PrecisionMax: 38;   Chars: False; UseChars: False; Scale: True;  ScaleMax: 0),
                  (DataType: 'PLS_INTEGER'; Precision: False; PrecisionMax: 0;    Chars: False; UseChars: False; Scale: False; ScaleMax: 0),
                  (DataType: 'char';        Precision: True;  PrecisionMax: 2000; Chars: False; UseChars: False; Scale: False; ScaleMax: 0),
                  (DataType: 'nchar';       Precision: True;  PrecisionMax: 2000; Chars: False; UseChars: False; Scale: False; ScaleMax: 0),
                  (DataType: 'nvarchar2';   Precision: True;  PrecisionMax: 4000; Chars: True;  UseChars: True; Scale: False; ScaleMax: 0),
                  (DataType: 'long';        Precision: False; PrecisionMax: 0;    Chars: False; UseChars: False; Scale: False; ScaleMax: 0),

                  (DataType: 'raw';         Precision: False; PrecisionMax: 0;    Chars: False; UseChars: False; Scale: False; ScaleMax: 0),
                  (DataType: 'long raw';    Precision: False; PrecisionMax: 0;    Chars: False; UseChars: False; Scale: False; ScaleMax: 0),
                  (DataType: 'bfile';       Precision: False; PrecisionMax: 0;    Chars: False; UseChars: False; Scale: False; ScaleMax: 0),
                  (DataType: 'blob';        Precision: False; PrecisionMax: 0;    Chars: False; UseChars: False; Scale: False; ScaleMax: 0),
                  (DataType: 'clob';        Precision: False; PrecisionMax: 0;    Chars: False; UseChars: False; Scale: False; ScaleMax: 0),
                  (DataType: 'nclob';       Precision: False; PrecisionMax: 0;    Chars: False; UseChars: False; Scale: False; ScaleMax: 0)
                  );



function TForm1.UniversalCheck(const AName: string): Boolean;
var tmpStr: string;
    i:Integer;
begin
  tmpStr := Trim(AName);

  Result:= (tmpStr <> EmptyStr) and
           (AnsiPos( tmpStr[Low(tmpStr) ], cNumberChars) = 0) and //Первый символ не может быть числом
           (tmpStr[Low(tmpStr)] <> '_');                          //и символом подчёркивания "_"

  // Проверяю на запрещённые символы
  if Result then
   for I := Low(tmpStr) to High(tmpStr) do
    if AnsiPos( tmpStr[i], cIncorrectChars) <> 0 then
     Exit(False);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  SetDB( tFirebird );
end;

function TForm1.GetDataTypeName(out ADataTypeName: string): Boolean;
const cPostfixIntInt = '(%d, %d)';
      cPostfixInt    = '(%d)';
      cPostfixChar   = '(%d CHAR)';

var tmpDataTypeName: string;
begin
  ADataTypeName:= EmptyStr;

  tmpDataTypeName := AnsiUpperCase( Trim(cbDataType.Text) );
  Result:= UniversalCheck(tmpDataTypeName);
  if Result then
   Begin
     if sePrecision.Visible and (sePrecision.Value <> 0) then
      if seScale.Visible then
        tmpDataTypeName:= Format(tmpDataTypeName + cPostfixIntInt, [sePrecision.Value, seScale.Value] )
       else if cbChars.Visible and cbChars.Checked then
         tmpDataTypeName:= Format(tmpDataTypeName + cPostfixChar, [sePrecision.Value] )
        else
         tmpDataTypeName:= Format(tmpDataTypeName + cPostfixInt, [sePrecision.Value] );

     ADataTypeName:= tmpDataTypeName;
   End
  else
   ShowMessage('Ошибка в типе данных!');
end;

function TForm1.GetFieldName(out AFieldName: string): Boolean;
var tmpFieldName: string;
begin
  AFieldName:= EmptyStr;

  tmpFieldName := AnsiUpperCase( Trim(edField.Text) );
  Result:= UniversalCheck(tmpFieldName);
  if Result then
   AFieldName:= tmpFieldName
  else
   ShowMessage('Ошибка в имени поля!');
end;

function TForm1.GetTableName(out ATableName: string): Boolean;
var tmpTableName: string;
begin
  ATableName:= EmptyStr;

  tmpTableName := AnsiUpperCase( Trim(edTable.Text) );
  Result:= UniversalCheck(tmpTableName);
  if Result then
   ATableName:= tmpTableName
  else
   ShowMessage('Ошибка в имени таблицы!');
end;

function TForm1.QuotedStr2(const AStr: string): string;
begin
  Result:=  IfThen( TabControl1.TabIndex = 0, QuotedStr(AStr), AStr);
end;

procedure TForm1.rgDataBaseTypeClick(Sender: TObject);
begin
  SetDB( TDB_Type(rgDataBaseType.ItemIndex) );
end;

procedure TForm1.SetDB(const AValue: TDB_Type);
var  i: Integer;
     pf: PField;
     max_arr: Integer;
begin
  pf:= nil;
  max_arr:= 0;

  FValue:= AValue;
  cbDataType.Clear;

//  case AValue of
//   tFirebird : Begin
//                for i := Low(cFB_Types_Arr) to High(cFB_Types_Arr) do
//                  cbDataType.Items.Add(cFB_Types_Arr[i].DataType);
//               End;
//
//   tOracle   : Begin
//                for i := Low(cOra_Types_Arr) to High(cOra_Types_Arr) do
//                 cbDataType.Items.Add(cOra_Types_Arr[i].DataType);
//               End;
//  end; //case


  case AValue of
   tFirebird : Begin
                pf:= @cFB_Types_Arr[0];
                max_arr:= High(cFB_Types_Arr);
               End;


   tOracle   : Begin
                pf:= @cOra_Types_Arr[0];
                max_arr:= High(cOra_Types_Arr);
               End;
  end; //case

  if Assigned(pf) and (max_arr > 0) then
   for i := 0 to max_arr do
    Begin
     cbDataType.Items.Add(pf^.DataType);
     Inc(pf);
    End;

end;

procedure TForm1.cbDataTypeChange(Sender: TObject);

  procedure SetField(const Source: TField);
  Begin
    with Source do
     begin
       lbPrecision.Visible:= Precision;
       sePrecision.Visible:= Precision;
       sePrecision.MaxValue:= PrecisionMax;

       cbChars.Visible:= Chars;
       cbChars.Checked:= UseChars;

       lbScale.Visible:= Scale;
       seScale.Visible:= Scale;
       seScale.MaxValue:= ScaleMax;
      End;
  End;

begin
  sePrecision.Value:= 0;
  cbChars.Checked:= False;
  seScale.Value:= 0;

  cbNotUseRestrictions.Visible:= cbDataType.ItemIndex < 0;
  if cbDataType.ItemIndex < 0 then
   Begin
    lbPrecision.Visible:= True;
    sePrecision.Visible:= True;
    cbChars.Visible:= True;
    lbScale.Visible:= True;
    seScale.Visible:= True;

    cbNotUseRestrictionsClick(nil);
    Exit;
   end;

  case FValue of
   tFirebird : SetField( cFB_Types_Arr[cbDataType.ItemIndex]  );
   tOracle   : SetField( cOra_Types_Arr[cbDataType.ItemIndex] );
  end; //case

end;

procedure TForm1.cbNotUseRestrictionsClick(Sender: TObject);
var ValBool: Boolean;
begin
   if not cbNotUseRestrictions.Visible then Exit;

   ValBool:= not cbNotUseRestrictions.Checked;

   lbPrecision.Visible:= ValBool;

   sePrecision.Visible:= ValBool;
   sePrecision.MaxValue:= 65536;

   cbChars.Visible:= ValBool;
   lbScale.Visible:= ValBool;

   seScale.Visible:= ValBool;
   seScale.MaxValue:= 65536;
end;

procedure TForm1.btnCreateClick(Sender: TObject);
begin
  CreateQuery;
end;

procedure TForm1.CreateQuery;
var Query, Table, Field, DataType, DefNull: string;
begin
  SynEdit1.Text:= EmptyStr;

  if GetTableName(Table) and
     GetFieldName(Field) and
     GetDataTypeName(DataType) then
   Begin
     DefNull := IfThen(cbDefNull.Checked, cDefNull);

     case rgDataBaseType.ItemIndex of
      0: Query:= IfThen( TabControl1.TabIndex = 0, cFB_ADD_Query, cFB_Change_Type_Query);
      1: Query:= IfThen( TabControl1.TabIndex = 0, cOracle_ADD_Query, cOracle_Change_Type_Query);
     end;//case

     case TabControl1.TabIndex of
      0: SynEdit1.Text:= Format(Query,[QuotedStr2(Table), QuotedStr2(Field),
                                       Table, Field, DataType, DefNull] );

      1: SynEdit1.Text:= Format(Query,[QuotedStr2(Table), QuotedStr2(Field),
                                       DataType, DefNull] );
     end;// case

   End;

end;



end.
