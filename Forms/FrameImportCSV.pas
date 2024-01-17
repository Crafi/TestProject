unit FrameImportCSV;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.StdCtrls,
  Vcl.ExtCtrls, cxTextEdit, cxMemo, cxRichEdit;

type
  TLogType = (ltInform, ltError, ltSuccess);

  TfrmImportCSV = class(TFrame)
    edtImportFile: TEdit;
    btnSelectFile: TButton;
    OpenDialog1: TOpenDialog;
    reditLogs: TcxRichEdit;
    pnlContorl: TPanel;
    cbLogType: TComboBox;
    btnStartImport: TButton;
    lblDescroption: TLabel;
    procedure btnStartImportClick(Sender: TObject);
    procedure btnSelectFileClick(Sender: TObject);
  private
    procedure AddToLog(const AText: string; ALogType: TLogType);
  public
    constructor Create(AParent: TComponent); override;
  end;

implementation

uses
  System.IOUtils, Transactions.Manager, SQL.Constants;

const
  sCVSDescription = 'Import *.CVS files in the format - Customer_Code;Amount' + CRLF +
    'Example:' + CRLF +
    '3;300' + CRLF +
    '4;400';

{$R *.dfm}

procedure TfrmImportCSV.AddToLog(const AText: string; ALogType: TLogType);
begin
  case ALogType of
    ltInform:
    begin
      reditLogs.SelAttributes.Color := clBlack;
      reditLogs.SelAttributes.Style := [];
    end;
    ltError:
    begin
      reditLogs.SelAttributes.Color := clRed;
      reditLogs.SelAttributes.Style := [fsBold];
    end;
    ltSuccess:
    begin
      reditLogs.SelAttributes.Color := clGreen;
      reditLogs.SelAttributes.Style := [];
    end;
  end;
  //Remove all new line for log text
  reditLogs.Lines.Add(AText);
end;

procedure TfrmImportCSV.btnSelectFileClick(Sender: TObject);
var
  LOpenDialog: TOpenDialog;
begin
  LOpenDialog := TOpenDialog.Create(Self);
  try
    LOpenDialog.Filter := 'CSV|*.csv';
    if LOpenDialog.Execute then
      edtImportFile.Text := LOpenDialog.FileName;
  finally
    LOpenDialog.Free;
  end;
end;

procedure TfrmImportCSV.btnStartImportClick(Sender: TObject);
const
  sImportStarted = 'Import for file name %s started';
  sImportFinished = 'Import for file name %s finished';
  sIncorrectLine = 'Incorrect line - %s';
  sIncorrectIntegerType = 'Inccorrect integer type for - %s (line - %s)';
  sIncorrectFloatType = 'Inccorrect float type for - %s (line - %s)';
  sLineSuccess = 'Line import success - %s';
  sLineFailed = 'Line %s failed with error - %s';
  C_DELIMITER = ';';
  C_COLUMN_CODE_NAME = '"Code"';
  C_COLUMN_AMOUNT_NAME = '"Amount"';
  C_COUNT_LINE = 2;

var
  LFileName, LError: string;
  LCSVFile, LCSVLine: TStringList;
  i: Integer;
  LCustomerCode: Integer;
  LAmount: Double;
begin
  if edtImportFile.Text = EmptyStr then
  begin
    ShowMessage('The file name is empty!');
    Exit;
  end;

  LFileName := edtImportFile.Text;

  if not TFile.Exists(LFileName) then
  begin
    ShowMessage('File does not exist!');
    Exit;
  end;

  reditLogs.Clear;
  AddToLog(Format(sImportStarted, [LFileName]), ltInform);

  LCSVFile := nil;
  LCSVLine := nil;
  try
    LCSVFile := TStringList.Create;
    LCSVLine := TStringList.Create;

    LCSVLine.StrictDelimiter := True;
    LCSVLine.Delimiter := C_DELIMITER;

    LCSVFile.LoadFromFile(LFileName);
    for i := 0 to Pred(LCSVFile.Count) do
    begin
      LCSVLine.DelimitedText := LCSVFile[i];

      if LCSVLine.Count <> C_COUNT_LINE then
      begin
        AddToLog(Format(sIncorrectLine, [LCSVFile[i]]), ltError);
        Continue;
      end;

      //if file include haders on 1-th line
      if LCSVLine[0].Equals(C_COLUMN_CODE_NAME) and LCSVLine[1].Equals(C_COLUMN_AMOUNT_NAME) and (i = 0) then
        Continue;

      //try to convert string
      if not TryStrToInt(LCSVLine[0], LCustomerCode) then
      begin
        AddToLog(Format(sIncorrectIntegerType, [LCSVLine[0], LCSVFile[i]]), ltError);
        Continue;
      end;

      if not TryStrToFloat(LCSVLine[1], LAmount) then
      begin
        AddToLog(Format(sIncorrectFloatType, [LCSVLine[0], LCSVFile[i]]), ltError);
        Continue;
      end;

      if TransactionsManager.AddTransaction(LCustomerCode, LAmount, LError) then
      begin
        if cbLogType.ItemIndex = 1 then
          AddToLog(Format(sLineSuccess, [LCSVFile[i]]), ltSuccess);
      end
      else
        AddToLog(Format(sLineFailed, [LCSVFile[i], LError]), ltError);
    end;

    AddToLog(Format(sImportFinished, [LFileName]), ltInform);
  finally
    LCSVFile.Free;
    LCSVLine.Free;
  end;
end;

constructor TfrmImportCSV.Create(AParent: TComponent);
begin
  inherited Create(AParent);
  lblDescroption.Caption := sCVSDescription;
  lblDescroption.Width := pnlContorl.Width -  lblDescroption.Left;
end;

end.
