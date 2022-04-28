unit SpkTypes;

interface

{$I Spk.inc}

uses
  Windows,
  Controls,
  Classes,
  ContNrs,
  Dialogs,
  Forms,
  Messages,
  Graphics,
  SysUtils,
  SpkMath;

type
  InternalException = class(Exception);
  AssignException = class(Exception);
  RuntimeException = class(Exception);
  ListException = class(Exception);

  /// <summary>
  ///
  /// </summary>
  TSpkBaseDispatch = class abstract(TObject);

  TSpkBaseAppearanceDispatch = class abstract(TSpkBaseDispatch)
  public
    procedure NotifyAppearanceChanged; virtual; abstract;
  end;

  TSpkBaseToolbarDispatch = class abstract(TSpkBaseAppearanceDispatch)
  public
    function GetTempBitmap: TBitmap; virtual; abstract;
    function ClientToScreen(Point: T2DIntPoint): T2DIntPoint; virtual; abstract;
    procedure NotifyItemsChanged; virtual; abstract;
    procedure NotifyMetricsChanged; virtual; abstract;
    procedure NotifyVisualsChanged; virtual; abstract;
  end;

  /// <summary>
  ///
  /// </summary>
  TSpkListState = (lsNeedsProcessing, lsReady);

  /// <summary>
  ///
  /// </summary>
  TSpkCollection = class(TPersistent)
  protected
    fList: TObjectList;
    fNames: TStringList;
    fListState: TSpkListState;
    fRootComponent: TComponent;
    // Getters and setters
    function GetItems(aIndex: integer): TComponent; virtual;
    // Methods responding to changes in list
    procedure Notify(Item: TComponent; Operation: TOperation); virtual;
    procedure Update; virtual;
  public
    constructor Create(aRootComponent : TComponent); reintroduce; virtual;
    destructor Destroy; override;
    /// List operations
    function Count: integer;
    function IndexOf(Item: TComponent) : integer;
    procedure AddItem(aItem: TComponent);
    procedure InsertItem(aIndex: integer; aItem: TComponent);
    procedure Clear;
    procedure Delete(aIndex: integer); virtual;
    procedure Remove(Item: TComponent); virtual;
    procedure RemoveReference(Item: TComponent);
    procedure Exchange(item1, item2: integer);
    procedure Move(IndexFrom, IndexTo: integer);
    /// Reader, writer and operation designtime and DFM
    procedure WriteNames(Writer: TWriter); virtual;
    procedure ReadNames(Reader: TReader); virtual;
    procedure ProcessNames(Owner: TComponent); virtual;
    procedure UpdateActions; virtual;
  public
    property ListState: TSpkListState read fListState;
    property Items[index: integer] : TComponent read GetItems; default;
    property RootComponent: TComponent read fRootComponent;
  end;

  /// <summary>
  ///
  /// </summary>
  TSpkComponent = class(TComponent)
  protected
    fParent: TComponent;
    fCollection: TSpkCollection;
    function GetSubCollection: TSpkCollection; virtual;
    procedure SetParent(Value: TComponent);
  protected
    property SubCollection: TSpkCollection read GetSubCollection;
  public
    function DPIScale(aSize: Integer): Integer;
    function HasParent: boolean; override;
    function GetParentComponent: TComponent; override;
    procedure SetParentComponent(Value: TComponent); override;
    procedure InitiateAction; virtual;
  public
    property Parent: TComponent read fParent write SetParent;
    property Collection: TSpkCollection read fCollection;
  end;

  /// <summary>
  ///
  /// </summary>
  TSpkCustomControl = class(TCustomControl)
  protected
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure WMEraseBkGnd(var Message: TMessage); message WM_ERASEBKGND;
  protected
    procedure MouseEnter; dynamic;
    procedure MouseLeave; dynamic;
  end;

implementation

{ TSpkCollection }

constructor TSpkCollection.Create(aRootComponent: TComponent);
begin
  inherited Create;
  fRootComponent := aRootComponent;
  fNames := TStringList.Create;
  fList := TObjectList.Create(False);
  fListState := lsReady;
end;

destructor TSpkCollection.Destroy;
begin
  fNames.Free;
  fList.Free;
  inherited;
end;

procedure TSpkCollection.AddItem(aItem: TComponent);
begin
  // This method can be recalling untreated names (in particular, the method
  // that processes the name uses the AddItem)

  Notify(aItem, opInsert);
  fList.Add(aItem);

  if aItem is TSpkComponent then
    TSpkComponent(aItem).fCollection := self;

  Update;
end;

procedure TSpkCollection.Clear;
begin
  fList.Clear;
  Update;
end;

function TSpkCollection.Count: Integer;
begin
  Result := fList.Count;
end;

