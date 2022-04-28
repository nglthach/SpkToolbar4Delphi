unit SpkButtons;

interface

{$I Spk.inc}

uses
  Windows,
  ActnList,
  Classes,
  Controls,
  Graphics,
  ImgList,
  Math,
  Menus,
  SpkGUITools,
  SpkGraphTools,
  SpkMath,
  SpkConst,
  SpkBaseItem,
  SpkTypes;

type
  TSpkMouseButtonElement = (
    beNone,
    beButton,
    beDropdown
  );

  TSpkButtonKind = (
    bkButton,
    bkButtonDropdown,
    bkDropdown,
    bkToggle
  );

  TSpkDropdownArrowPosition = (
    apBottom,
    apRight
  );

  TSpkBaseButton = class;

  /// <summary>
  ///
  /// </summary>
  TSpkButtonActionLink = class(TActionLink)
  protected
    fClient: TSpkBaseButton;
    function IsOnExecuteLinked: Boolean; override;
    procedure AssignClient(aClient: TObject); override;
    procedure SetCaption(const Value: string); override;
    procedure SetChecked(Value: Boolean); override;
    procedure SetEnabled(Value: Boolean); override;
    procedure SetGroupIndex(Value: Integer); override;
    procedure SetImageIndex(Value: Integer); override;
    procedure SetOnExecute(Value: TNotifyEvent); override;
    procedure SetVisible(Value: Boolean); override;
  public
    function IsCaptionLinked: Boolean; override;
    function IsCheckedLinked: Boolean; override;
    function IsEnabledLinked: Boolean; override;
    function IsGroupIndexLinked: Boolean; override;
    function IsImageIndexLinked: Boolean; override;
    function IsVisibleLinked: Boolean; override;
  end;

  /// <summary>
  ///  Base button
  /// </summary>
  TSpkBaseButton = class abstract(TSpkBaseItem)
  private
    fMouseHoverElement: TSpkMouseButtonElement;
    fMouseActiveElement: TSpkMouseButtonElement;
    fDropdownArrowPosition: TSpkDropdownArrowPosition;
    // Getters and Setters
    function GetAction: TBasicAction;
    procedure SetAllowAllUp(const Value: Boolean);
    procedure SetButtonKind(const Value: TSpkButtonKind);
    procedure SetCaption(const Value: string);
    procedure SetDropdownMenu(const Value: TPopupMenu);
    procedure SetGroupIndex(const Value: Integer);
    procedure SetImageIndex(const Value: TImageIndex);
    procedure SetDropdownArrowPosition(const Value: TSpkDropdownArrowPosition);
  protected
    fCaption: string;
    fImageIndex: TImageIndex;
    fOnClick: TNotifyEvent;
    fActionLink: TSpkButtonActionLink;
    fButtonState: TSpkButtonState;
    fButtonRect: T2DIntRect;
    fDropdownRect: T2DIntRect;
    fButtonKind: TSpkButtonKind;
    fChecked: Boolean;
    fGroupIndex: Integer;
    fAllowAllUp: Boolean;
    fDropdownMenu: TPopupMenu;
    // *** Drawing support ***
    // The task of the method in inherited classes is to calculate the
    // button's rectangle and the dropdown menu depending on fButtonState
    procedure CalcRects; virtual; abstract;
    function GetDropdownPointForPopupMenu: T2DIntPoint; virtual; abstract;
    // *** Action support ***
    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); virtual;
    procedure Click; virtual;
    procedure DoActionChange(Sender: TObject);
    procedure InitiateAction; override;
    procedure Notification(aComponent: TComponent; Operation: TOperation); override;
    function GetDefaultCaption: string; virtual;

    function SiblingsChecked: Boolean; virtual;
    procedure UncheckSiblings; virtual;

    procedure DrawDropdownArrow(aBuffer: TBitmap; aRect: TRect; aColor: TColor);

    // Getters and Setters
    function GetChecked: Boolean; virtual;
    procedure SetAction(const Value: TBasicAction); virtual;
    procedure SetChecked(const Value: Boolean); virtual;
    procedure SetEnabled(const Value: Boolean); override;
    procedure SetRect(const Value: T2DIntRect); override;
  protected
    property AllowAllUp: Boolean read fAllowAllUp write SetAllowAllUp default False;
    property ButtonKind: TSpkButtonKind read fButtonKind write SetButtonKind default bkButton;
    property Checked: Boolean read GetChecked write SetChecked default False;
    property DropdownMenu: TPopupMenu read fDropdownMenu write SetDropdownMenu;
    property DropdownArrowPosition: TSpkDropdownArrowPosition read fDropdownArrowPosition write SetDropdownArrowPosition;
    property GroupIndex: Integer read fGroupIndex write SetGroupIndex default 0;
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    procedure MouseLeave; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    function GetRootComponent: TComponent;
  published
    property Action: TBasicAction read GetAction write SetAction;
    property Caption: string read fCaption write SetCaption;
    property ImageIndex: TImageIndex read fImageIndex write SetImageIndex default -1;
    property OnClick: TNotifyEvent read fOnClick write fOnClick;
  end;

  /// <summary>
  ///
  /// </summary>
  TSpkLargeButton = class(TSpkBaseButton)
  private
    procedure FindBreakPlace(aCaption: string; out aPosition: Integer; out aWidth: Integer);
  protected
    function GetDropdownPointForPopupMenu : T2DIntPoint; override;
    procedure CalcRects; override;
  public
    procedure Draw(aBuffer: TBitmap; aClipRect: T2DIntRect); override;
    function GetGroupBehaviour: TSpkItemGroupBehaviour; override;
    function GetSizeType: TSpkItemSizeType; override;
    function GetTableBehaviour: TSpkItemTableBehaviour; override;
    function GetWidth: Integer; override;
  published
    property AllowAllUp;
    property BeginAGroup;
    property ButtonKind;
    property Checked;
    property DropdownMenu;
    property DropdownArrowPosition default apBottom;
    property GroupIndex;
  end;

  /// <summary>
  ///
  /// </summary>
  TSpkSmallButton = class(TSpkBaseButton)
  private
    fTableBehaviour: TSpkItemTableBehaviour;
    fGroupBehaviour: TSPkItemGroupBehaviour;
    fHideFrameWhenIdle: Boolean;
    fShowCaption: Boolean;
    fDropDownLabel: string;
    procedure ConstructRects(out aBtnRect, aDropRect: T2DIntRect);
    procedure SetGroupBehaviour(const Value: TSpkItemGroupBehaviour);
    procedure SetHideFrameWhenIdle(const Value: Boolean);
    procedure SetShowCaption(const Value: Boolean);
    procedure SetTableBehaviour(const Value: TSpkItemTableBehaviour);
    procedure SetDropDownLabel(const Value: string);
  protected
    procedure CalcRects; override;
    function GetDropdownPointForPopupMenu: T2DIntPoint; override;
  public
    constructor Create(aOwner: TComponent); override;
    procedure Draw(aBuffer: TBitmap; aClipRect: T2DIntRect); override;
    function GetGroupBehaviour: TSpkItemGroupBehaviour; override;
    function GetSizeType: TSpkItemSizeType; override;
    function GetTableBehaviour: TSpkItemTableBehaviour; override;
    function GetWidth: Integer; override;
  published
    property DropDownLabel: string read fDropDownLabel write SetDropDownLabel;
    property GroupBehaviour: TSpkItemGroupBehaviour read fGroupBehaviour write SetGroupBehaviour default gbSingleItem;
    property HideFrameWhenIdle: Boolean read fHideFrameWhenIdle write SetHideFrameWhenIdle default False;
    property ShowCaption: Boolean read fShowCaption write SetShowCaption default True;
    property TableBehaviour: TSpkItemTableBehaviour read fTableBehaviour write SetTableBehaviour default tbContinuesRow;
    property AllowAllUp;
    property ButtonKind;
    property Checked;
    property DropdownMenu;
    property GroupIndex;
  end;


implementation

uses
  SysUtils,
  SpkPane,
  SpkAppearance;

