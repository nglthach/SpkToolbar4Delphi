unit SpkPane;

interface

{$I Spk.inc}

uses
  Windows,
  Graphics,
  Controls,
  Classes,
  SysUtils,
  Math,
  Types,
  SpkGraphTools,
  SpkGUITools,
  SpkMath,
  SpkAppearance,
  SpkConst,
  SpkBaseItem,
  SpkItems,
  SpkTypes;

type
  TSpkPaneState = (psIdle, psHover);

  TSpkMousePaneElementType = (peNone, pePaneArea, peItem);

  TSpkMousePaneElement = record
    ElementType: TSpkMousePaneElementType;
    ElementIndex: Integer;
  end;

  T2DIntRectArray = array of T2DIntRect;

  TSpkPaneItemsLayout = record
    Rects: T2DIntRectArray;
    Width: Integer;
  end;

  /// <summary>
  ///
  /// </summary>
  TSpkPane = class(TSpkComponent)
  private
    fPaneState: TSpkPaneState;
    fMouseHoverElement: TSpkMousePaneElement;
    fMouseActiveElement: TSpkMousePaneElement;
  protected
    fAppearance: TSpkToolbarAppearance;
    fCaption: string;
    fDisabledImages: TImageList;
    fDisabledLargeImages: TImageList;
    fImages: TImageList;
    fImagesWidth: Integer;
    fItems: TSpkItems;
    fLargeImages: TImageList;
    fLargeImagesWidth: Integer;
    fRect: T2DIntRect;
    fToolbarDispatch: TSpkBaseToolbarDispatch;
    fVisible: Boolean;
    function GetSubCollection: TSpkCollection; override;
    procedure SetCaption(const Value: string);
    procedure SetVisible(const Value: Boolean);
    procedure SetAppearance(const Value: TSpkToolbarAppearance);
    procedure SetImages(const Value: TImageList);
    procedure SetDisabledImages(const Value: TImageList);
    procedure SetLargeImages(const Value: TImageList);
    procedure SetDisabledLargeImages(const Value: TImageList);
    procedure SetImagesWidth(const Value: Integer);
    procedure SetLargeImagesWidth(const Value: Integer);
    procedure SetRect(aRect : T2DIntRect);
    procedure SetToolbarDispatch(const Value: TSpkBaseToolbarDispatch);
  private
    /// Tính vị trí + kích thước của các button...
    function GenerateLayout: TSpkPaneItemsLayout;
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    procedure DefineProperties(Filer : TFiler); override;
    procedure Loaded; override;
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    function FindItemAt(x, y: integer): Integer;
    function GetWidth: Integer;
    procedure Draw(aBuffer: TBitmap; aClipRect: T2DIntRect);
    procedure FreeingItem(aItem: TSpkBaseItem);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MouseLeave;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer);
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  public
    property Appearance: TSpkToolbarAppearance read fAppearance write SetAppearance;
    property DisabledImages: TImageList read fDisabledImages write SetDisabledImages;
    property DisabledLargeImages: TImageList read fDisabledLargeImages write SetDisabledLargeImages;
    property Images: TImageList read fImages write SetImages;
    property ImagesWidth: Integer read fImagesWidth write SetImagesWidth;
    property Items: TSpkItems read fItems;
    property LargeImages: TImageList read fLargeImages write SetLargeImages;
    property LargeImagesWidth: Integer read fLargeImagesWidth write SetLargeImagesWidth;
    property Rect: T2DIntRect read fRect write SetRect;
    property ToolbarDispatch: TSpkBaseToolbarDispatch read fToolbarDispatch write SetToolbarDispatch;
  published
    property Caption: string read fCaption write SetCaption;
    property Visible: boolean read fVisible write SetVisible default true;
  end;

  /// <summary>
  ///
  /// </summary>
  TSpkPanes = class(TSpkCollection)
  private
  protected
    fAppearance: TSpkToolbarAppearance;
    fDisabledImages: TImageList;
    fDisabledLargeImages: TImageList;
    fImages: TImageList;
    fImagesWidth: Integer;
    fLargeImages: TImageList;
    fLargeImagesWidth: Integer;
    fToolbarDispatch: TSpkBaseToolbarDispatch;
    function GetItems(aIndex: integer): TSpkPane; reintroduce;
    procedure SetAppearance(const aValue: TSpkToolbarAppearance);
    procedure SetDisabledImages(const aValue: TImageList);
    procedure SetDisabledLargeImages(const aValue: TImageList);
    procedure SetImages(const aValue: TImageList);
    procedure SetImagesWidth(const aValue: Integer);
    procedure SetLargeImages(const aValue: TImageList);
    procedure SetLargeImagesWidth(const aValue: Integer);
    procedure SetToolbarDispatch(const aValue: TSpkBaseToolbarDispatch);
  public
    function Add: TSpkPane;
    function Insert(aIndex: integer): TSpkPane;
    procedure Notify(Item: TComponent; Operation: TOperation); override;
    procedure Update; override;
  public
    property Appearance: TSpkToolbarAppearance read fAppearance write SetAppearance;
    property DisabledImages: TImageList read fDisabledImages write SetDisabledImages;
    property DisabledLargeImages: TImageList read fDisabledLargeImages write SetDisabledLargeImages;
    property Images: TImageList read fImages write SetImages;
    property ImagesWidth: Integer read fImagesWidth write SetImagesWidth;
    property Items[index: integer]: TSpkPane read GetItems; default;
    property LargeImages: TImageList read fLargeImages write SetLargeImages;
    property LargeImagesWidth: Integer read fLargeImagesWidth write SetLargeImagesWidth;
    property ToolbarDispatch: TSpkBaseToolbarDispatch read fToolbarDispatch write SetToolbarDispatch;
  end;

