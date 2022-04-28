unit SpkCheckboxes;

interface

{$I Spk.inc}

uses
  Windows,
  Graphics,
  Classes,
  SysUtils,
  Controls,
  StdCtrls,
  ActnList,
  SpkMath,
  SpkGUITools,
  SpkBaseItem,
  SpkButtons;

type
  TSpkCustomCheckBox = class(TSPkBaseButton)
  private
    fCheckboxStyle: TSpkCheckboxStyle;
    fGroupBehaviour : TSPkItemGroupBehaviour;
    fHideFrameWhenIdle : boolean;
    fState: TCheckboxState;
    fTableBehaviour : TSpkItemTableBehaviour;
    procedure SetTableBehaviour(const Value: TSpkItemTableBehaviour);
  protected
    function GetChecked: Boolean; override;
    function GetDefaultCaption: String; override;
    function GetDropdownPointForPopupMenu: T2DIntPoint; override;
    procedure SetChecked(const aValue: Boolean); override;
    procedure SetState(aValue: TCheckboxState); virtual;
  protected
    procedure CalcRects; override;
    procedure ConstructRect(out BtnRect: T2DIntRect);
  public
    constructor Create(aOwner: TComponent); override;
    function GetGroupBehaviour : TSpkItemGroupBehaviour; override;
    function GetSizeType: TSpkItemSizeType; override;
    function GetTableBehaviour : TSpkItemTableBehaviour; override;
    function GetWidth: Integer; override;
    procedure Draw(aBuffer: TBitmap; ClipRect: T2DIntRect); override;
  published
    property Checked;
    property State: TCheckboxState read fState write SetState default cbUnchecked;
    property TableBehaviour: TSpkItemTableBehaviour read fTableBehaviour write SetTableBehaviour default tbContinuesRow;
  end;

  TSpkCheckbox = class(TSpkCustomCheckbox)
  public
    constructor Create(aOwner: TComponent); override;
  end;

  TSpkRadioButton = class(TSpkCustomCheckbox)
  protected
    function GetDefaultCaption: String; override;
    procedure SetState(aValue: TCheckboxState); override;
    procedure UncheckSiblings; override;
  public
    constructor Create(aOwner: TComponent); override;
  published
    property AllowAllUp;
    property GroupIndex;
  end;

implementation

uses
  Math,
  Themes,
  SpkGraphTools,
  SpkConst,
  SpkPane,
  SpkAppearance;

{ TSpkCustomCheckbox }

constructor TSpkCustomCheckbox.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  ButtonKind := bkToggle;
  fHideFrameWhenIdle := true;
  fTableBehaviour := tbContinuesRow;
  fGroupBehaviour := gbSingleItem;
  fCheckboxStyle := cbsCheckbox;
  fState := cbUnchecked;
end;

procedure TSpkCustomCheckbox.CalcRects;
var
  lRectVector: T2DIntVector;
begin
  ConstructRect(fButtonRect);
  fDropdownRect := T2DIntRect.Create(0, 0, 0, 0);
  lRectVector := T2DIntVector.Create(fRect.Left, fRect.Top);
  fButtonRect := fButtonRect + lRectVector;
end;

procedure TSpkCustomCheckbox.ConstructRect(out BtnRect: T2DIntRect);
var
  lBitmap: TBitmap;
  lBtnWidth: Integer;
  lTextWidth: Integer;
begin
  BtnRect := T2DIntRect.Create(0, 0, 0, 0);

  if not(Assigned(fToolbarDispatch)) then
    Exit;
  if not(Assigned(fAppearance)) then
    Exit;

  lBitmap := fToolbarDispatch.GetTempBitmap;
  if not Assigned(lBitmap) then
    Exit;

  lBitmap.Canvas.Font.Assign(fAppearance.Element.CaptionFont);
  // lBitmap.Canvas.Font.Height := DPIScale(fAppearance.Element.CaptionFont.Height);
  lTextWidth := lBitmap.Canvas.TextWidth(fCaption);

  lBtnWidth := SPK_SMALL_BUTTON_PADDING + SPK_SMALL_BUTTON_GLYPH_WIDTH +
    SPK_SMALL_BUTTON_PADDING + lTextWidth + SPK_SMALL_BUTTON_PADDING;
  lBtnWidth := Max(SPK_SMALL_BUTTON_MIN_WIDTH, lBtnWidth);

  if fGroupBehaviour in [gbContinuesGroup, gbEndsGroup] then
    lBtnWidth := lBtnWidth + SPK_SMALL_BUTTON_HALF_BORDER_WIDTH
  else
    lBtnWidth := lBtnWidth + SPK_SMALL_BUTTON_BORDER_WIDTH;

  // The right edge of the button
  if (fGroupBehaviour in [gbBeginsGroup, gbContinuesGroup]) then
    lBtnWidth := lBtnWidth + SPK_SMALL_BUTTON_HALF_BORDER_WIDTH
  else
    lBtnWidth := lBtnWidth + SPK_SMALL_BUTTON_BORDER_WIDTH;

  BtnRect := T2DIntRect.Create(0, 0, lBtnWidth - 1, SPK_PANE_ROW_HEIGHT - 1);