{ TSpkButtonActionLink }

procedure TSpkButtonActionLink.AssignClient(aClient: TObject);
begin
  fClient := TSpkBaseButton(aClient);
end;

function TSpkButtonActionLink.IsCaptionLinked: Boolean;
begin
  Result := inherited IsCaptionLinked and Assigned(fClient) and
            (fClient.Caption = (Action as TCustomAction).Caption);
end;

function TSpkButtonActionLink.IsCheckedLinked: Boolean;
begin
  Result := inherited IsCheckedLinked and Assigned(fClient) and
            (fClient.Checked = (Action as TCustomAction).Checked);
end;

function TSpkButtonActionLink.IsEnabledLinked: Boolean;
begin
  Result := inherited IsEnabledLinked and Assigned(fClient) and
            (fClient.Enabled = (Action as TCustomAction).Enabled);
end;

function TSpkButtonActionLink.IsGroupIndexLinked: Boolean;
begin
  Result := inherited IsGroupIndexLinked and Assigned(fClient) and
            (fClient.GroupIndex = (Action as TCustomAction).GroupIndex);
end;

function TSpkButtonActionLink.IsImageIndexLinked: Boolean;
begin
  Result := inherited IsImageIndexLinked and (TSpkSmallButton(fClient).ImageIndex = (Action as TCustomAction).ImageIndex);
end;

function TSpkButtonActionLink.IsOnExecuteLinked: Boolean;
begin
  Result := inherited IsOnExecuteLinked and DelegatesEqual(@fClient.OnClick, @Action.OnExecute);
end;

function TSpkButtonActionLink.IsVisibleLinked: Boolean;
begin
  Result := inherited IsVisibleLinked and Assigned(fClient) and
            (fClient.Visible = (Action as TCustomAction).Visible);
end;

procedure TSpkButtonActionLink.SetCaption(const Value: string);
begin
  if IsCaptionLinked then
    fClient.Caption := Value;
end;

procedure TSpkButtonActionLink.SetChecked(Value: Boolean);
begin
  if IsCheckedLinked then
    fClient.Checked := Value;
end;

procedure TSpkButtonActionLink.SetEnabled(Value: Boolean);
begin
  if IsEnabledLinked then
    fClient.Enabled := Value;
end;

procedure TSpkButtonActionLink.SetGroupIndex(Value: Integer);
begin
  if IsGroupIndexLinked then
    fClient.GroupIndex := Value;
end;

procedure TSpkButtonActionLink.SetImageIndex(Value: integer);
begin
  if IsImageIndexLinked then
    TSpkBaseButton(fClient).ImageIndex := Value;
end;

procedure TSpkButtonActionLink.SetOnExecute(Value: TNotifyEvent);
begin
{
  if IsOnExecuteLinked then
    fClient.OnClick := Value;
}
end;

procedure TSpkButtonActionLink.SetVisible(Value: Boolean);
begin
  if IsVisibleLinked then
    fClient.Visible := Value;
end;

{ TSpkBaseButton }

constructor TSpkBaseButton.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  fCaption := GetDefaultCaption;
  fBeginAGroup := False;
  fButtonState := bsIdle;
  fButtonKind := bkButton;
  fButtonRect := T2DIntRect.Create(0, 0, 1, 1);
  fDropdownRect := T2DIntRect.Create(0, 0, 1, 1);
  fDropdownArrowPosition := apBottom;
  fImageIndex := -1;
  fMouseHoverElement := beNone;
  fMouseActiveElement := beNone;
end;

destructor TSpkBaseButton.Destroy;
begin
  FreeAndNil(fActionLink);
  inherited Destroy;
end;

procedure TSpkBaseButton.ActionChange(Sender: TObject; CheckDefaults: Boolean);
begin
  if Sender is TCustomAction then
    with TCustomAction(Sender) do
    begin
      if not CheckDefaults or (Self.Caption = '') or (Self.Caption = Self.Name) then
        Self.Caption := Caption;
      if not CheckDefaults or (Self.Enabled = True) then
        Self.Enabled := Enabled;
      if not CheckDefaults or (Self.Visible = True) then
        Self.Visible := Visible;
      if not CheckDefaults or (Self.Checked = True) then
        Self.Checked := Checked;
      if not CheckDefaults or (Self.GroupIndex > 0) then
        Self.GroupIndex := GroupIndex;
      if not CheckDefaults or (Self.ImageIndex < 0) then
        Self.ImageIndex := ImageIndex;
      if not CheckDefaults or (@Self.OnClick = nil) then
        Self.OnClick := OnExecute;
    end;
end;

procedure TSpkBaseButton.Click;
begin
  { Call OnClick if assigned and not equal to associated action's OnExecute.
    If associated action's OnExecute assigned then call it, otherwise, call
    OnClick. }
  if Assigned(fOnClick) and (Action <> nil) and not DelegatesEqual(@fOnClick, @Action.OnExecute) then
    fOnClick(Self)
  else if not (csDesigning in ComponentState) and (fActionLink <> nil) then
    fActionLink.Execute(Self)
  else if Assigned(fOnClick) then
    fOnClick(Self);
end;

procedure TSpkBaseButton.DoActionChange(Sender: TObject);
begin
  if Sender = Action then
    ActionChange(Sender, False);
end;

{ Draw a downward-facing filled triangle as dropdown arrow }

procedure TSpkBaseButton.DrawDropdownArrow(aBuffer: TBitmap; aRect: TRect; aColor: TColor);
var
  P: array[0..3] of TPoint;
begin
  P[2].x := aRect.Left + (aRect.Right - aRect.Left) div 2;
  P[2].y := aRect.Top + (aRect.Bottom - aRect.Top + SPK_DROPDOWN_ARROW_HEIGHT) div 2 - 1;
  P[0] := Point(P[2].x - SPK_DROPDOWN_ARROW_WIDTH div 2, P[2].y - SPK_DROPDOWN_ARROW_HEIGHT div 2);
  P[1] := Point(P[2].x + SPK_DROPDOWN_ARROW_WIDTH div 2, P[0].y);
  P[3] := P[0];
  aBuffer.Canvas.Brush.Color := aColor;
  aBuffer.Canvas.Pen.Style := psClear;
  aBuffer.Canvas.Polygon(P);
end;

function TSpkBaseButton.GetAction: TBasicAction;
begin
  if Assigned(fActionLink) then
    Result := fActionLink.Action
  else
    Result := nil;
end;

function TSpkBaseButton.GetChecked: Boolean;
begin
  Result := fChecked;
end;

function TSpkBaseButton.GetDefaultCaption: string;
begin
  Result := 'Button';
end;

function TSpkBaseButton.GetRootComponent: TComponent;
var
  lTab: TSpkBaseItem;
  lPane: TSpkBaseItem;
begin
  Result := nil;
  if Collection <> nil then
    lPane := TSpkBaseItem(Collection.RootComponent)
  else
    Exit;

  if (lPane <> nil) and (lPane.Collection <> nil) then
    lTab := TSpkBaseItem(lPane.Collection.RootComponent)
  else
    Exit;

  if (lTab <> nil) and (lTab.Collection <> nil) then
    Result := lTab.Collection.RootComponent;
end;

procedure TSpkBaseButton.InitiateAction;
begin
  if fActionLink <> nil then
    fActionLink.Update;
end;

