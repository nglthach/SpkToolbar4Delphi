unit SpkTab;

interface

{$I Spk.inc}

uses
  Graphics,
  Controls,
  Classes,
  SysUtils,
  SpkMath,
  SpkAppearance,
  SpkConst,
  SpkPane,
  SpkTypes;

type
  TSpkTab = class;

  TSpkMouseTabElementType = (etNone, etTabArea, etPane);

  TSpkMouseTabElement = record
    ElementType: TSpkMouseTabElementType;
    ElementIndex: Integer;
  end;

  /// <summary>
  ///
  /// </summary>
  TSpkTabAppearanceDispatch = class(TSpkBaseAppearanceDispatch)
  private
    fTab: TSpkTab;
  public
    constructor Create(aTab: TSpkTab);
    procedure NotifyAppearanceChanged; override;
  end;

  /// <summary>
  ///
  /// </summary>
  TSpkTab = class(TSpkComponent)
  public
    const UNDEFINED_PANE_INDEX = -1;
  private
    fAppearanceDispatch: TSpkTabAppearanceDispatch;
    fAppearance: TSpkToolbarAppearance;
    fMouseHoverElement: TSpkMouseTabElement;
    fMouseActiveElement: TSpkMouseTabElement;
    fOnClick: TNotifyEvent;
  protected
    fToolbarDispatch: TSpkBaseToolbarDispatch;
    fCaption: string;
    fVisible: Boolean;
    fOverrideAppearance: Boolean;
    fCustomAppearance: TSpkToolbarAppearance;
    fPanes: TSpkPanes;
    fRect: T2DIntRect;
    fImages: TImageList;
    fDisabledImages: TImageList;
    fLargeImages: TImageList;
    fDisabledLargeImages: TImageList;
    fImagesWidth: Integer;
    fLargeImagesWidth: Integer;
    // *** Sets the appropriate appearance tiles ***
    function GetSubCollection: TSpkCollection; override;
    procedure SetPaneAppearance; inline;
    // *** Sheet search ***
    function FindPaneAt(x, y: Integer): Integer;
    // *** Designtime and DFM support ***
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    procedure DefineProperties(Filer: TFiler); override;
    procedure Loaded; override;
    // *** Getters and setters ***
    procedure SetCaption(const Value: string);
    procedure SetCustomAppearance(const Value: TSpkToolbarAppearance);
    procedure SetOverrideAppearance(const Value: Boolean);
    procedure SetVisible(const Value: Boolean);
    procedure SetAppearance(const Value: TSpkToolbarAppearance);
    procedure SetImages(const Value: TImageList);
    procedure SetDisabledImages(const Value: TImageList);
    procedure SetLargeImages(const Value: TImageList);
    procedure SetDisabledLargeImages(const Value: TImageList);
    procedure SetImagesWidth(const Value: Integer);
    procedure SetLargeImagesWidth(const Value: Integer);
    procedure SetRect(aRect: T2DIntRect);
    procedure SetToolbarDispatch(const Value: TSpkBaseToolbarDispatch);
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    // *** Geometry, sheet service, drawing ***
    function AtLeastOnePaneVisible: Boolean;
    procedure Draw(aBuffer: TBitmap; aClipRect: T2DIntRect);
    // *** Mouse support ***
    procedure MouseLeave;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MouseMove(Shift: TShiftState; X, Y: Integer);
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    // *** Dispatcher event handling ***
    procedure NotifyAppearanceChanged;
    // *** Support for elements ***
    procedure FreeingPane(aPane: TSpkPane);
    procedure ExecOnClick;
  public
    property ToolbarDispatch: TSpkBaseToolbarDispatch read fToolbarDispatch write SetToolbarDispatch;
    property Appearance: TSpkToolbarAppearance read fAppearance write SetAppearance;
    property Panes: TSpkPanes read fPanes;
    property Rect: T2DIntRect read fRect write SetRect;
    property Images: TImageList read fImages write SetImages;
    property DisabledImages: TImageList read fDisabledImages write SetDisabledImages;
    property LargeImages: TImageList read fLargeImages write SetLargeImages;
    property DisabledLargeImages: TImageList read fDisabledLargeImages write SetDisabledLargeImages;
    property ImagesWidth: Integer read fImagesWidth write SetImagesWidth;
    property LargeImagesWidth: Integer read fLargeImagesWidth write SetLargeImagesWidth;
  published
    property CustomAppearance: TSpkToolbarAppearance read fCustomAppearance write SetCustomAppearance;
    property Caption: string read fCaption write SetCaption;
    property OverrideAppearance: Boolean read fOverrideAppearance write SetOverrideAppearance default false;
    property Visible: Boolean read fVisible write SetVisible default true;
    property OnClick: TNotifyEvent read fOnClick write fOnClick;
  end;

  /// <summary>
  ///
  /// </summary>
  TSpkTabs = class(TSpkCollection)
  protected
    fToolbarDispatch: TSpkBaseToolbarDispatch;
    fAppearance: TSpkToolbarAppearance;
    fImages: TImageList;
    fDisabledImages: TImageList;
    fLargeImages: TImageList;
    fDisabledLargeImages: TImageList;
    fImagesWidth: Integer;
    fLargeImagesWidth: Integer;
    function GetItems(aIndex: Integer): TSpkTab; reintroduce;
    procedure SetAppearance(const Value: TSpkToolbarAppearance);
    procedure SetImages(const Value: TImageList);
    procedure SetDisabledImages(const Value: TImageList);
    procedure SetLargeImages(const Value: TImageList);
    procedure SetDisabledLargeImages(const Value: TImageList);
    procedure SetImagesWidth(const Value: Integer);
    procedure SetLargeImagesWidth(const Value: Integer);
    procedure SetToolbarDispatch(const Value: TSpkBaseToolbarDispatch);
  public
    function Add: TSpkTab;
    function Insert(aIndex: Integer): TSpkTab;
    procedure Notify(Item: TComponent; Operation: TOperation); override;
    procedure Update; override;
  public
    property Items[index: Integer]: TSpkTab read GetItems; default;
    property ToolbarDispatch: TSpkBaseToolbarDispatch read fToolbarDispatch write SetToolbarDispatch;
    property Appearance: TSpkToolbarAppearance read fAppearance write SetAppearance;
    property Images: TImageList read fImages write SetImages;
    property DisabledImages: TImageList read fDisabledImages write SetDisabledImages;
    property LargeImages: TImageList read fLargeImages write SetLargeImages;
    property DisabledLargeImages: TImageList read fDisabledLargeImages write SetDisabledLargeImages;
    property ImagesWidth: Integer read fImagesWidth write SetImagesWidth;
    property LargeImagesWidth: Integer read fLargeImagesWidth write SetLargeImagesWidth;
  end;


