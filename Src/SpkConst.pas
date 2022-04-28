unit SpkConst;

interface

{$I Spk.inc}

uses
  Graphics;

var
  SPK_LARGE_GROUP_SEPARATOR_MARGIN: Integer;
  // ****************
  // *** Elements ***
  // ****************
  SPK_LARGE_BUTTON_DROPDOWN_FIELD_SIZE: Integer;
  SPK_LARGE_BUTTON_GLYPH_MARGIN: Integer;
  SPK_LARGE_BUTTON_CAPTION_HMARGIN: Integer;
  SPK_LARGE_BUTTON_MIN_WIDTH: Integer;
  SPK_LARGE_BUTTON_RADIUS: Integer;
  SPK_LARGE_BUTTON_BORDER_SIZE: Integer;
  SPK_LARGE_BUTTON_CHEVRON_VMARGIN: Integer;
  SPK_LARGE_BUTTON_CAPTION_TOP_RAIL: Integer;
  SPK_LARGE_BUTTON_CAPTION_BUTTOM_RAIL: Integer;

  SPK_SMALL_BUTTON_GLYPH_WIDTH: Integer;
  SPK_SMALL_BUTTON_BORDER_WIDTH: Integer;
  SPK_SMALL_BUTTON_HALF_BORDER_WIDTH: Integer;
  SPK_SMALL_BUTTON_PADDING: Integer;
  SPK_SMALL_BUTTON_DROPDOWN_WIDTH: Integer;
  SPK_SMALL_BUTTON_RADIUS: Integer;
  SPK_SMALL_BUTTON_MIN_WIDTH: Integer;

  SPK_DROPDOWN_ARROW_WIDTH: Integer;
  SPK_DROPDOWN_ARROW_HEIGHT: Integer;

  // ***********************
  // *** Tab page layout ***
  // ***********************

  /// <summary>Maximum area height that can be used by an element</summary>
  SPK_ELEMENT_MAX_HEIGHT: Integer;

  /// <summary>Maximum row height</summary>
  SPK_PANE_ROW_HEIGHT: Integer;
  SPK_PANE_FULL_ROW_HEIGHT: Integer;

  /// <summary>Single row top margin</summary>
  SPK_PANE_ONE_ROW_TOP_PADDING: Integer;
  /// <summary>Single row bottom margin</summary>
  SPK_PANE_ONE_ROW_BOTTOM_PADDING: Integer;

  /// <summary>Space between rows in a double row layout</summary>
  SPK_PANE_TWO_ROWS_VSPACER: Integer;
  /// <summary>Double row layout top margin</summary>
  SPK_PANE_TWO_ROWS_TOP_PADDING: Integer;
  /// <summary>Double row layout bottom margin</summary>
  SPK_PANE_TWO_ROWS_BOTTOM_PADDING: Integer;

  /// <summary>Space between rows in triple row layout</summary>
  SPK_PANE_THREE_ROWS_VSPACER: Integer;
  /// <summary>Triple row layout top margin</summary>
  SPK_PANE_THREE_ROWS_TOP_PADDING: Integer;
  /// <summary>Triple row layout bottom margin</summary>
  SPK_PANE_THREE_ROWS_BOTTOM_PADDING: Integer;

  SPK_PANE_FULL_ROW_TOP_PADDING: Integer;
  SPK_PANE_FULL_ROW_BOTTOM_PADDING: Integer;

  /// <summary>Pane left padding, space between left pane border and left element border</summary>
  SPK_PANE_LEFT_PADDING: Integer;
  /// <summary>Pane right padding, space between right pane border and right element border</summary>
  SPK_PANE_RIGHT_PADDING: Integer;
  /// <summary>Space between two columns inside the pane</summary>
  SPK_PANE_COLUMN_SPACER: Integer;
  /// <summary>Space between groups on a row in pane</summary>
  SPK_PANE_GROUP_SPACER: Integer;

  // *******************
  // *** Pane layout ***
  // *******************

  /// <summary>Pane caption height</summary>
  SPK_PANE_CAPTION_HEIGHT: Integer;
  /// <summary>Pane corner radius</summary>
  SPK_PANE_CORNER_RADIUS: Integer;
  /// <summary>Pane border size</summary>
  /// <remarks>Do not change?</remarks>
  SPK_PANE_BORDER_SIZE: Integer;
  /// <summary>Half width of pane border?</summary>
  /// <remarks>Do not change?</remarks>
  SPK_PANE_BORDER_HALF_SIZE: Integer;
  /// <summary>Height of pane</summary>
  SPK_PANE_HEIGHT: Integer;
  /// <summary>Pane caption horizontal padding</summary>
  SPK_PANE_CAPTION_HMARGIN: Integer;

  // ************
  // *** Tabs ***
  // ************

  /// <summary>Tab corner radius</summary>
  SPK_TAB_CORNER_RADIUS: Integer;
  /// <summary>Tab page left margin</summary>
  SPK_TAB_PANE_LEFT_PADDING: Integer;
  /// <summary>Tab page right margin/summary>
  SPK_TAB_PANE_RIGHT_PADDING: Integer;
  /// <summary>Tab page top margin</summary>
  SPK_TAB_PANE_TOP_PADDING: Integer;
  /// <summary>Tab page bottom margin</summary>
  SPK_TAB_PANE_BOTTOM_PADDING: Integer;
  /// <summary>Space between panes</summary>
  SPK_TAB_PANE_HSPACING: Integer;
  /// <summary>Tab border size</summary>
  SPK_TAB_BORDER_SIZE: Integer;
  /// <summary>Tab height</summary>
  SPK_TAB_HEIGHT: Integer;

  // ***************
  // *** Toolbar ***
  // ***************

  /// <summary>Pane padding?</summary>
  SPK_TOOLBAR_BORDER_WIDTH: Integer;
  SPK_TOOLBAR_CORNER_RADIUS: Integer;
  SPK_TOOLBAR_TAB_START_OFFSET: Integer;
  /// <summary>Tab caption height</summary>
  SPK_TOOLBAR_TAB_CAPTIONS_HEIGHT: Integer;
  /// <summary>Tab caption horizontal padding</summary>
  SPK_TOOLBAR_TAB_CAPTIONS_TEXT_HPADDING: Integer;
  SPK_TOOLBAR_MIN_TAB_CAPTION_WIDTH: Integer;
  /// <summary>Toolbar total height</summary>
  SPK_TOOLBAR_HEIGHT: Integer;

