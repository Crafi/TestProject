unit FrameBaseView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, dxDateRanges,
  dxScrollbarAnnotations, Data.DB, cxDBData, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmBaseView = class(TFrame)
    pnlControl: TPanel;
    btnAdd: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    Grid: TcxGrid;
    TableView: TcxGridDBTableView;
    GridLevel: TcxGridLevel;
    FDQuery: TFDQuery;
    DataSource: TDataSource;
    btnRefresh: TButton;
    procedure btnAddClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
  private
    FDoAdd: TFunc<Boolean>;
    FDoEdit: TFunc<Integer, Boolean>;
    FDoDelete: TFunc<Integer, Boolean>;

    FIDName: string;

    function GetSelectedRowID: Integer;

    procedure RefreshUI;
    procedure DoRefreshUI(Sender: TObject);
  public
    constructor Create(AParent: TComponent); override;

    procedure InitData(const ASQL: string; AColumnsName, AColumnsCaption: TArray<string>;
      const AIDName: string = 'ID');

    property DoAdd: TFunc<Boolean> write FDoAdd;
    property DoDelete: TFunc<Integer, Boolean> write FDoDelete;
    property DoEdit: TFunc<Integer, Boolean> write FDoEdit;
  end;

implementation

uses
  cxPC;

{$R *.dfm}

{ TFrame1 }

procedure TfrmBaseView.btnAddClick(Sender: TObject);
begin
  if Assigned(FDoAdd) and FDoAdd then
    RefreshUI;
end;

procedure TfrmBaseView.btnDeleteClick(Sender: TObject);
var
  LID: Integer;
begin
  if FDQuery.RecordCount = 0 then
    Exit;

  LID := GetSelectedRowID;
  if (LID <> -1) and Assigned(FDoDelete) then
  begin
    if MessageDlg('Delete selected row?', mtConfirmation, [mbYes, mbNo], 0) = IDYES then
    begin
      if FDoDelete(LID) then
        RefreshUI;
    end;
  end;
end;

procedure TfrmBaseView.btnEditClick(Sender: TObject);
var
  LID: Integer;
begin
  if FDQuery.RecordCount = 0 then
    Exit;

  LID := GetSelectedRowID;
  if (LID <> -1) and Assigned(FDoEdit) then
  begin
    if FDoEdit(LID) then
      RefreshUI;
  end;
end;

procedure TfrmBaseView.btnRefreshClick(Sender: TObject);
begin
  RefreshUI;
end;

constructor TfrmBaseView.Create(AParent: TComponent);
begin
  inherited Create(AParent);

  //Added resfresh for onShow in parent (TFrame not have OnShow event)
  if AParent is TcxTabSheet then
    TcxTabSheet(AParent).OnShow := DoRefreshUI;
end;

procedure TfrmBaseView.DoRefreshUI(Sender: TObject);
begin
  RefreshUI;
end;

function TfrmBaseView.GetSelectedRowID: Integer;
var
  LField: TField;
begin
  Result := -1;
  LField := FDQuery.FindField(FIDName);
  if Assigned(LField) then
    Result := LField.AsInteger;
end;

procedure TfrmBaseView.InitData(const ASQL: string; AColumnsName,
  AColumnsCaption: TArray<string>; const AIDName: string);
var
  i: Integer;
  LColumn: TcxGridDBColumn;
begin
  FDQuery.Open(ASQL);

  for i := 0 to Pred(Length(AColumnsName)) do
  begin
    LColumn := TableView.CreateColumn;
    LColumn.DataBinding.FieldName := AColumnsName[i];

    if i < Length(AColumnsCaption) then
      LColumn.Caption := AColumnsCaption[i];
  end;

  FIDName := AIDName;
end;

procedure TfrmBaseView.RefreshUI;
begin
  FDQuery.Refresh;
end;

end.