end;

procedure TSpkCustomCheckbox.Draw(aBuffer: TBitmap; ClipRect: T2DIntRect);
var
  x, y: Integer;
  lFontColor: TColor;
  lCheckBoxHeight: Integer;
  lThemeElement: TThemedElementDetails;
  lCornerRadius: Integer;
begin
  if fToolbarDispatch = nil then
    Exit;
  if fAppearance = nil then
    Exit;
  if (fRect.Width < 2 * SPK_LARGE_BUTTON_RADIUS) or (fRect.Height < 2 * SPK_LARGE_BUTTON_RADIUS) then
    Exit;

  case fAppearance.Element.Style of
    esRounded:
      lCornerRadius := SPK_SMALL_BUTTON_RADIUS;
    esRectangle:
      lCornerRadius := 0;
  end;

  // Border
  if (fButtonState = bsIdle) and (not(fHideFrameWhenIdle)) then
  begin
    with fAppearance.Element do
      TGUITools.DrawButton(
        aBuffer,
        fButtonRect,
        IdleFrameColor,
        IdleInnerLightColor,
        IdleInnerDarkColor,
        IdleGradientFromColor,
        IdleGradientToColor,
        IdleGradientType,
        (fGroupBehaviour in [gbContinuesGroup, gbEndsGroup]),
        (fGroupBehaviour in [gbBeginsGroup, gbContinuesGroup]) or (fButtonKind = bkButtonDropdown),
        false,
        false,
        lCornerRadius,
        ClipRect
      );
  end else
  if (fButtonState=bsBtnHottrack) then
  begin
    with fAppearance.Element do
      TGUITools.DrawButton(
        aBuffer,
        fButtonRect,
        HotTrackFrameColor,
        HotTrackInnerLightColor,
        HotTrackInnerDarkColor,
        HotTrackGradientFromColor,
        HotTrackGradientToColor,
        HotTrackGradientType,
        (fGroupBehaviour in [gbContinuesGroup, gbEndsGroup]),
        (fGroupBehaviour in [gbBeginsGroup, gbContinuesGroup]) or (fButtonKind = bkButtonDropdown),
        false,
        false,
        lCornerRadius,
        ClipRect
      );
  end else
  if (fButtonState = bsBtnPressed) then
  begin
    with fAppearance.Element do
      TGUITools.DrawButton(
        aBuffer,
        fButtonRect,
        ActiveFrameColor,
        ActiveInnerLightColor,
        ActiveInnerDarkColor,
        ActiveGradientFromColor,
        ActiveGradientToColor,
        ActiveGradientType,
        (fGroupBehaviour in [gbContinuesGroup, gbEndsGroup]),
        (fGroupBehaviour in [gbBeginsGroup, gbContinuesGroup]) or (fButtonKind = bkButtonDropdown),
        false,
        false,
        lCornerRadius,
        ClipRect
      );
  end;

  // Checkbox
  if ThemeServices.ThemesEnabled then
  begin
    lThemeElement := ThemeServices.GetElementDetails(tbCheckboxCheckedNormal);
    lCheckBoxHeight := 13; //TODO: ThemeServices.GetDetailSize(te).cy;
  end else
    lCheckBoxHeight := GetSystemMetrics(SM_CYMENUCHECK);

  if (fGroupBehaviour in [gbContinuesGroup, gbEndsGroup]) then
    x := fButtonRect.Left + SPK_SMALL_BUTTON_HALF_BORDER_WIDTH + SPK_SMALL_BUTTON_PADDING
  else
    x := fButtonRect.Left + SPK_SMALL_BUTTON_BORDER_WIDTH + SPK_SMALL_BUTTON_PADDING;
  y := fButtonRect.Top + (fButtonRect.Height - lCheckBoxHeight) div 2;

  TGUITools.DrawCheckbox(
    aBuffer.Canvas,
    x,y,
    fState,
    fButtonState,
    fCheckboxStyle,
    ClipRect
  );

  // Text
  aBuffer.Canvas.Font.Assign(fAppearance.Element.CaptionFont);

  case fButtonState of
    bsIdle             : lFontColor := fAppearance.Element.IdleCaptionColor;
    bsBtnHottrack,
    bsDropdownHottrack : lFontColor := fAppearance.Element.HotTrackCaptionColor;
    bsBtnPressed,
    bsDropdownPressed  : lFontColor := fAppearance.ELement.ActiveCaptionColor;
  end;
  if not(fEnabled) then
    lFontColor := TColorTools.ColorToGrayscale(lFontColor);

  if (fGroupBehaviour in [gbContinuesGroup, gbEndsGroup]) then
    x := fButtonRect.Left + SPK_SMALL_BUTTON_HALF_BORDER_WIDTH
  else
    x := fButtonRect.Left + SPK_SMALL_BUTTON_BORDER_WIDTH;
  x := x + 2 * SPK_SMALL_BUTTON_PADDING + SPK_SMALL_BUTTON_GLYPH_WIDTH;
  y := fButtonRect.Top + (fButtonRect.Height - aBuffer.Canvas.TextHeight('Wy')) div 2;

  TGUITools.DrawText(aBuffer.Canvas, x, y, fCaption, lFontColor, ClipRect);