implementation

uses
  Vcl.Forms;

{ TSpkPane }

constructor TSpkPane.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);

  fPaneState := psIdle;
  fMouseHoverElement.ElementType := peNone;
  fMouseHoverElement.ElementIndex := -1;
  fMouseActiveElement.ElementType := peNone;
  fMouseActiveElement.ElementIndex := -1;

  fCaption := 'Pane';
  fRect := T2DIntRect.Create(0,0,0,0);
  fToolbarDispatch := nil;
  fAppearance := nil;
  fImages := nil;
  fDisabledImages := nil;
  fLargeImages := nil;
  fDisabledLargeImages := nil;
  fVisible := True;

  fItems := TSpkItems.Create(self);
  fItems.ToolbarDispatch := fToolbarDispatch;
  fItems.Appearance := fAppearance;
  fItems.ImagesWidth := fImagesWidth;
  fItems.LargeImagesWidth := fLargeImagesWidth;
end;

destructor TSpkPane.Destroy;
begin
  fItems.Free;
  inherited Destroy;
end;

procedure TSpkPane.SetRect(aRect: T2DIntRect);
var
  i: Integer;
  lPoint: T2DIntPoint;
  lLayout: TSpkPaneItemsLayout;
begin
  fRect := aRect;
  lLayout := GenerateLayout;
  lPoint := T2DIntPoint.Create(
    aRect.Left + SPK_PANE_BORDER_SIZE + SPK_PANE_LEFT_PADDING,
    aRect.Top + SPK_PANE_BORDER_SIZE
  );

  if Length(lLayout.Rects) > 0 then
  begin
    for i := 0 to High(lLayout.Rects) do
      fItems[i].Rect:=lLayout.Rects[i] + lPoint;
  end;
end;

procedure TSpkPane.SetToolbarDispatch(const Value: TSpkBaseToolbarDispatch);
begin
  fToolbarDispatch := Value;
  fItems.ToolbarDispatch := fToolbarDispatch;
end;


procedure TSpkPane.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineProperty('Items', fItems.ReadNames, fItems.WriteNames, true);
end;

procedure TSpkPane.Draw(aBuffer: TBitmap; aClipRect: T2DIntRect);
var
  x: Integer;
  y: Integer;
  BgFromColor, BgToColor, CaptionColor: TColor;
  FontColor, BorderLightColor, BorderDarkColor, c: TColor;
  i: Integer;
  R: T2DIntRect;
  delta: Integer;
