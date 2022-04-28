unit SpkGraphTools;

interface

{$I Spk.inc}

uses
  Windows,
  Graphics,
  Classes,
  Math,
  Sysutils,
  SpkMath;

const
  NUM_ZERO = 0.00000001;

type
  PRGBTripleArray = ^TRGBTripleArray;
  TRGBTripleArray = array[word] of TRGBTriple;
  THSLTriple = record
    H, S, L: extended;
  end;

  TGradientType = (
    gtVertical,
    gtHorizontal
  );

  TGradientLineShade = (
    lsShadeStart,
    lsShadeEnds,
    lsShadeCenter,
    lsShadeEnd
  );

  TGradient3dLine = (
    glRaised,
    glLowered
  );

  /// <summary>
  ///
  /// </summary>
  TColorTools = class
  public
    class function Darken(AColor: TColor; APercentage: byte): TColor;
    class function Brighten(AColor: TColor; APercentage: Integer): TColor;
    class function Shade(AColor1, AColor2: TColor; APercentage: Integer): TColor; overload;
    class function Shade(AColor1, AColor2: TColor; AStep: extended): TColor; overload;
    class function AddColors(AColor1, AColor2: TColor): TColor;
    class function MultiplyColors(AColor1, AColor2: TColor): TColor;
    class function MultiplyColor(AColor: TColor; AScalar: integer): TColor; overload;
    class function MultiplyColor(AColor: TColor; AScalar: extended): TColor; overload;
    class function percent(AMin, APos, AMax: integer): byte;
    class function RGB2HSL(ARGB: TRGBTriple): THSLTriple;
    class function HSL2RGB(AHSL: THSLTriple): TRGBTriple;
    class function RgbTripleToColor(ARgbTriple: TRGBTriple): TColor;
    class function ColorToRgbTriple(AColor: TColor): TRGBTriple;
    class function ColorToGrayscale(AColor: TColor): TColor;
  end;

  /// <summary>
  ///
  /// </summary>
  TGradientTools = class
  public
    class procedure HGradient(ACanvas: TCanvas; cStart,cEnd: TColor; ARect: T2DIntRect); overload;
    class procedure HGradient(ACanvas: TCanvas; cStart,cEnd: TColor; p1, p2: TPoint); overload;
    class procedure HGradient(ACanvas: TCanvas; cStart,cEnd: TColor; x1,y1,x2,y2: integer); overload;

    class procedure VGradient(ACanvas: TCanvas; cStart,cEnd: TColor; ARect: T2DIntRect); overload;
    class procedure VGradient(ACanvas: TCanvas; cStart,cEnd: TColor; p1, p2: TPoint); overload;
    class procedure VGradient(ACanvas: TCanvas; cStart,cEnd: TColor; x1,y1,x2,y2: integer); overload;

    class procedure Gradient(ACanvas: TCanvas; cStart,cEnd: TColor; ARect: T2DIntRect; AGradientType : TGradientType); overload;
    class procedure Gradient(ACanvas: TCanvas; cStart,cEnd: TColor; p1, p2: TPoint; AGradientType : TGradientType); overload;
    class procedure Gradient(ACanvas: TCanvas; cStart,cEnd: TColor; x1,y1,x2,y2: integer; AGradientType : TGradientType); overload;

    class procedure HGradientLine(ACanvas: TCanvas; cBase, cShade: TColor; x1, x2, y: integer; ShadeMode: TGradientLineShade);
    class procedure VGradientLine(ACanvas: TCanvas; cBase, cShade: TColor; x, y1, y2: integer; ShadeMode: TGradientLineShade);

    class procedure HGradient3dLine(ACanvas: TCanvas; x1,x2,y: integer; ShadeMode: TGradientLineShade; A3dKind: TGradient3dLine = glLowered);
    class procedure VGradient3dLine(ACanvas: TCanvas; x,y1,y2: integer; ShadeMode: TGradientLineShade; A3dKind: TGradient3dLine = glLowered);
  end;

  TTextTools = class
  public
    class procedure OutlinedText(ACanvas: TCanvas; x, y: integer; const AText: string);
  end;