procedure TSpkBaseButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if fEnabled then
  begin
    // The buttons react only to the left mouse button
    if Button <> mbLeft then
      Exit;

    if (fButtonKind = bkToggle) and ((Action = nil) or
       ((Action is TCustomAction) and not TCustomAction(Action).AutoCheck))
    then
      Checked := not Checked;

    if fMouseActiveElement = beButton then
    begin
      if fButtonState <> bsBtnPressed then
      begin
        fButtonState := bsBtnPressed;
        NotifyVisualsChanged;
      end;
    end
    else if fMouseActiveElement = beDropdown then
    begin
      if fButtonState <> bsDropdownPressed then
      begin
        fButtonState := bsDropdownPressed;
        NotifyVisualsChanged;
      end;
    end
    else if fMouseActiveElement = beNone then
    begin
      if fMouseHoverElement = beButton then
      begin
        fMouseActiveElement := beButton;
        if fButtonState <> bsBtnPressed then
        begin
          fButtonState := bsBtnPressed;
          NotifyVisualsChanged;
        end;
      end
      else if fMouseHoverElement = beDropdown then
      begin
        fMouseActiveElement := beDropdown;
        if fButtonState <> bsDropdownPressed then
        begin
          fButtonState := bsDropdownPressed;
          NotifyVisualsChanged;
        end;
      end;
    end;
  end    // if fEnabled
  else
  begin
    fMouseHoverElement := beNone;
    fMouseActiveElement := beNone;
    if fButtonState <> bsIdle then
    begin
      fButtonState := bsIdle;
      NotifyVisualsChanged;
    end;
  end;
end;

procedure TSpkBaseButton.MouseLeave;
begin
  if fEnabled then
  begin
    if fMouseActiveElement = beNone then
    begin
      if fMouseHoverElement = beButton then
      begin
        // Placeholder, if there is a need to handle this event
      end
      else if fMouseHoverElement = beDropdown then
      begin
        // Placeholder, if there is a need to handle this event
      end;
    end;
    if fButtonState <> bsIdle then
    begin
      fButtonState := bsIdle;
      NotifyVisualsChanged;
    end;
  end  // if fEnabled
  else
  begin
    fMouseHoverElement := beNone;
    fMouseActiveElement := beNone;
    if fButtonState <> bsIdle then
    begin
      fButtonState := bsIdle;
      NotifyVisualsChanged;
    end;
  end;
end;

procedure TSpkBaseButton.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  NewMouseHoverElement: TSpkMouseButtonElement;
begin
  if fEnabled then
  begin
    if fButtonRect.Contains(T2DIntPoint.Create(X,Y)) then
      NewMouseHoverElement := beButton
    else if (fButtonKind = bkButtonDropdown) and fDropdownRect.Contains(T2DIntPoint.Create(X,Y)) then
      NewMouseHoverElement := beDropdown
    else
      NewMouseHoverElement := beNone;

    if fMouseActiveElement = beButton then
    begin
      if (NewMouseHoverElement = beNone) and (fButtonState <> bsIdle) then
      begin
        fButtonState := bsIdle;
        NotifyVisualsChanged;
      end
      else if (NewMouseHoverElement = beButton) and (fButtonState <> bsBtnPressed) then
      begin
        fButtonState := bsBtnPressed;
        NotifyVisualsChanged;
      end;
    end
    else if fMouseActiveElement = beDropdown then
    begin
      if (NewMouseHoverElement = beNone) and (fButtonState <> bsIdle) then
      begin
        fButtonState := bsIdle;
        NotifyVisualsChanged;
      end
      else if (NewMouseHoverElement = beDropdown) and (fButtonState <> bsDropdownPressed) then
      begin
        fButtonState := bsDropdownPressed;
        NotifyVisualsChanged;
      end;
    end
    else if fMouseActiveElement = beNone then
    begin
      // Due to the simplified mouse support in the button, there is no need to
      // inform the previous element that the mouse has left its area.
      if NewMouseHoverElement = beButton then
      begin
        if fButtonState <> bsBtnHottrack then
        begin
          fButtonState := bsBtnHottrack;
          NotifyVisualsChanged;
        end;
      end
      else if NewMouseHoverElement = beDropdown then
      begin
        if fButtonState <> bsDropdownHottrack then
        begin
          fButtonState := bsDropdownHottrack;
          NotifyVisualsChanged;
        end;
      end
      else
      begin
        if fButtonState <> bsIdle then
        begin
          fButtonState := bsIdle;
          NotifyVisualsChanged;
        end;
      end;
    end;
    fMouseHoverElement := NewMouseHoverElement;
  end
  else
  begin
    fMouseHoverElement := beNone;
    fMouseActiveElement := beNone;
    if fButtonState <> bsIdle then
    begin
      fButtonState := bsIdle;
      NotifyVisualsChanged;
    end;
  end;
end;

procedure TSpkBaseButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  ClearActive: Boolean;
  DropPoint: T2DIntPoint;
begin
  if fEnabled then
  begin
    // The buttons react only to the left mouse button
    if Button <> mbLeft then
      Exit;

    ClearActive := not (ssLeft in Shift);

    if fMouseActiveElement = beButton then
    begin
      // The event only works when the mouse button is released above the button
      if fMouseHoverElement = beButton then
      begin
        if fButtonKind in [bkButton, bkButtonDropdown, bkToggle] then
        begin
          fButtonState := bsBtnHottrack;
          NotifyVisualsChanged;
          Click;
        end
        else if fButtonKind = bkDropdown then
        begin
          if Assigned(fDropdownMenu) then
          begin
            DropPoint := fToolbarDispatch.ClientToScreen(GetDropdownPointForPopupMenu);
            fDropdownMenu.Popup(DropPoint.x, DropPoint.y);
            fButtonState := bsBtnHottrack;
            NotifyVisualsChanged;
          end;
        end;
      end;
    end
    else if fMouseActiveElement = beDropDown then
    begin
      // The event only works if the mouse button has been released above the
      // DropDown button
      if fMouseHoverElement = beDropDown then
      begin
        if Assigned(fDropdownMenu) then
        begin
          DropPoint := fToolbarDispatch.ClientToScreen(GetDropdownPointForPopupMenu);
          fDropdownMenu.Popup(DropPoint.x, DropPoint.y);
          fButtonState := bsBtnHottrack;
          NotifyVisualsChanged;
        end;
      end;
    end;

    if ClearActive and (fMouseActiveElement <> fMouseHoverElement) then
    begin
      // Due to the simplified handling, there is no need to inform the
      // previous element that the mouse has left its area.
      if fMouseHoverElement = beButton then
      begin
        if fButtonState <> bsBtnHottrack then
        begin
          fButtonState := bsBtnHottrack;
          NotifyVisualsChanged;
        end;
      end
      else if fMouseHoverElement = beDropdown then
      begin
        if fButtonState <> bsDropdownHottrack then
        begin
          fButtonState := bsDropdownHottrack;
          NotifyVisualsChanged;
        end;
      end
      else if fMouseHoverElement = beNone then
      begin
        if fButtonState <> bsIdle then
        begin
          fButtonState := bsIdle;
          NotifyVisualsChanged;
        end;
      end;
    end;

    if ClearActive then
      fMouseActiveElement := beNone;
  end
  else
  begin
    fMouseHoverElement := beNone;
    fMouseActiveElement := beNone;
    if fButtonState <> bsIdle then
    begin
      fButtonState := bsIdle;
      NotifyVisualsChanged;
    end;
  end;
end;

procedure TSpkBaseButton.Notification(aComponent: TComponent; Operation: TOperation);
begin
  inherited;

  if (Operation = opRemove) and (aComponent = fDropdownMenu) then
    fDropdownMenu := nil;
end;

procedure TSpkBaseButton.SetAction(const Value: TBasicAction);
begin
  if Value = nil then
  begin
    fActionLink.Free;
    fActionLink := nil;
  end
  else
  begin
    if fActionLink = nil then
      fActionLink := TSpkButtonActionLink.Create(Self);
    fActionLink.Action := Value;
    fActionLink.OnChange := DoActionChange;
    ActionChange(Value, csLoading in Value.ComponentState);
    Value.FreeNotification(Self);
  end;
end;

procedure TSpkBaseButton.SetAllowAllUp(const Value: Boolean);
begin
  fAllowAllUp := Value;
end;

procedure TSpkBaseButton.SetButtonKind(const Value: TSpkButtonKind);
begin
  fButtonKind := Value;
  NotifyMetricsChanged;
end;

procedure TSpkBaseButton.SetCaption(const Value: string);
begin
  fCaption := Value;
  NotifyMetricsChanged;
end;