implementation

{ TSpkTabDispatch }

constructor TSpkTabAppearanceDispatch.Create(aTab: TSpkTab);
begin
  inherited Create;
  fTab := aTab;
end;

procedure TSpkTabAppearanceDispatch.NotifyAppearanceChanged;
begin
  if Assigned(fTab) then
    fTab.NotifyAppearanceChanged;
end;


{ TSpkTab }

constructor TSpkTab.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  fAppearanceDispatch := TSpkTabAppearanceDispatch.Create(self);
  fMouseHoverElement.ElementType := etNone;
  fMouseHoverElement.ElementIndex := UNDEFINED_PANE_INDEX;
  fMouseActiveElement.ElementType := etNone;
  fMouseActiveElement.ElementIndex := UNDEFINED_PANE_INDEX;
  fCaption := 'Tab';
  fVisible := true;
  fCustomAppearance := TSpkToolbarAppearance.Create(fAppearanceDispatch);
  fPanes := TSpkPanes.Create(self);
  fPanes.ToolbarDispatch := fToolbarDispatch;
  fPanes.ImagesWidth := fImagesWidth;
  fPanes.LargeImagesWidth := fLargeImagesWidth;
  fRect := T2DIntRect.Create(0,0,0,0);
  SetPaneAppearance;
end;

destructor TSpkTab.Destroy;
begin
  fPanes.Free;
  fCustomAppearance.Free;
  fAppearanceDispatch.Free;
  inherited Destroy;
end;

function TSpkTab.AtLeastOnePaneVisible: Boolean;
var
  i: Integer;
  lPaneVisible: Boolean;