implementation

{$IFNDEF FPC}
uses
  GraphUtil;
{$ENDIF}

type
  TRgbColor = packed record
    R,G,B,A: Byte;
  end;

{ TColorTools }

class function TColorTools.Darken(AColor: TColor; APercentage: byte): TColor;
var
  c: TRGBColor;
  f: extended;
begin
  c := TRGBColor(ColorToRGB(AColor));
  f := (100 - APercentage) / 100;
  result := rgb(
    round(c.R * f),
    round(c.G * f),
    round(c.B * f)
  );
end;

class function TColorTools.Brighten(AColor: TColor; APercentage: Integer): TColor;
var
  c: TRgbColor;
  p: Extended;
begin
  c := TRgbColor(ColorToRGB(AColor));
  p := APercentage/100;
  result := rgb(
    EnsureRange(round(c.R + (255-c.R)*p), 0, 255),
    EnsureRange(round(c.G + (255-c.G)*p), 0, 255),
    EnsureRange(round(c.B + (255-c.B)*p), 0, 255)
  );
end;

class function TColorTools.Shade(AColor1, AColor2: TColor;
  APercentage: Integer): TColor;
var
  c1, c2: TRgbColor;
  Step: Extended;  // percentage as floating point number
begin
  c1 := TRGBColor(ColorToRGB(AColor1));
  c2 := TRGBColor(ColorToRGB(AColor2));
  Step := APercentage / 100;
  result := rgb(
    EnsureRange(round(c1.R + (c2.R - c1.R) * Step), 0, 255),
    EnsureRange(round(c1.G + (c2.G - c1.G) * Step), 0, 255),
    EnsureRange(round(c1.B + (c2.B - c1.B) * Step), 0, 255)
  );
end;

class function TColorTools.Shade(AColor1, AColor2: TColor; AStep: extended): TColor;
var
  c1, c2: TRgbColor;
begin
  c1 := TRgbColor(ColorToRGB(AColor1));
  c2 := TRgbColor(ColorToRGB(AColor2));
  result := rgb(
    round(c1.R + (c2.R - c1.R) * AStep),
    round(c1.G + (c2.G - c1.G) * AStep),
    round(c1.B + (c2.B - c1.B) * AStep)
  );
end;

class function TColorTools.AddColors(AColor1, AColor2: TColor): TColor;
var
  c1, c2: TRgbColor;
begin
  c1 := TRgbColor(ColorToRGB(AColor1));
  c2 := TRgbColor(ColorToRGB(AColor2));
  result := rgb(
    max(0, min(255, Integer(c1.R) + c2.R)),
    max(0, min(255, Integer(c1.G) + c2.G)),
    max(0, min(255, Integer(c1.B) + c2.B))
  );
end;

class function TColorTools.MultiplyColors(AColor1, AColor2: TColor): TColor;
var
  c1, c2: TRgbColor;
begin
  c1 := TRgbColor(ColorToRGB(AColor1));
  c2 := TRgbColor(ColorToRGB(AColor2));
  result := rgb(
    max(0, min(255, Integer(c1.R) * c2.R)),
    max(0, min(255, Integer(c1.G) * c2.G)),
    max(0, min(255, Integer(c1.B) * c2.B))
  );
end;

class function TColorTools.MultiplyColor(AColor: TColor; AScalar: integer): TColor;
var
  c: TRgbColor;
begin
  c := TRgbColor(ColorToRGB(AColor));
  result := rgb(
    max(0, min(255, AScalar * c.R)),
    max(0, min(255, AScalar * c.G)),
    max(0, min(255, AScalar * c.B))
  );
end;

class function TColorTools.MultiplyColor(AColor: TColor; AScalar: extended): TColor;
var
  c: TRgbColor;
begin
  c := TRgbColor(ColorToRGB(AColor));
  result := rgb(
    max(0, min(255, round(c.R * AScalar))),
    max(0, min(255, round(c.G * AScalar))),
    max(0, min(255, round(c.B * AScalar)))
  );
end;