procedure TSpkCollection.Delete(aIndex: Integer);
begin
  if (aIndex < 0) or (aIndex >= fList.count) then
    raise InternalException.Create('TSpkCollection.Delete: Illegal index!');

  Notify(TComponent(fList[aIndex]), opRemove);
  fList.Delete(aIndex);
  Update;
end;

procedure TSpkCollection.Exchange(item1, item2: Integer);
begin
  fList.Exchange(item1, item2);
  Update;
end;

function TSpkCollection.GetItems(aIndex: Integer): TComponent;
begin
  if (aIndex < 0) or (aIndex >= fList.Count) then
    raise InternalException.Create('TSpkCollection.Delete: Illegal index!');

  Result := TComponent(fList[aIndex]);
end;

function TSpkCollection.IndexOf(Item: TComponent): Integer;
begin
  result := fList.IndexOf(Item);
end;

procedure TSpkCollection.InsertItem(aIndex: Integer; aItem: TComponent);
begin
  if (aIndex < 0) or (aIndex > fList.Count) then
    raise InternalException.Create('TSpkCollection.Delete: Illegal index!');

  Notify(aItem, opInsert);
  fList.Insert(aIndex, aItem);
  if aItem is TSpkComponent then
    TSpkComponent(aItem).fCollection := self;
  Update;
end;

procedure TSpkCollection.Move(IndexFrom, IndexTo: Integer);
begin
  if (IndexFrom < 0) or (IndexFrom >= fList.Count) or
     (IndexTo < 0) or (IndexTo >= fList.Count)
  then
    raise InternalException.Create('TSpkCollection.Delete: Illegal index!');

  fList.Move(IndexFrom, IndexTo);
  Update;
end;

procedure TSpkCollection.Notify(Item: TComponent; Operation: TOperation);
begin
//
end;

procedure TSpkCollection.ProcessNames(Owner: TComponent);
var
  s: string;
begin
  fList.Clear;
  if Owner <> nil then
    for s in fNames do
      AddItem(Owner.FindComponent(s));
  fNames.Clear;
  fListState := lsReady;
end;

procedure TSpkCollection.ReadNames(Reader: TReader);
begin
  Reader.ReadListBegin;
  fNames.Clear;
  while not(Reader.EndOfList) do
    fNames.Add(Reader.ReadString);
  Reader.ReadListEnd;
  fListState := lsNeedsProcessing;
end;

procedure TSpkCollection.Remove(Item: TComponent);
var
  i: integer;
begin
  i := fList.IndexOf(Item);
  if i >= 0 then
  begin
    Notify(Item, opRemove);
    fList.Delete(i);
    Update;
  end;
end;

procedure TSpkCollection.RemoveReference(Item: TComponent);
var
  i: integer;
begin
  i := fList.IndexOf(Item);
  if i >= 0 then
  begin
    Notify(Item, opRemove);
    fList.Extract(Item);
    Update;
  end;
end;

procedure TSpkCollection.Update;
begin
  //
end;

procedure TSpkCollection.UpdateActions;
var
  i: Integer;
begin
  for i := 0 to fList.Count - 1 do
    if fList.Items[i] is TSpkComponent then
    begin
      TSpkComponent(fList.Items[i]).InitiateAction;
      if Assigned(TSpkComponent(fList.Items[i]).SubCollection) then
        TSpkComponent(fList.Items[i]).SubCollection.UpdateActions;
    end;
end;

procedure TSpkCollection.WriteNames(Writer: TWriter);
var
  i: Integer;
begin
  Writer.WriteListBegin;
  for i := 0 to fList.Count - 1 do
    Writer.WriteString(TComponent(fList[i]).Name);
  Writer.WriteListEnd;
end;

{ TSpkComponent }

function TSpkComponent.GetSubCollection: TSpkCollection;
begin
  Result := nil;
end;

function TSpkComponent.DPIScale(aSize: Integer): Integer;
begin
  Result := MulDiv(aSize, Screen.PixelsPerInch, 96);
end;

function TSpkComponent.GetParentComponent: TComponent;
begin
  Result := fParent;
end;

function TSpkComponent.HasParent: Boolean;
begin
  Result := (fParent <> nil);
end;

procedure TSpkComponent.InitiateAction;
begin

end;

procedure TSpkComponent.SetParent(Value: TComponent);
begin
  fParent := Value;
end;

procedure TSpkComponent.SetParentComponent(Value: TComponent);
begin
  SetParent(Value);
end;

{ TSpkCustomControl }

procedure TSpkCustomControl.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  MouseEnter;
end;

procedure TSpkCustomControl.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  MouseLeave;
end;

procedure TSpkCustomControl.MouseEnter;
begin

end;

procedure TSpkCustomControl.MouseLeave;
begin

end;

procedure TSpkCustomControl.WMEraseBkGnd(var Message: TMessage);
begin
  Message.Result := 1;
end;

end.