procedure TSpkBaseButton.SetChecked(const Value: Boolean);
begin
  if fChecked = Value then
    Exit;

  if fGroupIndex > 0 then
  begin
    if fAllowAllUp or ((not fAllowAllUp) and Value) then
      UncheckSiblings;
    if not fAllowAllUp and (not Value) and not SiblingsChecked then
      Exit;
  end;

  fChecked := Value;
  NotifyVisualsChanged;

  if not (csDesigning in ComponentState) and (Action <> nil) then
    (Action as TCustomAction).Checked := Value;
end;

procedure TSpkBaseButton.SetDropdownArrowPosition(const Value: TSpkDropdownArrowPosition);
begin
  fDropdownArrowPosition := Value;
  NotifyMetricsChanged;
  NotifyVisualsChanged;
end;

procedure TSpkBaseButton.SetDropdownMenu(const Value: TPopupMenu);
begin
  fDropdownMenu := Value;
  NotifyMetricsChanged;
end;

procedure TSpkBaseButton.SetEnabled(const Value: Boolean);
begin
  inherited;
  if not fEnabled then
  begin
    // If the button has been switched off, it is immediately switched into
    // the Idle state and the active and under the mouse are reset.
    // If it has been enabled, its status will change during the first
    // mouse action.

    fMouseHoverElement := beNone;
    fMouseActiveElement := beNone;

    if fButtonState <> bsIdle then
    begin
      fButtonState := bsIdle;
      NotifyVisualsChanged;
    end;
  end;
end;

procedure TSpkBaseButton.SetGroupIndex(const Value: Integer);
begin
  if fGroupIndex = Value then
    Exit;

  fGroupIndex := Value;
  NotifyVisualsChanged;
end;

procedure TSpkBaseButton.SetImageIndex(const Value: TImageIndex);
begin
  if fImageIndex <> Value then
  begin
    fImageIndex := Value;
    NotifyMetricsChanged;
  end;
end;

procedure TSpkBaseButton.SetRect(const Value: T2DIntRect);
begin
  inherited;
  CalcRects;
end;

function TSpkBaseButton.SiblingsChecked: Boolean;
var
  i: Integer;
  lPane: TSpkPane;
  lButton: TSpkBaseButton;
begin
  if (Parent is TSpkPane) then
  begin
    lPane := TSpkPane(Parent);
    for i:=0 to lPane.Items.Count-1 do
      if lPane.Items[i] is TSpkBaseButton then
      begin
        lButton := TSpkBaseButton(lPane.Items[i]);
        if (lButton <> self) and (lButton.ButtonKind = bkToggle) and
           (lButton.GroupIndex = fGroupIndex) and lButton.Checked then
        begin
          Result := True;
          Exit;
        end;
      end;
  end;
  Result := False;
end;

procedure TSpkBaseButton.UncheckSiblings;
var
  i: Integer;
  lPane: TSpkPane;
  lButton: TSpkBaseButton;
begin
  if (Parent is TSpkPane) then begin
    lPane := TSpkPane(Parent);
    for i:=0 to lPane.Items.Count-1 do
      if lPane.Items[i] is TSpkBasebutton then
      begin
        lButton := TSpkBaseButton(lPane.Items[i]);
        if (lButton <> self) and (lButton.ButtonKind = bkToggle) and (lButton.GroupIndex = fGroupIndex) then
          lButton.fChecked := False;
      end;
  end;
end;

{ TSpkLargeButton }

procedure TSpkLargeButton.CalcRects;
begin
  if (fButtonKind in [bkButtonDropdown, bkDropdown]) and (fDropdownArrowPosition = apRight) then
  begin
    fButtonRect := T2DIntRect.Create(
      fRect.Left,
      fRect.Top,
      fRect.Right - 2 * SPK_DROPDOWN_ARROW_WIDTH,
      fRect.Bottom
    );

    fDropdownRect := T2DIntRect.Create(
      fRect.Right - 2 * SPK_DROPDOWN_ARROW_WIDTH,
      fRect.Top,
      fRect.Right,
      fRect.Bottom
    );
  end
  else if fButtonKind = bkButtonDropdown then
  begin
    fButtonRect := T2DIntRect.Create(
      fRect.Left,
      fRect.Top,
      fRect.Right,
      fRect.Bottom - SPK_LARGE_BUTTON_DROPDOWN_FIELD_SIZE
    );

    fDropdownRect := T2DIntRect.Create(
      fRect.Left,
      fRect.Bottom - SPK_LARGE_BUTTON_DROPDOWN_FIELD_SIZE,
      fRect.Right,
      fRect.Bottom
    );
  end
  else
  begin
    fButtonRect := fRect;
    fDropdownRect := T2DIntRect.Create(0, 0, 0, 0);
  end;
end;

procedure TSpkLargeButton.Draw(aBuffer: TBitmap; aClipRect: T2DIntRect);
var
  x, y: Integer;
  lFontColor, lFrameColor: TColor;
  lGradientFromColor, lGradientToColor: TColor;
  lInnerLightColor, lInnerDarkColor: TColor;
  lGradientKind: TBackgroundKind;
  lDelta: Integer;
  lCornerRadius: Integer;
  lImgList: TImageList;
  lImgSize: TSize;
  lTextHeight: Integer;
  lBreakPos, lBreakWidth: Integer;
  lText: string;
  lPoint: T2DIntPoint;
  lDrawBtn: Boolean;
  lPpi: Integer;
  lDropdownArrowRect: TRect;
  lDrawRect: T2DIntRect;