class function TColorTools.Percent(AMin, APos, AMax: integer): byte;
begin
  if AMax = AMin then
    result := AMax    // wp: is this correct? Shouldn't this be a value between a and 100?
  else
    result := round((APos - AMin) * 100 / (AMax - AMin));
end;

{.$MESSAGE WARN 'Comparing real numbers? This has to be corrected.'}
class function TColorTools.RGB2HSL(ARGB: TRGBTriple): THSLTriple;
var
  RGBmin, RGBmax, RGBrange: extended;
  R, G, B: extended;
  H, S, L: extended;
begin
  R := ARGB.rgbtRed/255;
  G := ARGB.rgbtGreen/255;
  B := ARGB.rgbtBlue/255;

  RGBmin := min(R, min(G, B));
  RGBmax := max(R, min(G, B));
  RGBrange := RGBmax - RGBmin;

  H := 0;
  if RGBmax = RGBmin then
    H := 0
  else
  if (R = RGBmax) and (G >= B) then
    H := pi/3 * (G-B) / RGBrange + 0
  else
  if (R = RGBmax) and (G < B) then
    H := pi/3 * (G-B) / RGBrange + 2*pi
  else
  if (G = RGBmax) then
    H := pi/3 * (B-R) / RGBrange + 2*pi/3
  else
  if (B = RGBmax) then
    H := pi/3 * (R-G) / RGBrange + 4*pi/3;

  L := RGBrange / 2;

  S:=0;
  if (L < NUM_ZERO) or (rgbMin = rgbMax) then
    S := 0
  else
  if (L <= 0.5) then
    S := RGBrange / (2*L)
  else
  if (L > 0.5) then
    S := RGBrange / (2-2*L);

  result.H := H / (2*pi);
  result.S := S;
  result.L := L;
end;

class function TColorTools.HSL2RGB(AHSL: THSLTriple): TRGBTriple;
var
  R, G, B: extended;
  TR, TG, TB: extended;
  Q, P: extended;

  function ProcessColor(c: extended): extended;
  begin
    if (c < 1/6) then
      result := P + (Q - P) * 6.0 * c
    else
    if (c < 1/2) then
      result := Q
    else
    if (c < 2/3) then
      result := P + (Q - P) * (2/3 - c) * 6.0
    else
      result := P;
  end;

begin
  if AHSL.S < NUM_ZERO then
  begin
    R := AHSL.L;
    G := AHSL.L;
    B := AHSL.L;
  end else
  begin
    if (AHSL.L < 0.5) then
      Q := AHSL.L * (AHSL.S + 1.0)
    else
      Q := AHSL.L + AHSL.S - AHSL.L*AHSL.S;

    P := 2.0*AHSL.L - Q;

    TR := AHSL.H + 1/3;
    TG := AHSL.H;
    TB := AHSL.H - 1/3;

    if (TR < 0) then
      TR := TR + 1
    else
    if (TR > 1) then
      TR := TR - 1;

    if (TG < 0) then
      TG := TG + 1
    else
    if (TG > 1) then
      TG := TG - 1;

    if (TB < 0) then
      TB := TB + 1
    else
    if (TB > 1) then
      TB := TB - 1;

    R := ProcessColor(TR);
    G := ProcessColor(TG);
    B := ProcessColor(TB);
  end;

  result.rgbtRed   := round(255*R);
  result.rgbtGreen := round(255*G);
  result.rgbtBlue  := round(255*B);
end;

class function TColorTools.RgbTripleToColor(ARgbTriple: TRGBTriple) : TColor;
begin
  result := rgb(
    ARgbTriple.rgbtRed,
    ARgbTriple.rgbtGreen,
    ARgbTriple.rgbtBlue
  );
end;

class function TColorTools.ColorToGrayscale(AColor: TColor): TColor;
var
  c: TRgbColor;
  avg : byte;
begin
  c := TRgbColor(ColorToRGB(AColor));
  avg := (c.R + c.G + c.B) div 3;
  result := rgb(avg, avg, avg);
end;

