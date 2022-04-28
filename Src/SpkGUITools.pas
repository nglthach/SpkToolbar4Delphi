unit SpkGUITools;

interface

{$I Spk.inc}
{$MESSAGE HINT 'Every rect in this module are exact rectanges (not like in WINAPI without right and bottom)'}

uses
  Windows,
  Classes,
  Controls,
  Graphics,
  ImgList,
  Math,
  SysUtils,
  SpkGraphTools,
  SpkMath;

type
  TCornerPos = (
    cpLeftTop,
    cpRightTop,
    cpLeftBottom,
    cpRightBottom
  );

  TCornerKind = (
    cpRound,
    cpNormal
  );

  TBackgroundKind = (
    bkSolid,
    bkVerticalGradient,
    bkHorizontalGradient,
    bkConcave
  );

  TCheckBoxState = (
    cbUnchecked,
    cbChecked,
    cbGrayed
  );

  TSpkCheckboxStyle = (
    cbsCheckbox,
    cbsRadioButton
  );

  TSpkButtonState = (
    bsIdle,
    bsBtnHottrack,
    bsBtnPressed,
    bsDropdownHottrack,
    bsDropdownPressed
  );

  TGUITools = class
  protected
    class procedure FillGradientRectangle(ACanvas: TCanvas; Rect: T2DIntRect;
        ColorFrom, ColorTo: TColor; GradientKind: TBackgroundKind);
    class procedure SaveClipRgn(DC: HDC; out OrgRgnExists: boolean; out OrgRgn: HRGN);
    class procedure RestoreClipRgn(DC: HDC; OrgRgnExists: boolean; var OrgRgn: HRGN);
  public
    // *** Lines ***

    // Performance:
    // w/ClipRect:  Bitmap is faster (2x)
    // wo/ClipRect: Canvas is faster (a little)
    class procedure DrawHLine(ABitmap: TBitmap;
                             x1, x2: Integer;
                             y: Integer;
                             Color: TColor); overload;
    class procedure DrawHLine(ABitmap: TBitmap;
                             x1, x2: Integer;
                             y: Integer;
                             Color: TColor;
                             ClipRect: T2DIntRect); overload;
    class procedure DrawHLine(ACanvas: TCanvas;
                             x1, x2: Integer;
                             y: Integer;
                             Color: TColor); overload;
    class procedure DrawHLine(ACanvas: TCanvas;
                             x1, x2: Integer;
                             y: Integer;
                             Color: TColor;
                             ClipRect: T2DIntRect); overload;

    // Performance:
    // w/ClipRect:  Bitmap is faster (2x)
    // wo/ClipRect: Canvas is faster (a little)
    class procedure DrawVLine(ABitmap: TBitmap;
                             x: Integer;
                             y1, y2: Integer;
                             Color: TColor); overload;
    class procedure DrawVLine(ABitmap: TBitmap;
                             x: Integer;
                             y1, y2: Integer;
                             Color: TColor;
                             ClipRect: T2DIntRect); overload;
    class procedure DrawVLine(ACanvas: TCanvas;
                             x: Integer;
                             y1, y2: Integer;
                             Color: TColor); overload;
    class procedure DrawVLine(ACanvas: TCanvas;
                             x: Integer;
                             y1, y2: Integer;
                             Color: TColor;
                             ClipRect: T2DIntRect); overload;

    // *** Background and frame tools ***

    // Performance:
    // w/ClipRect:  Bitmap is faster (extremely)
    // wo/ClipRect: Bitmap is faster (extremely)
    class procedure DrawAARoundCorner(ABitmap: TBitmap;
                                     Point: T2DIntVector;
                                     Radius: Integer;
                                     CornerPos: TCornerPos;
                                     Color: TColor); overload;
    class procedure DrawAARoundCorner(ABitmap: TBitmap;
                                     Point: T2DIntVector;
                                     Radius: Integer;
                                     CornerPos: TCornerPos;
                                     Color: TColor;
                                     ClipRect: T2DIntRect); overload;
    class procedure DrawAARoundCorner(ACanvas: TCanvas;
                                     Point: T2DIntVector;
                                     Radius: Integer;
                                     CornerPos: TCornerPos;
                                     Color: TColor); overload;
    class procedure DrawAARoundCorner(ACanvas: TCanvas;
                                     Point: T2DIntVector;
                                     Radius: Integer;
                                     CornerPos: TCornerPos;
                                     Color: TColor;
                                     ClipRect: T2DIntRect); overload;

    // Performance:
    // w/ClipRect:  Bitmap is faster (extremely)
    // wo/ClipRect: Bitmap is faster (extremely)
    class procedure DrawAARoundFrame(ABitmap: TBitmap;
                                    Rect: T2DIntRect;
                                    Radius: Integer;
                                    Color: TColor); overload;
    class procedure DrawAARoundFrame(ABitmap: TBitmap;
                                    Rect: T2DIntRect;
                                    Radius: Integer;
                                    Color: TColor;
                                    ClipRect: T2DIntRect); overload;
    class procedure DrawAARoundFrame(ABitmap: TBitmap;
                                    Rect: T2DIntRect;
                                    Radius: Integer;
                                    Color: TColor;
                                    LeftTopRound: Boolean;
                                    RightTopRound: Boolean;
                                    LeftBottomRound: Boolean;
                                    RightBottomRound: Boolean); overload;
    class procedure DrawAARoundFrame(ACanvas: TCanvas;
                                    Rect: T2DIntRect;
                                    Radius: Integer;
                                    Color: TColor); overload;
    class procedure DrawAARoundFrame(ACanvas: TCanvas;
                                    Rect: T2DIntRect;
                                    Radius: Integer;
                                    Color: TColor;
                                    ClipRect: T2DIntRect); overload;

    class procedure RenderBackground(ABuffer: TBitmap;
                                    Rect: T2DIntRect;
                                    Color1, Color2: TColor;
                                    BackgroundKind: TBackgroundKind);

    class procedure CopyRoundCorner(ABuffer: TBitmap;
                                   ABitmap: TBitmap;
                                   SrcPoint: T2DIntVector;
                                   DstPoint: T2DIntVector;
                                   Radius: Integer;
                                   CornerPos: TCornerPos;
                                   Convex: Boolean = True); overload;
    class procedure CopyRoundCorner(ABuffer: TBitmap;
                                   ABitmap: TBitmap;
                                   SrcPoint: T2DIntVector;
                                   DstPoint: T2DIntVector;
                                   Radius: Integer;
                                   CornerPos: TCornerPos;
                                   ClipRect: T2DIntRect;
                                   Convex: Boolean = True); overload;

    class procedure CopyCorner(ABuffer: TBitmap;
                              ABitmap: TBitmap;
                              SrcPoint: T2DIntVector;
                              DstPoint: T2DIntVector;
                              Radius: Integer); overload; inline;
    class procedure CopyCorner(ABuffer: TBitmap;
                              ABitmap: TBitmap;
                              SrcPoint: T2DIntVector;
                              DstPoint: T2DIntVector;
                              Radius: Integer;
                              ClipRect: T2DIntRect); overload; inline;

    class procedure CopyRectangle(ABuffer: TBitmap;
                                 ABitmap: TBitmap;
                                 SrcPoint: T2DIntVector;
                                 DstPoint: T2DIntVector;
                                 Width: Integer;
                                 Height: Integer); overload;
    class procedure CopyRectangle(ABuffer: TBitmap;
                                 ABitmap: TBitmap;
                                 SrcPoint: T2DIntVector;
                                 DstPoint: T2DIntVector;
                                 Width: Integer;
                                 Height: Integer;
                                 ClipRect: T2DIntRect); overload;
    class procedure CopyMaskRectangle(ABuffer: TBitmap;
                                     AMask: TBitmap;
                                     ABitmap: TBitmap;
                                     SrcPoint: T2DIntVector;
                                     DstPoint: T2DIntVector;
                                     Width: Integer;
                                     Height: Integer); overload;
    class procedure CopyMaskRectangle(ABuffer: TBitmap;
                                     AMask: TBitmap;
                                     ABitmap: TBitmap;
                                     SrcPoint: T2DIntVector;
                                     DstPoint: T2DIntVector;
                                     Width: Integer;
                                     Height: Integer;
                                     ClipRect: T2DIntRect); overload;

    // Performance (RenderBackground + CopyRoundRect vs DrawRoundRect):
    // w/ClipRect : Bitmap faster for smaller radiuses, Canvas faster for larger
    // wo/ClipRect: Bitmap faster for smaller radiuses, Canvas faster for larger
    class procedure CopyRoundRect(ABuffer: TBitmap;
                                 ABitmap: TBitmap;
                                 SrcPoint: T2DIntVector;
                                 DstPoint: T2DIntVector;
                                 Width, Height: Integer;
                                 Radius: Integer;
                                 LeftTopRound: Boolean = True;
                                 RightTopRound: Boolean = True;
                                 LeftBottomRound: Boolean = True;
                                 RightBottomRound: Boolean = True); overload;
    class procedure CopyRoundRect(ABuffer: TBitmap;
                                 ABitmap: TBitmap;
                                 SrcPoint: T2DIntVector;
                                 DstPoint: T2DIntVector;
                                 Width, Height: Integer;
                                 Radius: Integer;
                                 ClipRect: T2DIntRect;
                                 LeftTopRound: Boolean = True;
                                 RightTopRound: Boolean = True;
                                 LeftBottomRound: Boolean = True;
                                 RightBottomRound: Boolean = True); overload;


    class procedure DrawRoundRect(ACanvas: TCanvas;
                                 Rect: T2DIntRect;
                                 Radius: Integer;
                                 ColorFrom: TColor;
                                 ColorTo: TColor;
                                 GradientKind: TBackgroundKind;
                                 LeftTopRound: Boolean = True;
                                 RightTopRound: Boolean = True;
                                 LeftBottomRound: Boolean = True;
                                 RightBottomRound: Boolean = True); overload;
    class procedure DrawRoundRect(ACanvas: TCanvas;
                                 Rect: T2DIntRect;
                                 Radius: Integer;
                                 ColorFrom: TColor;
                                 ColorTo: TColor;
                                 GradientKind: TBackgroundKind;
                                 ClipRect: T2DIntRect;
                                 LeftTopRound: Boolean = True;
                                 RightTopRound: Boolean = True;
                                 LeftBottomRound: Boolean = True;
                                 RightBottomRound: Boolean = True); overload;

    class procedure DrawRegion(ACanvas: TCanvas;
                              Region: HRGN;
                              Rect: T2DIntRect;
                              ColorFrom: TColor;
                              ColorTo: TColor;
                              GradientKind: TBackgroundKind); overload;
    class procedure DrawRegion(ACanvas: TCanvas;
                              Region: HRGN;
                              Rect: T2DIntRect;
                              ColorFrom: TColor;
                              ColorTo: TColor;
                              GradientKind: TBackgroundKind;
                              ClipRect: T2DIntRect); overload;

    // Imagelist tools
    class procedure DrawImage(ABitmap: TBitmap;
                             Imagelist: TImageList;
                             ImageIndex: Integer;
                             Point: T2DIntVector); overload; inline;
    class procedure DrawImage(ABitmap: TBitmap;
                             Imagelist: TImageList;
                             ImageIndex: Integer;
                             Point: T2DIntVector;
                             ClipRect: T2DIntRect); overload; inline;
    class procedure DrawImage(ACanvas: TCanvas;
                             Imagelist: TImageList;
                             ImageIndex: Integer;
                             Point: T2DIntVector); overload; inline;
    class procedure DrawImage(ACanvas: TCanvas;
                             Imagelist: TImageList;
                             ImageIndex: Integer;
                             Point: T2DIntVector;
                             ClipRect: T2DIntRect); overload;
    class procedure DrawImage(ACanvas: TCanvas;
                             Imagelist: TImageList;
                             ImageIndex: Integer;
                             Point: T2DIntVector;
                             ClipRect: T2DIntRect;
                             AImageWidthAt96PPI, ATargetPPI: Integer;
                             ACanvasFactor: Double); overload;

    class procedure DrawDisabledImage(ABitmap: TBitmap;
                                     Imagelist: TImageList;
                                     ImageIndex: Integer;
                                     Point: T2DIntVector); overload; inline;
    class procedure DrawDisabledImage(ABitmap: TBitmap;
                                     Imagelist: TImageList;
                                     ImageIndex: Integer;
                                     Point: T2DIntVector;
                                     ClipRect: T2DIntRect); overload; inline;
    class procedure DrawDisabledImage(ACanvas: TCanvas;
                                     Imagelist: TImageList;
                                     ImageIndex: Integer;
                                     Point: T2DIntVector); overload;
    class procedure DrawDisabledImage(ACanvas: TCanvas;
                                     Imagelist: TImageList;
                                     ImageIndex: Integer;
                                     Point: T2DIntVector;
                                     ClipRect: T2DIntRect); overload; inline;

    // Checkbox
    class procedure DrawCheckbox(ACanvas: TCanvas;
                                 x,y: Integer;
                                 AState: TCheckboxState;
                                 AButtonState: TSpkButtonState;
                                 AStyle: TSpkCheckboxStyle); overload;
    class procedure DrawCheckbox(ACanvas: TCanvas;
                                 x,y: Integer;
                                 AState: TCheckboxState;
                                 AButtonState: TSpkButtonState;
                                 AStyle: TSpkCheckboxStyle;
                                 ClipRect: T2DIntRect); overload;

    // Text tools
    class procedure DrawText(ABitmap: TBitmap;
                        x, y: Integer;
                        const AText: string;
                        TextColor: TColor); overload;
    class procedure DrawText(ABitmap: TBitmap;
                        x, y: Integer;
                        const AText: string;
                        TextColor: TColor;
                        ClipRect: T2DIntRect); overload;
    class procedure DrawMarkedText(ACanvas: TCanvas;
                                  x, y: Integer;
                                  const AText, AMarkPhrase: string;
                                  TextColor: TColor;
                                  CaseSensitive: boolean = false); overload;
    class procedure DrawMarkedText(ACanvas: TCanvas;
                                  x, y: Integer;
                                  const AText, AMarkPhrase: string;
                                  TextColor: TColor;
                                  ClipRect: T2DIntRect;
                                  CaseSensitive: boolean = false); overload;
    class procedure DrawText(ACanvas: TCanvas;
                        x, y: Integer;
                        const AText: string;
                        TextColor: TColor); overload;
    class procedure DrawText(ACanvas: TCanvas;
                        x, y: Integer;
                        const AText: string;
                        TextColor: TColor;
                        ClipRect: T2DIntRect); overload;
    class procedure DrawFitWText(ABitmap: TBitmap;
                                x1, x2: Integer;
                                y: Integer;
                                const AText: string;
                                TextColor: TColor;
                                Align: TAlignment); overload;
    class procedure DrawFitWText(ACanvas: TCanvas;
                                x1, x2: Integer;
                                y: Integer;
                                const AText: string;
                                TextColor: TColor;
                                Align: TAlignment); overload;

    class procedure DrawOutlinedText(ABitmap: TBitmap;
                                    x, y: Integer;
                                    const AText: string;
                                    TextColor: TColor;
                                    OutlineColor: TColor); overload;
    class procedure DrawOutlinedText(ABitmap: TBitmap;
                                    x, y: Integer;
                                    const AText: string;
                                    TextColor: TColor;
                                    OutlineColor: TColor;
                                    ClipRect: T2DIntRect); overload;
    class procedure DrawOutlinedText(ACanvas: TCanvas;
                                    x, y: Integer;
                                    const AText: string;
                                    TextColor: TColor;
                                    OutlineColor: TColor); overload;
    class procedure DrawOutlinedText(ACanvas: TCanvas;
                                    x, y: Integer;
                                    const AText: string;
                                    TextColor: TColor;
                                    OutlineColor: TColor;
                                    ClipRect: T2DIntRect); overload;
    class procedure DrawFitWOutlinedText(ABitmap: TBitmap;
                                        x1, x2: Integer;
                                        y: Integer;
                                        const AText: string;
                                        TextColor,
                                        OutlineColor: TColor;
                                        Align: TAlignment); overload;
    class procedure DrawFitWOutlinedText(ACanvas: TCanvas;
                                        x1, x2: Integer;
                                        y: Integer;
                                        const AText: string;
                                        TextColor,
                                        OutlineColor: TColor;
                                        Align: TAlignment); overload;

    class procedure DrawButton(Bitmap: TBitmap;
                               Rect: T2DIntRect;
                               FrameColor,
                               InnerLightColor,
                               InnerDarkColor,
                               GradientFrom,
                               GradientTo: TColor;
                               GradientKind: TBackgroundKind;
                               LeftEdgeOpen,
                               RightEdgeOpen,
                               TopEdgeOpen,
                               BottomEdgeOpen: boolean;
                               Radius: Integer;
                               ClipRect: T2DIntRect);
  end;