begin
  if fToolbarDispatch = nil then
    Exit;
  if fAppearance = nil then
    Exit;

  if (fRect.Width < 2 * SPK_LARGE_BUTTON_RADIUS) or (fRect.Height < 2 * SPK_LARGE_BUTTON_RADIUS) then
    Exit;

  // Separator
  if fBeginAGroup then
    TGUITools.DrawVLine(aBuffer,
                        fRect.Left - SPK_PANE_GROUP_SPACER - 1,
                        fRect.Top + SPK_LARGE_GROUP_SEPARATOR_MARGIN,
                        fRect.Bottom - SPK_LARGE_GROUP_SEPARATOR_MARGIN,
                        fAppearance.Pane.BorderDarkColor
    );

  lDelta := fAppearance.Element.HotTrackBrightnessChange;
  case fAppearance.Element.Style of
    esRounded:
      lCornerRadius := SPK_LARGE_BUTTON_RADIUS;
    esRectangle:
      lCornerRadius := 0;
  end;

  // Prepare text color
  lFontColor := clNone;
  case fButtonState of
    bsIdle:
      lFontColor := fAppearance.Element.IdleCaptionColor;
    bsBtnHottrack,
    bsDropdownHottrack:
      lFontColor := fAppearance.Element.HotTrackCaptionColor;
    bsBtnPressed,
    bsDropdownPressed:
      lFontColor := fAppearance.ELement.ActiveCaptionColor;
  end;
  if not fEnabled then
    lFontColor := fAppearance.Element.DisabledCaptionColor;

  // Dropdown button
  // Draw full rect, otherwise the DropDownRect will contain the full gradient
  if fButtonKind = bkButtonDropdown then
  begin
    lDrawBtn := True;
    if (fButtonState in [bsBtnHotTrack, bsBtnPressed]) then
    begin
      fAppearance.Element.GetHotTrackColors(Checked,
        lFrameColor, lInnerLightColor, lInnerDarkColor,
        lGradientFromColor, lGradientToColor, lGradientKind,
        lDelta);
    end
    else if (fButtonState = bsDropdownHottrack) then
    begin
      fAppearance.Element.GetHotTrackColors(Checked,
        lFrameColor, lInnerLightColor, lInnerDarkColor,
        lGradientFromColor, lGradientToColor, lGradientKind);
    end
    else if (fButtonState = bsDropdownPressed) then
    begin
      fAppearance.Element.GetActiveColors(Checked,
        lFrameColor, lInnerLightColor, lInnerDarkColor,
        lGradientFromColor, lGradientToColor, lGradientKind);
    end
    else
      lDrawBtn := False;

    if lDrawBtn then
    begin
      TGUITools.DrawButton(
        aBuffer,
        fRect,
        lFrameColor,
        lInnerLightColor,
        lInnerDarkColor,
        lGradientFromColor,
        lGradientToColor,
        lGradientKind,
        False,
        False,
        False,
        False,
        lCornerRadius,
        aClipRect
      );
    end;
  end;

  // Button (Background and frame)
  lDrawBtn := True;
  if fButtonState = bsBtnHottrack then
  begin
    fAppearance.Element.GetHotTrackColors(Checked,
      lFrameColor, lInnerLightColor, lInnerDarkColor,
      lGradientFromColor, lGradientToColor, lGradientKind);
  end
  else if fButtonState = bsBtnPressed then
  begin
    fAppearance.Element.GetActiveColors(Checked,
      lFrameColor, lInnerLightColor, lInnerDarkColor,
      lGradientFromColor, lGradientToColor, lGradientKind);
  end
  else if (fButtonState in [bsDropdownHotTrack, bsDropdownPressed]) then
  begin
    fAppearance.Element.GetHotTrackColors(Checked,
      lFrameColor, lInnerLightColor, lInnerDarkColor,
      lGradientFromColor, lGradientToColor, lGradientKind,
      lDelta);
  end
  else if (fButtonState = bsIdle) and Checked then
  begin
    fAppearance.Element.GetActiveColors(Checked,
      lFrameColor, lInnerLightColor, lInnerDarkColor,
      lGradientFromColor, lGradientToColor, lGradientKind
    );
  end
  else
    lDrawBtn := False;

  if (fButtonKind in [bkButtonDropdown, bkDropdown])
      and (fDropdownArrowPosition = apRight)
      and (fButtonState = bsIdle)
      and (Enabled = False)
  then
    lDrawBtn := False;

  if lDrawBtn then
  begin
    if (fButtonKind in [bkButtonDropdown, bkDropdown])
        and (fDropdownArrowPosition = apRight)
        and (fButtonState = bsIdle)
    then
      lDrawRect := fRect
    else
      lDrawRect := fButtonRect;

    TGUITools.DrawButton(
      aBuffer,
      lDrawRect,       // draw button part only
      lFrameColor,
      lInnerLightColor,
      lInnerDarkColor,
      lGradientFromColor,
      lGradientToColor,
      lGradientKind,
      False,
      False,
      False,
      fButtonKind = bkButtonDropdown,
      lCornerRadius,
      aClipRect
    );

    if (fButtonKind in [bkButtonDropdown, bkDropdown])
        and (fDropdownArrowPosition = apRight)
        and (fButtonState = bsIdle)
    then
      TGuiTools.DrawVLine(
        aBuffer,
        fDropDownRect.Left,
        fDropDownRect.Top,
        fDropDownRect.Bottom,
        lFrameColor,
        aClipRect
     );


  end;

  // Dropdown button - draw horizontal dividing line
  if fButtonKind = bkButtonDropdown then
  begin
    lDrawBtn := True;
    if (fButtonState in [bsDropdownHotTrack, bsBtnHotTrack]) then
      lFrameColor := fAppearance.element.HotTrackFrameColor
    else if (fButtonState in [bsDropDownPressed, bsBtnPressed]) then
      lFrameColor := fAppearance.Element.ActiveFrameColor
    else
      lDrawBtn := False;

    if lDrawBtn then
      TGuiTools.DrawHLine(
        aBuffer,
        fDropDownRect.Left,
        fDropDownRect.Right,
        fDropDownRect.Top,
        lFrameColor,
        aClipRect
     );
  end;
  // Icon
  if not fEnabled and (fDisabledLargeImages <> nil) then
    lImgList := fDisabledLargeImages
  else
    lImgList := fLargeImages;

  if (lImgList <> nil) and (fImageIndex >= 0) and (fImageIndex < lImgList.Count) then
  begin
    lPpi := fAppearance.Element.CaptionFont.PixelsPerInch;
//    {$IF LCL_FULLVERSION >= 1090000}
//    imgSize := imgList.SizeForPPI[fLargeImagesWidth, ppi];
//    {$ELSE}
    lImgSize := TSize.Create(lImgList.Width, lImgList.Height);
//    {$ENDIF}

    lPoint := T2DIntPoint.Create(
      fButtonRect.Left + (fButtonRect.Width - lImgSize.CX) div 2,
      fButtonRect.Top + SPK_LARGE_BUTTON_BORDER_SIZE + SPK_LARGE_BUTTON_GLYPH_MARGIN
    );

    if not fEnabled and (fDisabledLargeImages = nil) then
      TGUITools.DrawDisabledImage(aBuffer.Canvas, lImgList, fImageIndex, lPoint, aClipRect)
    else
      TGUITools.DrawImage(aBuffer.Canvas, lImgList, fImageIndex, lPoint, aClipRect,
        fLargeImagesWidth, lPpi, 1.0);
  end;

  // Text
  aBuffer.Canvas.Font.Assign(fAppearance.Element.CaptionFont);
  aBuffer.Canvas.Font.Color := lFontColor;
  // aBuffer.Canvas.Font.Height := DPIScale(fAppearance.Element.CaptionFont.Height);

  if fButtonKind in [bkButton, bkToggle] then
    FindBreakPlace(fCaption, lBreakPos, lBreakWidth)
  else if (fButtonKind in [bkButtonDropdown, bkDropdown]) and (fDropdownArrowPosition = apRight) then
    FindBreakPlace(fCaption, lBreakPos, lBreakWidth)
  else
    lBreakPos := 0;
  lTextHeight := aBuffer.Canvas.TextHeight('Wy');

  if lBreakPos > 0 then
  begin
    lText := Copy(fCaption, 1, lBreakPos - 1);
    x := fButtonRect.Left + (fButtonRect.Width - aBuffer.Canvas.Textwidth(lText)) div 2;
    y := fButtonRect.Top + SPK_LARGE_BUTTON_CAPTION_TOP_RAIL - lTextHeight div 2;
    TGUITools.DrawText(aBuffer.Canvas, x, y, lText, lFontColor, aClipRect);

    lText := Copy(fCaption, lBreakPos + 1, Length(fCaption) - lBreakPos);
    x := fButtonRect.Left + (fButtonRect.Width - aBuffer.Canvas.Textwidth(lText)) div 2;
    y := fButtonRect.Top + SPK_LARGE_BUTTON_CAPTION_BUTTOM_RAIL - lTextHeight div 2;
    TGUITools.DrawText(aBuffer.Canvas, x, y, lText, lFontColor, aClipRect);
  end
  else
  begin
    // The text is not broken
    x := fButtonRect.Left + (fButtonRect.Width - aBuffer.Canvas.Textwidth(fCaption)) div 2;
    y := fRect.Top + SPK_LARGE_BUTTON_CAPTION_TOP_RAIL - lTextHeight div 2;
    TGUITools.DrawText(aBuffer.Canvas, x, y, fCaption, lFontColor, aClipRect);
  end;

  // Dropdown arrow
  if (fButtonKind in [bkButtonDropdown, bkDropdown]) and (fDropdownArrowPosition = apRight) then
  begin
    lDropdownArrowRect := Classes.Rect(fDropdownRect.Left, fDropdownRect.Top, fDropDownRect.Right, fDropdownRect.Bottom);
    DrawDropdownArrow(aBuffer, lDropdownArrowRect, lFontColor);
  end
  else if fButtonKind = bkDropdown then
  begin
    y := fButtonRect.Bottom - aBuffer.Canvas.TextHeight('Tg') - 1;
    lDropdownArrowRect := Classes.Rect(fButtonRect.Left, y, fButtonRect.Right, fButtonRect.Bottom);
    DrawDropdownArrow(aBuffer, lDropdownArrowRect, lFontColor);
  end
  else if fButtonKind = bkButtonDropdown then
  begin
    y := fDropdownRect.Bottom - aBuffer.Canvas.TextHeight('Tg') - 1;
    lDropdownArrowRect := Classes.Rect(fDropdownRect.Left, y, fDropDownRect.Right, fDropdownRect.Bottom);
    DrawDropdownArrow(aBuffer, lDropdownArrowRect, lFontColor);
  end;