begin
  // Under some conditions, we are not able to draw::
  // * No dispatcher
  if fToolbarDispatch = nil then
     Exit;

  // * No appearance
  if fAppearance = nil then
     Exit;

  if fPaneState = psIdle then
  begin
    // psIdle
    BgFromColor := fAppearance.Pane.GradientFromColor;
    BgToColor := fAppearance.Pane.GradientToColor;
    CaptionColor := fAppearance.Pane.CaptionBgColor;
    FontColor := fAppearance.Pane.CaptionFont.Color;
    BorderLightColor := fAppearance.Pane.BorderLightColor;
    BorderDarkColor := fAppearance.Pane.BorderDarkColor;
  end
  else
  begin
    // psHover
    delta := fAppearance.Pane.HotTrackBrightnessChange;
    BgFromColor := TColorTools.Brighten(fAppearance.Pane.GradientFromColor, delta);
    BgToColor := TColorTools.Brighten(fAppearance.Pane.GradientToColor, delta);
    CaptionColor := TColorTools.Brighten(fAppearance.Pane.CaptionBgColor, delta);
    FontColor := TColorTools.Brighten(fAppearance.Pane.CaptionFont.Color, delta);
    BorderLightColor := TColorTools.Brighten(fAppearance.Pane.BorderLightColor, delta);
    BorderDarkColor := TColorTools.Brighten(fAppearance.Pane.BorderDarkColor, delta);
  end;

  // The background
  R := T2DIntRect.Create(
    fRect.Left,
    fRect.Top,
    fRect.Right - SPK_PANE_BORDER_HALF_SIZE + 1, // Avoid white color at bottom-left, right of pane
    fRect.Bottom - SPK_PANE_BORDER_HALF_SIZE + 1
  );
  TGuiTools.DrawRoundRect(
    aBuffer.Canvas,
    R,
    SPK_PANE_CORNER_RADIUS,
    BgFromColor,
    BgToColor,
    fAppearance.Pane.GradientType,
    aClipRect
  );

  // Label background
  R := T2DIntRect.Create(
    fRect.Left,
    fRect.Bottom - SPK_PANE_CAPTION_HEIGHT - SPK_PANE_BORDER_HALF_SIZE,
    fRect.Right - SPK_PANE_BORDER_HALF_SIZE + 1, // Avoid white color at bottom-left, right of pane
    fRect.Bottom - SPK_PANE_BORDER_HALF_SIZE + 1
  );

  TGuiTools.DrawRoundRect(
    aBuffer.Canvas,
    R,
    SPK_PANE_CORNER_RADIUS,
    CaptionColor,
    clNone,
    bkSolid,
    aClipRect,
    false,
    false,
    true,
    true
  );

  // Pane label
  aBuffer.Canvas.Font.Assign(fAppearance.Pane.CaptionFont);
//  aBuffer.Canvas.Font.Height := DPIScale(fAppearance.Pane.CaptionFont.Height);

  x := fRect.Left + (fRect.Width - aBuffer.Canvas.TextWidth(fCaption)) div 2;
  y := fRect.Bottom - SPK_PANE_BORDER_SIZE - SPK_PANE_CAPTION_HEIGHT + 1 +
        (SPK_PANE_CAPTION_HEIGHT - aBuffer.Canvas.TextHeight('Wy')) div 2;

  TGUITools.DrawText(
    aBuffer.Canvas,
    x,
    y,
    fCaption,
    FontColor,
    aClipRect
  );

  // Frames
  case fAppearance.Pane.Style of
    psRectangleFlat:
      begin
        R := T2DIntRect.Create(
          fRect.Left,
          fRect.Top,
          fRect.Right,
          fRect.bottom
        );
        TGUITools.DrawAARoundFrame(
          aBuffer,
          R,
          SPK_PANE_CORNER_RADIUS,
          BorderDarkColor,
          aClipRect
        );
     end;

   psRectangleEtched, psRectangleRaised:
     begin
       R := T2DIntRect.Create(
         fRect.Left + 1,
         fRect.Top + 1,
         fRect.Right,
         fRect.bottom
       );
       if fAppearance.Pane.Style = psRectangleEtched then
         c := BorderLightColor else
         c := BorderDarkColor;
       TGUITools.DrawAARoundFrame(
         aBuffer,
         R,
         SPK_PANE_CORNER_RADIUS,
         c,
         aClipRect
       );

       R := T2DIntRect.Create(
         fRect.Left,
         fRect.Top,
         fRect.Right-1,
         fRect.Bottom-1
       );
       if fAppearance.Pane.Style = psRectangleEtched then
         c := BorderDarkColor
       else
         c := BorderLightColor;
       TGUITools.DrawAARoundFrame(
         aBuffer,
         R,
         SPK_PANE_CORNER_RADIUS,
         c,
         aClipRect
       );
     end;

   psDividerRaised, psDividerEtched:
     begin
       if fAppearance.Pane.Style = psDividerRaised then
         c := BorderLightColor else
         c := BorderDarkColor;
       TGUITools.DrawVLine(
         aBuffer,
         fRect.Right + SPK_PANE_BORDER_HALF_SIZE - 1,
         fRect.Top,
         fRect.Bottom,
         c
       );
       if fAppearance.Pane.Style = psDividerRaised then
         c := BorderDarkColor
       else
         c := BorderLightColor;
       TGUITools.DrawVLine(
         aBuffer,
         fRect.Right + SPK_PANE_BORDER_HALF_SIZE,
         fRect.Top,
         fRect.Bottom,
         c
       );
     end;

   psDividerFlat:
     TGUITools.DrawVLine(
       aBuffer,
       fRect.Right + SPK_PANE_BORDER_HALF_SIZE,
       fRect.Top,
       fRect.Bottom,
       BorderDarkColor
     );
  end;

  // Elements
  for i := 0 to fItems.Count - 1 do
    if fItems[i].Visible then
      fItems[i].Draw(aBuffer, aClipRect);
end;

function TSpkPane.FindItemAt(x, y: integer): Integer;
var
  i: Integer;