procedure SpkInitLayoutConsts(FromDPI: Integer; ToDPI: Integer = 0);

implementation

uses
  Forms,
  Windows;

const
  _SPK_DPI_AWARE = True;

  _LARGE_GROUP_SEPARATOR_MARGIN = 10;
  // ****************
  // *** Elements ***
  // ****************
  _LARGEBUTTON_DROPDOWN_FIELD_SIZE = 38;
  _LARGEBUTTON_GLYPH_MARGIN = 6;
  _LARGEBUTTON_CAPTION_HMARGIN = 8;
  _LARGEBUTTON_MIN_WIDTH = 24;
  _LARGEBUTTON_RADIUS = 4;
  _LARGEBUTTON_BORDER_SIZE = 2;
  _LARGEBUTTON_CHEVRON_VMARGIN = 2;
  _LARGEBUTTON_CAPTION_TOP_RAIL = 55;
  _LARGEBUTTON_CAPTION_BOTTOM_RAIL = 70;

  _SMALLBUTTON_GLYPH_WIDTH = 16; //was: 20; //16;
  _SMALLBUTTON_BORDER_WIDTH = 2;
  _SMALLBUTTON_HALF_BORDER_WIDTH = 1;
  _SMALLBUTTON_PADDING = 4;  // was: 2
  _SMALLBUTTON_DROPDOWN_WIDTH = 11;
  _SMALLBUTTON_RADIUS = 4;

  _DROPDOWN_ARROW_WIDTH = 8;
  _DROPDOWN_ARROW_HEIGHT = 8;

  // ***********************
  // *** Tab page layout ***
  // ***********************

  /// <summary>Maximum area height that can be used by an element</summary>
  _ELEMENT_MAX_HEIGHT = 85;

  /// <summary>Maximum row height</summary>
  _PANE_ROW_HEIGHT = 28;
  /// <summary>Single row top margin</summary>
  _PANE_ONE_ROW_TOPPADDING = 22;
  /// <summary>Single row bottom margin</summary>
  _PANE_ONE_ROW_BOTTOMPADDING = 23;
  /// <summary>Space between rows in a double row layout</summary>
  _PANE_TWO_ROWS_VSPACER = 7;
  /// <summary>Double row layout top margin</summary>
  _PANE_TWO_ROWS_TOPPADDING = 8;
  /// <summary>Double row layout bottom margin</summary>
  _PANE_TWO_ROWS_BOTTOMPADDING = 8;
  /// <summary>Space between rows in triple row layout</summary>
  _PANE_THREE_ROWS_VSPACER = 0;
  /// <summary>Triple row layout top margin</summary>
  _PANE_THREE_ROWS_TOPPADDING = 0;
  /// <summary>Triple row layout bottom margin</summary>
  _PANE_THREE_ROWS_BOTTOMPADDING = 1;
  /// <summary>Pane left padding, space between left pane border and left element border</summary>
  _PANE_LEFT_PADDING = 2;
  /// <summary>Pane right padding, space between right pane border and right element border</summary>
  _PANE_RIGHT_PADDING = 2;
  /// <summary>Space between two columns inside the pane</summary>
  _PANE_COLUMN_SPACER = 4;
  /// <summary>Space between groups on a row in pane</summary>
  _PANE_GROUP_SPACER = 4;

  // *******************
  // *** Pane layout ***
  // *******************

  /// <summary>Pane caption height</summary>
  _PANE_CAPTION_HEIGHT = 19;
  /// <summary>Pane corner radius</summary>
  _PANE_CORNER_RADIUS = 3;
  /// <summary>Pane border size.</summary>
  /// <remarks>Do not change?</remarks>
  _PANE_BORDER_SIZE = 2;
  /// <summary>Half width of pane border?</summary>
  /// <remarks>Do not change?</remarks>
  _PANE_BORDER_HALF_SIZE = 1;
  /// <summary>Pane caption horizontal padding</summary>
  _PANE_CAPTION_HMARGIN = 6;

  // ************
  // *** Tabs ***
  // ************

  /// <summary>Tab corner radius</summary>
  _TAB_CORNER_RADIUS = 3;
  /// <summary>Tab page left margin</summary>
  _TAB_PANE_LEFTPADDING = 2;
  /// <summary>Tab page right margin</summary>
  _TAB_PANE_RIGHTPADDING = 2;
  /// <summary>Tab page top margin</summary>
  _TAB_PANE_TOPPADDING = 2;
  /// <summary>Tab page bottom margin</summary>
  _TAB_PANE_BOTTOMPADDING = 2;
  /// <summary>Space between panes</summary>
  _TAB_PANE_HSPACING = 2;
  /// <summary>Tab border size</summary>
  _TAB_BORDER_SIZE = 2;
  // ***************
  // *** Toolbar ***
  // ***************
  /// <summary>Pane padding?</summary>
  _TOOLBAR_BORDER_WIDTH = 1;
  _TOOLBAR_CORNER_RADIUS = 0;
  /// <summary></summary>
  _TOOLBAR_TAB_START_OFFSET = 8;
  /// <summary>Tab caption height</summary>
  _TOOLBAR_TAB_CAPTIONS_HEIGHT = 26;
  /// <summary>Tab caption horizontal padding</summary>
  _TOOLBAR_TAB_CAPTIONS_TEXT_HPADDING = 10;
  /// <summary>Min tab caption width</summary>
  _TOOLBAR_MIN_TAB_CAPTION_WIDTH = 32;