end;

procedure TSpkLargeButton.FindBreakPlace(aCaption: string; out aPosition: Integer; out aWidth: Integer);
var
  i: Integer;
  lBitmap: TBitmap;
  lBeforeWidth, lAfterWidth: Integer;
begin
  aPosition := -1;
  aWidth := -1;

  if fToolbarDispatch=nil then
     Exit;
  if fAppearance=nil then
     Exit;

  lBitmap := fToolbarDispatch.GetTempBitmap;
  if lBitmap = nil then
    Exit;

  lBitmap.Canvas.Font.Assign(fAppearance.Element.CaptionFont);
  // lBitmap.Canvas.Font.Height := DPIScale(fAppearance.Element.CaptionFont.Height);
  aWidth := lBitmap.Canvas.TextWidth(fCaption);
  for i := 1 to Length(aCaption) do
    if aCaption[i] = ' ' then
    begin
      if i > 1 then
        lBeforeWidth := lBitmap.Canvas.TextWidth(Copy(aCaption, 1, i-1))
      else
        lBeforeWidth := 0;

      if i < Length(aCaption) then
        lAfterWidth := lBitmap.Canvas.TextWidth(Copy(aCaption, i+1, Length(aCaption)-i))
      else
        lAfterWidth := 0;

      if (aPosition = -1) or (Max(lBeforeWidth, lAfterWidth) < aWidth) then
      begin
        aWidth := Max(lBeforeWidth, lAfterWidth);
        aPosition := i;
      end;
    end;
end;

function TSpkLargeButton.GetDropdownPointForPopupMenu: T2DIntPoint;
begin
  case fButtonKind of
    bkDropdown       : Result := T2DIntPoint.Create(fButtonRect.Left, fButtonRect.Bottom+1);
    bkButtonDropdown : Result := T2DIntPoint.Create(fRect.Left, fRect.Bottom+1);
  else
    Result := T2DIntPoint.Create(0,0);
  end;
end;

function TSpkLargeButton.GetGroupBehaviour: TSpkItemGroupBehaviour;
begin
  Result := gbSingleItem;
end;

function TSpkLargeButton.GetSizeType: TSpkItemSizeType;
begin
  Result := isLarge;
end;

function TSpkLargeButton.GetTableBehaviour: TSpkItemTableBehaviour;
begin
  Result := tbBeginsColumn;
end;

function TSpkLargeButton.GetWidth: integer;
var
  lGlyphWidth: Integer;
  lTextWidth: Integer;
  lBitmap: TBitmap;
  lBreakPos, lRowWidth: Integer;
begin
  Result := -1;

  if fToolbarDispatch = nil then
    Exit;

  if fAppearance = nil then
    Exit;

  lBitmap := fToolbarDispatch.GetTempBitmap;
  if lBitmap = nil then
    Exit;

  // Glyph
  if fLargeImages <> nil then
    lGlyphWidth := 2 * SPK_LARGE_BUTTON_GLYPH_MARGIN + fLargeImages.Width
  else
    lGlyphWidth := 0;

  // Text
  if fButtonKind in [bkButton, bkToggle] then
  begin
    // Label
    FindBreakPlace(fCaption, lBreakPos, lRowWidth);
    lTextWidth := 2 * SPK_LARGE_BUTTON_CAPTION_HMARGIN + lRowWidth;
  end
  else if (fButtonKind in [bkButtonDropdown, bkDropdown]) and (fDropdownArrowPosition = apRight) then
  begin
    // Label
    FindBreakPlace(fCaption, lBreakPos, lRowWidth);
    lTextWidth := 2 * SPK_LARGE_BUTTON_CAPTION_HMARGIN + lRowWidth + 2 * SPK_DROPDOWN_ARROW_WIDTH;
  end
  else
  begin
    // do not break the label
    lBitmap.Canvas.Font.Assign(fAppearance.Element.CaptionFont);
    // lBitmap.Canvas.Font.Height := DPIScale(fAppearance.Element.CaptionFont.Height);
    lTextWidth := 2 * SPK_LARGE_BUTTON_CAPTION_HMARGIN + lBitmap.Canvas.TextWidth(fCaption);
  end;

  Result := Max(SPK_LARGE_BUTTON_MIN_WIDTH, Max(lGlyphWidth, lTextWidth));
end;

{ TSpkSmallButton }

constructor TSpkSmallButton.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  fImageIndex := -1;
  fTableBehaviour := tbContinuesRow;
  fGroupBehaviour := gbSingleItem;
  fHideFrameWhenIdle := False;
  fShowCaption := True;
  fDropDownLabel := '';
end;

procedure TSpkSmallButton.CalcRects;
var
  lRectVector: T2DIntVector;
begin
  ConstructRects(fButtonRect, fDropdownRect);
  lRectVector := T2DIntVector.Create(fRect.Left, fRect.Top);
  fButtonRect := fButtonRect + lRectVector;
  fDropdownRect := fDropdownRect + lRectVector;
end;

procedure TSpkSmallButton.ConstructRects(out aBtnRect, aDropRect: T2DIntRect);
var
  lBtnWidth: Integer;
  lDropdownWidth: Integer;
  lBitmap: TBitmap;
  lTextWidth: Integer;
  lAdditionalPadding: Boolean;