begin
  result := -1;
  i := fItems.count-1;
  while (i >= 0) and (result = -1) do
  begin
    if fItems[i].Visible then
    begin
      if fItems[i].Rect.Contains(T2DIntVector.create(x,y)) then
        Result := i;
    end;
    dec(i);
  end;
end;

procedure TSpkPane.FreeingItem(aItem: TSpkBaseItem);
begin
  fItems.RemoveReference(aItem);
end;

function TSpkPane.GenerateLayout: TSpkPaneItemsLayout;
type
  TLayoutRow    = array of Integer;
  TLayoutColumn = array of TLayoutRow;
  TLayout       = array of TLayoutColumn;
var
  c, r, i: Integer;
  lColumnX: Integer;
  lCurrentColumn: Integer;
  lCurrentItemIndex: Integer;
  lCurrentRow: Integer;
  lForceNewColumn: Boolean;
  lItemGroupBehaviour: TSpkItemGroupBehaviour;
  lItemSizeType: TSpkItemSizeType;
  lItemTableBehaviour: TSpkItemTableBehaviour;
  lItemWidth: Integer;
  lBeginGroup: Boolean;
  lLastX: Integer;
  lLayout: TLayout;
  lMaxRowX: Integer;
  lRows: Integer;
  lTmpRect: T2DIntRect;