begin
  Result := (fPanes.Count > 0);
  if Result then
  begin
    lPaneVisible := False;
    i := fPanes.Count - 1;
    while (i >= 0) and not lPaneVisible do
    begin
      lPaneVisible := fPanes[i].Visible;
      Dec(i);
    end;
    Result := Result and lPaneVisible;
  end;
end;

procedure TSpkTab.SetRect(aRect: T2DIntRect);
var
  x, i: Integer;
  lTabWidth: Integer;
  lTempRect: T2DIntRect;
begin
  fRect := aRect;
  if AtLeastOnePaneVisible then
  begin
    x := aRect.Left;
    for i := 0 to fPanes.Count - 1 do
      if fPanes[i].Visible then
      begin
        lTabWidth := fPanes[i].GetWidth;
        lTempRect.Left := x;
        lTempRect.Top := aRect.Top;
        lTempRect.Right := x + lTabWidth - 1;
        lTempRect.Bottom := aRect.bottom;
        fPanes[i].Rect := lTempRect;
        x := x + lTabWidth + SPK_TAB_PANE_HSPACING;
      end
      else
      begin
        fPanes[i].Rect := T2DIntRect.Create(-1,-1,-1,-1);
      end;
  end;
end;

procedure TSpkTab.SetToolbarDispatch(const Value: TSpkBaseToolbarDispatch);
begin
  fToolbarDispatch := Value;
  fPanes.ToolbarDispatch := fToolbarDispatch;
end;

procedure TSpkTab.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineProperty('Panes', fPanes.ReadNames, fPanes.WriteNames, true);
end;


procedure TSpkTab.Draw(aBuffer: TBitmap; aClipRect: T2DIntRect);
var
  i: Integer;
  lLocalClipRect: T2DIntRect;
begin
  if AtLeastOnePaneVisible then
    for i := 0 to fPanes.Count - 1 do
      if fPanes[i].visible then
      begin
        if aClipRect.IntersectsWith(fPanes[i].Rect, lLocalClipRect) then
          fPanes[i].Draw(aBuffer, lLocalClipRect);
      end;
end;

procedure TSpkTab.ExecOnClick;
begin
  if Assigned(fOnClick) then
    fOnClick(self);
end;

function TSpkTab.FindPaneAt(x, y: Integer): Integer;
var
  i: Integer;
begin
  Result := UNDEFINED_PANE_INDEX;
  i := fPanes.Count - 1;
  while i >= 0 do
  begin
    if fPanes[i].Visible then
    begin
      if fPanes[i].Rect.Contains(T2DIntVector.Create(x,y)) then
        Exit(i);
    end;
    Dec(i);
  end;
end;

procedure TSpkTab.FreeingPane(aPane: TSpkPane);
begin
  fPanes.RemoveReference(aPane);
end;

function TSpkTab.GetSubCollection: TSpkCollection;
begin
  Result := fPanes;
end;

procedure TSpkTab.GetChildren(Proc: TGetChildProc; Root: TComponent);
var
  i: Integer;
begin
  inherited;
  for i := 0 to fPanes.Count - 1 do
    Proc(fPanes.Items[i]);
end;

procedure TSpkTab.Loaded;
begin
  inherited;
  if fPanes.ListState = lsNeedsProcessing then
    fPanes.ProcessNames(Self.Owner);
end;

procedure TSpkTab.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if fMouseActiveElement.ElementType = etPane then
  begin
    if fMouseActiveElement.ElementIndex <> UNDEFINED_PANE_INDEX then
      fPanes[fMouseActiveElement.ElementIndex].MouseDown(Button, Shift, X, Y);
  end
  else if fMouseActiveElement.ElementType = etTabArea then
  begin
   // Placeholder, if there is a need to handle this event.
  end
  else if fMouseActiveElement.ElementType = etNone then
  begin
    if fMouseHoverElement.ElementType = etPane then
    begin
      if fMouseHoverElement.ElementIndex <> UNDEFINED_PANE_INDEX then
      begin
        fMouseActiveElement.ElementType := etPane;
        fMouseActiveElement.ElementIndex := fMouseHoverElement.ElementIndex;
        fPanes[fMouseHoverElement.ElementIndex].MouseDown(Button, Shift, X, Y);
      end
      else
      begin
        fMouseActiveElement.ElementType := etTabArea;
        fMouseActiveElement.ElementIndex := UNDEFINED_PANE_INDEX;
      end;
    end
    else if fMouseHoverElement.ElementType = etTabArea then
    begin
      fMouseActiveElement.ElementType := etTabArea;
      fMouseActiveElement.ElementIndex := UNDEFINED_PANE_INDEX;
      // Placeholder, if there is a need to handle this event.
    end;
  end;