begin
  aBtnRect := T2DIntRect.Create(0, 0, 0, 0);
  aDropRect := T2DIntRect.Create(0, 0, 0, 0);

  if not Assigned(fToolbarDispatch) then
    Exit;
  if not Assigned(fAppearance) then
    Exit;

  lBitmap := fToolbarDispatch.GetTempBitmap;
  if not Assigned(lBitmap) then
    Exit;

  // *** Regardless of the type, there must be room for the icon and / or text ***

  lBtnWidth := 0;
  lAdditionalPadding := False;

  // Icon
  if fImageIndex <> -1 then
  begin
    lBtnWidth := lBtnWidth + SPK_SMALL_BUTTON_PADDING + SPK_SMALL_BUTTON_GLYPH_WIDTH;
    lAdditionalPadding := True;
  end;

  // Text
  if fShowCaption then
  begin
    lBitmap.Canvas.Font.Assign(fAppearance.Element.CaptionFont);
    // lBitmap.Canvas.Font.Height := DPIScale(fAppearance.Element.CaptionFont.Height);
    lTextWidth := lBitmap.Canvas.TextWidth(fCaption);

    lBtnWidth := lBtnWidth + SPK_SMALL_BUTTON_PADDING + lTextWidth;
    lAdditionalPadding := True;
  end;

  // Padding behind the text or icon
  if lAdditionalPadding then
    lBtnWidth := lBtnWidth + SPK_SMALL_BUTTON_PADDING;

  // The width of the button content must be at least SMALLBUTTON_MIN_WIDTH
  lBtnWidth := Max(SPK_SMALL_BUTTON_MIN_WIDTH, lBtnWidth);

  // *** Dropdown ***
  case fButtonKind of
    bkButton, bkToggle:
      begin
        // Left edge of the button
        if fGroupBehaviour in [gbContinuesGroup, gbEndsGroup] then
          lBtnWidth := lBtnWidth + SPK_SMALL_BUTTON_HALF_BORDER_WIDTH
        else
          lBtnWidth := lBtnWidth + SPK_SMALL_BUTTON_BORDER_WIDTH;

        // Right edge of the button
        if (fGroupBehaviour in [gbBeginsGroup, gbContinuesGroup]) then
          lBtnWidth := lBtnWidth + SPK_SMALL_BUTTON_HALF_BORDER_WIDTH
        else
          lBtnWidth := lBtnWidth + SPK_SMALL_BUTTON_BORDER_WIDTH;

        aBtnRect := T2DIntRect.Create(0, 0, lBtnWidth - 1, SPK_PANE_ROW_HEIGHT - 1);
        aDropRect := T2DIntRect.Create(0, 0, 0, 0);
      end;

    bkButtonDropdown:
      begin
        // Left edge of the button
        if fGroupBehaviour in [gbContinuesGroup, gbEndsGroup] then
          lBtnWidth := lBtnWidth + SPK_SMALL_BUTTON_HALF_BORDER_WIDTH
        else
          lBtnWidth := lBtnWidth + SPK_SMALL_BUTTON_BORDER_WIDTH;

        // Right edge of the button
        lBtnWidth := lBtnWidth + SPK_SMALL_BUTTON_HALF_BORDER_WIDTH;

        // Left edge and dropdown field content
        lDropdownWidth := SPK_SMALL_BUTTON_HALF_BORDER_WIDTH + SPK_SMALL_BUTTON_DROPDOWN_WIDTH;

        // Right edge of the dropdown field
        if (fGroupBehaviour in [gbBeginsGroup, gbContinuesGroup]) then
          lDropdownWidth := lDropdownWidth + SPK_SMALL_BUTTON_HALF_BORDER_WIDTH
        else
          lDropdownWidth := lDropdownWidth + SPK_SMALL_BUTTON_BORDER_WIDTH;

        aBtnRect := T2DIntRect.Create(0, 0, lBtnWidth - 1, SPK_PANE_ROW_HEIGHT - 1);
        aDropRect := T2DIntRect.Create(aBtnRect.Right+1, 0, aBtnRect.Right+lDropdownWidth, SPK_PANE_ROW_HEIGHT - 1);
      end;

    bkDropdown:
      begin
        // Left edge of the button
        if fGroupBehaviour in [gbContinuesGroup, gbEndsGroup] then
          lBtnWidth := lBtnWidth + SPK_SMALL_BUTTON_HALF_BORDER_WIDTH
        else
          lBtnWidth := lBtnWidth + SPK_SMALL_BUTTON_BORDER_WIDTH;

        // Right edge of the button
        if (fGroupBehaviour in [gbBeginsGroup, gbContinuesGroup]) then
          lBtnWidth := lBtnWidth + SPK_SMALL_BUTTON_HALF_BORDER_WIDTH
        else
          lBtnWidth := lBtnWidth + SPK_SMALL_BUTTON_BORDER_WIDTH;

        // Additional area for dropdown + place for the central edge,
        // for dimensional compatibility with dkButtonDropdown
        lBtnWidth := lBtnWidth + SPK_SMALL_BUTTON_BORDER_WIDTH + SPK_SMALL_BUTTON_DROPDOWN_WIDTH;
        aBtnRect := T2DIntRect.Create(0, 0, lBtnWidth - 1, SPK_PANE_ROW_HEIGHT - 1);
        aDropRect := T2DIntRect.Create(0, 0, 0, 0);
      end;
  end;

  if (fButtonKind in [bkButtonDropdown, bkDropdown]) and not fDropDownLabel.IsEmpty then
  begin
    lBitmap.Canvas.Font.Assign(fAppearance.Element.CaptionFont);
    // lBitmap.Canvas.Font.Height := DPIScale(fAppearance.Element.CaptionFont.Height);
    lTextWidth := lBitmap.Canvas.TextWidth(fDropDownLabel) + SPK_SMALL_BUTTON_PADDING * 2;
    aBtnRect := aBtnRect + T2DIntVector.Create(lTextWidth, 0);
    aDropRect := aDropRect + T2DIntVector.Create(lTextWidth, 0);
  end;

end;

procedure TSpkSmallButton.Draw(aBuffer: TBitmap; aClipRect: T2DIntRect);
var
  x, y: Integer;
  lTextWidth: Integer;
  lFontColor: TColor;
  lFrameColor, lInnerLightColor, lInnerDarkColor: TColor;
  lGradientFromColor, lGradientToColor: TColor;
  lGradientKind: TBackgroundKind;
  lPoint: T2DIntPoint;
  lDelta: Integer;
  lCornerRadius: Integer;
  lImgList: TImageList;
  lImgSize: TSize;
  lDrawBtn: Boolean;
  lDropdownButtonRect: TRect;
  lDropdownButtonWidth: Integer;
  lPpi: Integer;