begin
  SetLength(Result.Rects, fItems.count);
  Result.Width := 0;

  if fItems.Count = 0 then
    Exit;

  // Note: the algorithm is structured in such a way that three of them,
  // lCurrentColumn, lCurrentRow and lCurrentItemIndex, point to an element that
  // is not yet present (just after the recently added element).

  SetLength(lLayout, 1);
  lCurrentColumn := 0;

  SetLength(lLayout[lCurrentColumn], 1);
  lCurrentRow := 0;

  SetLength(lLayout[lCurrentColumn][lCurrentRow], 0);
  lCurrentItemIndex := 0;

  lForceNewColumn := False;

  for i := 0 to fItems.Count - 1 do
  begin
    lItemTableBehaviour := fItems[i].GetTableBehaviour;
    lItemSizeType := fItems[i].GetSizeType;
    // Starting a new column?
    if (i = 0) or
       (lItemSizeType = isLarge) or
       (lItemTableBehaviour = tbBeginsColumn) or
       ((lItemTableBehaviour = tbBeginsRow) and (lCurrentRow = 2)) or
       (lForceNewColumn)
    then
    begin
      // If we are already at the beginning of the new column, there is nothing to do.
      if (lCurrentRow <> 0) or (lCurrentItemIndex <> 0) then
      begin
        SetLength(lLayout, Length(lLayout)+1);
        lCurrentColumn := High(lLayout);

        SetLength(lLayout[lCurrentColumn], 1);
        lCurrentRow := 0;

        SetLength(lLayout[lCurrentColumn][lCurrentRow], 0);
        lCurrentItemIndex := 0;
      end;
    end else
    // Starting a new row?
    if (lItemTableBehaviour = tbBeginsRow) then
    begin
      // If we are already at the beginning of a new poem, there is nothing to do.
      if lCurrentItemIndex <> 0 then
      begin
        SetLength(lLayout[lCurrentColumn], Length(lLayout[lCurrentColumn])+1);
        Inc(lCurrentRow);
        lCurrentItemIndex := 0;
      end;
    end;

    lForceNewColumn := (lItemSizeType = isLarge);
    // If the item is visible, we add it in the current column and the current row.
    if fItems[i].Visible then
    begin
      SetLength(lLayout[lCurrentColumn][lCurrentRow], Length(lLayout[lCurrentColumn][lCurrentRow])+1);
      lLayout[lCurrentColumn][lCurrentRow][lCurrentItemIndex] := i;

      Inc(lCurrentItemIndex);
    end;
  end;

  // We have a ready layout here. Now you have to calculate the positions
  // and sizes of the Rects.

  // First, fill them with empty data that will fill the place of invisible elements.
  for i := 0 to fItems.Count - 1 do
    Result.Rects[i] := T2DIntRect.Create(-1, -1, -1, -1);

  lMaxRowX := 0;

  // Now, we iterate through the layout, fixing the recit.
  for c := 0 to High(lLayout) do
  begin
    if c > 0 then
    begin
      lLastX := lMaxRowX + SPK_PANE_COLUMN_SPACER;
      lMaxRowX := lLastX;
    end
    else
      lLastX := lMaxRowX;

    lColumnX := lLastX;

    lRows := Length(lLayout[c]);
    for r := 0 to lRows - 1 do
    begin
      lLastX := lColumnX;

      for i := 0 to High(lLayout[c][r]) do
      begin
        lItemGroupBehaviour := fItems[lLayout[c][r][i]].GetGroupBehaviour;
        lItemSizeType := fItems[lLayout[c][r][i]].GetSizeType;
        lItemWidth := fItems[lLayout[c][r][i]].GetWidth;
        lBeginGroup := fItems[lLayout[c][r][i]].BeginAGroup;

        if lItemSizeType = isLarge then
        begin
          lTmpRect.Top := SPK_PANE_FULL_ROW_TOP_PADDING;
          lTmpRect.Bottom := lTmpRect.Top + SPK_PANE_FULL_ROW_HEIGHT - 1;
          lTmpRect.Left := lLastX;
          lTmpRect.Right := lLastX + lItemWidth - 1;

          if lBeginGroup then
            lTmpRect := lTmpRect + T2DIntVector.Create(SPK_PANE_GROUP_SPACER + 1, 0);

          lLastX := lTmpRect.Right + 1;
          if lLastX > lMaxRowX then
            lMaxRowX := lLastX;
        end
        else
        begin
          if lItemGroupBehaviour in [gbContinuesGroup, gbEndsGroup] then
          begin
            lTmpRect.Left := lLastX;
            lTmpRect.Right := lTmpRect.Left + lItemWidth - 1;
          end
          else
          begin
            // If the element is not the first one, it must be offset by
            // the margin from the previous one
            if i > 0 then
              lTmpRect.Left := lLastX + SPK_PANE_GROUP_SPACER
            else
              lTmpRect.Left := lLastX;
            lTmpRect.Right := lTmpRect.Left + lItemWidth - 1;
          end;

          {$REGION 'Calculation of tmpRect.top and bottom'}
          case lRows of
            1 : begin
                  lTmpRect.Top := SPK_PANE_ONE_ROW_TOP_PADDING;
                  lTmpRect.Bottom := lTmpRect.Top + SPK_PANE_ROW_HEIGHT - 1;
                end;
            2 : case r of
                  0 : begin
                        lTmpRect.Top := SPK_PANE_TWO_ROWS_TOP_PADDING;
                        lTmpRect.Bottom := lTmpRect.top + SPK_PANE_ROW_HEIGHT - 1;
                      end;
                  1 : begin
                        lTmpRect.Top := SPK_PANE_TWO_ROWS_TOP_PADDING + SPK_PANE_ROW_HEIGHT + SPK_PANE_TWO_ROWS_VSPACER;
                        lTmpRect.Bottom := lTmpRect.top + SPK_PANE_ROW_HEIGHT - 1;
                      end;
                end;
            3 : case r of
                  0 : begin
                        lTmpRect.Top := SPK_PANE_THREE_ROWS_TOP_PADDING;
                        lTmpRect.Bottom := lTmpRect.Top + SPK_PANE_ROW_HEIGHT - 1;
                      end;
                  1 : begin
                        lTmpRect.Top := SPK_PANE_THREE_ROWS_TOP_PADDING + SPK_PANE_ROW_HEIGHT + SPK_PANE_THREE_ROWS_VSPACER;
                        lTmpRect.Bottom := lTmpRect.Top + SPK_PANE_ROW_HEIGHT - 1;
                      end;
                  2 : begin
                        lTmpRect.Top := SPK_PANE_THREE_ROWS_TOP_PADDING + 2 * SPK_PANE_ROW_HEIGHT + 2 * SPK_PANE_THREE_ROWS_VSPACER;
                        lTmpRect.Bottom := lTmpRect.Top + SPK_PANE_ROW_HEIGHT - 1;
                      end;
                end;
          end;
          {$ENDREGION}

          lLastX := lTmpRect.Right + 1;
          if lLastX > lMaxRowX then
            lMaxRowX:=lLastX;
        end;

        Result.Rects[lLayout[c][r][i]] := lTmpRect;
      end;
    end;
  end;
  // At this point, MaxRowX points to the first pixel behind the most
  // right-hand element - ergo is equal to the width of the entire layout.
  Result.Width := lMaxRowX;
end;

function TSpkPane.GetSubCollection: TSpkCollection;
begin
  Result := fItems;
end;

procedure TSpkPane.GetChildren(Proc: TGetChildProc; Root: TComponent);
var
  i: Integer;
begin
  inherited;
  for i := 0 to fItems.Count - 1 do
    Proc(fItems.Items[i]);
end;

function TSpkPane.GetWidth: Integer;
var
  tmpBitmap: TBitmap;
  PaneCaptionWidth, PaneElementsWidth: Integer;
  TextW: Integer;
  ElementsW: Integer;
  Layout: TSpkPaneItemsLayout;