end;

procedure TSpkTab.MouseLeave;
begin
  if fMouseActiveElement.ElementType = etNone then
  begin
    if fMouseHoverElement.ElementType = etPane then
    begin
      if fMouseHoverElement.ElementIndex <> UNDEFINED_PANE_INDEX then
        fPanes[fMouseHoverElement.ElementIndex].MouseLeave;
    end else
    if fMouseHoverElement.ElementType = etTabArea then
    begin
      // Placeholder, if there is a need to handle this event.
    end;
  end;

  fMouseHoverElement.ElementType := etNone;
  fMouseHoverElement.ElementIndex := UNDEFINED_PANE_INDEX;
end;

procedure TSpkTab.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
  lNewMouseHoverElement: TSpkMouseTabElement;
begin
  // We're looking for an object under the mouse
  i := FindPaneAt(X, Y);
  if i <> -1 then
  begin
    lNewMouseHoverElement.ElementType := etPane;
    lNewMouseHoverElement.ElementIndex := i;
  end
  else if (X >= fRect.Left) and (Y >= fRect.top) and (X <= fRect.Right) and (Y <= fRect.bottom) then
  begin
    lNewMouseHoverElement.ElementType := etTabArea;
    lNewMouseHoverElement.ElementIndex := UNDEFINED_PANE_INDEX;
  end
  else
  begin
    lNewMouseHoverElement.ElementType := etNone;
    lNewMouseHoverElement.ElementIndex := UNDEFINED_PANE_INDEX;
  end;

  if fMouseActiveElement.ElementType = etPane then
  begin
    if fMouseActiveElement.ElementIndex <> UNDEFINED_PANE_INDEX then
    begin
      fPanes[fMouseActiveElement.ElementIndex].MouseMove(Shift, X, Y);
    end;
  end
  else if fMouseActiveElement.ElementType = etTabArea then
  begin
    // Placeholder, if there is a need to handle this event
  end
  else if fMouseActiveElement.ElementType = etNone then
  begin
    // If the item under the mouse changes, we inform the previous element
    // that the mouse leaves its area
    if (lNewMouseHoverElement.ElementType <> fMouseHoverElement.ElementType) or
      (lNewMouseHoverElement.ElementIndex <> fMouseHoverElement.ElementIndex) then
    begin
      if fMouseHoverElement.ElementType = etPane then
      begin
        if fMouseHoverElement.ElementIndex <> UNDEFINED_PANE_INDEX then
          fPanes[fMouseHoverElement.ElementIndex].MouseLeave;
      end
      else if fMouseHoverElement.ElementType = etTabArea then
      begin
        // Placeholder, if there is a need to handle this event
      end;
    end;

    if lNewMouseHoverElement.ElementType = etPane then
    begin
      if lNewMouseHoverElement.ElementIndex <> UNDEFINED_PANE_INDEX then
        fPanes[lNewMouseHoverElement.ElementIndex].MouseMove(Shift, X, Y);
    end
    else if lNewMouseHoverElement.ElementType = etTabArea then
    begin
      // Placeholder, if there is a need to handle this event
    end;
  end;

  fMouseHoverElement := lNewMouseHoverElement;
end;