begin
  if (fToolbarDispatch = nil) or (fAppearance = nil) then
    Exit;

  if (fRect.Width < 2 * SPK_SMALL_BUTTON_RADIUS) or (fRect.Height < 2 * SPK_SMALL_BUTTON_RADIUS) then
    Exit;

  lDelta := fAppearance.Element.HotTrackBrightnessChange;
  case fAppearance.Element.Style of
    esRounded:
      lCornerRadius := SPK_SMALL_BUTTON_RADIUS;
    esRectangle:
      lCornerRadius := 0;
  end;

  // Button (Background and frame)
  lDrawBtn := True;
  if (fButtonState = bsIdle) and (not fHideFrameWhenIdle) then
  begin
    fAppearance.Element.GetIdleColors(Checked,
      lFrameColor, lInnerLightColor, lInnerDarkColor,
      lGradientFromColor, lGradientToColor, lGradientKind
    );
  end
  else if fButtonState = bsBtnHottrack then
  begin
    fAppearance.Element.GetHotTrackColors(Checked,
      lFrameColor, lInnerLightColor, lInnerDarkColor,
      lGradientFromColor, lGradientToColor, lGradientKind
    );
  end
  else if fButtonState = bsBtnPressed then
  begin
    fAppearance.Element.GetActiveColors(Checked,
      lFrameColor, lInnerLightColor, lInnerDarkColor,
      lGradientFromColor, lGradientToColor, lGradientKind
    );
  end
  else if (fButtonState in [bsDropdownHotTrack, bsDropdownPressed]) then
  begin
    fAppearance.Element.GetHotTrackColors(Checked,
      lFrameColor, lInnerLightColor, lInnerDarkColor,
      lGradientFromColor, lGradientToColor, lGradientKind,
      lDelta
    );
  end
  else
    lDrawBtn := False;

  if lDrawBtn then
  begin
    TGUITools.DrawButton(
      aBuffer,
      fButtonRect,       // draw button part only
      lFrameColor,
      lInnerLightColor,
      lInnerDarkColor,
      lGradientFromColor,
      lGradientToColor,
      lGradientKind,
      (fGroupBehaviour in [gbContinuesGroup, gbEndsGroup]),
      (fGroupBehaviour in [gbBeginsGroup, gbContinuesGroup]) or (fButtonKind = bkButtonDropdown),
      False,
      False,
      lCornerRadius,
      aClipRect
    );
  end;

  // Icon
  if not fEnabled and (fDisabledImages <> nil) then
    lImgList := fDisabledImages
  else
    lImgList := fImages;

  if (lImgList <> nil) and (fImageIndex >= 0) and (fImageIndex < lImgList.Count) then
  begin
    lPpi := fAppearance.Element.CaptionFont.PixelsPerInch;
    //{$IF LCL_FULLVERSION >= 1090000}
    //imgSize := imgList.SizeForPPI[fImagesWidth, ppi];
    //{$ELSE}
    lImgSize := TSize.Create(lImgList.Width, lImgList.Height);
    //{$ENDIF}

    if (fGroupBehaviour in [gbContinuesGroup, gbEndsGroup]) then
      x := fButtonRect.Left + SPK_SMALL_BUTTON_HALF_BORDER_WIDTH + SPK_SMALL_BUTTON_PADDING
    else
      x := fButtonRect.Left + SPK_SMALL_BUTTON_BORDER_WIDTH + SPK_SMALL_BUTTON_PADDING;
    y := fButtonRect.top + (fButtonRect.height - lImgSize.CY) div 2;
    lPoint := T2DIntPoint.Create(x, y);

    if not fEnabled and (fDisabledLargeImages = nil) then
      TGUITools.DrawDisabledImage(aBuffer.Canvas, lImgList, fImageIndex, lPoint, aClipRect)
    else
      TGUITools.DrawImage(aBuffer.Canvas, lImgList, fImageIndex, lPoint, aClipRect,
        fImagesWidth, lPpi, 1.0);
  end;

  // Prepare font and chevron color
  lFontColor := clNone;
  case fButtonState of
    bsIdle:
      lFontColor := fAppearance.Element.IdleCaptionColor;
    bsBtnHottrack,
    bsDropdownHottrack:
      lFontColor := fAppearance.Element.HotTrackCaptionColor;
    bsBtnPressed,
    bsDropdownPressed:
      lFontColor := fAppearance.ELement.ActiveCaptionColor;
  end;
  if not fEnabled then
    lFontColor := fAppearance.Element.DisabledCaptionColor;

  // DropDownLabel
  if (fButtonKind in [bkButtonDropdown, bkDropdown]) and not fDropDownLabel.IsEmpty then
  begin
    aBuffer.Canvas.Font.Assign(fAppearance.Element.CaptionFont);
    aBuffer.Canvas.Font.Color := lFontColor;
    // aBuffer.Canvas.Font.Height := DPIScale(fAppearance.Element.CaptionFont.Height);

    lTextWidth := aBuffer.Canvas.TextWidth(fDropDownLabel);
    if (fGroupBehaviour in [gbContinuesGroup, gbEndsGroup]) then
      x := fButtonRect.Left - SPK_SMALL_BUTTON_HALF_BORDER_WIDTH - lTextWidth
    else
      x := fButtonRect.Left - SPK_SMALL_BUTTON_BORDER_WIDTH - lTextWidth;

    y := fButtonRect.Top + (fButtonRect.Height - aBuffer.Canvas.TextHeight('Wy')) div 2;

    TGUITools.DrawText(aBuffer.Canvas, x - SPK_SMALL_BUTTON_PADDING, y, fDropDownLabel, lFontColor, aClipRect);
  end;

  // Text
  if fShowCaption then
  begin
    aBuffer.Canvas.Font.Assign(fAppearance.Element.CaptionFont);
    aBuffer.Canvas.Font.Color := lFontColor;
    // aBuffer.Canvas.Font.Height := DPIScale(fAppearance.Element.CaptionFont.Height);

    if (fGroupBehaviour in [gbContinuesGroup, gbEndsGroup]) then
      x := fButtonRect.Left + SPK_SMALL_BUTTON_HALF_BORDER_WIDTH
    else
      x := fButtonRect.Left + SPK_SMALL_BUTTON_BORDER_WIDTH;

    if fImageIndex <> -1 then
      x := x + 2 * SPK_SMALL_BUTTON_PADDING + SPK_SMALL_BUTTON_GLYPH_WIDTH
    else
      x := x + SPK_SMALL_BUTTON_PADDING;
    y := fButtonRect.Top + (fButtonRect.Height - aBuffer.Canvas.TextHeight('Wy')) div 2;

    TGUITools.DrawText(aBuffer.Canvas, x, y, fCaption, lFontColor, aClipRect);
  end;

  // Dropdown button
  if fButtonKind = bkButtonDropdown then
  begin
    lDrawBtn := True;
    if (fButtonState = bsIdle) and not fHideFrameWhenIdle then
    begin
      fAppearance.Element.GetIdleColors(Checked,
        lFrameColor, lInnerLightColor, lInnerDarkColor,
        lGradientFromColor, lGradientToColor, lGradientKind
      );
    end
    else if fButtonState in [bsBtnHottrack, bsBtnPressed] then
    begin
      fAppearance.Element.GetHotTrackColors(Checked,
        lFrameColor, lInnerLightColor, lInnerDarkColor,
        lGradientFromColor, lGradientToColor, lGradientKind,
        lDelta
      );
    end
    else if fButtonState = bsDropdownHottrack then
    begin
      fAppearance.Element.GetHotTrackColors(Checked,
        lFrameColor, lInnerLightColor, lInnerDarkColor,
        lGradientFromColor, lGradientToColor, lGradientKind
      );
    end
    else if fButtonState = bsDropdownPressed then
    begin
      fAppearance.Element.GetActiveColors(Checked,
        lFrameColor, lInnerLightColor, lInnerDarkColor,
        lGradientFromColor, lGradientToColor, lGradientKind
      );
    end
    else
      lDrawBtn := False;

    if lDrawBtn then
    begin
      TGUITools.DrawButton(
        aBuffer,
        fDropdownRect,
        lFrameColor,
        lInnerLightColor,
        lInnerDarkColor,
        lGradientFromColor,
        lGradientToColor,
        lGradientKind,
        True,
        (fGroupBehaviour in [gbBeginsGroup, gbContinuesGroup]),
        False,
        False,
        lCornerRadius,
        aClipRect
      );
    end;
  end;

  // Dropdown arrow
  if fButtonKind in [bkDropdown, bkButtonDropdown] then
  begin
    lDropdownButtonWidth := SPK_SMALL_BUTTON_DROPDOWN_WIDTH;
    if fGroupBehaviour in [gbBeginsGroup, gbContinuesGroup] then
      Inc(lDropdownButtonWidth, SPK_SMALL_BUTTON_HALF_BORDER_WIDTH)
    else
      Inc(lDropdownButtonWidth, SPK_SMALL_BUTTON_BORDER_WIDTH);
    if fButtonKind = bkDropdown then
      lDropdownButtonRect := Classes.Rect(fButtonRect.Right - lDropdownButtonWidth, fButtonRect.Top, fButtonRect.Right, fButtonRect.Bottom)
    else
      lDropdownButtonRect := Classes.Rect(fDropdownRect.Right - lDropdownButtonWidth, fDropdownRect.Top, fDropdownRect.Right, fDropdownRect.Bottom);
    DrawdropdownArrow(aBuffer, lDropdownButtonRect, lFontColor);
  end;
end;

function TSpkSmallButton.GetDropdownPointForPopupMenu: T2DIntPoint;
begin
  if fButtonKind in [bkButtonDropdown, bkDropdown] then
    Result := T2DIntPoint.Create(fButtonRect.Left, fButtonRect.Bottom+1)
  else
    Result := T2DIntPoint.Create(0,0);
end;

function TSpkSmallButton.GetGroupBehaviour: TSpkItemGroupBehaviour;
begin
  Result := fGroupBehaviour;
end;

function TSpkSmallButton.GetSizeType: TSpkItemSizeType;
begin
  Result := isNormal;
end;

function TSpkSmallButton.GetTableBehaviour: TSpkItemTableBehaviour;
begin
  Result := fTableBehaviour;
end;

function TSpkSmallButton.GetWidth: Integer;
var
  lBtnRect, lDropRect: T2DIntRect;
begin
  Result := -1;

  if fToolbarDispatch = nil then
    Exit;
  if fAppearance = nil then
    Exit;

  ConstructRects(lBtnRect, lDropRect);

  if fButtonKind = bkButtonDropdown then
    Result := lDropRect.Right + 1
  else
    Result := lBtnRect.Right + 1;
end;

procedure TSpkSmallButton.SetDropDownLabel(const Value: string);
begin
  fDropDownLabel := Value;
  NotifyMetricsChanged;
end;

procedure TSpkSmallButton.SetGroupBehaviour(const Value: TSpkItemGroupBehaviour);
begin
  fGroupBehaviour := Value;
  NotifyMetricsChanged;
end;

procedure TSpkSmallButton.SetHideFrameWhenIdle(const Value: Boolean);
begin
  fHideFrameWhenIdle := Value;
  NotifyVisualsChanged;
end;

procedure TSpkSmallButton.SetShowCaption(const Value: Boolean);
begin
  fShowCaption := Value;
  NotifyMetricsChanged;
end;

procedure TSpkSmallButton.SetTableBehaviour(const Value: TSpkItemTableBehaviour);
begin
  fTableBehaviour := Value;
  NotifyMetricsChanged;
end;

initialization
  RegisterClasses([TSpkLargeButton, TSpkSmallButton]);

end.