begin
  // Preparing...
  Result := -1;
  if fToolbarDispatch = nil then
    exit;
  if fAppearance = nil then
    exit;

  tmpBitmap := fToolbarDispatch.GetTempBitmap;
  if tmpBitmap = nil then
    exit;
  tmpBitmap.Canvas.Font.Assign(fAppearance.Pane.CaptionFont);

  // *** The minimum width of the sheet (text) ***
  TextW := tmpBitmap.Canvas.TextWidth(fCaption);
  PaneCaptionWidth := 2*SPK_PANE_BORDER_SIZE + 2*SPK_PANE_CAPTION_HMARGIN + TextW;

  // *** The width of the elements of the sheet ***
  Layout := GenerateLayout;
  ElementsW := Layout.Width;
  PaneElementsWidth := SPK_PANE_BORDER_SIZE + SPK_PANE_LEFT_PADDING + ElementsW + SPK_PANE_RIGHT_PADDING + SPK_PANE_BORDER_SIZE;

  // *** Setting the width of the pane ***
  Result := Max(PaneCaptionWidth, PaneElementsWidth);
end;

procedure TSpkPane.Loaded;
begin
  inherited;
  if fItems.ListState = lsNeedsProcessing then
     fItems.ProcessNames(self.Owner);
end;

procedure TSpkPane.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if fMouseActiveElement.ElementType = peItem then
  begin
    if fMouseActiveElement.ElementIndex <> -1 then
      fItems[fMouseActiveElement.ElementIndex].MouseDown(Button, Shift, X, Y);
  end else
  if fMouseActiveElement.ElementType = pePaneArea then
  begin
    fPaneState := psHover;
  end else
  if fMouseActiveElement.ElementType = peNone then
  begin
    if fMouseHoverElement.ElementType = peItem then
    begin
      if fMouseHoverElement.ElementIndex <> -1 then
      begin
        fMouseActiveElement.ElementType := peItem;
        fMouseActiveElement.ElementIndex := fMouseHoverElement.ElementIndex;
        fItems[fMouseHoverElement.ElementIndex].MouseDown(Button, Shift, X, Y);
      end
      else
      begin
        fMouseActiveElement.ElementType := pePaneArea;
        fMouseActiveElement.ElementIndex := -1;
      end;
    end else
    if fMouseHoverElement.ElementType = pePaneArea then
    begin
      fMouseActiveElement.ElementType := pePaneArea;
      fMouseActiveElement.ElementIndex := -1;
      // Placeholder, if there is a need to handle this event.
    end;
  end;
end;

procedure TSpkPane.MouseLeave;
begin
  if fMouseActiveElement.ElementType = peNone then
  begin
    if fMouseHoverElement.ElementType = peItem then
    begin
      if fMouseHoverElement.ElementIndex <> -1 then
        fItems[fMouseHoverElement.ElementIndex].MouseLeave;
    end else
    if fMouseHoverElement.ElementType = pePaneArea then
    begin
      // Placeholder, if there is a need to handle this event.
    end;
  end;

  fMouseHoverElement.ElementType := peNone;
  fMouseHoverElement.ElementIndex := -1;

  // Regardless of which item was active / under the mouse, you need to
  // expire HotTrack.
  if fPaneState <> psIdle then
  begin
    fPaneState := psIdle;
    if Assigned(fToolbarDispatch) then
      fToolbarDispatch.NotifyVisualsChanged;
  end;
end;

procedure TSpkPane.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
  NewMouseHoverElement: TSpkMousePaneElement;
begin
  // MouseMove is only called when the tile is active, or when the mouse moves
  // inside its area. Therefore, it is always necessary to ignite HotTrack
  // in this situation.

  if fPaneState = psIdle then
  begin
    fPaneState := psHover;
    if Assigned(fToolbarDispatch) then
      fToolbarDispatch.NotifyVisualsChanged;
  end;

  // We're looking for an object under the mouse
  i := FindItemAt(X, Y);
  if i <> -1 then
  begin
    NewMouseHoverElement.ElementType := peItem;
    NewMouseHoverElement.ElementIndex := i;
  end else
  if (X >= fRect.Left) and (Y >= fRect.Top) and
     (X <= fRect.Right) and (Y <= fRect.Bottom) then
  begin
    NewMouseHoverElement.ElementType := pePaneArea;
    NewMouseHoverElement.ElementIndex := -1;
  end else
  begin
    NewMouseHoverElement.ElementType := peNone;
    NewMouseHoverElement.ElementIndex := -1;
  end;

  if fMouseActiveElement.ElementType = peItem then
  begin
    if fMouseActiveElement.ElementIndex <> -1 then
      fItems[fMouseActiveElement.ElementIndex].MouseMove(Shift, X, Y);
  end else
  if fMouseActiveElement.ElementType = pePaneArea then
  begin
    // Placeholder, if there is a need to handle this event
  end else
  if fMouseActiveElement.ElementType = peNone then
  begin
    // If the item under the mouse changes, we inform the previous element
    // that the mouse leaves its area
    if (NewMouseHoverElement.ElementType <> fMouseHoverElement.ELementType) or
       (NewMouseHoverElement.ElementIndex <> fMouseHoverElement.ElementIndex) then
    begin
      if fMouseHoverElement.ElementType = peItem then
      begin
        if fMouseHoverElement.ElementIndex <> -1 then
          fItems[fMouseHoverElement.ElementIndex].MouseLeave;
      end else
      if fMouseHoverElement.ElementType = pePaneArea then
      begin
        // Placeholder, if there is a need to handle this event
      end;
    end;

    if NewMouseHoverElement.ElementType = peItem then
    begin
      if NewMouseHoverElement.ElementIndex <> -1 then
        fItems[NewMouseHoverElement.ElementIndex].MouseMove(Shift, X, Y);
    end else
    if NewMouseHoverElement.ElementType = pePaneArea then
    begin
      // Placeholder, if there is a need to handle this event
    end;
  end;

  fMouseHoverElement := NewMouseHoverElement;
