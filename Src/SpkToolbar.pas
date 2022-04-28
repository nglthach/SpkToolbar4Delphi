unit SpkToolbar;

interface

{$I Spk.inc}

uses
  Windows,
  Classes,
  Controls,
  Dialogs,
  Forms,
  Graphics,
  Math,
  Messages,
  SysUtils,
  Types,
  SpkGraphTools,
  SpkGUITools,
  SpkMath,
  SpkAppearance,
  SpkBaseItem,
  SpkConst,
  SpkTab,
  SpkPane,
  SpkTypes;

type
  TSpkToolbar = class;

  { Type describes regions of the toolbar which are used during handling
    of interaction with the mouse }
  TSpkMouseToolbarElement = (teNone, teToolbarArea, teTabs, teTabContents);
  TSpkTabChangingEvent = procedure(Sender: TObject; OldIndex, NewIndex: Integer; var Allowed: Boolean) of object;

  { Dispatcher class which is used for safe accepting of information
    and requests from sub-elements. }

  TSpkToolbarDispatch = class(TSpkBaseToolbarDispatch)
  private
    { Toolbar component which is accepting information and requests from sub-elements }
    fToolbar: TSpkToolbar;
  public
    constructor Create(aToolbar: TSpkToolbar);

    // ******************************************************************
    // *** Implementation of abstract methods TSpkBaseToolbarDispatch ***
    // ******************************************************************

    { Method (NotifyAppearanceChanged) called when a content of the
      object of the appearance changes
      The object of the appearance contains colours and fonts used
      to draw the toolbar }
    procedure NotifyAppearanceChanged; override;
    { Method (NotifyItemsChanged) called when list of the sub-elements
      of one of toolbar elements changes }
    procedure NotifyItemsChanged; override;
    { Method (NotifyMetricsChanged) called when the size and position (metric)
      of one of toolbar elements change }
    procedure NotifyMetricsChanged; override;
    { Method (NotifyVisualsChanged) called when the appearance of one of
      toolbar elements changes
      if the toolbar element however doesn't need rebuilding of metrics }
    procedure NotifyVisualsChanged; override;
    { Method (GetTempBitmap) requests for suppporting bitmap delivered by toolbar
      For example, used to calculate the size of rendered text }
    function GetTempBitmap: TBitmap; override;
    { Method (ClientToScreen) converts the toolbar coordinates to screen coordinates
      For example, used to unfold popup menu }
    function ClientToScreen(Point: T2DIntPoint): T2DIntPoint; override;
  end;

  { TSpkToolbar }

  TSpkToolbar = class(TSpkCustomControl)
  public
    const UNDEFINED_TAB_INDEX = -1;
  private
    { Instance of dispatcher object
      Dispatcher is transfered to toolbar elements }
    fToolbarDispatch: TSpkToolbarDispatch;
    { Buffer bitmap to which toolbar is drawn }
    fBuffer: TBitmap;
    { Supporting bitmap is sent when toolbar elements request it }
    fTemporary: TBitmap;
    { Array of Rects of "handles" of tabs }
    fTabRects: array of T2DIntRect;
    { Cliprect region of "handles" of tabs }
    fTabClipRect: T2DIntRect;
    { ClipRect of region content of tab }
    fTabContentsClipRect: T2DIntRect;
    { The element over which the mouse pointer is }
    fMouseHoverElement: TSpkMouseToolbarElement;
    { The element over which the mouse pointer is and in which a mouse
      button is pressed }
    fMouseActiveElement: TSpkMouseToolbarElement;
    { The mouse pointer is now on the "handle" of tab }
    fHotTabIndex: Integer;
    { Flag which informs about validity of metrics of toolbar and its elements }
    fMetricsValid: Boolean;
    { Flag which informs about validity of buffer content }
    fBufferValid: Boolean;
    { Flag fInternalUpdating allows to block the validation of metrics and buffer
      when component is rebuilding its content
      The flag is switched on and off internally by component }
    fInternalUpdating: Boolean;
    { Flag fUpdating allows to block the validation of metrics and buffer
      when user is rebuilding content of the component.
      fUpdating is controlled by user }
    fUpdating: Boolean;
    { Quick selection of different appearances }
    fStyle: TSpkStyle;
    fOnTabChanging: TSpkTabChangingEvent;
    fOnTabChanged: TNotifyEvent;
  protected
    { Instance of the Appearance object storing colours and fonts used during
      rendering of the component }
    fAppearance: TSpkToolbarAppearance;
    { Tabs of the toolbar }
    fTabs: TSpkTabs;
    { Index of the selected tab }
    fActiveTabIndex: Integer;
    { Imagelist of the small pictures of toolbar elements }
    fImages: TImageList;
    { Image list of the small pictures in the state "disabled".
      If the list is not assigned, small "disabled" pictures will be generated
      automatically }
    fDisabledImages: TImageList;
    { Imagelist of the large pictures of toolbar elements }
    fLargeImages: TImageList;
    { Image list of the large pictures in the state "disabled".
      If the list is not assigned, large "disabled" pictures will be generated
      automatically }
    fDisabledLargeImages: TImageList;
    { Unscaled width of the small images }
    fImagesWidth: Integer;
    { Unscaled width of the large images }
    fLargeImagesWidth: Integer;

    function DPIScale(aSize: Integer): Integer;

    function DoTabChanging(OldIndex, NewIndex: Integer): Boolean;
    // *****************************************************
    // *** Management of the metric and the buffer state ***
    // *****************************************************
    { Method switches flags fMetricsValid and fBufferValid off }
    procedure SetMetricsInvalid;
    { Method swiches flag fBufferValid off }
    procedure SetBufferInvalid;
    { Method validates toolbar metrics and toolbar elements }
    procedure ValidateMetrics;
    { Method validates the content of the buffer }
    procedure ValidateBuffer;
    { Method switches on the mode of internal rebuilding
      and swiches flag fInternalUpdating on }
    procedure InternalBeginUpdate;
    { Method switches on the mode of internal rebuilding
      and swiches the flag fInternalUpdating off}
    procedure InternalEndUpdate;
    // ************************************************
    // *** Covering of methods from derived classes ***
    // ************************************************
    { The Change of component size }
    procedure Resize; override;
    { Method called when mouse pointer left component region }
    procedure MouseLeave; override;
    { Method called when mouse button is pressed }
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    { Method called when mouse pointer is moved over component }
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    { Method called when the mouse button is released }
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    { Method called when the whole component has finished loading from LFM file }
    procedure Loaded; override;
    { Method called when component becomes the owner of other component,
      or one of its sub-components is released }
    procedure Notification(aComponent: TComponent; Operation: TOperation); override;
    // ******************************************
    // *** Handling of mouse events for tabs  ***
    // ******************************************
    { Method called when mouse pointer left the region of tab "handles" }
    procedure TabMouseLeave;
    { Method called when the mouse button is pressed
      and at the same time the mouse pointer is over the region of tabs }
    procedure TabMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    { Method called when the mouse will move over the region of tab "handles" }
    procedure TabMouseMove(Shift: TShiftState; X, Y: Integer);
    { Method called when one of the mouse buttons is released
      and at the same time the region of tabs was active element of toolbar }
    procedure TabMouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    // *********************
    // *** Extra support ***
    // *********************
    { Metchod checks if at least one of the tabs is switched on by flag Visible }
    function AtLeastOneTabVisible: Boolean;
    // ****************
    // *** Messages ***
    // ****************
    { Message is received when mouse left the region of component }
    procedure CMMouseLeave(var msg: TMessage); message CM_MOUSELEAVE;
    // **************************
    // *** Designtime and LFM ***
    // **************************
    { Method gives back elements which will be saved as sub-elements of component }
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    { Method allows for saving and reading additional properties of component }
    procedure DefineProperties(Filer: TFiler); override;
    // ***************************
    // *** Getters and setters ***
    // ***************************
    { Setter for property Appearance }
    procedure SetAppearance(const Value: TSpkToolbarAppearance);
    { Getter for property Color }
    function GetColor: TColor;
    { Setter for property Color }
    procedure SetColor(Value: TColor);  // "override" will overflow the stack -->
    { Setter for property TabIndex }
    procedure SetTabIndex(const Value: Integer);
    { Setter for property Images }
    procedure SetImages(const Value: TImageList);
    { Setter for property DisabledImages }
    procedure SetDisabledImages(const Value: TImageList);
    { Setter for property LargeImages }
    procedure SetLargeImages(const Value: TImageList);
    { Setter for property DisabledLargeImages }
    procedure SetDisabledLargeImages(const Value: TImageList);
    { Setter for toolbar style, i.e. quick selection of new appearance theme }
    procedure SetStyle(const Value: TSpkStyle);
    { Hi-DPI image list support }
    procedure SetImagesWidth(const aValue: Integer);
    procedure SetLargeImagesWidth(const aValue: Integer);
    { Support Action }
    procedure UpdateActions;
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    procedure InitiateAction; override;
    // *************************
    // *** Dispatcher events ***
    // *************************
    { Reaction to change of toolbar elements structure }
    procedure NotifyItemsChanged;
    { Reaction to change of toolbar elements metric }
    procedure NotifyMetricsChanged;
    { Reaction to change of toolbar elements appearance }
    procedure NotifyVisualsChanged;
    { Reaction to change of content of toolbar class appearance }
    procedure NotifyAppearanceChanged;
    { Method gives back the instance of supporting bitmap }
    function GetTempBitmap: TBitmap;
    // ***************
    // *** Drawing ***
    // ***************
    { Method draws the content of the component }
    procedure Paint; override;
    { Method enforces the rebuilding of metrics and buffer }
    procedure ForceRepaint;
    { Method swiches over the component in update mode of the content
      by switching on flag fUpdating }
    procedure BeginUpdate;
    { Method switches off the update mode of the content
      by switching off flag fUpdating }
    procedure EndUpdate;
    // ****************
    // *** Elements ***
    // ****************
    { Method called when one of the tabs is released
      You cannot call method FreeingTab from code (by writing it in code)
      It's called internally and its purpuse is to update internal list of tabs }
    procedure FreeingTab(aTab: TSpkTab);
    // **********************
    // *** Access to tabs ***
    // **********************
    { Property gives accesss to tabs in runtime mode
      To edit tabs in designtime mode use proper editor
      Savings and readings from LFM is done manually }
    property Tabs: TSpkTabs read fTabs;
  published
    { Component background color }
    property Color: TColor read GetColor write SetColor default clSkyBlue;
    { Appearance style - don't move after Appearance! }
    property Style: TSpkStyle read fStyle write SetStyle default spkOffice2007Blue;
    { Object containing attributes of toolbar appearance }
    property Appearance: TSpkToolbarAppearance read fAppearance write SetAppearance;
    { Index of active tab }
    property TabIndex: Integer read fActiveTabIndex write SetTabIndex;
    { ImageList with the small pictures }
    property Images: TImageList read fImages write SetImages;
    { ImageList with the small pictures in state "disabled" }
    property DisabledImages: TImageList read fDisabledImages write SetDisabledImages;
    { ImageList with the large pictures }
    property LargeImages: TImageList read fLargeImages write SetLargeImages;
    { ImageList with the large pictures in state "disabled" }
    property DisabledLargeImages: TImageList
        read fDisabledLargeImages write SetDisabledLargeImages;
    { Unscaled size of the small images }
    property ImagesWidth: Integer read fImagesWidth write SetImagesWidth default 16;
    { Unscaled size of the large images }
    property LargeImagesWidth: Integer read fLargeImagesWidth write SetLargeImagesWidth default 32;
    { Events called before and after another tab is selected }
    property OnTabChanging: TSpkTabChangingEvent
        read fOnTabChanging write fOnTabChanging;
    property OnTabChanged: TNotifyEvent read fOnTabChanged write fOnTabChanged;
    { inherited properties }
    property Align default alTop;
    property Anchors;
    property Hint;
    property ParentShowHint;
    property ShowHint;
    property Visible;
    property OnResize;
  end;

implementation

uses
  Themes;

{ TSpkToolbarDispatch }

function TSpkToolbarDispatch.ClientToScreen(Point: T2DIntPoint): T2DIntPoint;
begin
  if fToolbar <> nil then
    Result := fToolbar.ClientToScreen(Point)
  else
    Result := T2DIntPoint.Create(-1, -1);
end;

constructor TSpkToolbarDispatch.Create(aToolbar: TSpkToolbar);
begin
  inherited Create;
  fToolbar := aToolbar;
end;

function TSpkToolbarDispatch.GetTempBitmap: TBitmap;
begin
  if fToolbar <> nil then
    Result := fToolbar.GetTempBitmap
  else
    Result := nil;
end;

procedure TSpkToolbarDispatch.NotifyAppearanceChanged;
begin
  if fToolbar <> nil then
    fToolbar.NotifyAppearanceChanged;
end;

procedure TSpkToolbarDispatch.NotifyMetricsChanged;
begin
  if fToolbar <> nil then
    fToolbar.NotifyMetricsChanged;
end;

procedure TSpkToolbarDispatch.NotifyItemsChanged;
begin
  if fToolbar <> nil then
    fToolbar.NotifyItemsChanged;
end;

procedure TSpkToolbarDispatch.NotifyVisualsChanged;
begin
  if fToolbar <> nil then
    fToolbar.NotifyVisualsChanged;
end;

{ TSpkToolbar }

function TSpkToolbar.AtLeastOneTabVisible: Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to fTabs.Count - 1 do
    if fTabs[i].Visible then
      Exit(True);
end;

procedure TSpkToolbar.BeginUpdate;
begin
  fUpdating := True;
end;

procedure TSpkToolbar.CMMouseLeave(var msg: TMessage);
begin
  inherited;
  MouseLeave;
end;

constructor TSpkToolbar.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  // Support Action
  ControlStyle := ControlStyle + [csActionClient];

  fImagesWidth := 16;
  fLargeImagesWidth := 32;
  // Initialization of inherited property
  Align := alTop;

  if (aOwner is TForm) then
    SpkInitLayoutConsts(96); // This default dpi value is ignored for VCL scaling

  Height := SPK_TOOLBAR_HEIGHT;
  // Initialization of internal data fields
  fToolbarDispatch := TSpkToolbarDispatch.Create(self);

  fBuffer := TBitmap.Create;
  fBuffer.PixelFormat := pf24bit;

  fTemporary := TBitmap.Create;
  fTemporary.Pixelformat := pf24bit;

  SetLength(fTabRects, 0);

  fTabClipRect := T2DIntRect.Create(0, 0, 0, 0);
  fTabContentsClipRect := T2DIntRect.Create(0, 0, 0, 0);

  fMouseHoverElement := teNone;
  fMouseActiveElement := teNone;

  fHotTabIndex := UNDEFINED_TAB_INDEX;

  // Initialization of fields
  fAppearance := TSpkToolbarAppearance.Create(fToolbarDispatch);

  fTabs := TSpkTabs.Create(self);
  fTabs.ToolbarDispatch := fToolbarDispatch;
  fTabs.Appearance := fAppearance;
  fTabs.ImagesWidth := fImagesWidth;
  fTabs.LargeImagesWidth := fLargeImagesWidth;

  fActiveTabIndex := UNDEFINED_TAB_INDEX;
  Color := clSkyBlue;
end;

procedure TSpkToolbar.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineProperty('Tabs', fTabs.ReadNames, fTabs.WriteNames, True);
end;

destructor TSpkToolbar.Destroy;
begin
  // Release the fields
  fTabs.Free;
  fAppearance.Free;

  // Release the internal fields
  fTemporary.Free;
  fBuffer.Free;
  fToolbarDispatch.Free;

  inherited Destroy;
end;

procedure TSpkToolbar.EndUpdate;
begin
  fUpdating := False;
  ValidateMetrics;
  ValidateBuffer;
  Invalidate;
end;

procedure TSpkToolbar.ForceRepaint;
begin
  SetMetricsInvalid;
  SetBufferInvalid;
  Invalidate;
end;

procedure TSpkToolbar.FreeingTab(aTab: TSpkTab);
begin
  fTabs.RemoveReference(aTab);
end;

procedure TSpkToolbar.GetChildren(Proc: TGetChildProc; Root: TComponent);
var
  i: Integer;
begin
  inherited;
  for i := 0 to fTabs.Count - 1 do
    Proc(fTabs.Items[i]);
end;

function TSpkToolbar.GetColor: TColor;
begin
  Result := inherited Color;
end;

function TSpkToolbar.GetTempBitmap: TBitmap;
begin
  Result := fTemporary;
end;

procedure TSpkToolbar.InitiateAction;
begin
  inherited;
  UpdateActions;
end;

procedure TSpkToolbar.InternalBeginUpdate;
begin
  fInternalUpdating := True;
end;

procedure TSpkToolbar.InternalEndUpdate;
begin
  fInternalUpdating := False;
  //After internal changes the metrics and buffers are refreshed
  ValidateMetrics;
  ValidateBuffer;
  Invalidate;
end;

procedure TSpkToolbar.Loaded;
begin
  inherited;

  InternalBeginUpdate;

  if fTabs.ListState = lsNeedsProcessing then
    fTabs.ProcessNames(Self.Owner);

  InternalEndUpdate;
  //The process of internal update always refreshes metrics and buffer at the end
  //and draws component
end;

procedure TSpkToolbar.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  // During rebuilding procees the mouse is ignored
  if fInternalUpdating or fUpdating then
    Exit;

  inherited MouseDown(Button, Shift, X, Y);

  // It is possible that the other mouse button was pressed
  // In this situation active object receives next notification
  if fMouseActiveElement = teTabs then
    TabMouseDown(Button, Shift, X, Y)
  else if fMouseActiveElement = teTabContents then
  begin
    if fActiveTabIndex <> UNDEFINED_TAB_INDEX then
      fTabs[fActiveTabIndex].MouseDown(Button, Shift, X, Y);
  end
  else if fMouseActiveElement = teToolbarArea then
  begin
    // Placeholder if there will be need to use this event
  end
  else
  // If there is no active element, the active element will be one
  // which is now under the mouse
  if fMouseActiveElement = teNone then
  begin
    if fMouseHoverElement = teTabs then
    begin
      fMouseActiveElement := teTabs;
      TabMouseDown(Button, Shift, X, Y);
    end
    else
    if fMouseHoverElement = teTabContents then
    begin
      fMouseActiveElement := teTabContents;
      if fActiveTabIndex <> UNDEFINED_TAB_INDEX then
        fTabs[fActiveTabIndex].MouseDown(Button, Shift, X, Y);
    end
    else
    if fMouseHoverElement = teToolbarArea then
    begin
      fMouseActiveElement := teToolbarArea;
      // Placeholder if there will be need to use this event
    end;
  end;
end;

procedure TSpkToolbar.MouseLeave;
begin
  // During rebuilding procees the mouse is ignored
  if fInternalUpdating or fUpdating then
    Exit;

  // MouseLeave has no chance to be called for active object
  // because when the mouse button is pressed every mouse move is transfered
  // as MouseMove. If the mouse left from component region then
  // MouseLeave will be called just after MouseUp but MouseUp cleans the
  // active object
  if fMouseActiveElement = teNone then
  begin
    // If there is no active element, the elements under mouse will be supported
    if fMouseHoverElement = teTabs then
      TabMouseLeave
    else if fMouseHoverElement = teTabContents then
    begin
      if fActiveTabIndex <> UNDEFINED_TAB_INDEX then
        fTabs[fActiveTabIndex].MouseLeave;
    end
    else if fMouseHoverElement = teToolbarArea then
    begin
      // Placeholder if there will be need to use this event
    end;
  end;

  fMouseHoverElement := teNone;
end;

procedure TSpkToolbar.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  lNewMouseHoverElement: TSpkMouseToolbarElement;
  lMousePoint: T2DIntVector;
begin
  // During rebuilding process the mouse is ignored
  if fInternalUpdating or fUpdating then
    Exit;

  inherited MouseMove(Shift, X, Y);

  // Checking which element is under the mouse
  lMousePoint := T2DIntVector.Create(x, y);

  if fTabClipRect.Contains(lMousePoint) then
    lNewMouseHoverElement := teTabs
  else if fTabContentsClipRect.Contains(lMousePoint) then
    lNewMouseHoverElement := teTabContents
  else if (X >= 0) and (Y >= 0) and (X < Self.Width) and (Y < Self.Height) then
    lNewMouseHoverElement := teToolbarArea
  else
    lNewMouseHoverElement := teNone;

  // If there is an active element then it has exlusiveness for messages
  if fMouseActiveElement = teTabs then
    TabMouseMove(Shift, X, Y)
  else if fMouseActiveElement = teTabContents then
  begin
    if fActiveTabIndex <> UNDEFINED_TAB_INDEX then
      fTabs[fActiveTabIndex].MouseMove(Shift, X, Y);
  end
  else if fMouseActiveElement = teToolbarArea then
  begin
    // Placeholder if there will be need to use this event
  end
  else if fMouseActiveElement = teNone then
  begin
    // If element changes under the mouse, then previous element will be informed
    // that mouse is leaving its region
    if lNewMouseHoverElement <> fMouseHoverElement then
    begin
      if fMouseHoverElement = teTabs then
        TabMouseLeave
      else if fMouseHoverElement = teTabContents then
      begin
        if fActiveTabIndex <> UNDEFINED_TAB_INDEX then
          fTabs[fActiveTabIndex].MouseLeave;
      end
      else if fMouseHoverElement = teToolbarArea then
      begin
        // Placeholder if there will be need to use this event
      end;
    end;

    // Element under mouse receives MouseMove
    if lNewMouseHoverElement = teTabs then
      TabMouseMove(Shift, X, Y)
    else if lNewMouseHoverElement = teTabContents then
    begin
      if fActiveTabIndex <> UNDEFINED_TAB_INDEX then
        fTabs[fActiveTabIndex].MouseMove(Shift, X, Y);
    end
    else if lNewMouseHoverElement = teToolbarArea then
    begin
      // Placeholder if there will be need to use this event
    end;
  end;

  fMouseHoverElement := lNewMouseHoverElement;
end;

procedure TSpkToolbar.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  lClearActive: Boolean;
begin
  // During rebuilding procees the mouse is ignored
  if fInternalUpdating or fUpdating then
    Exit;

  inherited MouseUp(Button, Shift, X, Y);

  lClearActive := not (ssLeft in Shift) and not (ssMiddle in Shift) and not (ssRight in Shift);

  // If there is an active element then it has exlusiveness for messages
  if fMouseActiveElement = teTabs then
    TabMouseUp(Button, Shift, X, Y)
  else if fMouseActiveElement = teTabContents then
  begin
    if fActiveTabIndex <> UNDEFINED_TAB_INDEX then
      fTabs[fActiveTabIndex].MouseUp(Button, Shift, X, Y);
  end
  else if fMouseActiveElement = teToolbarArea then
  begin
    // Placeholder if there will be need to use this event
  end;

  // If the last mouse button is released and mouse doesn't locate over
  // the active object, it must additionally call MouseLeave for active one
  // and MouseMove for object being under mouse
  if lClearActive and (fMouseActiveElement <> fMouseHoverElement) then
  begin
    if fMouseActiveElement = teTabs then
      TabMouseLeave
    else if fMouseActiveElement = teTabContents then
    begin
      if fActiveTabIndex <> UNDEFINED_TAB_INDEX then
        fTabs[fActiveTabIndex].MouseLeave;
    end
    else if fMouseActiveElement = teToolbarArea then
    begin
      // Placeholder if there will be need to use this event
    end;

    if fMouseHoverElement = teTabs then
      TabMouseMove(Shift, X, Y)
    else if fMouseHoverElement = teTabContents then
    begin
      if fActiveTabIndex <> UNDEFINED_TAB_INDEX then
        fTabs[fActiveTabIndex].MouseMove(Shift, X, Y);
    end
    else if fMouseHoverElement = teToolbarArea then
    begin
      // Placeholder if there will be need to use this event
    end;
  end;

  // MouseUp swiches off active object, when all mouse buttons were released
  if lClearActive then
    fMouseActiveElement := teNone;
end;

procedure TSpkToolbar.Notification(aComponent: TComponent; Operation: TOperation);
var
  lTab: TSpkTab;
  lPane: TSpkPane;
  lItem: TSpkBaseItem;
begin
  inherited;

  if Operation <> opRemove then
    Exit;

  if aComponent is TSpkTab then
    FreeingTab(aComponent as TSpkTab)
  else if aComponent is TSpkPane then
  begin
    lPane := aComponent as TSpkPane;
    if (lPane.Parent <> nil) and (lPane.Parent is TSpkTab) then
    begin
      lTab := lPane.Parent as TSpkTab;
      lTab.FreeingPane(lPane);
    end;
  end
  else if aComponent is TSpkBaseItem then
  begin
    lItem := aComponent as TSpkBaseItem;
    if (lItem.Parent <> nil) and (lItem.Parent is TSpkPane) then
    begin
      lPane := lItem.Parent as TSpkPane;
      lPane.FreeingItem(lItem);
    end;
  end;
end;

procedure TSpkToolbar.NotifyAppearanceChanged;
begin
  SetMetricsInvalid;
  if not (fInternalUpdating or fUpdating) then
    Invalidate;
end;

procedure TSpkToolbar.NotifyMetricsChanged;
begin
  SetMetricsInvalid;
  if not (fInternalUpdating or fUpdating) then
    Invalidate;
end;

procedure TSpkToolbar.NotifyItemsChanged;
var
  lOldTabIndex: Integer;
begin
  lOldTabIndex := fActiveTabIndex;
  // Fixed TabIndex when you need it
  if not AtLeastOneTabVisible then
    fActiveTabIndex := UNDEFINED_TAB_INDEX
  else
  begin
    fActiveTabIndex := Max(0, Min(fTabs.Count - 1, fActiveTabIndex));

    // I know that at least one tab is visible (from previous condition)
    // so below loop will finish
    while not fTabs[fActiveTabIndex].Visible do
      fActiveTabIndex := (fActiveTabIndex + 1) mod fTabs.Count;
  end;
  fHotTabIndex := UNDEFINED_TAB_INDEX;

  if DoTabChanging(lOldTabIndex, fActiveTabIndex) then
  begin
    SetMetricsInvalid;

    if not (fInternalUpdating or fUpdating) then
      Invalidate;

    if Assigned(fOnTabChanged) then
      fOnTabChanged(Self);
  end
  else
    fActiveTabIndex := lOldTabIndex;
end;

procedure TSpkToolbar.NotifyVisualsChanged;
begin
  SetBufferInvalid;
  if not (fInternalUpdating or fUpdating) then
    Invalidate;
end;

procedure TSpkToolbar.Paint;
begin
  // If the rebuilding process (internal or by user) is running now
  // then validation of metrics and buffer is not running, however
  // the buffer is drawn in a shape what was remembered before rebuilding process
  if not (fInternalUpdating or fUpdating) then
  begin
    if not (fMetricsValid) then
      ValidateMetrics;
    if not (fBufferValid) then
      ValidateBuffer;
  end;
  Self.Canvas.Draw(0, 0, fBuffer);
end;

procedure TSpkToolbar.Resize;
begin
  if Height <> SPK_TOOLBAR_HEIGHT then
    Height := SPK_TOOLBAR_HEIGHT;

  SetMetricsInvalid;
  SetBufferInvalid;

  if not (fInternalUpdating or fUpdating) then
    Invalidate;

  inherited;
end;

procedure TSpkToolbar.SetBufferInvalid;
begin
  fBufferValid := False;
end;

procedure TSpkToolbar.SetColor(Value: TColor);
begin
  inherited Color := Value;
  SetBufferInvalid;
  if not (fInternalUpdating or fUpdating) then
    Invalidate;
end;

procedure TSpkToolbar.SetDisabledImages(const Value: TImageList);
begin
  fDisabledImages := Value;
  fTabs.DisabledImages := Value;
  SetMetricsInvalid;
  if not (fInternalUpdating or fUpdating) then
    Invalidate;
end;

procedure TSpkToolbar.SetDisabledLargeImages(const Value: TImageList);
begin
  fDisabledLargeImages := Value;
  fTabs.DisabledLargeImages := Value;
  SetMetricsInvalid;
  if not (fInternalUpdating or fUpdating) then
    Invalidate;
end;

procedure TSpkToolbar.SetImages(const Value: TImageList);
begin
  fImages := Value;
  fTabs.Images := Value;
  SetMetricsInvalid;
  if not (fInternalUpdating or fUpdating) then
    Invalidate;
end;

procedure TSpkToolbar.SetLargeImages(const Value: TImageList);
begin
  fLargeImages := Value;
  fTabs.LargeImages := Value;
  SetMetricsInvalid;
  if not (fInternalUpdating or fUpdating) then
    Invalidate;
end;

procedure TSpkToolbar.SetStyle(const Value: TSpkStyle);
begin
  fStyle := Value;
  fAppearance.Reset(fStyle);
  ForceRepaint;
end;

function TSpkToolbar.DoTabChanging(OldIndex, NewIndex: Integer): Boolean;
begin
  Result := True;
  if Assigned(fOnTabChanging) then
    fOnTabChanging(Self, OldIndex, NewIndex, Result);
end;

function TSpkToolbar.DPIScale(aSize: Integer): Integer;
begin
  Result := MulDiv(aSize, fCurrentPPI, 96);
end;

procedure TSpkToolbar.SetMetricsInvalid;
begin
  fMetricsValid := False;
  fBufferValid := False;
end;

procedure TSpkToolbar.SetTabIndex(const Value: Integer);
var
  lOldTabIndex: Integer;
begin
  lOldTabIndex := fActiveTabIndex;

  if not AtLeastOneTabVisible then
    fActiveTabIndex := UNDEFINED_TAB_INDEX
  else
  begin
    fActiveTabIndex := Max(0, Min(fTabs.Count - 1, Value));

    // I know that at least one tab is visible (from previous condition)
    // so below loop will finish
    while not (fTabs[fActiveTabIndex].Visible) do
      fActiveTabIndex := (fActiveTabIndex + 1) mod fTabs.Count;
  end;
  fHotTabIndex := UNDEFINED_TAB_INDEX;

  if DoTabChanging(lOldTabIndex, fActiveTabIndex) then
  begin
    SetMetricsInvalid;
    if not (fInternalUpdating or fUpdating) then
      Invalidate;
    if Assigned(fOnTabChanged) then
      fOnTabChanged(self);
  end
  else
    fActiveTabIndex := lOldTabIndex;
end;

procedure TSpkToolbar.TabMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
  lSelTab: Integer;
  lTabRect: T2DIntRect;
begin
  // During rebuilding procees the mouse is ignored
  if fInternalUpdating or fUpdating then
    Exit;

  lSelTab := UNDEFINED_TAB_INDEX;
  for i := 0 to fTabs.Count - 1 do
    if fTabs[i].Visible then
    begin
      if fTabClipRect.IntersectsWith(fTabRects[i], lTabRect) then
        if lTabRect.Contains(T2DIntPoint.Create(x, y)) then
          lSelTab := i;
    end;

  // If any tab was clicked but one (not being selected) then change selection
  if (Button = mbLeft) and (lSelTab <> -1) and (lSelTab <> fActiveTabIndex) then
  begin
    if DoTabChanging(fActiveTabIndex, lSelTab) then
    begin
      fActiveTabIndex := lSelTab;
      SetMetricsInvalid;
      Invalidate;
      if Assigned(fOnTabChanged) then
        fOnTabChanged(self);
    end;
  end;
end;

procedure TSpkToolbar.TabMouseLeave;
begin
  // During rebuilding procees the mouse is ignored
  if fInternalUpdating or fUpdating then
    Exit;

  if fHotTabIndex <> UNDEFINED_TAB_INDEX then
  begin
    fHotTabIndex := UNDEFINED_TAB_INDEX;
    SetBufferInvalid;
    Invalidate;
  end;
end;

procedure TSpkToolbar.TabMouseMove(Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
  lNewTabHover: Integer;
  lTabRect: T2DIntRect;
begin
  // During rebuilding procees the mouse is ignored
  if fInternalUpdating or fUpdating then
    Exit;

  lNewTabHover := UNDEFINED_TAB_INDEX;
  for i := 0 to fTabs.Count - 1 do
    if fTabs[i].Visible then
    begin
      if fTabClipRect.IntersectsWith(fTabRects[i], lTabRect) then
        if lTabRect.Contains(T2DIntPoint.Create(x, y)) then
          lNewTabHover := i;
    end;

  if lNewTabHover <> fHotTabIndex then
  begin
    fHotTabIndex := lNewTabHover;
    SetBufferInvalid;
    Invalidate;
  end;
end;

procedure TSpkToolbar.TabMouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  // During rebuilding procees the mouse is ignored
  if fInternalUpdating or fUpdating then
    Exit;

  if (fActiveTabIndex <> UNDEFINED_TAB_INDEX) then
    fTabs[fActiveTabIndex].ExecOnClick;

  // Tabs don't need MouseUp
end;

procedure TSpkToolbar.UpdateActions;
begin
  fTabs.UpdateActions;
end;

procedure TSpkToolbar.SetAppearance(const Value: TSpkToolbarAppearance);
begin
  fAppearance.Assign(Value);
  SetBufferInvalid;
  if not (fInternalUpdating or fUpdating) then
    Invalidate;
end;

procedure TSpkToolbar.ValidateBuffer;

  procedure DrawBackgroundColor;
  begin
    fBuffer.Canvas.Brush.Color := Color;
    fBuffer.Canvas.Brush.Style := bsSolid;
    fBuffer.Canvas.FillRect(Rect(0, 0, Self.Width, Self.Height));
  end;

  procedure DrawBody;
  var
    i: Integer;
    lFocusedAppearance: TSpkToolbarAppearance;
  begin
    // Loading appearance of selected tab
    // or fToolbarAppearance if selected tab has no set OverrideAppearance
    if (fActiveTabIndex <> UNDEFINED_TAB_INDEX) and (fTabs[fActiveTabIndex].OverrideAppearance) then
      lFocusedAppearance := fTabs[fActiveTabIndex].CustomAppearance
    else
      lFocusedAppearance := fAppearance;

    TGuiTools.DrawRoundRect(fBuffer.Canvas,
      T2DIntRect.Create(0, SPK_TOOLBAR_TAB_CAPTIONS_HEIGHT, Self.Width -1, Self.Height - 1),
      SPK_TOOLBAR_CORNER_RADIUS,
      lFocusedAppearance.Tab.GradientFromColor,
      lFocusedAppearance.Tab.GradientToColor,
      lFocusedAppearance.Tab.GradientType);

    TGuiTools.DrawAARoundCorner(fBuffer,
      T2DIntPoint.Create(0, SPK_TOOLBAR_TAB_CAPTIONS_HEIGHT),
      SPK_TOOLBAR_CORNER_RADIUS,
      cpLeftTop,
      lFocusedAppearance.Tab.BorderColor);

    TGuiTools.DrawAARoundCorner(fBuffer,
      T2DIntPoint.Create(Self.Width - SPK_TOOLBAR_CORNER_RADIUS, SPK_TOOLBAR_TAB_CAPTIONS_HEIGHT),
      SPK_TOOLBAR_CORNER_RADIUS,
      cpRightTop,
      lFocusedAppearance.Tab.BorderColor);

    TGuiTools.DrawAARoundCorner(fBuffer,
      T2DIntPoint.Create(0, Self.Height - SPK_TOOLBAR_CORNER_RADIUS),
      SPK_TOOLBAR_CORNER_RADIUS,
      cpLeftBottom,
      lFocusedAppearance.Tab.BorderColor);

    TGuiTools.DrawAARoundCorner(fBuffer,
      T2DIntPoint.Create(Self.Width - SPK_TOOLBAR_CORNER_RADIUS, Self.Height - SPK_TOOLBAR_CORNER_RADIUS),
      SPK_TOOLBAR_CORNER_RADIUS,
      cpRightBottom,
      lFocusedAppearance.Tab.BorderColor);

    {
    TGuiTools.DrawVLine(fBuffer, 0, ToolbarTabCaptionsHeight +
      ToolbarCornerRadius, Self.Height - ToolbarCornerRadius,
      lFocusedAppearance.Tab.BorderColor);
    }

    TGuiTools.DrawHLine(fBuffer, SPK_TOOLBAR_CORNER_RADIUS, Self.Width - SPK_TOOLBAR_CORNER_RADIUS,
      Self.Height - 1, lFocusedAppearance.Tab.BorderColor);
    {
    TGuiTools.DrawVLine(fBuffer, Self.Width - 1, ToolbarTabCaptionsHeight +
      ToolbarCornerRadius, Self.Height - ToolbarCornerRadius,
      lFocusedAppearance.Tab.BorderColor);
    }

    if not AtLeastOneTabVisible then
    begin

      // If there are no tabs then the horizontal line will be drawn
      TGuiTools.DrawHLine(fBuffer, SPK_TOOLBAR_CORNER_RADIUS, Self.Width - SPK_TOOLBAR_CORNER_RADIUS,
        SPK_TOOLBAR_TAB_CAPTIONS_HEIGHT, lFocusedAppearance.Tab.BorderColor);
    end
    else
    begin
      i := 0;
      while not fTabs[i].Visible do
        Inc(i);

      TGuiTools.DrawHLine(fBuffer, 0, fTabRects[i].Left - SPK_TOOLBAR_CORNER_RADIUS,
        SPK_TOOLBAR_TAB_CAPTIONS_HEIGHT, lFocusedAppearance.Tab.BorderColor);
      // If there are tabs then the place will be left for them
      // Last visible tab is looked for
      i := fTabs.Count - 1;
      while not fTabs[i].Visible do
        Dec(i);

      // Only right part, the rest will be drawn with tabs
      if fTabRects[i].Right < Self.Width - SPK_TOOLBAR_CORNER_RADIUS - 1 then
        TGuiTools.DrawHLine(fBuffer, fTabRects[i].Right + 1, Self.Width - SPK_TOOLBAR_CORNER_RADIUS,
          SPK_TOOLBAR_TAB_CAPTIONS_HEIGHT, lFocusedAppearance.Tab.BorderColor);
    end;
  end;

  procedure DrawTabs;
  var
    i: Integer;
    lCurrentAppearance: TSpkToolbarAppearance;
    lFocusedAppearance: TSpkToolbarAppearance;

    procedure DrawTabText(aTabIndex: Integer; aFont: TFont; aOverrideTextColor: TColor = clNone);
    var
      x, y: Integer;
      lColor: TColor;
      lTabRect: T2DIntRect;
    begin
      lTabRect := fTabRects[aTabIndex];
      fBuffer.Canvas.Font.Assign(aFont);
      // fBuffer.Canvas.Font.Height := DPIScale(aFont.Height);

      if aOverrideTextColor <> clNone then
        lColor := aOverrideTextColor
      else
        lColor := aFont.Color;
      x := lTabRect.Left + (lTabRect.Width - fBuffer.Canvas.TextWidth(fTabs[aTabIndex].Caption)) div 2;
      y := lTabRect.Top + (lTabRect.Height - fBuffer.Canvas.TextHeight('Wy')) div 2;

      TGuiTools.DrawText(fBuffer.Canvas, x, y, fTabs[aTabIndex].Caption, lColor, fTabClipRect);
    end;

    procedure DrawTab(aTabIndex: Integer; aBorderColor, aGradientFrom, aGradientTo: TColor);
    var
      lTabRect: T2DIntRect;
      lTabRegion: HRGN;
      lTmpRegion, lTmpRegion2: HRGN;
    begin
      // Note!! Tabs cover one pixel of toolbar region, because
      // the they must draw edge, which fits in with region edge
      lTabRect := fTabRects[aTabIndex];

      // Middle rectangle
      lTabRegion := CreateRectRgn(
        lTabRect.Left + SPK_TAB_CORNER_RADIUS - 1,
        lTabRect.Top + SPK_TAB_CORNER_RADIUS,
        lTabRect.Right - SPK_TAB_CORNER_RADIUS + 1 + 1,
        lTabRect.Bottom + 1
      );
      // Top part with top convex curves
      lTmpRegion := CreateRectRgn(
        lTabRect.Left + 2 * SPK_TAB_CORNER_RADIUS - 1,
        lTabRect.Top,
        lTabRect.Right - 2 * SPK_TAB_CORNER_RADIUS + 1 + 1,
        lTabRect.Top + SPK_TAB_CORNER_RADIUS
      );
      CombineRgn(lTabRegion, lTabRegion, lTmpRegion, RGN_OR);
      DeleteObject(lTmpRegion);

      lTmpRegion := CreateEllipticRgn(
        lTabRect.Left + SPK_TAB_CORNER_RADIUS - 1,
        lTabRect.Top,
        lTabRect.Left + 3 * SPK_TAB_CORNER_RADIUS,
        lTabRect.Top + 2 * SPK_TAB_CORNER_RADIUS + 1
      );
      CombineRgn(lTabRegion, lTabRegion, lTmpRegion, RGN_OR);
      DeleteObject(lTmpRegion);

      lTmpRegion := CreateEllipticRgn(
        lTabRect.Right - 3 * SPK_TAB_CORNER_RADIUS + 2,
        lTabRect.Top,
        lTabRect.Right - SPK_TAB_CORNER_RADIUS + 3,
        lTabRect.Top + 2 * SPK_TAB_CORNER_RADIUS + 1
      );
      CombineRgn(lTabRegion, lTabRegion, lTmpRegion, RGN_OR);
      DeleteObject(lTmpRegion);
      // Bottom part with bottom convex curves
      lTmpRegion := CreateRectRgn(
        lTabRect.Left,
        lTabRect.Bottom - SPK_TAB_CORNER_RADIUS,
        lTabRect.Right + 1,
        lTabRect.Bottom + 1
      );

      lTmpRegion2 := CreateEllipticRgn(
        lTabRect.Left - SPK_TAB_CORNER_RADIUS,
        lTabRect.Bottom - 2 * SPK_TAB_CORNER_RADIUS + 1,
        lTabRect.Left + SPK_TAB_CORNER_RADIUS + 1,
        lTabRect.Bottom + 2
      );
      CombineRgn(lTmpRegion, lTmpRegion, lTmpRegion2, RGN_DIFF);
      DeleteObject(lTmpRegion2);

      lTmpRegion2 := CreateEllipticRgn(
        lTabRect.Right - SPK_TAB_CORNER_RADIUS + 1,
        lTabRect.Bottom - 2 * SPK_TAB_CORNER_RADIUS + 1,
        lTabRect.Right + SPK_TAB_CORNER_RADIUS + 2,
        lTabRect.Bottom + 2
      );
      CombineRgn(lTmpRegion, lTmpRegion, lTmpRegion2, RGN_DIFF);
      DeleteObject(lTmpRegion2);

      CombineRgn(lTabRegion, lTabRegion, lTmpRegion, RGN_OR);
      DeleteObject(lTmpRegion);

      TGUITools.DrawRegion(fBuffer.Canvas,
        lTabRegion,
        lTabRect,
        aGradientFrom,
        aGradientTo,
        bkVerticalGradient);

      DeleteObject(lTabRegion);

      // Frame
      TGuiTools.DrawAARoundCorner(fBuffer,
        T2DIntPoint.Create(lTabRect.Left, lTabRect.Bottom - SPK_TAB_CORNER_RADIUS + 1),
        SPK_TAB_CORNER_RADIUS,
        cpRightBottom,
        aBorderColor,
        fTabClipRect);

      TGuiTools.DrawAARoundCorner(fBuffer,
        T2DIntPoint.Create(lTabRect.Right - SPK_TAB_CORNER_RADIUS + 1, lTabRect.Bottom - SPK_TAB_CORNER_RADIUS + 1),
        SPK_TAB_CORNER_RADIUS,
        cpLeftBottom,
        aBorderColor,
        fTabClipRect);

      TGuiTools.DrawVLine(fBuffer,
        lTabRect.Left + SPK_TAB_CORNER_RADIUS - 1,
        lTabRect.Top + SPK_TAB_CORNER_RADIUS,
        lTabRect.Bottom - SPK_TAB_CORNER_RADIUS + 1,
        aBorderColor,
        fTabClipRect);

      TGuiTools.DrawVLine(fBuffer,
        lTabRect.Right - SPK_TAB_CORNER_RADIUS + 1,
        lTabRect.Top + SPK_TAB_CORNER_RADIUS,
        lTabRect.Bottom - SPK_TAB_CORNER_RADIUS + 1,
        aBorderColor,
        fTabClipRect);

      TGuiTools.DrawAARoundCorner(fBuffer,
        T2DIntPoint.Create(lTabRect.Left + SPK_TAB_CORNER_RADIUS - 1, 0),
        SPK_TAB_CORNER_RADIUS,
        cpLeftTop,
        aBorderColor,
        fTabClipRect);

      TGuiTools.DrawAARoundCorner(fBuffer,
        T2DIntPoint.Create(lTabRect.Right - 2 * SPK_TAB_CORNER_RADIUS + 2, 0),
        SPK_TAB_CORNER_RADIUS,
        cpRightTop,
        aBorderColor,
        fTabClipRect);

      TGuiTools.DrawHLine(fBuffer,
        lTabRect.Left + 2 * SPK_TAB_CORNER_RADIUS - 1,
        lTabRect.Right - 2 * SPK_TAB_CORNER_RADIUS + 2,
        0,
        aBorderColor,
        fTabClipRect);
    end;

    procedure DrawBottomLine(aTabIndex: Integer; aBorderColor: TColor);
    var
      lTabRect: T2DIntRect;
    begin
      lTabRect := fTabRects[aTabIndex];

      TGUITools.DrawHLine(fBuffer,
        lTabRect.Left,
        lTabRect.Right,
        lTabRect.Bottom,
        aBorderColor,
        fTabClipRect);
    end;

  var
    lGradientColorDelta: Integer;
  begin
    {*** I assume that the tabs size is reasonable ***}

    if (fActiveTabIndex <> UNDEFINED_TAB_INDEX) and (fTabs[fActiveTabIndex].OverrideAppearance) then
      lFocusedAppearance := fTabs[fActiveTabIndex].CustomAppearance
    else
      lFocusedAppearance := fAppearance;

    if fTabs.Count > 0 then
      for i := 0 to fTabs.Count - 1 do
        if fTabs[i].Visible then
        begin
          // Is there any sense to draw?
          if not (fTabClipRect.IntersectsWith(fTabRects[i])) then
            Continue;

          //Loading appearance of now drawn tab
          if (fTabs[i].OverrideAppearance) then
            lCurrentAppearance := fTabs[i].CustomAppearance
          else
            lCurrentAppearance := fAppearance;

          if lCurrentAppearance.Tab.GradientType = bkSolid then
            lGradientColorDelta := 50 // Old value: 0
          else
            lGradientColorDelta := 50;

          // Tab is drawn
          if i = fActiveTabIndex then
          begin
            if i = fHotTabIndex then
            begin
              DrawTab(i,
                lCurrentAppearance.Tab.BorderColor,
                TColorTools.Brighten(TColorTools.Brighten(
                  lCurrentAppearance.Tab.GradientFromColor, lGradientColorDelta), lGradientColorDelta),
                lCurrentAppearance.Tab.GradientFromColor);
            end
            else
            begin
              DrawTab(i,
                lCurrentAppearance.Tab.BorderColor,
                TColorTools.Brighten(
                  lCurrentAppearance.Tab.GradientFromColor, lGradientColorDelta),
                lCurrentAppearance.Tab.GradientFromColor);
            end;

            DrawTabText(i, lCurrentAppearance.Tab.TabHeaderFont);
          end
          else
          begin
            if i = fHotTabIndex then
            begin
              DrawTab(i,
                TColorTools.Shade(
                  Self.Color, lCurrentAppearance.Tab.BorderColor, lGradientColorDelta),
                TColorTools.Shade(Self.color,
                  TColorTools.Brighten(lCurrentAppearance.Tab.GradientFromColor, lGradientColorDelta), 50),
                TColorTools.Shade(
                  Self.color, lCurrentAppearance.Tab.GradientFromColor, 50) );
            end;
            // Bottom line
            // Warning!! Irrespective of tab, the appearance will be drawn
            // with color now selected tab
            DrawBottomLine(i, lFocusedAppearance.Tab.BorderColor);
            // Text
            DrawTabText(i, lCurrentAppearance.Tab.TabHeaderFont,
              lCurrentAppearance.Tab.InactiveTabHeaderFontColor);
          end;
        end;
  end;

  procedure DrawTabContents;
  begin
    if fActiveTabIndex <> UNDEFINED_TAB_INDEX then
      fTabs[fActiveTabIndex].Draw(fBuffer, fTabContentsClipRect);
  end;

begin
  if fInternalUpdating or fUpdating then
    Exit;
  if fBufferValid then
    Exit;

  // ValidateBuffer could be called only when metrics is calulated
  // Method assumes that buffer has proper sizes and all rects of toolbar and
  // sub-elements are correctly calculated

  // Component background
  DrawBackgroundColor;
  // The toolbar background is generated
  DrawBody;
  // Tabs
  DrawTabs;
  // Tabs content
  DrawTabContents;
  // Buffer is correct
  fBufferValid := True;
end;

procedure TSpkToolbar.ValidateMetrics;
var
  i: Integer;
  x: Integer;
  lTabWidth: Integer;
  lTabAppearance: TSpkToolbarAppearance;
begin
  if fInternalUpdating or fUpdating then
    Exit;
  if fMetricsValid then
    Exit;

  fBuffer.Free;
  fBuffer := TBitmap.Create;
  fBuffer.PixelFormat := pf24bit;
  fBuffer.SetSize(Self.Width, Self.Height);

  // *** Tabs ***

  // Cliprect of tabs (containg top frame of component)
  fTabClipRect := T2DIntRect.Create(
    SPK_TOOLBAR_CORNER_RADIUS,
    0,
    Self.Width - SPK_TOOLBAR_CORNER_RADIUS - 1,
    SPK_TOOLBAR_TAB_CAPTIONS_HEIGHT
  );

  // Rects of tabs headings (containg top frame of component)
  Setlength(fTabRects, fTabs.Count);
  if fTabs.Count > 0 then
  begin
    x := SPK_TOOLBAR_TAB_START_OFFSET;
    for i := 0 to fTabs.Count - 1 do
      if fTabs[i].Visible then
      begin
        // Loading appearance of tab
        if fTabs[i].OverrideAppearance then
          lTabAppearance := fTabs[i].CustomAppearance
        else
          lTabAppearance := fAppearance;
        fBuffer.Canvas.Font.Assign(lTabAppearance.Tab.TabHeaderFont);

        lTabWidth := 2 +  // Frame
          2 * SPK_TAB_CORNER_RADIUS +
          // Curves
          2 * SPK_TOOLBAR_TAB_CAPTIONS_TEXT_HPADDING +
          // Internal margins
          Max(SPK_TOOLBAR_MIN_TAB_CAPTION_WIDTH,
          fBuffer.Canvas.TextWidth(fTabs.Items[i].Caption));
        // Breadth of text

        fTabRects[i].Left := x;
        fTabRects[i].Right := x + lTabWidth - 1;
        fTabRects[i].Top := 0;
        fTabRects[i].Bottom := SPK_TOOLBAR_TAB_CAPTIONS_HEIGHT;

        x := fTabRects[i].Right + 1;
      end
      else
      begin
        fTabRects[i] := T2DIntRect.Create(-1, -1, -1, -1);
      end;
  end;

  // *** Panes ***

  if fActiveTabIndex <> UNDEFINED_TAB_INDEX then
  begin
    // Rect of tab region
    fTabContentsClipRect := T2DIntRect.Create(SPK_TOOLBAR_BORDER_WIDTH + SPK_TAB_PANE_LEFT_PADDING,
      SPK_TOOLBAR_TAB_CAPTIONS_HEIGHT + SPK_TOOLBAR_BORDER_WIDTH + SPK_TAB_PANE_TOP_PADDING,
      Self.Width - 1 - SPK_TOOLBAR_BORDER_WIDTH - SPK_TAB_PANE_RIGHT_PADDING,
      Self.Height - 1 - SPK_TOOLBAR_BORDER_WIDTH - SPK_TAB_PANE_BOTTOM_PADDING
    );

    fTabs[fActiveTabIndex].Rect := fTabContentsClipRect;
  end;

  fMetricsValid := True;
end;

{ Hi-DPI image list support }

procedure TSpkToolbar.SetImagesWidth(const aValue: Integer);
begin
  if fImagesWidth = aValue then
    Exit;
  fImagesWidth := aValue;
  NotifyMetricsChanged
end;

procedure TSpkToolbar.SetLargeImagesWidth(const aValue: Integer);
begin
  if fLargeImagesWidth = aValue then
    Exit;
  fLargeImagesWidth := aValue;
  NotifyMetricsChanged
end;

end.
