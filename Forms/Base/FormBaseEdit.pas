unit FormBaseEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmBaseEdit = class(TForm)
    Panel1: TPanel;
    btnOk: TButton;
    btnCancel: TButton;
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtFloatKeyPress(Sender: TObject; var Key: Char);
    procedure edtIntegerKeyPress(Sender: TObject; var Key: Char);
    procedure edtFloatNegativeKeyPress(Sender: TObject; var Key: Char);
  private
    //Can use for check dublicate without current ID or etc
    FID: Integer;
  protected
    function CheckInputValue(var AKey: Word; var AKeyChar: Char;
      const AEdt: TEdit; AIsNegative: Boolean; AIsCommaInput: Boolean = True): Boolean;
    function CheckData: Boolean; virtual; abstract;
  public
    constructor Create(AOwner: TComponent); override;

    property ID: Integer read FID write FID;
  end;
var
  frmBaseEdit: TfrmBaseEdit;

implementation

uses
  System.RegularExpressions, System.UITypes;

{$R *.dfm}

function TfrmBaseEdit.CheckInputValue(var AKey: Word; var AKeyChar: Char;
  const AEdt: TEdit; AIsNegative, AIsCommaInput: Boolean): Boolean;
var
  S: string;
begin
  Result := True;

  if not AEdt.ReadOnly then
  begin
    if not (AKey in [vkDelete, vkBack, vkLeft, vkRight, vkHome, vkEnd, vkReturn]) then
    begin
      if CharInSet(AKeyChar, [',', '.']) then
        AKeyChar := FormatSettings.DecimalSeparator;

      if ((AEdt.SelLength = Length(AEdt.Text)) and (CharInSet(AKeyChar, ['0'..'9', '.', ',', '-'])) and AIsNegative)
        or ((AEdt.SelLength = Length(AEdt.Text)) and (CharInSet(AKeyChar, ['0'..'9', '.', ','])) and not AIsNegative) then
        AEdt.Text := EmptyStr;

      S := AEdt.Text;
      Insert(AKeyChar, S, AEdt.SelStart + 1);

      if AIsCommaInput then
      begin
        if AIsNegative then
          Result := TRegex.IsMatch(S, '^([-]?[0-9]*){1}(([.]|[,]){1}[0-9]*)?$')
        else
          Result := TRegEx.IsMatch(S, '^[0-9]+(([.]|[,]){1}[0-9]*)?$');
      end
      else
      begin
        if AIsNegative then
          Result := TRegEx.IsMatch(S, '^[-]?[0-9]+$')
        else
          Result := TRegEx.IsMatch(S, '^[0-9]+$');
      end;
    end;
  end;
end;

procedure TfrmBaseEdit.edtIntegerKeyPress(Sender: TObject; var Key: Char);
begin
  if not CheckInputValue(Word(Key), Key, TEdit(Sender), False, False) then
    Abort;
end;

constructor TfrmBaseEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FID := -1;
end;

procedure TfrmBaseEdit.edtFloatKeyPress(Sender: TObject; var Key: Char);
begin
  if not CheckInputValue(Word(Key), Key, TEdit(Sender), False, True) then
    Abort;
end;

procedure TfrmBaseEdit.edtFloatNegativeKeyPress(Sender: TObject; var Key: Char);
begin
  if not CheckInputValue(Word(Key), Key, TEdit(Sender), True, True) then
    Abort;
end;

procedure TfrmBaseEdit.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (ModalResult = mrOk) and (not CheckData) then
    ModalResult := mrNone;
end;

procedure TfrmBaseEdit.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    ModalResult := MrOk;
end;

end.