end;

procedure TSpkPane.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  ClearActive: boolean;
begin
  ClearActive := not (ssLeft in Shift) and not (ssMiddle in Shift) and not (ssRight in Shift);

  if fMouseActiveElement.ElementType = peItem then
  begin
    if fMouseActiveElement.ElementIndex <> -1 then
      fItems[fMouseActiveElement.ElementIndex].MouseUp(Button, Shift, X, Y);
  end else
  if fMouseActiveElement.ElementType = pePaneArea then
  begin
    // Placeholder, if there is a need to handle this event
  end;

  if ClearActive and
    (fMouseActiveElement.ElementType <> fMouseHoverElement.ElementType) or
    (fMouseActiveElement.ElementIndex <> fMouseHoverElement.ElementIndex) then
  begin
    if fMouseActiveElement.ElementType = peItem then
    begin
      if fMouseActiveElement.ElementIndex <> -1 then
        fItems[fMouseActiveElement.ElementIndex].MouseLeave;
    end else
    if fMouseActiveElement.ElementType = pePaneArea then
    begin
      // Placeholder, if there is a need to handle this event
    end;

    if fMouseHoverElement.ElementType = peItem then
    begin
      if fMouseActiveElement.ElementIndex <> -1 then
        fItems[fMouseActiveElement.ElementIndex].MouseMove(Shift, X, Y);
    end else
    if fMouseHoverElement.ElementType = pePaneArea then
    begin
      // Placeholder, if there is a need to handle this event
    end else
    if fMouseHoverElement.ElementType = peNone then
    begin
      if fPaneState <> psIdle then
      begin
        fPaneState := psIdle;
        if Assigned(fToolbarDispatch) then
          fToolbarDispatch.NotifyVisualsChanged;
      end;
    end;
  end;

  if ClearActive then
  begin
    fMouseActiveElement.ElementType := peNone;
    fMouseActiveElement.ElementIndex := -1;
  end;
end;

procedure TSpkPane.SetAppearance(const Value: TSpkToolbarAppearance);
begin
  fAppearance := Value;
  fItems.Appearance := Value;
end;

procedure TSpkPane.SetCaption(const Value: string);
begin
  fCaption := Value;
  if Assigned(fToolbarDispatch) then
     fToolbarDispatch.NotifyMetricsChanged;
end;

procedure TSpkPane.SetDisabledImages(const Value: TImageList);
begin
  fDisabledImages := Value;
  fItems.DisabledImages := fDisabledImages;
end;

procedure TSpkPane.SetDisabledLargeImages(const Value: TImageList);
begin
  fDisabledLargeImages := Value;
  fItems.DisabledLargeImages := fDisabledLargeImages;
end;

procedure TSpkPane.SetImages(const Value: TImageList);
begin
  fImages := Value;
  fItems.Images := fImages;
end;

procedure TSpkPane.SetImagesWidth(const Value: Integer);
begin
  fImagesWidth := Value;
  fItems.ImagesWidth := fImagesWidth;
end;

procedure TSpkPane.SetLargeImages(const Value: TImageList);
begin
  fLargeImages := Value;
  fItems.LargeImages := fLargeImages;
end;

procedure TSpkPane.SetLargeImagesWidth(const Value: Integer);
begin
  fLargeImagesWidth := Value;
  fItems.LargeImagesWidth := fLargeImagesWidth;
end;

procedure TSpkPane.SetVisible(const Value: boolean);
begin
  fVisible := Value;
  if Assigned(fToolbarDispatch) then
    fToolbarDispatch.NotifyItemsChanged;
end;


{ TSpkPanes }

function TSpkPanes.Add: TSpkPane;
begin
  Result := TSpkPane.Create(fRootComponent);
  Result.Parent := fRootComponent;
  AddItem(Result);
end;

function TSpkPanes.GetItems(aIndex: integer): TSpkPane;
begin
  Result := TSpkPane(inherited Items[aIndex]);