class function TColorTools.ColorToRgbTriple(AColor: TColor): TRGBTriple;
var
  c: TRgbColor;
begin
  c := TRgbColor(ColorToRGB(AColor));
  result.rgbtRed   := c.R;
  result.rgbtGreen := c.G;
  result.rgbtBlue  := c.B;
end;


{ TGradientTools }

class procedure TGradientTools.HGradient(ACanvas: TCanvas; cStart, cEnd: TColor;
  ARect: T2DIntRect);
begin
{$IFDEF FPC}
  ACanvas.GradientFill(ARect.ForWinAPI,cStart, cEnd, gdHorizontal);
{$ELSE}
  GradientFillCanvas(ACanvas, cStart, cEnd, ARect.ForWinAPI, gdHorizontal);
{$ENDIF}
end;

class procedure TGradientTools.HGradient(ACanvas: TCanvas; cStart, cEnd: TColor;
  p1, p2: TPoint);
begin
  HGradient(ACanvas, cStart, cEnd, rect(p1.x,p1.y,p2.x,p2.y));
end;

class procedure TGradientTools.HGradient(ACanvas: TCanvas; cStart, cEnd: TColor;
  x1,y1,x2,y2: integer);
begin
  HGradient(ACanvas, cStart, cEnd, rect(x1,y1,x2,y2));
end;

class procedure TGradientTools.VGradient(ACanvas: TCanvas; cStart, cEnd: TColor;
  ARect: T2DIntRect);
begin
{$IFDEF FPC}
  ACanvas.GradientFill(ARect.ForWinAPI, cStart, cEnd, gdVertical);
{$ELSE}
  GradientFillCanvas(ACanvas, cStart, cEnd, ARect.ForWinAPI, gdVertical);
{$ENDIF}
end;

class procedure TGradientTools.VGradient(ACanvas: TCanvas; cStart, cEnd: TColor;
  p1, p2: TPoint);
begin
  VGradient(ACanvas, cStart, cEnd, rect(p1.x,p1.y,p2.x,p2.y));
end;

class procedure TGradientTools.VGradient(ACanvas: TCanvas; cStart, cEnd: TColor;
  x1,y1,x2,y2: integer);
begin
  VGradient(ACanvas, cStart, cEnd, rect(x1,y1,x2,y2));
end;

class procedure TGradientTools.Gradient(ACanvas: TCanvas; cStart, cEnd: TColor;
  ARect: T2DIntRect; AGradientType: TGradientType);
begin
  if AGradientType = gtVertical then
    VGradient(ACanvas, cStart, cEnd, ARect)
  else
    HGradient(ACanvas, cStart, cEnd, ARect);
end;

class procedure TGradientTools.Gradient(ACanvas: TCanvas; cStart, cEnd: TColor;
  p1, p2: TPoint; AGradientType: TGradientType);
begin
  if AGradientType = gtVertical then
    VGradient(ACanvas, cStart, cEnd, p1, p2)
  else
    HGradient(ACanvas, cStart, cEnd, p1, p2);
end;

class procedure TGradientTools.Gradient(ACanvas: TCanvas; cStart, cEnd: TColor;
  x1,y1,x2,y2: integer; AGradientType: TGradientType);
begin
  if AGradientType = gtVertical then
    VGradient(ACanvas, cStart, cEnd, x1, y1, x2, y2)
  else
    HGradient(ACanvas, cStart, cEnd, x1, y1, x2, y2);
end;

class procedure TGradientTools.HGradientLine(ACanvas: TCanvas;
  cBase, cShade: TColor; x1, x2, y: integer; ShadeMode: TGradientLineShade);
var
  i: integer;