procedure TSpkTab.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  lClearActive: Boolean;
begin
  lClearActive := not (ssLeft in Shift) and not (ssMiddle in Shift) and not (ssRight in Shift);

  if fMouseActiveElement.ElementType = etPane then
  begin
    if fMouseActiveElement.ElementIndex <> UNDEFINED_PANE_INDEX then
      fPanes[fMouseActiveElement.ElementIndex].MouseUp(Button, Shift, X, Y);
  end
  else if fMouseActiveElement.ElementType = etTabArea then
  begin
    // Placeholder, if there is a need to handle this event.
  end;

  if lClearActive and
    (fMouseActiveElement.ElementType <> fMouseHoverElement.ElementType) or
    (fMouseActiveElement.ElementIndex <> fMouseHoverElement.ElementIndex) then
  begin
    if fMouseActiveElement.ElementType = etPane then
    begin
      if fMouseActiveElement.ElementIndex <> UNDEFINED_PANE_INDEX then
        fPanes[fMouseActiveElement.ElementIndex].MouseLeave;
    end
    else if fMouseActiveElement.ElementType = etTabArea then
    begin
      // Placeholder, if there is a need to handle this event.
    end;

    if fMouseHoverElement.ElementType = etPane then
    begin
      if fMouseHoverElement.ElementIndex <> UNDEFINED_PANE_INDEX then
        fPanes[fMouseHoverElement.ElementIndex].MouseMove(Shift, X, Y);
    end
    else if fMouseHoverElement.ElementType = etTabArea then
    begin
      // Placeholder, if there is a need to handle this event.
    end;
  end;

  if lClearActive then
  begin
    fMouseActiveElement.ElementType := etNone;
    fMouseActiveElement.ElementIndex := UNDEFINED_PANE_INDEX;
  end;
end;

procedure TSpkTab.NotifyAppearanceChanged;
begin
  if Assigned(fToolbarDispatch) then
    fToolbarDispatch.NotifyAppearanceChanged;
end;

procedure TSpkTab.SetCustomAppearance(const Value: TSpkToolbarAppearance);
begin
  fCustomAppearance.Assign(Value);
end;

procedure TSpkTab.SetDisabledImages(const Value: TImageList);
begin
  fDisabledImages := Value;
  fPanes.DisabledImages := Value;
end;

procedure TSpkTab.SetDisabledLargeImages(const Value: TImageList);
begin
  fDisabledLargeImages := Value;
  fPanes.DisabledLargeImages := Value;
end;

procedure TSpkTab.SetImages(const Value: TImageList);
begin
  fImages := Value;
  fPanes.Images := Value;
end;

procedure TSpkTab.SetImagesWidth(const Value: Integer);
begin
  fImagesWidth := Value;
  fPanes.ImagesWidth := Value;
end;

procedure TSpkTab.SetLargeImages(const Value: TImageList);
begin
  fLargeImages := Value;
  fPanes.LargeImages := Value;
end;

procedure TSpkTab.SetLargeImagesWidth(const Value: Integer);
begin
  fLargeImagesWidth := Value;
  fPanes.LargeImagesWidth := Value;
end;

procedure TSpkTab.SetAppearance(const Value: TSpkToolbarAppearance);
begin
  fAppearance := Value;
  SetPaneAppearance;
  if fToolbarDispatch <> nil then
    fToolbarDispatch.NotifyMetricsChanged;
end;

procedure TSpkTab.SetCaption(const Value: string);
begin
  fCaption := Value;
  if Assigned(fToolbarDispatch) then
    fToolbarDispatch.NotifyMetricsChanged;
end;

procedure TSpkTab.SetOverrideAppearance(const Value: Boolean);
begin
  fOverrideAppearance := Value;
  SetPaneAppearance;
  if fToolbarDispatch <> nil then
    fToolbarDispatch.NotifyMetricsChanged;
end;

procedure TSpkTab.SetPaneAppearance;
begin
  if fOverrideAppearance then
    fPanes.Appearance := fCustomAppearance
  else
    fPanes.Appearance := fAppearance;
  // The method plays the role of a macro - therefore it does not
  // notify the dispatcher about the change.
end;

procedure TSpkTab.SetVisible(const Value: Boolean);
begin
  fVisible := Value;
  if fToolbarDispatch <> nil then
    fToolbarDispatch.NotifyItemsChanged;
end;


{ TSpkTabs }

function TSpkTabs.Add: TSpkTab;
begin
  Result := TSpkTab.create(fRootComponent);
  Result.Parent := fRootComponent;
  AddItem(Result);
end;

function TSpkTabs.GetItems(aIndex: Integer): TSpkTab;
begin
  Result := TSpkTab(inherited Items[aIndex]);
end;

function TSpkTabs.Insert(aIndex: Integer): TSpkTab;
var
  i: Integer;
  lOwner, lParent: TComponent;