end;

function TSpkPanes.Insert(aIndex: integer): TSpkPane;
var
  lOwner, lParent: TComponent;
  i: Integer;
begin
  if (aIndex < 0) or (aIndex > self.Count) then
    raise InternalException.Create('TSpkPanes.Insert: Invalid index!');

  if fRootComponent<>nil then
  begin
    lOwner := fRootComponent.Owner;
    lParent := fRootComponent;
  end
  else
  begin
    lOwner := nil;
    lParent := nil;
  end;

  Result := TSpkPane.Create(lOwner);
  Result.Parent := lParent;

  if fRootComponent <> nil then
  begin
    i := 0;
    while fRootComponent.Owner.FindComponent('SpkPane'+IntToStr(i)) <> nil do
      inc(i);
    Result.Name := 'SpkPane' + IntToStr(i);
  end;

  InsertItem(aIndex, Result);
end;

procedure TSpkPanes.Notify(Item: TComponent; Operation: TOperation);
begin
  inherited Notify(Item, Operation);
  case Operation of
    opInsert:
      begin
        // Setting the dispatcher to nil will cause that during the
        // ownership assignment, the Notify method will not be called
        TSpkPane(Item).ToolbarDispatch := nil;
        TSpkPane(Item).Appearance := fAppearance;
        TSpkPane(Item).Images := fImages;
        TSpkPane(Item).DisabledImages := fDisabledImages;
        TSpkPane(Item).LargeImages := fLargeImages;
        TSpkPane(Item).DisabledLargeImages := fDisabledLargeImages;
        TSpkPane(Item).ImagesWidth := fImagesWidth;
        TSpkPane(Item).LargeImagesWidth := fLargeImagesWidth;
        TSpkPane(Item).ToolbarDispatch := fToolbarDispatch;
      end;
    opRemove:
      if not(csDestroying in Item.ComponentState) then
      begin
        TSpkPane(Item).ToolbarDispatch := nil;
        TSpkPane(Item).Appearance := nil;
        TSpkPane(Item).Images := nil;
        TSpkPane(Item).DisabledImages := nil;
        TSpkPane(Item).LargeImages := nil;
        TSpkPane(Item).DisabledLargeImages := nil;
//        TSpkPane(Item).ImagesWidth := 0;
//        TSpkPane(Item).LargeImagesWidth := 0;
      end;
  end;
end;

procedure TSpkPanes.SetImages(const aValue: TImageList);
var
  I: Integer;
begin
  fImages := aValue;
  for I := 0 to self.Count - 1 do
    Items[i].Images := aValue;
end;

procedure TSpkPanes.SetImagesWidth(const aValue: Integer);
var
  I: Integer;
begin
  fImagesWidth := aValue;
  for I := 0 to Count - 1 do
    Items[i].ImagesWidth := aValue;
end;

procedure TSpkPanes.SetLargeImages(const aValue: TImageList);
var
  I: Integer;
begin
  fLargeImages := aValue;
  for I := 0 to self.Count - 1 do
    Items[i].LargeImages := aValue;
end;

procedure TSpkPanes.SetLargeImagesWidth(const aValue: Integer);
var
  I: Integer;
begin
  fLargeImagesWidth := aValue;
  for I := 0 to Count - 1 do
    Items[i].LargeImagesWidth := aValue;
end;

procedure TSpkPanes.SetToolbarDispatch(const aValue: TSpkBaseToolbarDispatch);
var
  i: Integer;
begin
  fToolbarDispatch := aValue;
  for i := 0 to self.Count - 1 do
    Items[i].ToolbarDispatch := fToolbarDispatch;
end;

procedure TSpkPanes.SetAppearance(const aValue: TSpkToolbarAppearance);
var
  i: Integer;
begin
  fAppearance := aValue;
  for i := 0 to self.Count - 1 do
    Items[i].Appearance := fAppearance;
  if fToolbarDispatch <> nil then
     fToolbarDispatch.NotifyMetricsChanged;
end;

procedure TSpkPanes.SetDisabledImages(const aValue: TImageList);
var
  I: Integer;
begin
  fDisabledImages := aValue;
  for I := 0 to self.Count - 1 do
    Items[i].DisabledImages := aValue;
end;

procedure TSpkPanes.SetDisabledLargeImages(const aValue: TImageList);
var
  I: Integer;
begin
  fDisabledLargeImages := aValue;
  for I := 0 to self.Count - 1 do
    Items[i].DisabledLargeImages := aValue;
end;

procedure TSpkPanes.Update;
begin
  inherited Update;
  if Assigned(fToolbarDispatch) then
     fToolbarDispatch.NotifyItemsChanged;
end;

initialization
  RegisterClasses([TSpkPane]);

end.