implementation

uses
  Types,
  Themes;

{$IFNDEF FPC}
type
{$IFDEF CPUX64}
  PtrInt = Int64;
  PtrUInt = UInt64;
{$ELSE}
  PtrInt = longint;
  PtrUInt = Longword;
{$ENDIF}

procedure EnsureOrder(var x, y: Integer);
var
  t: Integer;
begin
  if x > y then
  begin
    t := x;
    x := y;
    y := t;
  end;
end;

{$ENDIF}

{ TSpkGUITools }

class procedure TGUITools.CopyRoundCorner(ABuffer, ABitmap: TBitmap; SrcPoint,
  DstPoint: T2DIntVector; Radius: Integer; CornerPos: TCornerPos;
  ClipRect: T2DIntRect; Convex: boolean);
var
  BufferRect, BitmapRect, TempRect: T2DIntRect;
  OrgSrcRect, UnClippedDstRect, OrgDstRect: T2DIntRect;
  SrcRect: T2DIntRect;
  Offset: T2DIntVector;
  Center: T2DIntVector;
  y: Integer;
  SrcLine: Pointer;
  DstLine: Pointer;
  SrcPtr, DstPtr: PByte;
  x: Integer;
  Dist: double;
begin
  if (ABuffer.PixelFormat <> pf24Bit) or (ABitmap.PixelFormat <> pf24Bit) then
    raise Exception.Create('TSpkGUITools.CopyRoundCorner: Only 24-bit bitmaps are accepted!');

  // Validation
  if Radius < 1 then
    Exit;

  if (ABuffer.Width = 0) or (ABuffer.Height = 0) or
     (ABitmap.Width = 0) or (ABitmap.Height = 0) then exit;

  //todo minimize use of temps here
  BufferRect := T2DIntRect.Create(0, 0, ABuffer.width-1, ABuffer.height-1);
  if not BufferRect.IntersectsWith(
      T2DIntRect.Create(SrcPoint.x, SrcPoint.y, SrcPoint.x+Radius-1, SrcPoint.y+Radius-1),
      OrgSrcRect
    )
  then
    Exit;

  BitmapRect := T2DIntRect.Create(0, 0, ABitmap.Width-1, ABitmap.Height-1);
  if not BitmapRect.IntersectsWith(
      T2DIntRect.Create(DstPoint.x, DstPoint.y, DstPoint.x+Radius-1, DstPoint.y+Radius-1),
      UnClippedDstRect
    )
  then
    exit;

  if not(ClipRect.IntersectsWith(UnClippedDstRect, OrgDstRect)) then
    exit;

  Offset := DstPoint - SrcPoint;

  if not(OrgSrcRect.IntersectsWith(OrgDstRect - Offset, SrcRect)) then
    exit;

  // We position the center of the arc
  case CornerPos of
    cpLeftTop:
      Center := T2DIntVector.Create(SrcPoint.x + Radius - 1, SrcPoint.y + Radius - 1);
    cpRightTop:
      Center := T2DIntVector.Create(SrcPoint.x, SrcPoint.y + Radius - 1);
    cpLeftBottom:
      Center := T2DIntVector.Create(SrcPoint.x + Radius - 1, SrcPoint.y);
    cpRightBottom:
      Center := T2DIntVector.Create(SrcPoint.x, SrcPoint.y);
  end;

  // Is there anything to be processed?
  if Convex then
  begin
    //todo: remove the check since is not necessary
    if (SrcRect.Left <= SrcRect.Right) and (SrcRect.Top <= SrcRect.Bottom) then
      for y := SrcRect.Top to SrcRect.Bottom do
      begin
        SrcLine := ABuffer.ScanLine[y];
        DstLine := ABitmap.ScanLine[y + Offset.y];

        SrcPtr := pointer(PtrInt(SrcLine) + SrcRect.Left*3);
        DstPtr := pointer(PtrInt(DstLine) + 3*(SrcRect.Left + Offset.x));
        for x := SrcRect.Left to SrcRect.Right do
        begin
          Dist := Center.DistanceTo(T2DIntVector.Create(x, y));
          if Dist <= (Radius-1) then
            Move(SrcPtr^, DstPtr^, 3);

          inc(SrcPtr, 3);
          inc(DstPtr, 3);
        end;
      end;
  end
  else
  begin
    if (SrcRect.Left <= SrcRect.Right) and (SrcRect.Top <= SrcRect.Bottom) then
      for y := SrcRect.Top to SrcRect.Bottom do
      begin
        SrcLine := ABuffer.ScanLine[y];
        DstLine := ABitmap.ScanLine[y + Offset.y];

        SrcPtr := pointer(PtrInt(SrcLine) + 3*SrcRect.Left);
        DstPtr := pointer(PtrInt(DstLine) + 3*(SrcRect.Left + Offset.x));
        for x := SrcRect.Left to SrcRect.Right do
        begin
          Dist := Center.DistanceTo(T2DIntVector.Create(x, y));
          if Dist >= (Radius-1) then
            Move(SrcPtr^, DstPtr^, 3);
          inc(SrcPtr,3);
          inc(DstPtr,3);
        end;
      end;
  end;
end;

class procedure TGUITools.CopyRoundRect(ABuffer, ABitmap: TBitmap; SrcPoint,
  DstPoint: T2DIntVector; Width, Height, Radius: Integer; ClipRect: T2DIntRect;
  LeftTopRound, RightTopRound, LeftBottomRound, RightBottomRound: boolean);
begin
  if (ABuffer.PixelFormat <> pf24Bit) or (ABitmap.PixelFormat <> pf24Bit) then
    raise Exception.Create('TSpkGUITools.CopyBackground: Only 24 bit bitmaps are accepted!');

  if Radius < 0 then
    Exit;

  if (Radius > Width div 2) or (Radius > Height div 2) then
    Exit;

  if (ABuffer.Width = 0) or (ABuffer.Height = 0) or
     (ABitmap.Width = 0) or (ABitmap.Height = 0) then exit;

{$REGION 'We fill the rectangles'}
  // Mountain /????
  // Góra
  CopyRectangle(ABuffer,
               ABitmap,
               T2DIntPoint.Create(SrcPoint.x + Radius, SrcPoint.y),
               T2DIntPoint.Create(DstPoint.x + Radius, DstPoint.y),
               Width - 2*Radius,
               Radius,
               ClipRect);
  // Down
  // Dó³
  CopyRectangle(ABuffer,
               ABitmap,
               T2DIntPoint.Create(SrcPoint.x + Radius, SrcPoint.y + Height - Radius),
               T2DIntPoint.Create(DstPoint.x + Radius, DstPoint.y + Height - Radius),
               Width - 2*Radius,
               Radius,
               ClipRect);
  // Agent (???)
  // Œrodek
  CopyRectangle(ABuffer,
               ABitmap,
               T2DIntPoint.Create(SrcPoint.x, SrcPoint.y + Radius),
               T2DIntPoint.Create(DstPoint.x, DstPoint.y + Radius),
               Width,
               Height - 2*Radius,
               ClipRect);
{$ENDREGION}

  // We fill the corners
{$REGION 'Left upper'}
  if LeftTopRound then
    TGUITools.CopyRoundCorner(ABuffer,
                              ABitmap,
                              T2DIntPoint.Create(SrcPoint.x, SrcPoint.y),
                              T2DIntPoint.Create(DstPoint.x, DstPoint.y),
                              Radius,
                              cpLeftTop,
                              ClipRect,
                              true)
  else
    TGUITools.CopyCorner(ABuffer,
                         ABitmap,
                         T2DIntPoint.Create(SrcPoint.x, SrcPoint.y),
                         T2DIntPoint.Create(DstPoint.x, DstPoint.y),
                         Radius,
                         ClipRect);
{$ENDREGION}

{$REGION 'Right upper'}
  if RightTopRound then
    TGUITools.CopyRoundCorner(ABuffer,
                              ABitmap,
                              T2DIntPoint.Create(SrcPoint.x + Width - Radius, SrcPoint.y),
                              T2DIntPoint.Create(DstPoint.x + Width - Radius, DstPoint.y),
                              Radius,
                              cpRightTop,
                              ClipRect,
                              true)
  else
    TGUITools.CopyCorner(ABuffer,
                         ABitmap,
                         T2DIntPoint.Create(SrcPoint.x + Width - Radius, SrcPoint.y),
                         T2DIntPoint.Create(DstPoint.x + Width - Radius, DstPoint.y),
                         Radius,
                         ClipRect);
{$ENDREGION}

{$REGION 'Left bottom'}
  if LeftBottomRound then
    TGUITools.CopyRoundCorner(ABuffer,
                              ABitmap,
                              T2DIntPoint.Create(SrcPoint.x, SrcPoint.y + Height - Radius),
                              T2DIntPoint.Create(DstPoint.x, DstPoint.y + Height - Radius),
                              Radius,
                              cpLeftBottom,
                              ClipRect,
                              true)
  else
    TGUITools.CopyCorner(ABuffer,
                         ABitmap,
                         T2DIntPoint.Create(SrcPoint.x, SrcPoint.y + Height - Radius),
                         T2DIntPoint.Create(DstPoint.x, DstPoint.y + Height - Radius),
                         Radius,
                         ClipRect);
{$ENDREGION}