end;

function TSpkCustomCheckbox.GetChecked: Boolean;
begin
  Result := (fState = cbChecked);
end;

function TSpkCustomCheckbox.GetDefaultCaption: String;
begin
  Result := 'Checkbox';
end;

function TSpkCustomCheckbox.GetDropdownPointForPopupMenu: T2DIntPoint;
begin
  Result := T2DIntPoint.Create(0,0);
end;

function TSpkCustomCheckbox.GetGroupBehaviour: TSpkItemGroupBehaviour;
begin
  Result := gbSingleitem; //fGroupBehaviour;
end;

function TSpkCustomCheckbox.GetSizeType: TSpkItemSizeType;
begin
  Result := isNormal;
end;

function TSpkCustomCheckbox.GetTableBehaviour: TSpkItemTableBehaviour;
begin
  Result := fTableBehaviour;
end;

function TSpkCustomCheckbox.GetWidth: integer;
var
  BtnRect: T2DIntRect;
begin
  Result := -1;
  if fToolbarDispatch = nil then
    Exit;
  if fAppearance = nil then
    Exit;
  ConstructRect(BtnRect);
  Result := BtnRect.Right + 1;
end;

procedure TSpkCustomCheckbox.SetChecked(const aValue: Boolean);
begin
  inherited SetChecked(aValue);
  if fChecked then
    SetState(cbChecked)
  else
    SetState(cbUnchecked);
end;

procedure TSpkCustomCheckbox.SetState(aValue:TCheckboxState);
begin
  if aValue <> fState then
  begin
    fState := aValue;
    inherited SetChecked(Checked);
    NotifyVisualsChanged;
  end;
end;

procedure TSpkCustomCheckbox.SetTableBehaviour(const Value: TSpkItemTableBehaviour);
begin
  fTableBehaviour := Value;
  NotifyMetricsChanged;
end;


{ TSpkCheckbox }

constructor TSpkCheckbox.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  fCheckboxStyle := cbsCheckbox;
end;


{ TSpkRadioButton }

constructor TSpkRadioButton.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  fCheckboxStyle := cbsRadioButton;
end;

function TSpkRadioButton.GetDefaultCaption: string;
begin
  Result := 'RadioButton';
end;

procedure TSpkRadioButton.SetState(aValue: TCheckboxState);
begin
  inherited SetState(aValue);
  if (aValue = cbChecked) then
    UncheckSiblings;
end;

procedure TSpkRadioButton.UncheckSiblings;
var
  i: Integer;
  lRadioButton: TSpkRadioButton;
  lPane: TSpkPane;
begin
  if (Parent is TSpkPane) then begin
    lPane := TSpkPane(Parent);
    for i := 0 to lPane.Items.Count-1 do
      if (lPane.Items[i] is TSpkRadioButton) then
      begin
        lRadioButton := TSpkRadioButton(lPane.Items[i]);
        if (lRadioButton <> self) and (lRadioButton.GroupIndex = GroupIndex) then begin
          lRadioButton.fChecked := false;
          lRadioButton.fState := cbUnchecked;
        end;
      end;
  end;
end;

initialization
  RegisterClasses([TSpkCheckbox, TSpkRadioButton]);

end.