procedure SpkInitLayoutConsts(FromDPI: Integer; ToDPI: Integer = 0);

  function SpkScaleX(Size: Integer): integer;
  begin
    if ToDPI = 0 then
      ToDPI := Screen.PixelsPerInch;

    if (not _SPK_DPI_AWARE) or (ToDPI = FromDPI) then
      Result := Size
    else
    begin
      if (ToDPI/FromDPI <= 1.5) and (Size = 1) then
        Result := 1 //maintaining 1px on 150% scale for crispness
      else
        Result := MulDiv(Size, ToDPI, FromDPI);
    end;
  end;

  function SpkScaleY(Size: Integer): integer;
  begin
    if ToDPI = 0 then
      ToDPI := Screen.PixelsPerInch;

    if (not _SPK_DPI_AWARE) or (ToDPI = FromDPI) then
      Result := Size
    else
    begin
      if (ToDPI/FromDPI <= 1.5) and (Size = 1) then
        Result := 1 //maintaining 1px on 150% scale for crispness
      else
        Result := MulDiv(Size, ToDPI, FromDPI);
    end;
  end;

begin
  if not _SPK_DPI_AWARE then
    ToDPI := FromDPI;

  {$IfDef Darwin}
    ToDPI := FromDPI; //macOS raster scales by itself
  {$EndIf}
  SPK_LARGE_GROUP_SEPARATOR_MARGIN := SpkScaleX(_LARGE_GROUP_SEPARATOR_MARGIN);

  SPK_LARGE_BUTTON_DROPDOWN_FIELD_SIZE := SpkScaleX(_LARGEBUTTON_DROPDOWN_FIELD_SIZE);
  SPK_LARGE_BUTTON_GLYPH_MARGIN := SpkScaleX(_LARGEBUTTON_GLYPH_MARGIN);
  SPK_LARGE_BUTTON_CAPTION_HMARGIN := SpkScaleX(_LARGEBUTTON_CAPTION_HMARGIN);
  SPK_LARGE_BUTTON_MIN_WIDTH := SpkScaleX(_LARGEBUTTON_MIN_WIDTH);
  SPK_LARGE_BUTTON_RADIUS := _LARGEBUTTON_RADIUS;
  SPK_LARGE_BUTTON_BORDER_SIZE := SpkScaleX(_LARGEBUTTON_BORDER_SIZE);
  SPK_LARGE_BUTTON_CHEVRON_VMARGIN := SpkScaleY(_LARGEBUTTON_CHEVRON_VMARGIN);
  SPK_LARGE_BUTTON_CAPTION_TOP_RAIL := SpkScaleY(_LARGEBUTTON_CAPTION_TOP_RAIL);
  SPK_LARGE_BUTTON_CAPTION_BUTTOM_RAIL := SpkScaleY(_LARGEBUTTON_CAPTION_BOTTOM_RAIL);

  SPK_SMALL_BUTTON_GLYPH_WIDTH := SpkScaleX(_SMALLBUTTON_GLYPH_WIDTH);
  SPK_SMALL_BUTTON_BORDER_WIDTH := SpkScaleX(_SMALLBUTTON_BORDER_WIDTH);
  SPK_SMALL_BUTTON_HALF_BORDER_WIDTH := SpkScaleX(_SMALLBUTTON_HALF_BORDER_WIDTH);
  SPK_SMALL_BUTTON_PADDING := SpkScaleX(_SMALLBUTTON_PADDING);
  SPK_SMALL_BUTTON_DROPDOWN_WIDTH := SpkScaleX(_SMALLBUTTON_DROPDOWN_WIDTH);
  SPK_SMALL_BUTTON_RADIUS := SpkScaleX(_SMALLBUTTON_RADIUS);
  SPK_SMALL_BUTTON_MIN_WIDTH := 2 * SPK_SMALL_BUTTON_PADDING + SPK_SMALL_BUTTON_GLYPH_WIDTH;

  SPK_DROPDOWN_ARROW_WIDTH := SpkScaleX(_DROPDOWN_ARROW_WIDTH);
  SPK_DROPDOWN_ARROW_HEIGHT := SpkScaleY(_DROPDOWN_ARROW_HEIGHT);

  SPK_ELEMENT_MAX_HEIGHT := SpkScaleY(_ELEMENT_MAX_HEIGHT);
  SPK_PANE_ROW_HEIGHT := SpkScaleY(_PANE_ROW_HEIGHT);
  SPK_PANE_FULL_ROW_HEIGHT := 3 * SPK_PANE_ROW_HEIGHT;
  SPK_PANE_ONE_ROW_TOP_PADDING := SpkScaleY(_PANE_ONE_ROW_TOPPADDING);
  SPK_PANE_ONE_ROW_BOTTOM_PADDING := SpkScaleY(_PANE_ONE_ROW_BOTTOMPADDING);
  SPK_PANE_TWO_ROWS_VSPACER := SpkScaleY(_PANE_TWO_ROWS_VSPACER);
  SPK_PANE_TWO_ROWS_TOP_PADDING := SpkScaleY(_PANE_TWO_ROWS_TOPPADDING);
  SPK_PANE_TWO_ROWS_BOTTOM_PADDING := SpkScaleY(_PANE_TWO_ROWS_BOTTOMPADDING);
  SPK_PANE_THREE_ROWS_VSPACER := SpkScaleY(_PANE_THREE_ROWS_VSPACER);
  SPK_PANE_THREE_ROWS_TOP_PADDING := SpkScaleY(_PANE_THREE_ROWS_TOPPADDING);
  SPK_PANE_THREE_ROWS_BOTTOM_PADDING := SpkScaleY(_PANE_THREE_ROWS_BOTTOMPADDING);
  SPK_PANE_FULL_ROW_TOP_PADDING := SPK_PANE_THREE_ROWS_TOP_PADDING;
  SPK_PANE_FULL_ROW_BOTTOM_PADDING := SPK_PANE_THREE_ROWS_BOTTOM_PADDING;
  SPK_PANE_LEFT_PADDING := SpkScaleX(_PANE_LEFT_PADDING);
  SPK_PANE_RIGHT_PADDING := SpkScaleX(_PANE_RIGHT_PADDING);
  SPK_PANE_COLUMN_SPACER := SpkScaleX(_PANE_COLUMN_SPACER);
  SPK_PANE_GROUP_SPACER := SpkScaleX(_PANE_GROUP_SPACER);

  SPK_PANE_CAPTION_HEIGHT := SpkScaleY(_PANE_CAPTION_HEIGHT);
  SPK_PANE_CORNER_RADIUS := SpkScaleX(_PANE_CORNER_RADIUS);
  SPK_PANE_BORDER_SIZE := SpkScaleX(_PANE_BORDER_SIZE);
  SPK_PANE_BORDER_HALF_SIZE := SpkScaleX(_PANE_BORDER_HALF_SIZE);
  SPK_PANE_HEIGHT := SPK_ELEMENT_MAX_HEIGHT + SPK_PANE_CAPTION_HEIGHT + 2 * SPK_PANE_BORDER_SIZE;
  SPK_PANE_CAPTION_HMARGIN := SpkScaleX(_PANE_CAPTION_HMARGIN);

  SPK_TAB_CORNER_RADIUS := SpkScaleX(_TAB_CORNER_RADIUS);
  SPK_TAB_PANE_LEFT_PADDING := SpkScaleX(_TAB_PANE_LEFTPADDING);
  SPK_TAB_PANE_RIGHT_PADDING := SpkScaleX(_TAB_PANE_RIGHTPADDING);
  SPK_TAB_PANE_TOP_PADDING := SpkScaleY(_TAB_PANE_TOPPADDING);
  SPK_TAB_PANE_BOTTOM_PADDING := SpkScaleY(_TAB_PANE_BOTTOMPADDING);
  SPK_TAB_PANE_HSPACING := SpkScaleX(_TAB_PANE_HSPACING);
  SPK_TAB_BORDER_SIZE := SpkScaleX(_TAB_BORDER_SIZE);
  SPK_TAB_HEIGHT := SPK_PANE_HEIGHT + SPK_TAB_PANE_TOP_PADDING + SPK_TAB_PANE_BOTTOM_PADDING + SPK_TAB_BORDER_SIZE;

  SPK_TOOLBAR_BORDER_WIDTH := SpkScaleX(_TOOLBAR_BORDER_WIDTH);
  SPK_TOOLBAR_CORNER_RADIUS := SpkScaleX(_TOOLBAR_CORNER_RADIUS);
  SPK_TOOLBAR_TAB_START_OFFSET := SpkScaleX(_TOOLBAR_TAB_START_OFFSET);
  SPK_TOOLBAR_TAB_CAPTIONS_HEIGHT := SpkScaleY(_TOOLBAR_TAB_CAPTIONS_HEIGHT);
  SPK_TOOLBAR_TAB_CAPTIONS_TEXT_HPADDING := SpkScaleX(_TOOLBAR_TAB_CAPTIONS_TEXT_HPADDING);
  SPK_TOOLBAR_MIN_TAB_CAPTION_WIDTH := SpkScaleX(_TOOLBAR_MIN_TAB_CAPTION_WIDTH);
  SPK_TOOLBAR_HEIGHT := SPK_TOOLBAR_TAB_CAPTIONS_HEIGHT + SPK_TAB_HEIGHT;

  // scaling radius if not square
  if SPK_LARGE_BUTTON_RADIUS > 1 then
    SPK_LARGE_BUTTON_RADIUS := SpkScaleX(SPK_LARGE_BUTTON_RADIUS);

  if SPK_SMALL_BUTTON_RADIUS > 1 then
    SPK_SMALL_BUTTON_RADIUS := SpkScaleX(SPK_SMALL_BUTTON_RADIUS);

  if SPK_PANE_CORNER_RADIUS > 1 then
    SPK_PANE_CORNER_RADIUS := SpkScaleX(SPK_PANE_CORNER_RADIUS);

  if SPK_TAB_CORNER_RADIUS > 1 then
    SPK_TAB_CORNER_RADIUS := SpkScaleX(SPK_TAB_CORNER_RADIUS);

  if SPK_TOOLBAR_CORNER_RADIUS > 1 then
    SPK_TOOLBAR_CORNER_RADIUS := SpkScaleX(SPK_TOOLBAR_CORNER_RADIUS);

  if SPK_TOOLBAR_TAB_START_OFFSET > 1 then
    SPK_TOOLBAR_TAB_START_OFFSET := SpkScaleX(SPK_TOOLBAR_TAB_START_OFFSET);
end;

initialization

{$IFDEF DEBUG}
  // A big button
  Assert(_LARGEBUTTON_RADIUS * 2 <= _LARGEBUTTON_DROPDOWN_FIELD_SIZE);
  // Tile, version with one row
  Assert(_PANE_ROW_HEIGHT +
         _PANE_ONE_ROW_TOPPADDING +
         _PANE_ONE_ROW_BOTTOMPADDING <= _ELEMENT_MAX_HEIGHT);
  // Tile, version with two lines
  Assert(2 * _PANE_ROW_HEIGHT +
         _PANE_TWO_ROWS_TOPPADDING +
         _PANE_TWO_ROWS_VSPACER +
         _PANE_TWO_ROWS_BOTTOMPADDING <= _ELEMENT_MAX_HEIGHT);
  // Tile, version with three lines
  Assert(3 * _PANE_ROW_HEIGHT +
         _PANE_THREE_ROWS_TOPPADDING +
         2 * _PANE_THREE_ROWS_VSPACER +
         _PANE_THREE_ROWS_BOTTOMPADDING <= _ELEMENT_MAX_HEIGHT);
{$ENDIF}

end.