begin
  if (aIndex < 0) or (aIndex >= Self.Count) then
    raise InternalException.Create('TSpkTabs.Insert: Invalid index!');

  if fRootComponent <> nil then
  begin
    lOwner := fRootComponent.Owner;
    lParent := fRootComponent;
  end
  else
  begin
    lOwner := nil;
    lParent := nil;
  end;

  Result := TSpkTab.Create(lOwner);
  Result.Parent := lParent;

  if fRootComponent <> nil then
  begin
    i := 0;
    while fRootComponent.Owner.FindComponent('SpkTab' + IntToStr(i)) <> nil do
      Inc(i);

    Result.Name := 'SpkTab' + IntToStr(i);
  end;
  InsertItem(aIndex, Result);
end;

procedure TSpkTabs.Notify(Item: TComponent; Operation: TOperation);
begin
  inherited Notify(Item, Operation);

  case Operation of
    opInsert:
      begin
        // Setting the dispatcher to nil will cause that during the
        // ownership assignment, the Notify method will not be called
        TSpkTab(Item).ToolbarDispatch := nil;
        TSpkTab(Item).Appearance := Self.fAppearance;
        TSpkTab(Item).Images := Self.fImages;
        TSpkTab(Item).DisabledImages := Self.fDisabledImages;
        TSpkTab(Item).LargeImages := Self.fLargeImages;
        TSpkTab(Item).DisabledLargeImages := Self.fDisabledLargeImages;
        TSpkTab(Item).ImagesWidth := Self.fImagesWidth;
        TSpkTab(Item).LargeImagesWidth := Self.fLargeImagesWidth;
        TSpkTab(Item).ToolbarDispatch := Self.fToolbarDispatch;
      end;
    opRemove:
      if not(csDestroying in Item.ComponentState) then
      begin
        TSpkTab(Item).ToolbarDispatch := nil;
        TSpkTab(Item).Appearance := nil;
        TSpkTab(Item).Images := nil;
        TSpkTab(Item).DisabledImages := nil;
        TSpkTab(Item).LargeImages := nil;
        TSpkTab(Item).DisabledLargeImages := nil;
  //      TSpkTab(Item).ImagesWidth := 0;
//        TSpkTab(Item).LargeImagesWidth := 0;
      end;
  end;
end;

procedure TSpkTabs.SetAppearance(const Value: TSpkToolbarAppearance);
var
  i: Integer;
begin
  fAppearance := Value;
  for i := 0 to Self.Count - 1 do
    Self.Items[i].Appearance := fAppearance;
end;

procedure TSpkTabs.SetDisabledImages(const Value: TImageList);
var
  i: Integer;
begin
  fDisabledImages := Value;
  for i := 0 to Self.Count - 1 do
    Items[i].DisabledImages := Value;
end;

procedure TSpkTabs.SetDisabledLargeImages(const Value: TImageList);
var
  i: Integer;
begin
  fDisabledLargeImages := Value;
  for i := 0 to Self.count - 1 do
    Items[i].DisabledLargeImages := Value;
end;

procedure TSpkTabs.SetImages(const Value: TImageList);
var
  i: Integer;
begin
  fImages := Value;
  for i := 0 to Self.Count - 1 do
    Items[i].Images := Value;
end;

procedure TSpkTabs.SetImagesWidth(const Value: Integer);
var
  i: Integer;
begin
  fImagesWidth := Value;
  for i := 0 to Count - 1 do
    Items[i].ImagesWidth := Value;
end;

procedure TSpkTabs.SetLargeImages(const Value: TImageList);
var
  i: Integer;
begin
  fLargeImages := Value;
  for i := 0 to Self.Count - 1 do
    Items[i].LargeImages := Value;
end;

procedure TSpkTabs.SetLargeImagesWidth(const Value: Integer);
var
  i: Integer;
begin
  fLargeImagesWidth := Value;
  for i := 0 to Count - 1 do
    Items[i].LargeImagesWidth := Value;
end;

procedure TSpkTabs.SetToolbarDispatch(const Value: TSpkBaseToolbarDispatch);
var
  i: Integer;
begin
  fToolbarDispatch := Value;
  for i := 0 to Self.Count - 1 do
    Self.Items[i].ToolbarDispatch := fToolbarDispatch;
end;

procedure TSpkTabs.Update;
begin
  inherited Update;

  if Assigned(fToolbarDispatch) then
    fToolbarDispatch.NotifyItemsChanged;
end;

initialization
  RegisterClasses([TSpkTab]);

end.