{$REGION 'Right bottom'}
  if RightBottomRound then
    TGUITools.CopyRoundCorner(ABuffer,
                              ABitmap,
                              T2DIntPoint.Create(SrcPoint.x + Width - Radius, SrcPoint.y + Height - Radius),
                              T2DIntPoint.Create(DstPoint.x + Width - Radius, DstPoint.y + Height - Radius),
                              Radius,
                              cpRightBottom,
                              ClipRect,
                              true)
  else
    TGUITools.CopyCorner(ABuffer,
                         ABitmap,
                         T2DIntPoint.Create(SrcPoint.x + Width - Radius, SrcPoint.y + Height - Radius),
                         T2DIntPoint.Create(DstPoint.x + Width - Radius, DstPoint.y + Height - Radius),
                         Radius,
                         ClipRect);
{$ENDREGION'}
end;

class procedure TGUITools.CopyRoundRect(ABuffer: TBitmap; ABitmap: TBitmap; SrcPoint,
  DstPoint: T2DIntVector; Width, Height, Radius: Integer; LeftTopRound,
  RightTopRound, LeftBottomRound, RightBottomRound: boolean);
begin
  if (ABuffer.PixelFormat <> pf24bit) or (ABitmap.PixelFormat <> pf24bit) then
    raise exception.create('TSpkGUITools.CopyBackground: Only 24 bit bitmaps are accepted!');

  if Radius < 0 then
    Exit;

  if (Radius > Width div 2) or (Radius > Height div 2) then
    Exit;

  if (ABuffer.Width = 0) or (ABuffer.Height = 0) or
     (ABitmap.Width = 0) or (ABitmap.Height = 0) then exit;

{$REGION 'We fill the rectangles'}
  // Góra
  CopyRectangle(ABuffer,
                ABitmap,
                T2DIntPoint.Create(SrcPoint.x + Radius, SrcPoint.y),
                T2DIntPoint.Create(DstPoint.x + Radius, DstPoint.y),
                Width - 2*Radius,
                Radius);
  // Dó³
  CopyRectangle(ABuffer,
                ABitmap,
                T2DIntPoint.Create(SrcPoint.x + Radius, SrcPoint.y + Height - radius),
                T2DIntPoint.Create(DstPoint.x + Radius, DstPoint.y + Height - radius),
                Width - 2*Radius,
                Radius);
  // Œrodek
  CopyRectangle(ABuffer,
               ABitmap,
               T2DIntPoint.Create(SrcPoint.x, SrcPoint.y + Radius),
               T2DIntPoint.Create(DstPoint.x, DstPoint.y + Radius),
               Width,
               Height - 2*Radius);
{$ENDREGION}

  // We fill the corners
{$REGION 'Left upper'}
  if LeftTopRound then
    TGUITools.CopyRoundCorner(ABuffer,
                              ABitmap,
                              T2DIntPoint.Create(SrcPoint.x, SrcPoint.y),
                              T2DIntPoint.Create(DstPoint.x, DstPoint.y),
                              Radius,
                              cpLeftTop,
                              true)
  else
    TGUITools.CopyCorner(ABuffer,
                         ABitmap,
                         T2DIntPoint.Create(SrcPoint.x, SrcPoint.y),
                         T2DIntPoint.Create(DstPoint.x, DstPoint.y),
                         Radius);
{$ENDREGION}

{$REGION 'Right upper'}
  if RightTopRound then
    TGUITools.CopyRoundCorner(ABuffer,
                              ABitmap,
                              T2DIntPoint.Create(SrcPoint.x + Width - Radius, SrcPoint.y),
                              T2DIntPoint.Create(DstPoint.x + Width - Radius, DstPoint.y),
                              Radius,
                              cpRightTop,
                              true)
  else
    TGUITools.CopyCorner(ABuffer,
                         ABitmap,
                         T2DIntPoint.Create(SrcPoint.x + Width - Radius, SrcPoint.y),
                         T2DIntPoint.Create(DstPoint.x + Width - Radius, DstPoint.y),
                         Radius);
{$ENDREGION}

{$REGION 'Left bottom'}
  if LeftBottomRound then
    TGUITools.CopyRoundCorner(ABuffer,
                              ABitmap,
                              T2DIntPoint.Create(SrcPoint.x, SrcPoint.y + Height - Radius),
                              T2DIntPoint.Create(DstPoint.x, DstPoint.y + Height - Radius),
                              Radius,
                              cpLeftBottom,
                              true)
  else
    TGUITools.CopyCorner(ABuffer,
                         ABitmap,
                         T2DIntPoint.Create(SrcPoint.x, SrcPoint.y + Height - Radius),
                         T2DIntPoint.Create(DstPoint.x, DstPoint.y + Height - Radius),
                         Radius);
{$ENDREGION}

{$REGION 'Right bottom'}
  if RightBottomRound then
    TGUITools.CopyRoundCorner(ABuffer,
                              ABitmap,
                              T2DIntPoint.Create(SrcPoint.x + Width - Radius, SrcPoint.y + Height - Radius),
                              T2DIntPoint.Create(DstPoint.x + Width - Radius, DstPoint.y + Height - Radius),
                              Radius,
                              cpRightBottom,
                              true)
  else
    TGUITools.CopyCorner(ABuffer,
                         ABitmap,
                         T2DIntPoint.Create(SrcPoint.x + Width - Radius, SrcPoint.y + Height - Radius),
                         T2DIntPoint.Create(DstPoint.x + Width - Radius, DstPoint.y + Height - Radius),
                         Radius);
{$ENDREGION}
end;

class procedure TGUITools.CopyRectangle(ABuffer, ABitmap: TBitmap; SrcPoint,
  DstPoint: T2DIntVector; Width, Height: Integer);
var
  BufferRect, BitmapRect: T2DIntRect;
  SrcRect, DstRect: T2DIntRect;
  ClippedSrcRect: T2DIntRect;
  Offset: T2DIntVector;
  y: Integer;
  SrcLine: Pointer;
  DstLine: Pointer;
begin
  if (ABuffer.PixelFormat <> pf24Bit) or (ABitmap.PixelFormat <> pf24Bit) then
    raise exception.create('TSpkGUITools.CopyRoundCorner: Only 24 bit bitmaps are accepted!');

  // Validation
  if (Width < 1) or (Height < 1) then
    Exit;

  if (ABuffer.Width = 0) or (ABuffer.Height = 0) or (ABitmap.Width = 0) or (ABitmap.Height = 0) then
    Exit;

  // Truncate the source rect to the source bitmap
  BufferRect := T2DIntRect.Create(0, 0, ABuffer.Width-1, ABuffer.Height-1);
  if not BufferRect.IntersectsWith(
      T2DIntRect.Create(SrcPoint.x, SrcPoint.y, SrcPoint.x+Width-1, SrcPoint.y+Height-1),
      SrcRect
    )
  then
    Exit;

  // We cut the target rect to the target bitmap
  BitmapRect := T2DIntRect.Create(0, 0, ABitmap.Width-1, ABitmap.Height-1);
  if not BitmapRect.IntersectsWith(
      T2DIntRect.Create(DstPoint.x, DstPoint.y, DstPoint.x+Width-1, DstPoint.y+Height-1),
      DstRect
    )
  then
    Exit;

  // We are counting the source offset to the target recta
  Offset := DstPoint - SrcPoint;

  // Sprawdzamy, czy na³o¿one na siebie recty: Ÿród³owy i docelowy przesuniêty o
  // offset maj¹ jak¹œ czêœæ wspóln¹
  // Google-translated:
  // Verify that the rectangular overhead: source and target shifted by offset have some common
  if not SrcRect.IntersectsWith(DstRect - Offset, ClippedSrcRect) then
    Exit;

  // If there is anything to process, do the operation
  if (ClippedSrcRect.Left <= ClippedSrcRect.Right) and (ClippedSrcRect.Top <= ClippedSrcRect.Bottom) then
    for y := ClippedSrcRect.Top to ClippedSrcRect.Bottom do
    begin
      SrcLine := ABuffer.ScanLine[y];
      DstLine := ABitmap.ScanLine[y + Offset.y];
      Move(pointer(PtrInt(SrcLine) + 3*ClippedSrcRect.Left)^,
           pointer(PtrInt(DstLine) + 3*(ClippedSrcRect.Left + Offset.x))^,
           3*ClippedSrcRect.Width);
    end;
end;

class procedure TGUITools.CopyCorner(ABuffer, ABitmap: TBitmap;
  SrcPoint, DstPoint: T2DIntVector; Radius: Integer);
begin
  CopyRectangle(ABuffer, ABitmap, SrcPoint, DstPoint, Radius, Radius);
end;

class procedure TGUITools.CopyCorner(ABuffer, ABitmap: TBitmap; SrcPoint,
  DstPoint: T2DIntVector; Radius: Integer; ClipRect: T2DIntRect);
begin
  CopyRectangle(ABuffer, ABitmap, SrcPoint, DstPoint, Radius, Radius, ClipRect);
end;

class procedure TGUITools.CopyMaskRectangle(ABuffer, AMask, ABitmap: TBitmap;
  SrcPoint, DstPoint: T2DIntVector; Width, Height: Integer);
var
  BufferRect, BitmapRect: T2DIntRect;
  SrcRect, DstRect: T2DIntRect;
  ClippedSrcRect: T2DIntRect;
  Offset: T2DIntVector;
  y: Integer;
  SrcLine: Pointer;
  MaskLine: Pointer;
  DstLine: Pointer;
  i: Integer;
begin
  if (ABuffer.PixelFormat <> pf24Bit) or (ABitmap.PixelFormat <> pf24Bit) then
    raise Exception.Create('TSpkGUITools.CopyRoundCorner: Only 24 bit bitmaps are accepted!');

 if (AMask.PixelFormat <> pf8bit) then
   raise Exception.Create('TSpkGUITools.CopyRoundCorner: Only 8-bit masks are accepted!');

  // Validation
  if (Width < 1) or (Height < 1) then
    exit;

  if (ABuffer.Width = 0) or (ABuffer.Height = 0) or
     (ABitmap.Width = 0) or (ABitmap.Height = 0) then exit;

  if (ABuffer.Width <> AMask.Width) or (ABuffer.Height <> AMask.Height) then
    exit;

  // Truncate the source rect to the source bitmap
  BufferRect := T2DIntRect.Create(0, 0, ABuffer.Width-1, ABuffer.Height-1);
  if not BufferRect.IntersectsWith(
      T2DIntRect.Create(SrcPoint.x, SrcPoint.y, SrcPoint.x+Width-1, SrcPoint.y+Height-1),
      SrcRect
    )
  then
    exit;
  // We cut the target rect to the target bitmap
  BitmapRect := T2DIntRect.Create(0, 0, ABitmap.Width-1, ABitmap.Height-1);
  if not BitmapRect.IntersectsWith(
      T2DIntRect.Create(DstPoint.x, DstPoint.y, DstPoint.x+Width-1, DstPoint.y+Height-1),
      DstRect
    )
  then
    exit;

  // We are counting the source offset to the target recta
  Offset := DstPoint - SrcPoint;

  // Sprawdzamy, czy na³o¿one na siebie recty: Ÿród³owy i docelowy przesuniêty o
  // offset maj¹ jak¹œ czêœæ wspóln¹
  // Google-translated:
  // We check that the rectangles that are superimposed on each other:
  // source and target shifted by offset have some common
  if not(SrcRect.IntersectsWith(DstRect - Offset, ClippedSrcRect)) then
    exit;

  // If there is anything to process, do the operation
  if (ClippedSrcRect.Left <= ClippedSrcRect.Right) and
     (ClippedSrcRect.Top <= ClippedSrcRect.Bottom) then
  begin
    for y := ClippedSrcRect.top to ClippedSrcRect.bottom do
    begin
      SrcLine := ABuffer.ScanLine[y];
      SrcLine := pointer(PtrInt(SrcLine) + 3 * ClippedSrcRect.Left);

      MaskLine := AMask.ScanLine[y];
      MaskLine := pointer(PtrInt(MaskLine) + ClippedSrcRect.Left);

      DstLine := ABitmap.ScanLine[y + Offset.y];
      DstLine := pointer(PtrInt(DstLine) + 3 * (ClippedSrcRect.Left + Offset.x));

      for i := 0 to ClippedSrcRect.Width - 1 do
      begin
        if PByte(MaskLine)^ < 128 then
          Move(SrcLine^, DstLine^, 3);

        SrcLine := pointer(PtrInt(SrcLine)+3);
        DstLine := pointer(PtrInt(DstLine)+3);
        MaskLine := pointer(PtrInt(MaskLine)+1);
      end;
    end;
  end;
end;

class procedure TGUITools.CopyMaskRectangle(ABuffer, AMask, ABitmap: TBitmap;
  SrcPoint, DstPoint: T2DIntVector; Width, Height: Integer;
  ClipRect: T2DIntRect);
var
  BufferRect, BitmapRect: T2DIntRect;
  SrcRect, DstRect: T2DIntRect;
  ClippedSrcRect, ClippedDstRect: T2DIntRect;
  Offset: T2DIntVector;
  y: Integer;
  SrcLine: Pointer;
  DstLine: Pointer;
  i: Integer;
  MaskLine: Pointer;
begin
  if (ABuffer.PixelFormat <> pf24Bit) or (ABitmap.PixelFormat <> pf24Bit) then
    raise Exception.Create('TSpkGUITools.CopyMaskRectangle: Only 24 bit bitmaps are accepted!');
  if AMask.PixelFormat<>pf8bit then
    raise Exception.Create('TSpkGUITools.CopyMaskRectangle: Only 8-bit masks are accepted!');

  // Validation
  if (Width < 1) or (Height < 1) then
    exit;

  if (ABuffer.Width = 0) or (ABuffer.Height = 0) or
     (ABitmap.Width = 0) or (ABitmap.Height = 0) then exit;

  if (ABuffer.Width <> AMask.Width) or
     (ABuffer.Height <> AMask.Height)
  then
    raise Exception.Create('TSpkGUITools.CopyMaskRectangle: The mask has incorrect dimensions!');

  // Truncate the source rect to the source bitmap
  BufferRect := T2DIntRect.Create(0, 0, ABuffer.Width-1, ABuffer.Height-1);
  if not BufferRect.IntersectsWith(
      T2DIntRect.Create(SrcPoint.x, SrcPoint.y, SrcPoint.x+Width-1, SrcPoint.y+Height-1),
      SrcRect
    )
  then
    Exit;

  // We trim the target rect to the target area of the bitmap
  BitmapRect:=T2DIntRect.create(0, 0, ABitmap.width-1, ABitmap.height-1);
  if not(BitmapRect.IntersectsWith(T2DIntRect.create(DstPoint.x,
                                                     DstPoint.y,
                                                     DstPoint.x+Width-1,
                                                     DstPoint.y+Height-1),
                                   DstRect))
  then
    Exit;


  // In addition, we trim the target rect
  if not(DstRect.IntersectsWith(ClipRect, ClippedDstRect)) then
     Exit;

  // We count the source offset to the target recta
  Offset:=DstPoint - SrcPoint;

  // Checking whether imposed recty: source and target offsets
  // offset have some common part
  if not (SrcRect.IntersectsWith(ClippedDstRect - Offset, ClippedSrcRect)) then
    Exit;

  // If there is anything to be processed, perform the operation
  if (ClippedSrcRect.Left <= ClippedSrcRect.Right) and (ClippedSrcRect.top <= ClippedSrcRect.bottom) then
    for y := ClippedSrcRect.top to ClippedSrcRect.bottom do
    begin
      SrcLine := ABuffer.ScanLine[y];
      SrcLine:=pointer(PtrInt(SrcLine) + 3 * ClippedSrcRect.Left);

      MaskLine := AMask.ScanLine[y];
      MaskLine:=pointer(PtrInt(MaskLine) + ClippedSrcRect.Left);

      DstLine := ABitmap.ScanLine[y + Offset.y];
      DstLine:=pointer(PtrInt(DstLine) + 3 * (ClippedSrcRect.Left + Offset.x));

      for i := 0 to ClippedSrcRect.width - 1 do
      begin
        if PByte(MaskLine)^<128 then
          Move(SrcLine^, DstLine^, 3);

        SrcLine:=pointer(PtrInt(SrcLine)+3);
        DstLine:=pointer(PtrInt(DstLine)+3);
        MaskLine:=pointer(PtrInt(MaskLine)+1);
      end;
    end;
end;

class procedure TGUITools.CopyRectangle(ABuffer, ABitmap: TBitmap; SrcPoint,
  DstPoint: T2DIntVector; Width, Height: Integer; ClipRect: T2DIntRect);

var
  BufferRect, BitmapRect: T2DIntRect;
  SrcRect, DstRect: T2DIntRect;
  ClippedSrcRect, ClippedDstRect: T2DIntRect;
  Offset: T2DIntVector;
  y: Integer;
  SrcLine: Pointer;
  DstLine: Pointer;
begin
  if (ABuffer.PixelFormat<>pf24bit) or (ABitmap.PixelFormat<>pf24bit) then
     raise exception.create('TSpkGUITools.CopyRoundCorner: Only 24-bit bitmaps are accepted!');

  // Validation
  if (Width < 1) or (Height < 1) then
     Exit;

  if (ABuffer.width=0) or (ABuffer.height=0) or (ABitmap.width=0) or (ABitmap.height=0) then
   Exit;

  // We trim the rect source to the source area of the bitmap
  BufferRect:=T2DIntRect.create(0, 0, ABuffer.width-1, ABuffer.height-1);
  if not(BufferRect.IntersectsWith(T2DIntRect.create(SrcPoint.x,
                                                     SrcPoint.y,
                                                     SrcPoint.x+Width-1,
                                                     SrcPoint.y+Height-1),
                                                     SrcRect))
  then
    Exit;

  // We trim the target rect to the target area of the bitmap
  BitmapRect:=T2DIntRect.create(0, 0, ABitmap.width-1, ABitmap.height-1);
  if not(BitmapRect.IntersectsWith(T2DIntRect.create(DstPoint.x,
                                                     DstPoint.y,
                                                     DstPoint.x+Width-1,
                                                     DstPoint.y+Height-1),
                                                     DstRect))
  then
    Exit;

  // In addition, we trim the target rect
  if not(DstRect.IntersectsWith(ClipRect, ClippedDstRect)) then
     Exit;

  // We count the source offset to the target recta
  Offset:=DstPoint - SrcPoint;

  // Checking whether superimposed overlaps: source offsets and target offsets
  // offset have some common part
  if not(SrcRect.IntersectsWith(ClippedDstRect - Offset, ClippedSrcRect)) then
    Exit;

  // If there is anything to be processed, perform the operation
  if (ClippedSrcRect.Left <= ClippedSrcRect.Right) and (ClippedSrcRect.top <= ClippedSrcRect.bottom) then
    for y := ClippedSrcRect.top to ClippedSrcRect.bottom do
    begin
      SrcLine := ABuffer.ScanLine[y];
      DstLine := ABitmap.ScanLine[y + Offset.y];

      Move(pointer(PtrInt(SrcLine) + 3*ClippedSrcRect.Left)^,
           pointer(PtrInt(DstLine) + 3*(ClippedSrcRect.Left + Offset.x))^,
           3*ClippedSrcRect.Width);
    end;
end;

class procedure TGUITools.CopyRoundCorner(ABuffer: TBitmap; ABitmap: TBitmap;
  SrcPoint, DstPoint: T2DIntVector; Radius: Integer; CornerPos: TCornerPos;
  Convex: boolean);

var
  BufferRect, BitmapRect: T2DIntRect;
  OrgSrcRect, OrgDstRect: T2DIntRect;
  SrcRect: T2DIntRect;
  Offset: T2DIntVector;
  Center: T2DIntVector;
  y: Integer;
  SrcLine: Pointer;
  DstLine: Pointer;
  SrcPtr, DstPtr: PByte;
  x: Integer;
  Dist: double;
begin
  if (ABuffer.PixelFormat<>pf24bit) or (ABitmap.PixelFormat<>pf24bit) then
    raise exception.create('TSpkGUITools.CopyRoundCorner: Only 24-bit bitmaps are accepted!');

  // Sprawdzanie poprawnoœci
  if Radius < 1 then
     Exit;

  if (ABuffer.width=0) or (ABuffer.height=0) or (ABitmap.width=0) or (ABitmap.height=0) then
    Exit;

  BufferRect:=T2DIntRect.create(0, 0, ABuffer.width-1, ABuffer.height-1);
  if not(BufferRect.IntersectsWith(T2DIntRect.create(SrcPoint.x,
                                                     SrcPoint.y,
                                                     SrcPoint.x+Radius-1,
                                                     SrcPoint.y+Radius-1),
                                   OrgSrcRect))
  then
    Exit;

  BitmapRect:=T2DIntRect.create(0, 0, ABitmap.width-1, ABitmap.height-1);
  if not(BitmapRect.IntersectsWith(T2DIntRect.create(DstPoint.x,
                                                     DstPoint.y,
                                                     DstPoint.x+Radius-1,
                                                     DstPoint.y+Radius-1),
                                   OrgDstRect))
  then
    Exit;

  Offset:=DstPoint - SrcPoint;

  if not(OrgSrcRect.IntersectsWith(OrgDstRect - Offset, SrcRect)) then
    Exit;

  // We set the position of the center of the arc
  case CornerPos of
       cpLeftTop: Center:=T2DIntVector.create(SrcPoint.x + radius - 1, SrcPoint.y + Radius - 1);
       cpRightTop: Center:=T2DIntVector.create(SrcPoint.x, SrcPoint.y + Radius - 1);
       cpLeftBottom: Center:=T2DIntVector.Create(SrcPoint.x + radius - 1, SrcPoint.y);
       cpRightBottom: Center:=T2DIntVector.Create(SrcPoint.x, SrcPoint.y);
  end;

  // Is there anything to be processed?
  if Convex then
  begin
    if (SrcRect.Left <= SrcRect.Right) and (SrcRect.top <= SrcRect.bottom) then
      for y := SrcRect.top to SrcRect.bottom do
      begin
        SrcLine := ABuffer.ScanLine[y];
        DstLine := ABitmap.ScanLine[y + Offset.y];

        SrcPtr:=pointer(PtrInt(SrcLine) + 3*SrcRect.Left);
        DstPtr:=pointer(PtrInt(DstLine) + 3*(SrcRect.Left + Offset.x));
        for x := SrcRect.Left to SrcRect.Right do
        begin
          Dist:=Center.DistanceTo(T2DVector.create(x, y));
          if Dist <= (Radius-1) then
            Move(SrcPtr^,DstPtr^,3);

          Inc(SrcPtr,3);
          Inc(DstPtr,3);
        end;
      end;
  end
  else
  begin
    if (SrcRect.Left <= SrcRect.Right) and (SrcRect.top <= SrcRect.bottom) then
      for y := SrcRect.top to SrcRect.bottom do
      begin
        SrcLine := ABuffer.ScanLine[y];
        DstLine := ABitmap.ScanLine[y + Offset.y];

        SrcPtr:=pointer(PtrInt(SrcLine) + 3*SrcRect.Left);
        DstPtr:=pointer(PtrInt(DstLine) + 3*(SrcRect.Left + Offset.x));
        for x := SrcRect.Left to SrcRect.Right do
        begin
          Dist:=Center.DistanceTo(T2DVector.create(x, y));
          if Dist >= (Radius-1) then
            Move(SrcPtr^,DstPtr^,3);

          Inc(SrcPtr,3);
          Inc(DstPtr,3);
        end;
      end;
  end;
end;

class procedure TGUITools.DrawAARoundCorner(ABitmap: TBitmap; Point: T2DIntVector;
  Radius: Integer; CornerPos: TCornerPos; Color: TColor);
var
  CornerRect: T2DIntRect;
  Center: T2DIntVector;
  Line: PByte;
  Ptr: PByte;
  colorR, colorG, colorB: byte;
  x, y: Integer;
  RadiusDist: double;
  OrgCornerRect: T2DIntRect;
  BitmapRect: T2DIntRect;
begin
  if ABitmap.PixelFormat <> pf24bit then
    raise Exception.Create('TSpkGUITools.DrawAARoundCorner: Only 24-bit bitmaps are accepted!');

  // We check the correctness
  if Radius < 1 then
    Exit;
  if (ABitmap.Width=0) or (ABitmap.Height=0) then
    Exit;

  // Source rect
  OrgCornerRect := T2DIntRect.Create(Point.x,
                                     Point.y,
                                     Point.x + radius - 1,
                                     Point.y + radius - 1);

  // ...cut to the size of a bitmap
  BitmapRect := T2DIntRect.Create(0, 0, ABitmap.Width-1, ABitmap.Height-1);

  if not BitmapRect.intersectsWith(OrgCornerRect, CornerRect) then
    exit;

  // If there is nothing to draw, we leave
  if (CornerRect.Left > CornerRect.Right) or (CornerRect.Top > CornerRect.Bottom) then
    Exit;

  // We are looking for a center of arc - depending on the type of corner
  case CornerPos of
    cpLeftTop:
      Center := T2DIntVector.Create(Point.x + radius - 1, Point.y + Radius - 1);
    cpRightTop:
      Center := T2DIntVector.Create(Point.x, Point.y + Radius - 1);
    cpLeftBottom:
      Center := T2DIntVector.Create(Point.x + radius - 1, Point.y);
    cpRightBottom:
      Center := T2DIntVector.Create(Point.x, Point.y);
  end;

  Color := ColorToRGB(Color);
  colorR := GetRValue(Color);
  colorG := GetGValue(Color);
  colorB := GetBValue(Color);

  for y := CornerRect.top to CornerRect.bottom do
  begin
    Line := ABitmap.ScanLine[y];
    for x := CornerRect.Left to CornerRect.Right do
    begin
      RadiusDist := 1 - abs((Radius - 1) - Center.DistanceTo(T2DIntVector.create(x, y)));
      if RadiusDist > 0 then
      begin
        Ptr := pointer(integer(Line) + 3 * x);
        Ptr^ := round(Ptr^ + (colorB - Ptr^) * RadiusDist);
        inc(Ptr);
        Ptr^ := round(Ptr^ + (colorG - Ptr^) * RadiusDist);
        inc(Ptr);
        Ptr^ := round(Ptr^ + (colorR - Ptr^) * RadiusDist);
      end;
    end;
  end;
end;

class procedure TGUITools.DrawAARoundCorner(ABitmap: TBitmap;
  Point: T2DIntVector; Radius: Integer; CornerPos: TCornerPos; Color: TColor;
  ClipRect: T2DIntRect);
var
  CornerRect: T2DIntRect;
  Center: T2DIntVector;
  Line: PByte;
  Ptr: PByte;
  colorR, colorG, colorB: byte;
  x, y: Integer;
  RadiusDist: double;
  OrgCornerRect: T2DIntRect;
  UnClippedCornerRect: T2DIntRect;
  BitmapRect: T2DIntRect;
begin
  if ABitmap.PixelFormat<>pf24bit then
    raise Exception.Create('TSpkGUITools.DrawAARoundCorner: Only 24-bit bitmaps are accepted!');

  if Radius < 1 then
    exit;
  if (ABitmap.Width = 0) or (ABitmap.Height = 0) then
    exit;

  // Source rect...
  OrgCornerRect := T2DIntRect.Create(
    Point.x, Point.y, Point.x + radius - 1, Point.y + radius - 1
  );
  // ... cut to size bitmap
  BitmapRect := T2DIntRect.Create(
    0, 0, ABitmap.Width-1, ABitmap.Height-1);

  if not BitmapRect.IntersectsWith(OrgCornerRect, UnClippedCornerRect) then
    exit;

  // ClipRect
  if not UnClippedCornerRect.IntersectsWith(ClipRect, CornerRect) then
    exit;

  // If there is nothing to draw, we leave
  if (CornerRect.Left > CornerRect.Right) or
     (CornerRect.Top > CornerRect.Bottom)
  then
    exit;

  // We seek the center of the arc - depending on the type of corner
  case CornerPos of
    cpLeftTop:
      Center := T2DIntVector.Create(Point.x + radius - 1, Point.y + Radius - 1);
    cpRightTop:
      Center := T2DIntVector.Create(Point.x, Point.y + Radius - 1);
    cpLeftBottom:
      Center := T2DIntVector.Create(Point.x + radius - 1, Point.y);
    cpRightBottom:
      Center := T2DIntVector.Create(Point.x, Point.y);
  end;

  Color := ColorToRGB(Color);
  colorR := GetRValue(Color);
  colorG := GetGValue(Color);
  colorB := GetBValue(Color);

  for y := CornerRect.top to CornerRect.bottom do
  begin
    Line := ABitmap.ScanLine[y];
    for x := CornerRect.Left to CornerRect.Right do
    begin
      RadiusDist := 1 - abs((Radius - 1) - Center.DistanceTo(T2DIntVector.create(x, y)));
      if RadiusDist > 0 then
      begin
        Ptr := pointer(integer(Line) + 3 * x);
        Ptr^ := round(Ptr^ + (colorB - Ptr^) * RadiusDist);
        inc(Ptr);
        Ptr^ := round(Ptr^ + (colorG - Ptr^) * RadiusDist);
        inc(Ptr);
        Ptr^ := round(Ptr^ + (colorR - Ptr^) * RadiusDist);
      end;
    end;
  end;
end;

class procedure TGUITools.DrawAARoundCorner(ACanvas: TCanvas;
  Point: T2DIntVector; Radius: Integer; CornerPos: TCornerPos; Color: TColor);
var
  Center: T2DIntVector;
  OrgColor: TColor;
  x, y: Integer;
  RadiusDist: double;
  CornerRect: T2DIntRect;
begin
  if Radius < 1 then
    Exit;

  // Source rect
  CornerRect := T2DIntRect.Create(
    Point.x, Point.y, Point.x + radius - 1, Point.y + radius - 1
  );
  // We seek the center of the arc - depending on the type of corner
  case CornerPos of
    cpLeftTop:
      Center := T2DIntVector.Create(Point.x + radius - 1, Point.y + Radius - 1);
    cpRightTop:
      Center := T2DIntVector.Create(Point.x, Point.y + Radius - 1);
    cpLeftBottom:
      Center := T2DIntVector.Create(Point.x + radius - 1, Point.y);
    cpRightBottom:
      Center := T2DIntVector.Create(Point.x, Point.y);
  end;

  Color := ColorToRGB(Color);

  for y := CornerRect.Top to CornerRect.Bottom do
  begin
    for x := CornerRect.Left to CornerRect.Right do
    begin
      RadiusDist := 1 - abs((Radius - 1) - Center.DistanceTo(T2DIntVector.Create(x, y)));
      if RadiusDist > 0 then
      begin
        OrgColor := ACanvas.Pixels[x, y];
        ACanvas.Pixels[x, y] := TColorTools.Shade(OrgColor, Color, RadiusDist);
      end;
    end;
  end;
end;

class procedure TGUITools.DrawAARoundCorner(ACanvas: TCanvas;
  Point: T2DIntVector; Radius: Integer; CornerPos: TCornerPos; Color: TColor;
  ClipRect: T2DIntRect);
var
  UseOrgClipRgn: boolean;
  ClipRgn: HRGN;
  OrgRgn: HRGN;
begin
  // Store the original ClipRgn and set a new one
  SaveClipRgn(ACanvas.Handle, UseOrgClipRgn, OrgRgn);

  ClipRgn := CreateRectRgn(ClipRect.Left, ClipRect.Top, ClipRect.Right+1, ClipRect.Bottom+1);
  if UseOrgClipRgn then
    CombineRgn(ClipRgn, ClipRgn, OrgRgn, RGN_AND);

  SelectClipRgn(ACanvas.Handle, ClipRgn);

  DrawAARoundCorner(ACanvas, Point, Radius, CornerPos, Color);

  // Restores previous ClipRgn and removes used regions
  RestoreClipRgn(ACanvas.Handle, UseOrgClipRgn, OrgRgn);
  DeleteObject(ClipRgn);
end;

class procedure TGUITools.DrawAARoundFrame(ABitmap: TBitmap; Rect: T2DIntRect; Radius: Integer; Color: TColor;
  LeftTopRound, RightTopRound, LeftBottomRound, RightBottomRound: Boolean);
begin
  if ABitmap.PixelFormat <> pf24Bit then
    raise Exception.Create('TGUITools.DrawAARoundFrame: Only 24-bit bitmaps are accepted!');

  if Radius < 1 then
    Exit;

  if (Radius > Rect.Width div 2) or (Radius > Rect.Height div 2) then
    Exit;

  // DrawAARoundCorner is protected against drawing outside the area
  if LeftTopRound then
    DrawAARoundCorner(ABitmap, T2DIntVector.Create(Rect.Left, Rect.Top), Radius, cpLeftTop, Color);
  if RightTopRound then
    DrawAARoundCorner(ABitmap, T2DIntVector.Create(Rect.Right - Radius + 1, Rect.Top), Radius, cpRightTop, Color);
  if LeftBottomRound then
    DrawAARoundCorner(ABitmap, T2DIntVector.Create(Rect.Left, Rect.Bottom - Radius + 1), Radius, cpLeftBottom, Color);
  if RightBottomRound then
    DrawAARoundCorner(ABitmap, T2DIntVector.Create(Rect.Right - Radius + 1, Rect.Bottom - Radius + 1), Radius, cpRightBottom, Color);

  ABitmap.Canvas.Pen.Color := Color;
  ABitmap.Canvas.pen.Style := psSolid;

  // Draw*Line is protected against drawing outside the area
  DrawVLine(ABitmap, Rect.Left, Rect.Top + Radius, Rect.Bottom - Radius, Color);
  DrawVLine(ABitmap, Rect.Right, Rect.Top + Radius, Rect.Bottom - Radius, Color);
  DrawHLine(ABitmap, Rect.Left + Radius, Rect.Right - Radius, Rect.Top, Color);
  DrawHLine(ABitmap, Rect.Left + Radius, Rect.Right - Radius, Rect.Bottom, Color);

  if not LeftTopRound then
  begin
    DrawVLine(ABitmap, Rect.Left, Rect.Top, Rect.Top + Radius, Color);
    DrawHLine(ABitmap, Rect.Left, Rect.Left + Radius, Rect.Top, Color);
  end;

  if not RightTopRound then
  begin
    DrawVLine(ABitmap, Rect.Right, Rect.Top, Rect.Top + Radius, Color);
    DrawHLine(ABitmap, Rect.Right, Rect.Right - Radius, Rect.Top, Color);
  end;

  if not LeftBottomRound then
  begin
    DrawVLine(ABitmap, Rect.Left, Rect.Bottom, Rect.Bottom - Radius, Color);
    DrawHLine(ABitmap, Rect.Left, Rect.Left + Radius, Rect.Bottom, Color);
  end;

  if not RightBottomRound then
  begin
    DrawVLine(ABitmap, Rect.Right, Rect.Bottom, Rect.Bottom - Radius, Color);
    DrawHLine(ABitmap, Rect.Right, Rect.Right - Radius, Rect.Bottom, Color);
  end;
end;

class procedure TGUITools.DrawAARoundFrame(ABitmap: TBitmap; Rect: T2DIntRect;
  Radius: Integer; Color: TColor; ClipRect: T2DIntRect);
begin
  if ABitmap.PixelFormat <> pf24Bit then
   raise Exception.Create('TGUITools.DrawAARoundFrame: Only 24-bit bitmaps are accepted!');

  if Radius < 1 then
    exit;

  if (Radius > Rect.Width div 2) or (Radius > Rect.Height div 2) then
    exit;

  // DrawAARoundCorner is protected against drawing outside the area
  DrawAARoundCorner(ABitmap, T2DIntVector.Create(Rect.Left, Rect.Top), Radius, cpLeftTop, Color, ClipRect);
  DrawAARoundCorner(ABitmap, T2DIntVector.Create(Rect.Right - Radius + 1, Rect.Top), Radius, cpRightTop, Color, ClipRect);
  DrawAARoundCorner(ABitmap, T2DIntVector.Create(Rect.Left, Rect.Bottom - Radius + 1), Radius, cpLeftBottom, Color, ClipRect);
  DrawAARoundCorner(ABitmap, T2DIntVector.Create(Rect.Right - Radius + 1, Rect.Bottom - Radius + 1), Radius, cpRightBottom, Color, ClipRect);

  ABitmap.Canvas.Pen.Color := Color;
  ABitmap.Canvas.pen.Style := psSolid;

  // Draw*Line is protected against drawing outside the area
  DrawVLine(ABitmap, Rect.Left, Rect.top + Radius, Rect.Bottom - Radius, Color, ClipRect);
  DrawVLine(ABitmap, Rect.Right, Rect.top + Radius, Rect.Bottom - Radius, Color, ClipRect);
  DrawHLine(ABitmap, Rect.Left + Radius, Rect.Right - Radius, Rect.Top, Color, ClipRect);
  DrawHLine(ABitmap, Rect.Left + Radius, Rect.Right - Radius, Rect.Bottom, Color, ClipRect);
end;

class procedure TGUITools.DrawAARoundFrame(ABitmap: TBitmap; Rect: T2DIntRect;
  Radius: Integer; Color: TColor);
begin
  if ABitmap.PixelFormat <> pf24Bit then
    raise Exception.Create('TGUITools.DrawAARoundFrame: Only 24-bit bitmaps are accepted!');

  if Radius < 1 then
    Exit;

  if (Radius > Rect.Width div 2) or (Radius > Rect.Height div 2) then
    Exit;

  // DrawAARoundCorner is protected against drawing outside the area
  DrawAARoundCorner(ABitmap, T2DIntVector.Create(Rect.Left, Rect.Top), Radius, cpLeftTop, Color);
  DrawAARoundCorner(ABitmap, T2DIntVector.Create(Rect.Right - Radius + 1, Rect.Top), Radius, cpRightTop, Color);
  DrawAARoundCorner(ABitmap, T2DIntVector.Create(Rect.Left, Rect.Bottom - Radius + 1), Radius, cpLeftBottom, Color);
  DrawAARoundCorner(ABitmap, T2DIntVector.Create(Rect.Right - Radius + 1, Rect.Bottom - Radius + 1), Radius, cpRightBottom, Color);

  ABitmap.Canvas.Pen.Color := Color;
  ABitmap.Canvas.pen.Style := psSolid;

  // Draw*Line is protected against drawing outside the area
  DrawVLine(ABitmap, Rect.Left, Rect.Top + Radius, Rect.bottom - Radius, Color);
  DrawVLine(ABitmap, Rect.Right, Rect.Top + Radius, Rect.bottom - Radius, Color);
  DrawHLine(ABitmap, Rect.Left + Radius, Rect.Right - Radius, Rect.Top, Color);
  DrawHLine(ABitmap, Rect.Left + Radius, Rect.Right - Radius, Rect.Bottom, Color);
end;

class procedure TGUITools.DrawFitWText(ABitmap: TBitmap; x1, x2, y: Integer;
  const AText: string; TextColor: TColor; Align: TAlignment);
var
  tw: Integer;
  s: string;
begin
  with ABitmap.Canvas do
  begin
    Font.Color := TextColor;
    s := AText;
    tw := TextWidth(s);
    if tw <= x2-x1+1 then
    case Align of
      taLeftJustify : TextOut(x1,y,AText);
      taRightJustify: TextOut(x2-tw+1,y,AText);
      taCenter      : TextOut(x1 + ((x2-x1 - tw) div 2), y, AText);
    end else
    begin
      while (s <> '') and (tw > x2-x1+1) do
      begin
        Delete(s, Length(s), 1);
        tw := TextWidth(s+'...');
      end;
      if tw <= x2-x1+1 then
        TextOut(x1, y, s+'...');
    end;
  end;
end;

class procedure TGUITools.DrawHLine(ACanvas: TCanvas; x1, x2, y: Integer;
  Color: TColor);
begin
  EnsureOrder(x1, x2);
  ACanvas.Pen.Color := Color;
  ACanvas.MoveTo(x1, y);
  ACanvas.LineTo(x2+1,y);
end;

class procedure TGUITools.DrawHLine(ACanvas: TCanvas; x1, x2, y: Integer;
  Color: TColor; ClipRect: T2DIntRect);
var
  UseOrgClipRgn: boolean;
  ClipRgn: HRGN;
  OrgRgn: HRGN;
begin
  // Store the original ClipRgn and set a new one
  SaveClipRgn(ACanvas.Handle, UseOrgClipRgn, OrgRgn);

  ClipRgn := CreateRectRgn(ClipRect.Left, ClipRect.Top, ClipRect.Right+1, ClipRect.Bottom+1);
  if UseOrgClipRgn then
    CombineRgn(ClipRgn, ClipRgn, OrgRgn, RGN_AND);

  SelectClipRgn(ACanvas.Handle, ClipRgn);

  DrawHLine(ACanvas, x1, x2, y, Color);

  // Restores previous ClipRgn and removes used regions
  RestoreClipRgn(ACanvas.Handle, UseOrgClipRgn, OrgRgn);
  DeleteObject(ClipRgn);
end;

class procedure TGUITools.DrawImage(ABitmap: TBitmap; Imagelist: TImageList;
  ImageIndex: Integer; Point: T2DIntVector; ClipRect: T2DIntRect);
begin
  DrawImage(ABitmap.Canvas, ImageList, ImageIndex, Point, ClipRect);
end;

class procedure TGUITools.DrawImage(ABitmap: TBitmap; Imagelist: TImageList;
  ImageIndex: Integer; Point: T2DIntVector);
begin
  DrawImage(ABitmap.Canvas, ImageList, ImageIndex, Point);
end;

class procedure TGUITools.DrawImage(ACanvas: TCanvas; Imagelist: TImageList;
  ImageIndex: Integer; Point: T2DIntVector; ClipRect: T2DIntRect);
var
  UseOrgClipRgn: Boolean;
  OrgRgn: HRGN;
  ClipRgn: HRGN;
  //ImageIcon: TIcon;  // wp: no longer needed -- see below
  ImageBitmap: TBitmap;
begin
  // Storing original ClipRgn and applying a new one
  SaveClipRgn(ACanvas.Handle, UseOrgClipRgn, OrgRgn);

  ClipRgn := CreateRectRgn(ClipRect.Left, ClipRect.Top, ClipRect.Right+1, ClipRect.Bottom+1);
  if UseOrgClipRgn then
    CombineRgn(ClipRgn, ClipRgn, OrgRgn, RGN_AND);

  SelectClipRgn(ACanvas.Handle, ClipRgn);
  ImageList.Draw(ACanvas, Point.X, Point.Y, ImageIndex);

  RestoreClipRgn(ACanvas.Handle, UseOrgClipRgn, OrgRgn);
  DeleteObject(ClipRgn);
end;

class procedure TGUITools.DrawImage(ACanvas: TCanvas; Imagelist: TImageList;
  ImageIndex: Integer; Point: T2DIntVector; ClipRect: T2DIntRect;
  AImageWidthAt96PPI, ATargetPPI: Integer; ACanvasFactor: Double);
var
  UseOrgClipRgn: Boolean;
  OrgRgn: HRGN;
  ClipRgn: HRGN;
  ImageBitmap: TBitmap;
begin
  // Storing original ClipRgn and applying a new one
  SaveClipRgn(ACanvas.Handle, UseOrgClipRgn, OrgRgn);

  ClipRgn := CreateRectRgn(ClipRect.Left, ClipRect.Top, ClipRect.Right+1, ClipRect.Bottom+1);
  if UseOrgClipRgn then
    CombineRgn(ClipRgn, ClipRgn, OrgRgn, RGN_AND);

  SelectClipRgn(ACanvas.Handle, ClipRgn);

  //{$IF LCL_FULLVERSION >= 1090000}
  //ImageList.DrawForPPI(ACanvas, Point.X, Point.Y, ImageIndex, AImageWidthAt96PPI, ATargetPPI, ACanvasFactor);
  //{$ELSE}
  ImageList.Draw(ACanvas, Point.X, Point.Y, ImageIndex);
  //{$ENDIF}

  RestoreClipRgn(ACanvas.Handle, UseOrgClipRgn, OrgRgn);
  DeleteObject(ClipRgn);
end;


class procedure TGUITools.DrawMarkedText(ACanvas: TCanvas; x, y: Integer; const AText,
  AMarkPhrase: string; TextColor: TColor; ClipRect: T2DIntRect; CaseSensitive: boolean);
var
  UseOrgClipRgn: Boolean;
  OrgRgn: HRGN;
  ClipRgn: HRGN;
begin
  // Store the original ClipRgn and set a new one
  SaveClipRgn(ACanvas.Handle, UseOrgClipRgn, OrgRgn);

  ClipRgn := CreateRectRgn(ClipRect.Left, ClipRect.Top, ClipRect.Right+1, ClipRect.Bottom+1);
  if UseOrgClipRgn then
    CombineRgn(ClipRgn, ClipRgn, OrgRgn, RGN_AND);

  SelectClipRgn(ACanvas.Handle, ClipRgn);

  DrawMarkedText(ACanvas, x, y, AText, AMarkPhrase, TextColor, CaseSensitive);

  RestoreClipRgn(ACanvas.Handle, UseOrgClipRgn, OrgRgn);
  DeleteObject(ClipRgn);
end;

class procedure TGUITools.DrawMarkedText(ACanvas: TCanvas; x, y: Integer; const AText,
  AMarkPhrase: string; TextColor: TColor; CaseSensitive: boolean);
var
  TextToDraw: string;
  BaseText: string;
  MarkText: string;
  MarkPos: Integer;
  x1: Integer;
  s: string;
  MarkTextLength: Integer;
begin
  TextToDraw := AText;
  if CaseSensitive then
  begin
    BaseText := AText;
    MarkText := AMarkPhrase;
  end else
  begin
    BaseText := AnsiUpperCase(AText);
    MarkText := AnsiUpperCase(AMarkPhrase);
  end;

  x1 := x;
  MarkTextLength := Length(MarkText);

  ACanvas.Font.Color := TextColor;
  ACanvas.Brush.Style := bsClear;

  MarkPos := pos(MarkText, BaseText);
  while MarkPos > 0 do
  begin
    if MarkPos > 1 then
    begin
      // Drawing text before highlighted
      ACanvas.Font.Style := ACanvas.Font.Style - [fsBold];
      s := copy(TextToDraw, 1, MarkPos-1);

      ACanvas.TextOut(x1, y, s);
      inc(x1, ACanvas.TextWidth(s)+1);

      Delete(TextToDraw, 1, MarkPos-1);
      Delete(BaseText, 1, MarkPos-1);
    end;

    // Drawing highlighted text
    ACanvas.Font.Style := ACanvas.Font.Style + [fsBold];
    s := copy(TextToDraw, 1, MarkTextLength);

    ACanvas.TextOut(x1, y, s);
    inc(x1, ACanvas.TextWidth(s)+1);

    Delete(TextToDraw, 1, MarkTextLength);
    Delete(BaseText, 1, MarkTextLength);

    MarkPos := pos(MarkText, BaseText);
  end;

  if Length(BaseText) > 0 then
  begin
    ACanvas.Font.Style := ACanvas.Font.Style - [fsBold];
    ACanvas.TextOut(x1, y, TextToDraw);
  end;
end;

class procedure TGUITools.DrawImage(ACanvas: TCanvas; Imagelist: TImageList;
  ImageIndex: Integer; Point: T2DIntVector);
begin
  ImageList.Draw(ACanvas, Point.x, Point.y, ImageIndex);
end;

class procedure TGUITools.DrawOutlinedText(ACanvas: TCanvas; x, y: Integer;
  const AText: string; TextColor, OutlineColor: TColor);
begin
  with ACanvas do
  begin
    Brush.Style := bsClear;
    Font.Color := OutlineColor;
    TextOut(x-1, y-1, AText);
    TextOut(x, y-1, AText);
    TextOut(x+1, y-1, AText);
    TextOut(x-1, y, AText);
    TextOut(x+1, y, AText);
    TextOut(x-1, y+1, AText);
    TextOut(x, y+1, AText);
    TextOut(x+1, y+1, AText);

    Font.Color := TextColor;
    TextOut(x, y, AText);
  end;
end;

class procedure TGUITools.DrawOutlinedText(ACanvas: TCanvas; x, y: Integer;
  const AText: string; TextColor, OutlineColor: TColor; ClipRect: T2DIntRect);
var
  WinAPIClipRect: TRect;
begin
  WinAPIClipRect := ClipRect.ForWinAPI;
  with ACanvas do
  begin
    Brush.Style := bsClear;
    Font.Color := OutlineColor;
    TextRect(WinAPIClipRect, x-1, y-1, AText);
    TextRect(WinAPIClipRect, x, y-1, AText);
    TextRect(WinAPIClipRect, x+1, y-1, AText);
    TextRect(WinAPIClipRect, x-1, y, AText);
    TextRect(WinAPIClipRect, x+1, y, AText);
    TextRect(WinAPIClipRect, x-1, y+1, AText);
    TextRect(WinAPIClipRect, x, y+1, AText);
    TextRect(WinAPIClipRect, x+1, y+1, AText);

    Font.Color := TextColor;
    TextRect(WinAPIClipRect, x, y, AText);
  end;
end;

class procedure TGUITools.DrawHLine(ABitmap: TBitmap; x1, x2, y: Integer;
  Color: TColor);
var
  LineRect: T2DIntRect;
  BitmapRect: T2DIntRect;
begin
  if ABitmap.PixelFormat <> pf24Bit then
    raise Exception.Create('TGUITools.DrawHLine: Only 24-bit bitmaps are accepted');

  EnsureOrder(x1, x2);
  BitmapRect := T2DIntRect.Create(0, 0, ABitmap.Width-1, ABitmap.Height-1);
  if not BitmapRect.IntersectsWith(T2DIntRect.Create(x1, y, x2, y), LineRect) then
    Exit;

  ABitmap.Canvas.Pen.Color := Color;
  ABitmap.Canvas.Pen.Style := psSolid;
  ABitmap.Canvas.MoveTo(LineRect.Left, LineRect.Top);
  ABitmap.canvas.LineTo(LineRect.Right+1, LineRect.Top);
end;

class procedure TGUITools.DrawHLine(ABitmap: TBitmap; x1, x2, y: Integer;
  Color: TColor; ClipRect: T2DIntRect);
var
  OrgLineRect: T2DIntRect;
  LineRect: T2DIntRect;
  BitmapRect: T2DIntRect;
begin
  if ABitmap.PixelFormat<>pf24bit then
    raise Exception.Create('TGUITools.DrawHLine: Only 24-bit bitmaps are accepted!');

  EnsureOrder(x1, x2);
  BitmapRect := T2DIntRect.Create(0, 0, ABitmap.Width-1, ABitmap.Height-1);
  if not BitmapRect.IntersectsWith(T2DIntRect.Create(x1, y, x2, y), OrgLineRect) then
    Exit;

  if not OrgLineRect.IntersectsWith(ClipRect, LineRect) then
    Exit;

  ABitmap.Canvas.Pen.Color := Color;
  ABitmap.Canvas.Pen.Style := psSolid;
  ABitmap.Canvas.MoveTo(LineRect.Left, LineRect.Top);
  ABitmap.Canvas.LineTo(LineRect.Right+1, LineRect.Top);
end;

class procedure TGUITools.DrawOutlinedText(ABitmap: TBitmap; x, y: Integer;
  const AText: string; TextColor, OutlineColor: TColor; ClipRect: T2DIntRect);
var
  WinAPIClipRect: TRect;
begin
  WinAPIClipRect := ClipRect.ForWinAPI;
  with ABitmap.canvas do
  begin
    Brush.Style := bsClear;
    Font.Color := OutlineColor;
    TextRect(WinAPIClipRect, x-1, y-1, AText);
    TextRect(WinAPIClipRect, x, y-1, AText);
    TextRect(WinAPIClipRect, x+1, y-1, AText);
    TextRect(WinAPIClipRect, x-1, y, AText);
    TextRect(WinAPIClipRect, x+1, y, AText);
    TextRect(WinAPIClipRect, x-1, y+1, AText);
    TextRect(WinAPIClipRect, x, y+1, AText);
    TextRect(WinAPIClipRect, x+1, y+1, AText);

    Font.Color := TextColor;
    TextRect(WinAPIClipRect, x, y, AText);
  end;
end;

class procedure TGUITools.DrawRegion(ACanvas: TCanvas; Region: HRGN;
  Rect: T2DIntRect; ColorFrom, ColorTo: TColor; GradientKind: TBackgroundKind);
var
  UseOrgClipRgn: Boolean;
  OrgRgn: HRGN;
begin
  // Store the original ClipRgn and set a new one
  SaveClipRgn(ACanvas.Handle, UseOrgClipRgn, OrgRgn);
  SelectClipRgn(ACanvas.Handle, Region);

  FillGradientRectangle(ACanvas, Rect, ColorToRGB(ColorFrom), ColorToRGB(ColorTo), GradientKind);
  RestoreClipRgn(ACanvas.Handle, UseOrgClipRgn, OrgRgn);
end;

class procedure TGUITools.DrawRegion(ACanvas: TCanvas; Region: HRGN;
  Rect: T2DIntRect; ColorFrom, ColorTo: TColor; GradientKind: TBackgroundKind;
  ClipRect: T2DIntRect);
var
  UseOrgClipRgn: boolean;
  ClipRgn: HRGN;
  OrgRgn: HRGN;
begin
  // Store the original ClipRgn and set a new one
  SaveClipRgn(ACanvas.Handle, UseOrgClipRgn, OrgRgn);

  ClipRgn := CreateRectRgn(ClipRect.Left, ClipRect.Top, ClipRect.Right+1, ClipRect.Bottom+1);
  if UseOrgClipRgn then
    CombineRgn(ClipRgn, ClipRgn, OrgRgn, RGN_AND);

  SelectClipRgn(ACanvas.Handle, ClipRgn);

  DrawRegion(ACanvas, Region, Rect, ColorFrom, ColorTo, GradientKind);

  // Restores previous ClipRgn and removes used regions
  RestoreClipRgn(ACanvas.Handle, UseOrgClipRgn, OrgRgn);
  DeleteObject(ClipRgn);
end;

class procedure TGUITools.DrawRoundRect(ACanvas: TCanvas; Rect: T2DIntRect;
  Radius: Integer; ColorFrom, ColorTo: TColor; GradientKind: TBackgroundKind;
  ClipRect: T2DIntRect; LeftTopRound, RightTopRound, LeftBottomRound,
  RightBottomRound: boolean);
var
  UseOrgClipRgn: boolean;
  ClipRgn: HRGN;
  OrgRgn: HRGN;
begin
  // Store the original ClipRgn and set a new one
  SaveClipRgn(ACanvas.Handle, UseOrgClipRgn, OrgRgn);

  ClipRgn := CreateRectRgn(
    ClipRect.Left, ClipRect.Top, ClipRect.Right+1, ClipRect.Bottom+1
  );
  if UseOrgClipRgn then
    CombineRgn(ClipRgn, ClipRgn, OrgRgn, RGN_AND);

  SelectClipRgn(ACanvas.Handle, ClipRgn);

  DrawRoundRect(ACanvas, Rect, Radius, ColorFrom, ColorTo, GradientKind,
    LeftTopRound, RightTopRound, LeftBottomRound, RightBottomRound);

  // Restores previous ClipRgn and removes used regions
  RestoreClipRgn(ACanvas.Handle, UseOrgClipRgn, OrgRgn);
  DeleteObject(ClipRgn);
end;

class procedure TGUITools.DrawText(ACanvas: TCanvas; x, y: Integer;
  const AText: string; TextColor: TColor);
begin
  with ACanvas do
  begin
    Brush.Style := bsClear;
    Font.Color := TextColor;
    TextOut(x, y, AText);
  end;
end;

class procedure TGUITools.DrawText(ACanvas: TCanvas; x, y: Integer;
  const AText: string; TextColor: TColor; ClipRect: T2DIntRect);
var
  WinAPIClipRect: TRect;
begin
  WinAPIClipRect := ClipRect.ForWinAPI;
  with ACanvas do
  begin
    Brush.Style := bsClear;
    Font.Color := TextColor;
    TextRect(WinAPIClipRect, x, y, AText);
  end;
end;

class procedure TGUITools.DrawRoundRect(ACanvas: TCanvas; Rect: T2DIntRect;
  Radius: Integer; ColorFrom, ColorTo: TColor; GradientKind: TBackgroundKind;
  LeftTopRound, RightTopRound, LeftBottomRound, RightBottomRound: boolean);
var
  RoundRgn: HRGN;
  TmpRgn: HRGN;
  OrgRgn: HRGN;
  UseOrgClipRgn: Boolean;
begin
  if Radius < 0 then
    Exit;

  if Radius > 0 then
  begin
    if (Radius*2 > Rect.Width) or (Radius*2 > Rect.Height) then
      Exit;

    // Zapamiêtywanie oryginalnego ClipRgn i ustawianie nowego
    SaveClipRgn(ACanvas.Handle, UseOrgClipRgn, OrgRgn);

    if not(LeftTopRound) and
       not(RightTopRound) and
       not(LeftBottomRound) and
       not (RightBottomRound) then
    begin
      RoundRgn := CreateRectRgn(Rect.Left, Rect.Top, Rect.Right + 1, Rect.Bottom + 1);
    end
    else
    begin
      RoundRgn := CreateRoundRectRgn(Rect.Left, Rect.Top, Rect.Right +2, Rect.Bottom + 2, Radius*2, Radius*2);

      if not LeftTopRound then
      begin
        TmpRgn := CreateRectRgn(Rect.Left, Rect.Top, Rect.Left + Radius, Rect.Top + Radius);
        CombineRgn(RoundRgn, RoundRgn, TmpRgn, RGN_OR);
        DeleteObject(TmpRgn);
      end;

      if not RightTopRound then
      begin
        TmpRgn := CreateRectRgn(Rect.Right - Radius + 1, Rect.Top, Rect.Right + 1, Rect.Top + Radius);
        CombineRgn(RoundRgn, RoundRgn, TmpRgn, RGN_OR);
        DeleteObject(TmpRgn);
      end;

      if not LeftBottomRound then
      begin
        TmpRgn := CreateRectRgn(Rect.Left, Rect.Bottom - Radius + 1, Rect.Left + Radius, Rect.Bottom + 1);
        CombineRgn(RoundRgn, RoundRgn, TmpRgn, RGN_OR);
        DeleteObject(TmpRgn);
      end;

      if not RightBottomRound then
      begin
        TmpRgn := CreateRectRgn(Rect.Right - Radius + 1, Rect.Bottom - Radius + 1, Rect.Right + 1, Rect.Bottom + 1);
        CombineRgn(RoundRgn, RoundRgn, TmpRgn, RGN_OR);
        DeleteObject(TmpRgn);
      end;
    end;

    if UseOrgClipRgn then
      CombineRgn(RoundRgn, RoundRgn, OrgRgn, RGN_AND);

    SelectClipRgn(ACanvas.Handle, RoundRgn);
  end;  // if Radius > 0

  ColorFrom := ColorToRGB(ColorFrom);
  ColorTo := ColorToRGB(ColorTo);

  FillGradientRectangle(ACanvas, Rect, ColorFrom, ColorTo, GradientKind);

  if Radius > 0 then
  begin
    // Restores previous ClipRgn and removes used regions
    RestoreClipRgn(ACanvas.Handle, UseOrgClipRgn, OrgRgn);
    DeleteObject(RoundRgn);
  end;
end;

class procedure TGUITools.DrawOutlinedText(ABitmap: TBitmap; x, y: Integer;
  const AText: string; TextColor, OutlineColor: TColor);
begin
  with ABitmap.Canvas do
  begin
    Brush.Style := bsClear;
    Font.Color := OutlineColor;
    TextOut(x-1, y-1, AText);
    TextOut(x, y-1, AText);
    TextOut(x+1, y-1, AText);
    TextOut(x-1, y, AText);
    TextOut(x+1, y, AText);
    TextOut(x-1, y+1, AText);
    TextOut(x, y+1, AText);
    TextOut(x+1, y+1, AText);

    Font.Color := TextColor;
    TextOut(x, y, AText);
  end;
end;

class procedure TGUITools.DrawText(ABitmap: TBitmap; x, y: Integer;
  const AText: string; TextColor: TColor; ClipRect: T2DIntRect);
var
  WinAPIClipRect: TRect;
begin
  WinAPIClipRect := ClipRect.ForWinAPI;
  with ABitmap.Canvas do
  begin
    Brush.Style := bsClear;
    Font.Color := TextColor;
    TextRect(WinAPIClipRect, x, y, AText);
  end;
end;

class procedure TGUITools.DrawFitWOutlinedText(ABitmap: TBitmap;
  x1, x2, y: Integer; const AText: string; TextColor, OutlineColor: TColor;
  Align: TAlignment);
var
  tw: Integer;
  s: string;
begin
  with ABitmap.Canvas do
  begin
    s := AText;
    tw := TextWidth(s) + 2;
    if tw <= x2 - x1 + 1 then
      case Align of
        taLeftJustify:
          TGUITools.DrawOutlinedText(ABitmap,x1, y, AText, TextColor, OutlineColor);
        taRightJustify:
          TGUITools.DrawOutlinedText(ABitmap,x2-tw+1, y, AText, TextColor, OutlineColor);
        taCenter:
          TGUITools.DrawOutlinedText(ABitmap,x1 + ((x2-x1 - tw) div 2), y, AText, TextColor, OutlineColor);
      end
    else
    begin
      while (s <> '') and (tw > x2 - x1 + 1) do
      begin
        Delete(s, Length(s), 1);
        tw := TextWidth(s + '...') + 2;
      end;
      if tw <= x2 - x1 + 1 then
        TGUITools.DrawOutlinedText(ABitmap, x1, y, s+'...', TextColor, OutlineColor);
    end;
  end;
end;

class procedure TGUITools.DrawFitWOutlinedText(ACanvas: TCanvas;
  x1, x2, y: Integer; const AText: string; TextColor, OutlineColor: TColor;
  Align: TAlignment);
var
  tw: Integer;
  s: string;
begin
  with ACanvas do
  begin
    s := AText;
    tw := TextWidth(s) + 2;
    if tw <= x2 - x1 + 1 then
      case Align of
        taLeftJustify:
          TGUITools.DrawOutlinedText(ACanvas,x1, y, AText, TextColor, OutlineColor);
        taRightJustify:
          TGUITools.DrawOutlinedText(ACanvas,x2-tw+1, y, AText, TextColor, OutlineColor);
        taCenter:
          TGUITools.DrawOutlinedText(ACanvas,x1 + (x2-x1 - tw) div 2, y, AText, TextColor, OutlineColor);
       end
    else
    begin
      while (s <> '') and (tw > x2 - x1 + 1) do
      begin
        Delete(s, Length(s), 1);
        tw := TextWidth(s + '...') + 2;
      end;
      if tw <= x2 - x1 + 1 then
        TGUITools.DrawOutlinedText(ACanvas, x1, y, s+'...', TextColor, OutlineColor);
    end;
  end;
end;

class procedure TGUITools.FillGradientRectangle(ACanvas: TCanvas;
  Rect: T2DIntRect; ColorFrom: TColor; ColorTo: TColor;
  GradientKind: TBackgroundKind);
var
  Mesh: array of GRADIENT_RECT;
  GradientVertice: array of TRIVERTEX;
  ConcaveColor: TColor;
begin
  case GradientKind of
    bkSolid:
      begin
        ACanvas.Brush.Style := bsSolid;
        ACanvas.Brush.color := ColorFrom;
        ACanvas.Fillrect(Rect.ForWinAPI);
      end;
    bkVerticalGradient, bkHorizontalGradient:
      begin
        SetLength(GradientVertice, 2);
        with GradientVertice[0] do
        begin
          x := Rect.Left;
          y := Rect.top;
          Red := GetRValue(ColorFrom) shl 8;
          Green := GetGValue(ColorFrom) shl 8;
          Blue := GetBValue(ColorFrom) shl 8;
          Alpha := 255 shl 8;
        end;
        with GradientVertice[1] do
        begin
          x := Rect.Right + 1;
          y := Rect.bottom + 1;
          Red := GetRValue(ColorTo) shl 8;
          Green := GetGValue(ColorTo) shl 8;
          Blue := GetBValue(ColorTo) shl 8;
          Alpha := 255 shl 8;
        end;
        SetLength(Mesh, 1);
        Mesh[0].UpperLeft := 0;
        Mesh[0].LowerRight := 1;
        if GradientKind = bkVerticalGradient then
          GradientFill(ACanvas.Handle, @GradientVertice[0], 2, @Mesh[0], 1, GRADIENT_FILL_RECT_V)
        else
          GradientFill(ACanvas.Handle, @GradientVertice[0], 2, @Mesh[0], 1, GRADIENT_FILL_RECT_H);
      end;
    bkConcave:
      begin
        ConcaveColor:=TColorTools.Brighten(ColorFrom, 20);
        SetLength(GradientVertice, 4);
        with GradientVertice[0] do
        begin
          x := Rect.Left;
          y := Rect.top;
          Red := GetRValue(ColorFrom) shl 8;
          Green := GetGValue(ColorFrom) shl 8;
          Blue := GetBValue(ColorFrom) shl 8;
          Alpha := 255 shl 8;
        end;
        with GradientVertice[1] do
        begin
          x := Rect.Right + 1;
          y := Rect.Top + (Rect.height) div 4;
          Red := GetRValue(ConcaveColor) shl 8;
          Green := GetGValue(ConcaveColor) shl 8;
          Blue := GetBValue(ConcaveColor) shl 8;
          Alpha := 255 shl 8;
        end;
        with GradientVertice[2] do
        begin
          x := Rect.Left;
          y := Rect.Top + (Rect.height) div 4;
          Red := GetRValue(ColorTo) shl 8;
          Green := GetGValue(ColorTo) shl 8;
          Blue := GetBValue(ColorTo) shl 8;
          Alpha := 255 shl 8;
        end;
        with GradientVertice[3] do
        begin
          x := Rect.Right + 1;
          y := Rect.bottom + 1;
          Red := GetRValue(ColorFrom) shl 8;
          Green := GetGValue(ColorFrom) shl 8;
          Blue := GetBValue(ColorFrom) shl 8;
          Alpha := 255 shl 8;
        end;
        SetLength(Mesh, 2);
        Mesh[0].UpperLeft := 0;
        Mesh[0].LowerRight := 1;
        Mesh[1].UpperLeft := 2;
        Mesh[1].LowerRight := 3;
        GradientFill(ACanvas.Handle, @GradientVertice[0], 4, @Mesh[0], 2, GRADIENT_FILL_RECT_V);
      end;
  end;
end;

class procedure TGUITools.DrawFitWText(ACanvas: TCanvas; x1, x2, y: Integer;
  const AText: string; TextColor: TColor; Align: TAlignment);
var
  tw: Integer;
  s: string;
begin
  with ACanvas do
  begin
    Font.Color := TextColor;
    s := AText;
    tw := TextWidth(s);
    // We draw if the text is changed
    if tw <= x2 - x1 + 1 then
      case Align of
        taLeftJustify : TextOut(x1, y, AText);
        taRightJustify: TextOut(x2-tw+1, y, AText);
        taCenter      : TextOut(x1 + (x2-x1 - tw) div 2, y, AText);
      end
    else
    begin
      while (s <> '') and (tw > x2 - x1 + 1) do
      begin
        Delete(s, Length(s), 1);
        tw := TextWidth(s + '...');
      end;
      if tw <= x2 - x1 + 1 then
        TextOut(x1, y, s + '...');
    end;
  end;
end;

class procedure TGUITools.RenderBackground(ABuffer: TBitmap;
  Rect: T2DIntRect; Color1, Color2: TColor; BackgroundKind: TBackgroundKind);
var
  TempRect: T2DIntRect;
begin
  if ABuffer.PixelFormat<>pf24bit then
    raise Exception.Create('TGUITools.RenderBackground: Only 24-bit bitmaps are accepted');

  if (Rect.Left > Rect.Right) or (Rect.Top > Rect.Bottom) then
    Exit;

  // Both the FillRect method and the WinAPI gradient drawing are
  // protected from drawing outside the canvas area.
  case BackgroundKind of
    bkSolid:
      begin
        ABuffer.Canvas.Brush.Color := Color1;
        ABuffer.Canvas.Brush.Style := bsSolid;
        ABuffer.Canvas.FillRect(Rect.ForWinAPI);
      end;
    bkVerticalGradient:
      TGradientTools.VGradient(ABuffer.Canvas, Color1, Color2, Rect.ForWinAPI);
    bkHorizontalGradient:
      TGradientTools.HGradient(ABuffer.Canvas, Color1, Color2, Rect.ForWinAPI);
   bkConcave:
     begin
       TempRect := T2DIntRect.Create(
         Rect.Left, Rect.Top, Rect.Right, Rect.Top + (Rect.Bottom - Rect.Top) div 4
       );
       TGradientTools.VGradient(ABuffer.Canvas, Color1, TColorTools.Shade(Color1, Color2, 20), TempRect.ForWinAPI);
       TempRect := T2DIntRect.Create(
         Rect.Left, Rect.Top + (Rect.Bottom - Rect.Top) div 4 + 1, Rect.Right, Rect.Bottom
       );
       TGradientTools.VGradient(ABuffer.Canvas, Color2, Color1, TempRect.ForWinAPI);
     end;
  end;  // case
end;

class procedure TGUITools.RestoreClipRgn(DC: HDC; OrgRgnExists: boolean;
  var OrgRgn: HRGN);
begin
  if OrgRgnExists then
    SelectClipRgn(DC, OrgRgn) else
    SelectClipRgn(DC, 0);
  DeleteObject(OrgRgn);
end;

class procedure TGUITools.SaveClipRgn(DC: HDC; out OrgRgnExists: boolean;
  out OrgRgn: HRGN);
var
  i: Integer;
begin
  OrgRgn := CreateRectRgn(0, 0, 1, 1);
  i := GetClipRgn(DC, OrgRgn);
  OrgRgnExists := (i=1);
end;

class procedure TGUITools.DrawText(ABitmap: TBitmap; x, y: Integer; const AText: string;
  TextColor: TColor);
begin
  with ABitmap.Canvas do
  begin
    Brush.Style := bsClear;
    Font.Color:= TextColor;
    TextOut(x, y, AText);
  end;
end;

class procedure TGUITools.DrawVLine(ABitmap: TBitmap; x, y1, y2: Integer;
  Color: TColor);
var
  LineRect: T2DIntRect;
  BitmapRect: T2DIntRect;
begin
  if ABitmap.PixelFormat <> pf24bit then
    raise Exception.Create('TGUITools.DrawHLine: Only 24-bit bitmaps are accepted!');

  EnsureOrder(y1, y2);

  BitmapRect := T2DIntRect.Create(0, 0, ABitmap.Width-1, ABitmap.Height-1);
  if not (BitmapRect.IntersectsWith(T2DIntRect.Create(x, y1, x, y2), LineRect)) then
    exit;

  ABitmap.Canvas.Pen.color := Color;
  ABitmap.Canvas.Pen.style := psSolid;
  ABitmap.Canvas.Moveto(LineRect.Left, LineRect.Top);
  ABitmap.Canvas.Lineto(LineRect.Left, Linerect.Bottom+1);
end;

class procedure TGUITools.DrawVLine(ABitmap: TBitmap; x, y1, y2: Integer;
  Color: TColor; ClipRect: T2DIntRect);
var
  OrgLineRect: T2DIntRect;
  LineRect: T2DIntRect;
  BitmapRect: T2DIntRect;
begin
  if ABitmap.PixelFormat <> pf24bit then
    raise Exception.Create('TGUITools.DrawHLine: Only 24-bit bitmaps are accepted!');

  EnsureOrder(y1, y2);

  BitmapRect := T2DIntRect.Create(0, 0, ABitmap.Width-1, ABitmap.Height-1);
  if not(BitmapRect.IntersectsWith(T2DIntRect.Create(x, y1, x, y2), OrgLineRect)) then
    Exit;

  if not(OrgLineRect.IntersectsWith(ClipRect, LineRect)) then
    Exit;

  ABitmap.Canvas.Pen.Color := Color;
  ABitmap.Canvas.Pen.Style := psSolid;
  ABitmap.Canvas.Moveto(LineRect.Left, LineRect.Top);
  ABitmap.Canvas.Lineto(LineRect.Left, Linerect.Bottom+1);
end;

class procedure TGUITools.DrawVLine(ACanvas: TCanvas; x, y1, y2: Integer;
  Color: TColor);
begin
  EnsureOrder(y1, y2);
  ACanvas.Pen.Color := Color;
  ACanvas.Moveto(x, y1);
  ACanvas.Lineto(x, y2+1);
end;

class procedure TGUITools.DrawVLine(ACanvas: TCanvas; x, y1, y2: Integer;
  Color: TColor; ClipRect: T2DIntRect);
var
  UseOrgClipRgn: boolean;
  ClipRgn: HRGN;
  OrgRgn: HRGN;
begin
  // Store the original ClipRgn and set a new one
  SaveClipRgn(ACanvas.Handle, UseOrgClipRgn, OrgRgn);

  ClipRgn := CreateRectRgn(ClipRect.Left, ClipRect.Top, ClipRect.Right+1, ClipRect.Bottom+1);
  if UseOrgClipRgn then
    CombineRgn(ClipRgn, ClipRgn, OrgRgn, RGN_AND);

  SelectClipRgn(ACanvas.Handle, ClipRgn);

  DrawVLine(ACanvas, x, y1, y2, Color);

  // Restores previous ClipRgn and removes used regions
  RestoreClipRgn(ACanvas.Handle, UseOrgClipRgn, OrgRgn);
  DeleteObject(ClipRgn);
end;

class procedure TGUITools.DrawAARoundFrame(ACanvas: TCanvas; Rect: T2DIntRect;
  Radius: Integer; Color: TColor);
begin
  if Radius < 1 then
    Exit;

  if (Radius > Rect.Width div 2) or (Radius > Rect.Height div 2) then
    Exit;

  // DrawAARoundCorner is protected against drawing outside the area
  DrawAARoundCorner(ACanvas, T2DIntVector.create(Rect.Left, Rect.Top), Radius, cpLeftTop, Color);
  DrawAARoundCorner(ACanvas, T2DIntVector.create(Rect.Right - Radius + 1, Rect.Top), Radius, cpRightTop, Color);
  DrawAARoundCorner(ACanvas, T2DIntVector.create(Rect.Left, Rect.Bottom - Radius + 1), Radius, cpLeftBottom, Color);
  DrawAARoundCorner(ACanvas, T2DIntVector.create(Rect.Right - Radius + 1, Rect.Bottom - Radius + 1), Radius, cpRightBottom, Color);

  ACanvas.Pen.color := Color;
  ACanvas.pen.style := psSolid;

  // Draw * Line is protected against drawing outside the area
  DrawVLine(ACanvas, Rect.Left, Rect.Top + Radius, Rect.Bottom - Radius, Color);
  DrawVLine(ACanvas, Rect.Right, Rect.Top + Radius, Rect.Bottom - Radius, Color);
  DrawHLine(ACanvas, Rect.Left + Radius, Rect.Right - Radius, Rect.Top, Color);
  DrawHLine(ACanvas, Rect.Left + Radius, Rect.Right - Radius, Rect.Bottom, Color);
end;

class procedure TGUITools.DrawAARoundFrame(ACanvas: TCanvas; Rect: T2DIntRect;
  Radius: Integer; Color: TColor; ClipRect: T2DIntRect);
var
  UseOrgClipRgn: boolean;
  ClipRgn: HRGN;
  OrgRgn: HRGN;
begin
  // Store the original ClipRgn and set a new one
  SaveClipRgn(ACanvas.Handle, UseOrgClipRgn, OrgRgn);

  ClipRgn := CreateRectRgn(ClipRect.Left, ClipRect.Top, ClipRect.Right+1, ClipRect.Bottom+1);
  if UseOrgClipRgn then
    CombineRgn(ClipRgn, ClipRgn, OrgRgn, RGN_AND);

  SelectClipRgn(ACanvas.Handle, ClipRgn);

  DrawAARoundFrame(ACanvas, Rect, Radius, Color);

  // Restores previous ClipRgn and removes used regions
  RestoreClipRgn(ACanvas.Handle, UseOrgClipRgn, OrgRgn);
  DeleteObject(ClipRgn);
end;

class procedure TGUITools.DrawButton(Bitmap: TBitmap; Rect: T2DIntRect; FrameColor, InnerLightColor, InnerDarkColor,
  GradientFrom, GradientTo: TColor; GradientKind: TBackgroundKind; LeftEdgeOpen, RightEdgeOpen, TopEdgeOpen,
  BottomEdgeOpen: boolean; Radius: Integer; ClipRect: T2DIntRect);
var
  x1, x2, y1, y2: Integer;
  LeftClosed, TopClosed, RightClosed, BottomClosed: byte;
begin
  if (Rect.Width < 6) or (Rect.Height < 6) or
    (Rect.Width < 2*Radius) or (Rect.Height < 2*Radius) then exit;

  if LeftEdgeOpen then LeftClosed := 0 else LeftClosed := 1;
  if RightEdgeOpen then RightClosed := 0 else RightClosed := 1;
  if TopEdgeOpen then TopClosed := 0 else TopClosed := 1;
  if BottomEdgeOpen then BottomClosed := 0 else BottomClosed := 1;

  TGuiTools.DrawRoundRect(
    Bitmap.Canvas,
    Rect,
    Radius,
    GradientFrom,
    GradientTo,
    GradientKind,
    ClipRect,
    not (LeftEdgeOpen or TopEdgeOpen),
    not (RightEdgeOpen or TopEdgeOpen),
    not (LeftEdgeOpen or BottomEdgeOpen),
    not (RightEdgeOpen or BottomEdgeOpen)
  );

  // Inner edge
  // *** Top ***
  x1 := Rect.Left + radius * TopClosed * LeftClosed + LeftClosed;
  x2 := Rect.Right - radius * TopClosed * RightClosed - RightClosed;
  y1 := Rect.Top + TopClosed;
  TGuiTools.DrawHLine(Bitmap, x1, x2, y1, InnerLightColor, ClipRect);

  // *** Bottom ***
  x1 := Rect.Left + radius * BottomClosed * LeftClosed + LeftClosed;
  x2 := Rect.Right - radius * BottomClosed * RightClosed - RightClosed;
  y1 := Rect.Bottom - BottomClosed;
  if BottomEdgeOpen then
    TGuiTools.DrawHLine(Bitmap, x1, x2, y1, InnerDarkColor, ClipRect)
  else
    TGuiTools.DrawHLine(Bitmap, x1, x2, y1, InnerLightColor, ClipRect);

  // *** Left ***
  y1 := Rect.Top + Radius * LeftClosed * TopClosed + TopClosed;
  y2 := Rect.Bottom - Radius * LeftClosed * BottomClosed - BottomClosed;
  x1 := Rect.Left + LeftClosed;
  TGuiTools.DrawVLine(Bitmap, x1, y1, y2, InnerLightColor, ClipRect);

  // *** Right ***
  y1 := Rect.Top + Radius * RightClosed * TopClosed + TopClosed;
  y2 := Rect.Bottom - Radius * RightClosed * BottomClosed - BottomClosed;
  x1 := Rect.Right - RightClosed;
  if RightEdgeOpen then
    TGuiTools.DrawVLine(Bitmap, x1, y1, y2, InnerDarkColor, ClipRect)
  else
    TGuiTools.DrawVLine(Bitmap, x1, y1, y2, InnerLightColor, ClipRect);

  // Rounded corners
  if not(LeftEdgeOpen or TopEdgeOpen) then
    TGuiTools.DrawAARoundCorner(
      Bitmap,
      T2DIntPoint.create(Rect.left + 1, Rect.Top + 1),
      Radius,
      cpLeftTop,
      InnerLightColor,
      ClipRect
    );
  if not(RightEdgeOpen or TopEdgeOpen) then
    TGuiTools.DrawAARoundCorner(
      Bitmap,
      T2DIntPoint.Create(Rect.right - radius, Rect.Top + 1),
      Radius,
      cpRightTop,
      InnerLightColor,
      ClipRect
    );
  if not(LeftEdgeOpen or BottomEdgeOpen) then
    TGuiTools.DrawAARoundCorner(
      Bitmap,
      T2DIntPoint.create(Rect.left + 1, Rect.bottom - Radius),
      Radius,
      cpLeftBottom,
      InnerLightColor,
      ClipRect
    );
  if not(RightEdgeOpen or BottomEdgeOpen) then
    TGuiTools.DrawAARoundCorner(
      Bitmap,
      T2DIntPoint.create(Rect.right - Radius, Rect.bottom - Radius),
      Radius,
      cpRightBottom,
      InnerLightColor,
      ClipRect
    );

  // Outer edge
  // Rounded corners
  if not TopEdgeOpen then
  begin
    x1 := Rect.Left + Radius * LeftClosed;
    x2 := Rect.Right - Radius * RightClosed;
    y1 := Rect.Top;
    TGuiTools.DrawHLine(Bitmap, x1, x2, y1, FrameColor, ClipRect);
  end;

  if not BottomEdgeOpen then
  begin
    x1 := Rect.Left + Radius * LeftClosed;
    x2 := Rect.Right - Radius * RightClosed;
    y1 := Rect.Bottom;
    TGuiTools.DrawHLine(Bitmap, x1, x2, y1, FrameColor, ClipRect);
  end;

  if not LeftEdgeOpen then
  begin
    y1 := Rect.Top + Radius * TopClosed;
    y2 := Rect.Bottom - Radius * BottomClosed;
    x1 := Rect.Left;
    TGuiTools.DrawVLine(Bitmap, x1, y1, y2, FrameColor, ClipRect);
  end;

  if not(RightEdgeOpen) then
  begin
    y1 := Rect.Top + Radius * TopClosed;
    y2 := Rect.Bottom - Radius * BottomClosed;
    x1 := Rect.Right;
    TGuiTools.DrawVLine(Bitmap, x1, y1, y2, FrameColor, ClipRect);
  end;

  if not(LeftEdgeOpen or TopEdgeOpen) then
    TGuiTools.DrawAARoundCorner(
      Bitmap,
      T2DIntPoint.create(Rect.left, Rect.Top),
      Radius,
      cpLeftTop,
      FrameColor,
      ClipRect
    );

  if not(RightEdgeOpen or TopEdgeOpen) then
    TGuiTools.DrawAARoundCorner(
      Bitmap,
      T2DIntPoint.create(Rect.right - radius + 1, Rect.Top),
      Radius,
      cpRightTop,
      FrameColor,
      ClipRect
    );

  if not(LeftEdgeOpen or BottomEdgeOpen) then
    TGuiTools.DrawAARoundCorner(
      Bitmap,
      T2DIntPoint.create(Rect.left, Rect.bottom - radius + 1),
      Radius,
      cpLeftBottom,
      FrameColor,
      ClipRect
    );

  if not(RightEdgeOpen or BottomEdgeOpen) then
    TGuiTools.DrawAARoundCorner(
      Bitmap,
      T2DIntPoint.create(Rect.right - radius + 1, Rect.bottom - radius + 1),
      Radius,
      cpRightBottom,
      FrameColor,
      ClipRect
    );
end;

class procedure TGUITools.DrawDisabledImage(ABitmap: TBitmap;
  Imagelist: TImageList; ImageIndex: Integer; Point: T2DIntVector;
  ClipRect: T2DIntRect);
begin
  DrawDisabledImage(ABitmap.Canvas, ImageList, ImageIndex, Point, ClipRect);
end;

class procedure TGUITools.DrawDisabledImage(ABitmap: TBitmap;
  Imagelist: TImageList; ImageIndex: Integer; Point: T2DIntVector);
begin
  DrawDisabledImage(ABitmap.Canvas, ImageList, ImageIndex, Point);
end;

class procedure TGUITools.DrawDisabledImage(ACanvas: TCanvas;
  Imagelist: TImageList; ImageIndex: Integer; Point: T2DIntVector;
  ClipRect: T2DIntRect);
var
  UseOrgClipRgn: Boolean;
  OrgRgn: HRGN;
  ClipRgn: HRGN;
  DCStackPos: Integer;
begin
  // Store the original ClipRgn and set a new one
  SaveClipRgn(ACanvas.Handle, UseOrgClipRgn, OrgRgn);

  ClipRgn := CreateRectRgn(ClipRect.Left, ClipRect.Top, ClipRect.Right+1, ClipRect.Bottom+1);
  if UseOrgClipRgn then
    CombineRgn(ClipRgn, ClipRgn, OrgRgn, RGN_AND);

  SelectClipRgn(ACanvas.Handle, ClipRgn);

  // Hack fixes the bug in ImageList.Draw which does not restore the previous one  /???
  // Font color for canvas
  DcStackPos := SaveDC(ACanvas.Handle);
  ImageList.Draw(ACanvas, Point.x, Point.y, ImageIndex, false);
  RestoreDC(ACanvas.Handle, DcStackPos);

  RestoreClipRgn(ACanvas.Handle, UseOrgClipRgn, OrgRgn);

  DeleteObject(ClipRgn);
end;

class procedure TGUITools.DrawDisabledImage(ACanvas: TCanvas;
  Imagelist: TImageList; ImageIndex: Integer; Point: T2DIntVector);
var
  DCStackPos: Integer;
begin
  //todo: see if is necessary to save the DC
  DcStackPos := SaveDC(ACanvas.Handle);
  ImageList.Draw(ACanvas, Point.x, Point.y, ImageIndex, false);
  RestoreDC(ACanvas.Handle, DcStackPos);
end;

class procedure TGUITools.DrawCheckbox(ACanvas:TCanvas; x,y: Integer;
  AState: TCheckboxState; AButtonState:TSpkButtonState;
  AStyle: TSpkCheckboxStyle; ClipRect:T2DIntRect);
var
  UseOrgClipRgn: Boolean;
  OrgRgn: HRGN;
  ClipRgn: HRGN;
begin
  SaveClipRgn(ACanvas.Handle, UseOrgClipRgn, OrgRgn);
  ClipRgn := CreateRectRgn(ClipRect.Left, ClipRect.Top, ClipRect.Right+1, ClipRect.Bottom+1);
  if UseOrgClipRgn then
    CombineRgn(ClipRgn, ClipRgn, OrgRgn, RGN_AND);
  SelectClipRgn(ACanvas.Handle, ClipRgn);
  DrawCheckbox(ACanvas, x,y, AState, AButtonState, AStyle);
  RestoreClipRgn(ACanvas.Handle, UseOrgClipRgn, OrgRgn);
  DeleteObject(ClipRgn);
end;

class procedure TGUITools.DrawCheckbox(ACanvas: TCanvas; x,y: Integer;
  AState: TCheckboxState; AButtonState: TSpkButtonState;
  AStyle: TSpkCheckboxStyle);
const
  NOT_USED = tbCheckboxCheckedNormal;
const
  UNTHEMED_FLAGS: array [TSpkCheckboxStyle, TCheckboxState] of Integer = (
    (DFCS_BUTTONCHECK, DFCS_BUTTONCHECK or DFCS_CHECKED, DFCS_BUTTONCHECK or DFCS_BUTTON3STATE),
    (DFCS_BUTTONRADIO, DFCS_BUTTONRADIO or DFCS_CHECKED, DFCS_BUTTONRADIO or DFCS_BUTTON3STATE)
  );
  THEMED_FLAGS: array [TSpkCheckboxStyle, TCheckboxState, TSpkButtonState] of TThemedButton = (
    ( (tbCheckboxUncheckedNormal, tbCheckboxUncheckedHot, tbCheckboxUncheckedPressed, tbCheckboxUncheckedDisabled, NOT_USED),
      (tbCheckboxCheckedNormal, tbCheckboxCheckedHot, tbCheckboxCheckedPressed, tbCheckboxCheckedDisabled, NOT_USED),
      (tbCheckboxMixedNormal, tbCheckboxMixedHot, tbCheckboxMixedPressed, tbCheckboxMixedDisabled, NOT_USED)
    ),
    ( (tbRadioButtonUncheckedNormal, tbRadioButtonUncheckedHot, tbRadioButtonUncheckedPressed, tbRadioButtonUncheckedDisabled, NOT_USED),
      (tbRadioButtonCheckedNormal, tbRadioButtonCheckedHot, tbRadioButtonCheckedPressed, tbRadioButtonCheckedDisabled, NOT_USED),
      (tbRadioButtonCheckedNormal, tbRadioButtonCheckedHot, tbRadioButtonCheckedPressed, tbRadioButtonCheckedDisabled, NOT_USED)
    )
  );
var
  R: TRect;
  w: Integer;
  sz: TSize;
  te: TThemedElementDetails;
begin
  if ThemeServices.ThemesEnabled then begin
    te := ThemeServices.GetElementDetails(THEMED_FLAGS[AStyle, AState, AButtonState]);
    sz := TSize.Create(13, 13); //TODO: ThemeServices.GetDetailSize(te);
    R := Bounds(x, y, sz.cx, sz.cy);
    InflateRect(R, 1, 1);
    ThemeServices.DrawElement(ACanvas.Handle, te, R);
  end else begin
    w := GetSystemMetrics(SM_CYMENUCHECK);
    R := Bounds(x, y, w, w);
    DrawFrameControl(
      ACanvas.Handle, R, DFC_BUTTON, UNTHEMED_FLAGS[AStyle, AState]);
  end;
end;

end.