begin
  if x1 = x2 then
    Exit;

  if x1 > x2 then
  begin
    i := x1;
    x1 := x2;
    x2 := i;
  end;

  case ShadeMode of
    lsShadeStart:
      HGradient(ACanvas, cShade, cBase, rect(x1,y,x2,y+1));
    lsShadeEnds:
      begin
        i := (x1 + x2) div 2;
        HGradient(ACanvas, cShade, cBase, rect(x1,y,i,y+1));
        HGradient(ACanvas, cBase, cShade, rect(i,y,x2,y+1));
      end;
    lsShadeCenter:
      begin
        i := (x1 + x2) div 2;
        HGradient(ACanvas, cBase, cShade, rect(x1,y,i,y+1));
        HGradient(ACanvas, cShade, cBase, rect(i,y,x2,y+1));
      end;
    lsShadeEnd:
      HGradient(ACanvas,cBase,cShade,rect(x1,y,x2,y+1));
  end;
end;

class procedure TGradientTools.VGradientLine(ACanvas: TCanvas;
  cBase, cShade: TColor; x, y1, y2: integer; ShadeMode: TGradientLineShade);
var
  i : integer;
begin
  if y1 = y2 then
    Exit;

  if y1 > y2 then
  begin
    i := y1;
    y1 := y2;
    y2 := i;
  end;

  case ShadeMode of
    lsShadeStart:
      VGradient(ACanvas, cShade, cBase, rect(x,y1,x+1,y2));
    lsShadeEnds:
      begin
        i := (y1 + y2) div 2;
        VGradient(ACanvas, cShade, cBase, rect(x,y1,x+1,i));
        VGradient(ACanvas, cBase, cShade, rect(x,i,x+1,y2));
      end;
    lsShadeCenter:
      begin
        i := (y1 + y2) div 2;
        VGradient(ACanvas, cBase, cShade, rect(x,y1,x+1,i));
        VGradient(ACanvas, cShade, cBase, rect(x,i,x+1,y2));
      end;
    lsShadeEnd:
      VGradient(ACanvas, cBase, cShade, rect(x,y1,x+1,y2));
  end;
end;

class procedure TGradientTools.HGradient3dLine(ACanvas: TCanvas; x1,x2,y: integer;
  ShadeMode: TGradientLineShade; A3dKind: TGradient3dLine = glLowered);
begin
  if A3dKind = glRaised then
  begin
    HGradientLine(ACanvas, clBtnHighlight, clBtnFace, x1,x2,y, ShadeMode);
    HGradientLine(ACanvas, clBtnShadow, clBtnFace, x1,x2,y+1, ShadeMode);
  end
  else
  begin
    HGradientLine(ACanvas, clBtnShadow, clBtnFace, x1,x2,y, ShadeMode);
    HGradientLine(ACanvas, clBtnHighlight, clBtnFace, x1,x2,y+1, ShadeMode);
  end;
end;

class procedure TGradientTools.VGradient3dLine(ACanvas: TCanvas; x,y1,y2: integer;
  ShadeMode: TGradientLineShade; A3dKind: TGradient3dLine = glLowered);
begin
  if A3dKind = glLowered then
  begin
    VGradientLine(ACanvas, clBtnFace, clBtnHighlight, x,y1,y2, ShadeMode);
    VGradientLine(ACanvas, clBtnFace, clBtnShadow, x+1,y1,y2, ShadeMode);
  end
  else
  begin
    VGradientLine(ACanvas, clBtnFace, clBtnShadow, x,y1,y2, ShadeMode);
    VGradientLine(ACanvas, clBtnFace, clBtnHighlight, x+1,y1,y2, ShadeMode);
  end;
end;

{ TTextTools }

class procedure TTextTools.OutlinedText(ACanvas: TCanvas; x, y: integer; const AText: string);
var
  TmpColor: TColor;
  TmpBrushStyle: TBrushStyle;
begin
  TmpColor := ACanvas.Font.Color;
  TmpBrushStyle := ACanvas.Brush.Style;

  ACanvas.Brush.Style := bsClear;

  ACanvas.Font.Color := clBlack;
  ACanvas.TextOut(x-1, y,   AText);
  ACanvas.TextOut(x+1, y,   AText);
  ACanvas.TextOut(x,   y-1, AText);
  ACanvas.TextOut(x,   y+1, AText);

  ACanvas.Font.Color := TmpColor;
  ACanvas.TextOut(x, y, AText);

  ACanvas.Brush.Style := TmpBrushStyle;
end;

end.
