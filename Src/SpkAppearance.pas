unit SpkAppearance;

interface

{$I Spk.inc}

uses
  Windows,
  Graphics,
  Classes,
  Forms,
  SysUtils,
  IniFiles,
  SpkGUITools,
  SpkTypes;

type
  TSpkToolbarAppearance = class;

  TSpkPaneStyle = (
    psRectangleFlat,
    psRectangleEtched,
    psRectangleRaised,
    psDividerFlat,
    psDividerEtched,
    psDividerRaised
  );

  TSpkElementStyle = (esRounded, esRectangle);

  TSpkStyle = (
    spkOffice2007Blue,
    spkOffice2007Silver,
    spkOffice2007SilverTurquoise,
    spkMetroLight,
    spkMetroDark
  );

  /// <summary>
  ///
  /// </summary>
  TSpkTabAppearance = class(TPersistent)
  public
    const INI_SECTION = 'TabAppearance';
    const INI_HEADER_FONT_SECTION = INI_SECTION + '\TabHeaderFont';
  private
    fDispatch: TSpkBaseAppearanceDispatch;
    fTabHeaderFont: TFont;
    fBorderColor: TColor;
    fGradientFromColor: TColor;
    fGradientToColor: TColor;
    fGradientType: TBackgroundKind;
    fInactiveHeaderFontColor: TColor;
    procedure SetHeaderFont(const Value: TFont);
    procedure SetBorderColor(const Value: TColor);
    procedure SetGradientFromColor(const Value: TColor);
    procedure SetGradientToColor(const Value: TColor);
    procedure SetGradientType(const Value: TBackgroundKind);
    procedure SetInactiveHeaderFontColor(const Value: TColor);
    procedure TabHeaderFontChange(Sender: TObject);
  public
    constructor Create(aDispatch: TSpkBaseAppearanceDispatch);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure LoadFromIni(aIniFile: TCustomIniFile);
    procedure SaveToIni(aIniFile: TCustomIniFile);
    procedure SaveToPascal(aList: TStrings);
    procedure Reset(aStyle: TSpkStyle = spkOffice2007Blue);
  published
    property TabHeaderFont: TFont read fTabHeaderFont write SetHeaderFont;
    property BorderColor: TColor read fBorderColor write SetBorderColor;
    property GradientFromColor: TColor read fGradientFromColor write SetGradientFromColor;
    property GradientToColor: TColor read fGradientToColor write SetGradientToColor;
    property GradientType: TBackgroundKind read fGradientType write SetGradientType;
    property InactiveTabHeaderFontColor: TColor read fInactiveHeaderFontColor write SetInactiveHeaderFontColor;
  end;

  /// <summary>
  ///
  /// </summary>
  TSpkPaneAppearance = class(TPersistent)
  public
    const INI_SECTION = 'PaneAppearance';
    const INI_CAPTION_FONT_SECTION = INI_SECTION + '\CaptionFont';
  private
    fDispatch: TSpkBaseAppearanceDispatch;
    fCaptionFont: TFont;
    fBorderDarkColor: TColor;
    fBorderLightColor: TColor;
    fCaptionBgColor: TColor;
    fGradientFromColor: TColor;
    fGradientToColor: TColor;
    fGradientType: TBackgroundKind;
    fHotTrackBrightnessChange: Integer;
    fStyle: TSpkPaneStyle;
    procedure SetCaptionBgColor(const Value: TColor);
    procedure SetCaptionFont(const Value: TFont);
    procedure SetBorderDarkColor(const Value: TColor);
    procedure SetBorderLightColor(const Value: TColor);
    procedure SetGradientFromColor(const Value: TColor);
    procedure SetGradientToColor(const Value: TColor);
    procedure SetGradientType(const Value: TBackgroundKind);
    procedure SetHotTrackBrightnessChange(const Value: Integer);
    procedure SetStyle(const Value: TSpkPaneStyle);
    procedure CaptionFontChange(Sender: TObject);
  public
    constructor Create(aDispatch: TSpkBaseAppearanceDispatch);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure LoadFromIni(aIniFile: TCustomIniFile);
    procedure SaveToIni(aIniFile: TCustomIniFile);
    procedure SaveToPascal(aList: TStrings);
    procedure Reset(aStyle: TSpkStyle = spkOffice2007Blue);
  published
    property BorderDarkColor: TColor read fBorderDarkColor write SetBorderDarkColor;
    property BorderLightColor: TColor read fBorderLightColor write SetBorderLightColor;
    property CaptionBgColor: TColor read fCaptionBgColor write SetCaptionBgColor;
    property CaptionFont: TFont read fCaptionFont write SetCaptionFont;
    property GradientFromColor: TColor read fGradientFromColor write SetGradientFromColor;
    property GradientToColor: TColor read fGradientToColor write SetGradientToColor;
    property GradientType: TBackgroundKind read fGradientType write SetGradientType;
    property HotTrackBrightnessChange: Integer read fHotTrackBrightnessChange write SetHotTrackBrightnessChange default 20;
    property Style: TSpkPaneStyle read fStyle write SetStyle default psRectangleEtched;
  end;

  /// <summary>
  ///
  /// </summary>
  TSpkElementAppearance = class(TPersistent)
  public
    const INI_SECTION = 'ElementAppearance';
    const INI_CAPTION_FONT_SECTION = INI_SECTION + '\CaptionFont';
  private
    fDispatch: TSpkBaseAppearanceDispatch;
    fCaptionFont: TFont;
    fIdleFrameColor: TColor;
    fIdleGradientFromColor: TColor;
    fIdleGradientToColor: TColor;
    fIdleGradientType: TBackgroundKind;
    fIdleInnerLightColor: TColor;
    fIdleInnerDarkColor: TColor;
    fIdleCaptionColor: TColor;
    fHotTrackFrameColor: TColor;
    fHotTrackGradientFromColor: TColor;
    fHotTrackGradientToColor: TColor;
    fHotTrackGradientType: TBackgroundKind;
    fHotTrackInnerLightColor: TColor;
    fHotTrackInnerDarkColor: TColor;
    fHotTrackCaptionColor: TColor;
    fHotTrackBrightnessChange: Integer;
    fActiveFrameColor: TColor;
    fActiveGradientFromColor: TColor;
    fActiveGradientToColor: TColor;
    fActiveGradientType: TBackgroundKind;
    fActiveInnerLightColor: TColor;
    fActiveInnerDarkColor: TColor;
    fActiveCaptionColor: TColor;
    fStyle: TSpkElementStyle;
    fDisabledCaptionColor: TColor;
    procedure SetActiveCaptionColor(const Value: TColor);
    procedure SetActiveFrameColor(const Value: TColor);
    procedure SetActiveGradientFromColor(const Value: TColor);
    procedure SetActiveGradientToColor(const Value: TColor);
    procedure SetActiveGradientType(const Value: TBackgroundKind);
    procedure SetActiveInnerDarkColor(const Value: TColor);
    procedure SetActiveInnerLightColor(const Value: TColor);
    procedure SetCaptionFont(const Value: TFont);
    procedure SetDisabledCaptionColor(const Value: TColor);
    procedure SetHotTrackCaptionColor(const Value: TColor);
    procedure SetHotTrackFrameColor(const Value: TColor);
    procedure SetHotTrackGradientFromColor(const Value: TColor);
    procedure SetHotTrackGradientToColor(const Value: TColor);
    procedure SetHotTrackGradientType(const Value: TBackgroundKind);
    procedure SetHotTrackInnerDarkColor(const Value: TColor);
    procedure SetHotTrackInnerLightColor(const Value: TColor);
    procedure SetHotTrackBrightnessChange(const Value: Integer);
    procedure SetIdleCaptionColor(const Value: TColor);
    procedure SetIdleFrameColor(const Value: TColor);
    procedure SetIdleGradientFromColor(const Value: TColor);
    procedure SetIdleGradientToColor(const Value: TColor);
    procedure SetIdleGradientType(const Value: TBackgroundKind);
    procedure SetIdleInnerDarkColor(const Value: TColor);
    procedure SetIdleInnerLightColor(const Value: TColor);
    procedure SetStyle(const Value: TSpkElementStyle);
    procedure CaptionFontChange(Sender: TObject);
  public
    constructor Create(aDispatch: TSpkBaseAppearanceDispatch);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure LoadFromIni(aIniFile: TCustomIniFile);
    procedure SaveToIni(aIniFile: TCustomIniFile);
    procedure SaveToPascal(aList: TStrings);
    procedure Reset(aStyle: TSpkStyle = spkOffice2007Blue);
    procedure GetActiveColors(IsChecked: Boolean; out aFrameColor,
        aInnerLightColor, aInnerDarkColor, aGradientFromColor,
        aGradientToColor: TColor; out aGradientKind: TBackgroundKind;
        aBrightenBy: Integer = 0);
    procedure GetHotTrackColors(IsChecked: Boolean; out aFrameColor,
        aInnerLightColor, aInnerDarkColor, aGradientFromColor,
        aGradientToColor: TColor; out aGradientKind: TBackgroundKind;
        aBrightenBy: Integer = 0);
    procedure GetIdleColors(IsChecked: Boolean; out aFrameColor,
        aInnerLightColor, aInnerDarkColor, aGradientFromColor,
        aGradientToColor: TColor; out aGradientKind: TBackgroundKind;
        aBrightenBy: Integer = 0);
  published
    property CaptionFont: TFont read fCaptionFont write SetCaptionFont;
    property DisabledCaptionColor: TColor read fDisabledCaptionColor write SetDisabledCaptionColor;
    property IdleFrameColor: TColor read fIdleFrameColor write SetIdleFrameColor;
    property IdleGradientFromColor: TColor read fIdleGradientFromColor write SetIdleGradientFromColor;
    property IdleGradientToColor: TColor read fIdleGradientToColor write SetIdleGradientToColor;
    property IdleGradientType: TBackgroundKind read fIdleGradientType write SetIdleGradientType;
    property IdleInnerLightColor: TColor read fIdleInnerLightColor write SetIdleInnerLightColor;
    property IdleInnerDarkColor: TColor read fIdleInnerDarkColor write SetIdleInnerDarkColor;
    property IdleCaptionColor: TColor read fIdleCaptionColor write SetIdleCaptionColor;
    property HotTrackFrameColor: TColor read fHotTrackFrameColor write SetHotTrackFrameColor;
    property HotTrackGradientFromColor: TColor read fHotTrackGradientFromColor write SetHotTrackGradientFromColor;
    property HotTrackGradientToColor: TColor read fHotTrackGradientToColor write SetHotTrackGradientToColor;
    property HotTrackGradientType: TBackgroundKind read fHotTrackGradientType write SetHotTrackGradientType;
    property HotTrackInnerLightColor: TColor read fHotTrackInnerLightColor write SetHotTrackInnerLightColor;
    property HotTrackInnerDarkColor: TColor read fHotTrackInnerDarkColor write SetHotTrackInnerDarkColor;
    property HotTrackCaptionColor: TColor read fHotTrackCaptionColor write SetHotTrackCaptionColor;
    property HotTrackBrightnessChange: Integer read fHotTrackBrightnessChange write SetHotTrackBrightnessChange default 20;
    property ActiveFrameColor: TColor read fActiveFrameColor write SetActiveFrameColor;
    property ActiveGradientFromColor: TColor read fActiveGradientFromColor write SetActiveGradientFromColor;
    property ActiveGradientToColor: TColor read fActiveGradientToColor write SetActiveGradientToColor;
    property ActiveGradientType: TBackgroundKind read fActiveGradientType write SetActiveGradientType;
    property ActiveInnerLightColor: TColor read fActiveInnerLightColor write SetActiveInnerLightColor;
    property ActiveInnerDarkColor: TColor read fActiveInnerDarkColor write SetActiveInnerDarkColor;
    property ActiveCaptionColor: TColor read fActiveCaptionColor write SetActiveCaptionColor;
    property Style: TSpkElementStyle read fStyle write SetStyle;
  end;

  /// <summary>
  ///
  /// </summary>
  TSpkToolbarAppearanceDispatch = class(TSpkBaseAppearanceDispatch)
  private
    fToolbarAppearance: TSpkToolbarAppearance;
  public
    constructor Create(aToolbarAppearance: TSpkToolbarAppearance);
    procedure NotifyAppearanceChanged; override;
  end;

  /// <summary>
  ///
  /// </summary>
  TSpkToolbarAppearance = class(TPersistent)
  private
    fAppearanceDispatch: TSpkToolbarAppearanceDispatch;
    fTab: TSpkTabAppearance;
    fPane: TSpkPaneAppearance;
    fElement: TSpkElementAppearance;
    fDispatch: TSpkBaseAppearanceDispatch;
    procedure SetElementAppearance(const Value: TSpkElementAppearance);
    procedure SetPaneAppearance(const Value: TSpkPaneAppearance);
    procedure SetTabAppearance(const Value: TSpkTabAppearance);
  public
    constructor Create(aDispatch: TSpkBaseAppearanceDispatch); reintroduce;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure NotifyAppearanceChanged;
    procedure Reset(aStyle: TSpkStyle = spkOffice2007Blue);
    procedure SaveToPascal(aList: TStrings);
    procedure SaveToIni(aIniFile: TCustomIniFile);
    procedure LoadFromIni(aIniFile: TCustomIniFile);
  published
    property Tab: TSpkTabAppearance read fTab write SetTabAppearance;
    property Pane: TSpkPaneAppearance read fPane write SetPaneAppearance;
    property Element: TSpkElementAppearance read fElement write SetElementAppearance;
  end;

implementation

uses
  TypInfo,
  SpkGraphTools;

type
  TColorHelper = record helper for TColor
    function ToString: string;
    procedure FromString(const aStr: string);
  end;

{ TColorHelper }

procedure TColorHelper.FromString(const aStr: string);
begin
  Self := StringToColor(aStr);
end;

function TColorHelper.ToString: string;
begin
  Result := ColorToString(Self);
end;

procedure SaveFontToPascal(aList: TStrings; aFont: TFont; aName: String);
var
  sty: String;
begin
  sty := '';
  if fsBold in aFont.Style then sty := sty + 'fsBold,';
  if fsItalic in aFont.Style then sty := sty + 'fsItalic,';
  if fsUnderline in aFont.Style then sty := sty + 'fsUnderline,';
  if fsStrikeout in aFont.Style then sty := sty + 'fsStrikeout,';
  if sty <> '' then Delete(sty, Length(sty), 1);
  with aList do
  begin
    Add(aName + '.Name := ''' + aFont.Name + ''';');
    Add(aName + '.Size := ' + IntToStr(aFont.Size) + ';');
    Add(aName + '.Style := [' + sty + '];');
    Add(aName + '.Color := $' + IntToHex(aFont.Color, 8) + ';');
  end;
end;

procedure SaveFontToIni(aIni: TCustomIniFile; aSection: string; aFont: TFont);
begin
  aIni.WriteString(aSection, 'Name', aFont.Name);
  aIni.WriteInteger(aSection, 'CharSet', aFont.CharSet);
  aIni.WriteInteger(aSection, 'Color', aFont.Color);
  aIni.WriteInteger(aSection, 'Size', aFont.Size);
  aIni.WriteInteger(aSection, 'Style', Byte(aFont.Style));
end;

procedure LoadFontFromIni(aIni: TCustomIniFile; aSection: string; aFont: TFont);
begin
  aFont.Name    := aIni.ReadString(aSection, 'Name', aFont.Name);
  aFont.CharSet := TFontCharSet(aIni.ReadInteger(aSection, 'CharSet', aFont.CharSet));
  aFont.Color   := TColor(aIni.ReadInteger(aSection, 'Color', aFont.Color));
  aFont.Size    := aIni.ReadInteger(aSection, 'Size', aFont.Size);
  aFont.Style   := TFontStyles(Byte(aIni.ReadInteger(aSection, 'Style', Byte(aFont.Style))));
end;

{ TSpkBaseToolbarAppearance }

constructor TSpkTabAppearance.Create(aDispatch: TSpkBaseAppearanceDispatch);
begin
  inherited Create;
  fDispatch := aDispatch;
  fTabHeaderFont := TFont.Create;
  fTabHeaderFont.OnChange := TabHeaderFontChange;
  Reset;
end;

destructor TSpkTabAppearance.Destroy;
begin
  fTabHeaderFont.Free;
  inherited;
end;

procedure TSpkTabAppearance.Assign(Source: TPersistent);
var
  SrcAppearance: TSpkTabAppearance;
begin
  if Source is TSpkTabAppearance then
  begin
     SrcAppearance := TSpkTabAppearance(Source);
     fTabHeaderFont.Assign(SrcAppearance.TabHeaderFont);
     fBorderColor := SrcAppearance.BorderColor;
     fGradientFromColor := SrcAppearance.GradientFromColor;
     fGradientToColor := SrcAppearance.GradientToColor;
     fGradientType := SrcAppearance.GradientType;
     fInactiveHeaderFontColor := SrcAppearance.InactiveTabHeaderFontColor;

     if fDispatch <> nil then
        fDispatch.NotifyAppearanceChanged;
  end
  else
    raise AssignException.Create('TSpkToolbarAppearance.Assign: Cannot assign the object '+Source.ClassName+' to TSpkToolbarAppearance!');
end;

procedure TSpkTabAppearance.LoadFromIni(aIniFile: TCustomIniFile);
begin
  if not Assigned(aIniFile) then
    Exit;

  LoadFontFromIni(aIniFile, INI_HEADER_FONT_SECTION, fTabHeaderFont);
  fBorderColor := StringToColor(aIniFile.ReadString(INI_SECTION, 'BorderColor', 'clBlack'));
  fGradientFromColor := StringToColor(aIniFile.ReadString(INI_SECTION, 'GradientFromColor', 'clBlack'));
  fGradientToColor := StringToColor(aIniFile.ReadString(INI_SECTION, 'GradientToColor', 'clBlack'));
  fGradientType := TBackgroundKind(aIniFile.ReadInteger(INI_SECTION, 'GradientType', 0));
  fInactiveHeaderFontColor := StringToColor(aIniFile.ReadString(INI_SECTION, 'InactiveTabHeaderFontColor', 'clBlack'));
end;

procedure TSpkTabAppearance.Reset(aStyle: TSpkStyle);
begin
  case aStyle of
    spkOffice2007Blue:
    begin
      fTabHeaderFont.Color := rgb(21, 66, 139);
      fBorderColor := rgb(141, 178, 227);
      fGradientFromColor := rgb(222, 232, 245);
      fGradientToColor := rgb(199, 216, 237);
      fGradientType := bkConcave;
      fInactiveHeaderFontColor := fTabHeaderFont.Color;
    end;

    spkOffice2007Silver,
    spkOffice2007SilverTurquoise:
    begin
      fTabHeaderFont.Style := [];
      fTabHeaderFont.Color := $007A534C;
      fBorderColor := $00BEBEBE;
      fGradientFromColor := $00F4F2F2;
      fGradientToColor := $00EFE6E1;
      fGradientType := bkConcave;
      fInactiveHeaderFontColor := $007A534C;
    end;

    spkMetroLight:
    begin
      fTabHeaderFont.Style := [];
      fTabHeaderFont.Color := $0095572A;
      fBorderColor := $00D2D0CF;
      fGradientFromColor := $00F1F1F1;
      fGradientToColor := $00F1F1F1;
      fGradientType := bkSolid;
      fInactiveHeaderFontColor := $00696969;
    end;

    spkMetroDark:
    begin
      fTabHeaderFont.Style := [];
      fTabHeaderFont.Color := $00FFFFFF;
      fBorderColor := $00000000;
      fGradientFromColor := $00464646;
      fGradientToColor := $00464646;
      fGradientType := bkSolid;
      fInactiveHeaderFontColor := $00787878;
    end;
  end;
end;

procedure TSpkTabAppearance.SaveToPascal(aList: TStrings);
begin
  with aList do
  begin
    Add('  with Tab do begin');
    SaveFontToPascal(aList, fTabHeaderFont, '    TabHeaderFont');
    Add('    BorderColor := $' + IntToHex(fBorderColor, 8) + ';');
    Add('    GradientFromColor := $' + IntToHex(fGradientFromColor, 8) + ';');
    Add('    GradientToColor := $' + IntToHex(fGradientToColor, 8) + ';');
    Add('    GradientType := ' + GetEnumName(TypeInfo(TBackgroundKind), ord(fGradientType)) + ';');
    Add('    InactiveHeaderFontColor := $' + IntToHex(fInactiveHeaderFontColor, 8) + ';');
    Add('  end;');
  end;
end;

procedure TSpkTabAppearance.SaveToIni(aIniFile: TCustomIniFile);
begin
  if not Assigned(aIniFile) then
    Exit;

  SaveFontToIni(aIniFile, INI_HEADER_FONT_SECTION, fTabHeaderFont);
  aIniFile.WriteString(INI_SECTION, 'BorderColor', ColorToString(fBorderColor));
  aIniFile.WriteString(INI_SECTION, 'GradientFromColor', ColorToString(fGradientFromColor));
  aIniFile.WriteString(INI_SECTION, 'GradientToColor', ColorToString(fGradientToColor));
  aIniFile.WriteInteger(INI_SECTION, 'GradientType', Integer(fGradientType));
  aIniFile.WriteString(INI_SECTION, 'BorderColor', ColorToString(fBorderColor));
end;

procedure TSpkTabAppearance.SetBorderColor(const Value: TColor);
begin
  fBorderColor := Value;
  if fDispatch <> nil then
    fDispatch.NotifyAppearanceChanged;
end;

procedure TSpkTabAppearance.SetGradientFromColor(const Value: TColor);
begin
  fGradientFromColor := Value;
  if fDispatch <> nil then
    fDispatch.NotifyAppearanceChanged;
end;

procedure TSpkTabAppearance.SetGradientToColor(const Value: TColor);
begin
  fGradientToColor := Value;
  if fDispatch <> nil then
    fDispatch.NotifyAppearanceChanged;
end;

procedure TSpkTabAppearance.SetGradientType(const Value: TBackgroundKind);
begin
  fGradientType := Value;
  if fDispatch <> nil then
    fDispatch.NotifyAppearanceChanged;
end;

procedure TSpkTabAppearance.SetHeaderFont(const Value: TFont);
begin
  fTabHeaderFont.Assign(Value);
  if fDispatch <> nil then
    fDispatch.NotifyAppearanceChanged;
end;

procedure TSpkTabAppearance.SetInactiveHeaderFontColor(const Value: TColor);
begin
  fInactiveHeaderFontColor := Value;
  if fDispatch <> nil then
    fDispatch.NotifyAppearanceChanged;
end;

procedure TSpkTabAppearance.TabHeaderFontChange(Sender: TObject);
begin
  if fDispatch <> nil then
    fDispatch.NotifyAppearanceChanged;
end;


{ TSpkPaneAppearance }

constructor TSpkPaneAppearance.Create(aDispatch: TSpkBaseAppearanceDispatch);
begin
  inherited Create;
  fDispatch := aDispatch;
  fCaptionFont := TFont.Create;
  fCaptionFont.OnChange := CaptionFontChange;
  fHotTrackBrightnessChange := 20;
  fStyle := psRectangleEtched;
  Reset;
end;

destructor TSpkPaneAppearance.Destroy;
begin
  fCaptionFont.Free;
  inherited Destroy;
end;

procedure TSpkPaneAppearance.Assign(Source: TPersistent);
var
  SrcAppearance: TSpkPaneAppearance;
begin
  if Source is TSpkPaneAppearance then
  begin
    SrcAppearance := TSpkPaneAppearance(Source);

    fCaptionFont.Assign(SrcAppearance.CaptionFont);
    fBorderDarkColor := SrcAppearance.BorderDarkColor;
    fBorderLightColor := SrcAppearance.BorderLightColor;
    fCaptionBgColor := SrcAppearance.CaptionBgColor;
    fGradientFromColor := SrcAppearance.GradientFromColor;
    fGradientToColor := SrcAppearance.GradientToColor;
    fGradientType := SrcAppearance.GradientType;
    fHotTrackBrightnessChange := SrcAppearance.HotTrackBrightnessChange;
    fStyle := SrcAppearance.Style;

    if fDispatch <> nil then
      fDispatch.NotifyAppearanceChanged;
  end else
    raise AssignException.Create('TSpkPaneAppearance.Assign: Cannot assign the class '+Source.ClassName+' to TSpkPaneAppearance!');
end;

procedure TSpkPaneAppearance.CaptionFontChange(Sender: TObject);
begin
  if fDispatch <> nil then
    fDispatch.NotifyAppearanceChanged;
end;

procedure TSpkPaneAppearance.LoadFromIni(aIniFile: TCustomIniFile);
begin
  if not Assigned(aIniFile) then
    Exit;

  LoadFontFromIni(aIniFile, INI_CAPTION_FONT_SECTION, fCaptionFont);
  fBorderDarkColor := StringToColor(aIniFile.ReadString(INI_SECTION, 'BorderDarkColor', 'clBlack'));
  fBorderLightColor := StringToColor(aIniFile.ReadString(INI_SECTION, 'BorderLightColor', 'clBlack'));
  fCaptionBgColor := StringToColor(aIniFile.ReadString(INI_SECTION, 'CaptionBgColor', 'clBlack'));
  fGradientFromColor := StringToColor(aIniFile.ReadString(INI_SECTION, 'GradientFromColor', 'clBlack'));
  fGradientToColor := StringToColor(aIniFile.ReadString(INI_SECTION, 'GradientToColor', 'clBlack'));
  fGradientType := TBackgroundKind(aIniFile.ReadInteger(INI_SECTION, 'GradientType', 0));
  fHotTrackBrightnessChange := aIniFile.ReadInteger(INI_SECTION, 'HotTrackBrightnessChange', 0);
  fStyle := TSpkPaneStyle(aIniFile.ReadInteger(INI_SECTION, 'Style', 0));
end;

procedure TSpkPaneAppearance.Reset(aStyle: TSpkStyle = spkOffice2007Blue);
begin
  case aStyle of
    spkOffice2007Blue:
    begin
      fCaptionFont.Style := [];
      fCaptionFont.Color := rgb(21, 66, 139);
      fBorderDarkColor := rgb(158, 190, 218);
      fBorderLightColor := rgb(237, 242, 248);
      fCaptionBgColor := rgb(194, 217, 241);
      fGradientFromColor := rgb(222, 232, 245);
      fGradientToColor := rgb(199, 216, 237);
      fGradientType := bkConcave;
      fHotTrackBrightnessChange := 20;
      fStyle := psRectangleEtched;
    end;

    spkOffice2007Silver,
    spkOffice2007SilverTurquoise:
    begin
      fCaptionFont.Style := [];
      fCaptionFont.Color := $00363636;
      fBorderDarkColor := $00A6A6A6;
      fBorderLightColor := $00FFFFFF;
      fCaptionBgColor := $00E4E4E4;
      fGradientFromColor := $00F8F8F8;
      fGradientToColor := $00E9E9E9;
      fGradientType := bkConcave;
      fHotTrackBrightnessChange := 20;
      fStyle := psRectangleEtched;
    end;

    spkMetroLight:
    begin
      fCaptionFont.Style := [];
      fCaptionFont.Color := $00696969;
      fBorderDarkColor := $00D2D0CF;
      fBorderLightColor := $00F8F2ED;
      fCaptionBgColor := $00F1F1F1;
      fGradientFromColor := $00F1F1F1;
      fGradientToColor := $00F1F1F1;
      fGradientType := bkSolid;
      fHotTrackBrightnessChange := 0;
      fStyle := psDividerFlat;
    end;

    spkMetroDark:
    begin
      fCaptionFont.Style := [];
      fCaptionFont.Color := $00FFFFFF;
      fBorderDarkColor := $008C8482;
      fBorderLightColor := $00A29D9B;
      fCaptionBgColor := $00464646;
      fGradientFromColor := $00464646;
      fGradientToColor := $00F1F1F1;
      fGradientType := bkSolid;
      fHotTrackBrightnessChange := 0;
      fStyle := psDividerFlat;
    end;
  end;
end;

procedure TSpkPaneAppearance.SaveToPascal(aList: TStrings);
begin
  with aList do
  begin
    Add('  with Pane do begin');
    SaveFontToPascal(aList, fCaptionFont, '    CaptionFont');
    Add('    BorderDarkColor := $' + IntToHex(fBorderDarkColor, 8) + ';');
    Add('    BorderLightColor := $' + IntToHex(fBorderLightColor, 8) + ';');
    Add('    CaptionBgColor := $' + IntToHex(FcaptionBgColor, 8) + ';');
    Add('    GradientFromColor := $' + IntToHex(fGradientFromColor, 8) + ';');
    Add('    GradientToColor := $' + IntToHex(fGradientToColor, 8) + ';');
    Add('    GradientType := ' + GetEnumName(TypeInfo(TBackgroundKind), ord(fGradientType)) + ';');
    Add('    HotTrackBrightnessChange = ' + IntToStr(fHotTrackBrightnessChange) + ';');
    Add('    Style := ' + GetEnumName(TypeInfo(TSpkPaneStyle), ord(fStyle)) +';');
    Add('  end;');
  end;
end;

procedure TSpkPaneAppearance.SaveToIni(aIniFile: TCustomIniFile);
begin
  if not Assigned(aIniFile) then
    Exit;

  SaveFontToIni(aIniFile, INI_CAPTION_FONT_SECTION, fCaptionFont);
  aIniFile.WriteString(INI_SECTION, 'BorderDarkColor', ColorToString(fBorderDarkColor));
  aIniFile.WriteString(INI_SECTION, 'BorderLightColor', ColorToString(fBorderLightColor));
  aIniFile.WriteString(INI_SECTION, 'CaptionBgColor', ColorToString(fCaptionBgColor));
  aIniFile.WriteString(INI_SECTION, 'GradientFromColor', ColorToString(fGradientFromColor));
  aIniFile.WriteString(INI_SECTION, 'GradientToColor', ColorToString(fGradientToColor));
  aIniFile.WriteInteger(INI_SECTION, 'GradientType', Integer(fGradientType));
  aIniFile.WriteInteger(INI_SECTION, 'HotTrackBrightnessChange', fHotTrackBrightnessChange);
  aIniFile.WriteInteger(INI_SECTION, 'Style', Integer(fStyle));
end;

procedure TSpkPaneAppearance.SetBorderDarkColor(const Value: TColor);
begin
  fBorderDarkColor := Value;
  if Assigned(fDispatch) then
    fDispatch.NotifyAppearanceChanged;
end;

procedure TSpkPaneAppearance.SetBorderLightColor(const Value: TColor);
begin
  fBorderLightColor := Value;
  if fDispatch <> nil then
    fDispatch.NotifyAppearanceChanged;
end;

procedure TSpkPaneAppearance.SetCaptionBgColor(const Value: TColor);
begin
  fCaptionBgColor := Value;
  if fDispatch <> nil then
    fDispatch.NotifyAppearanceChanged;
end;

procedure TSpkPaneAppearance.SetCaptionFont(const Value: TFont);
begin
  fCaptionFont.Assign(Value);
  if fDispatch <> nil then
    fDispatch.NotifyAppearanceChanged;
end;

procedure TSpkPaneAppearance.SetGradientFromColor(const Value: TColor);
begin
  fGradientFromColor := Value;
  if fDispatch <> nil then
    fDispatch.NotifyAppearanceChanged;
end;

procedure TSpkPaneAppearance.SetGradientToColor(const Value: TColor);
begin
  fGradientToColor := Value;
  if fDispatch <> nil then
    fDispatch.NotifyAppearanceChanged;
end;

procedure TSpkPaneAppearance.SetGradientType(const Value: TBackgroundKind);
begin
  fGradientType := Value;
  if fDispatch <> nil then
    fDispatch.NotifyAppearanceChanged;
end;

procedure TSpkPaneAppearance.SetHotTrackBrightnessChange(const Value: Integer);
begin
  fHotTrackBrightnessChange := Value;
  if fDispatch <> nil then
    fDispatch.NotifyAppearanceChanged;
end;

procedure TSpkPaneAppearance.SetStyle(const Value: TSpkPaneStyle);
begin
  fStyle := Value;
  if fDispatch <> nil then
    fDispatch.NotifyAppearanceChanged;
end;


{ TSpkElementAppearance }

constructor TSpkElementAppearance.Create(aDispatch: TSpkBaseAppearanceDispatch);
begin
  inherited Create;
  fDispatch := aDispatch;
  fCaptionFont := TFont.Create;
  fCaptionFont.OnChange := CaptionFontChange;
  fHotTrackBrightnessChange := 40;
  Reset;
end;

destructor TSpkElementAppearance.Destroy;
begin
  fCaptionFont.Free;
  inherited Destroy;
end;

procedure TSpkElementAppearance.Assign(Source: TPersistent);
var
  SrcAppearance: TSpkElementAppearance;
begin
  if Source is TSpkElementAppearance then
  begin
    SrcAppearance := TSpkElementAppearance(Source);

    fCaptionFont.Assign(SrcAppearance.CaptionFont);
    fIdleFrameColor := SrcAppearance.IdleFrameColor;
    fIdleGradientFromColor := SrcAppearance.IdleGradientFromColor;
    fIdleGradientToColor := SrcAppearance.IdleGradientToColor;
    fIdleGradientType := SrcAppearance.IdleGradientType;
    fIdleInnerLightColor := SrcAppearance.IdleInnerLightColor;
    fIdleInnerDarkColor := SrcAppearance.IdleInnerDarkColor;
    fIdleCaptionColor := SrcAppearance.IdleCaptionColor;
    fHotTrackFrameColor := SrcAppearance.HotTrackFrameColor;
    fHotTrackGradientFromColor := SrcAppearance.HotTrackGradientFromColor;
    fHotTrackGradientToColor := SrcAppearance.HotTrackGradientToColor;
    fHotTrackGradientType := SrcAppearance.HotTrackGradientType;
    fHotTrackInnerLightColor := SrcAppearance.HotTrackInnerLightColor;
    fHotTrackInnerDarkColor := SrcAppearance.HotTrackInnerDarkColor;
    fHotTrackCaptionColor := SrcAppearance.HotTrackCaptionColor;
    fHotTrackBrightnessChange := SrcAppearance.HotTrackBrightnessChange;
    fActiveFrameColor := SrcAppearance.ActiveFrameColor;
    fActiveGradientFromColor := SrcAppearance.ActiveGradientFromColor;
    fActiveGradientToColor := SrcAppearance.ActiveGradientToColor;
    fActiveGradientType := SrcAppearance.ActiveGradientType;
    fActiveInnerLightColor := SrcAppearance.ActiveInnerLightColor;
    fActiveInnerDarkColor := SrcAppearance.ActiveInnerDarkColor;
    fActiveCaptionColor := SrcAppearance.ActiveCaptionColor;
    fStyle := SrcAppearance.Style;

    if fDispatch <> nil then
      fDispatch.NotifyAppearanceChanged;
  end
  else
    raise AssignException.Create('TSpkElementAppearance.Assign: Cannot assign the objecct '+Source.ClassName+' to TSpkElementAppearance!');
end;

procedure TSpkElementAppearance.CaptionFontChange(Sender: TObject);
begin
  if fDispatch <> nil then
    fDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.GetActiveColors(IsChecked: Boolean;
  out aFrameColor, aInnerLightColor, aInnerDarkColor, aGradientFromColor,
  aGradientToColor: TColor; out aGradientKind: TBackgroundKind;
  aBrightenBy: Integer = 0);
const
  DELTA = -20;
begin
  aFrameColor := fActiveFrameColor;
  aInnerLightColor := fActiveInnerLightColor;
  aInnerDarkColor := fActiveInnerDarkColor;
  aGradientFromColor := fActiveGradientFromColor;
  aGradientToColor := fActiveGradientToColor;
  aGradientKind := fActiveGradientType;

  if IsChecked then
    aBrightenBy := DELTA + aBrightenBy;

  if aBrightenBy <> 0 then
  begin
    aFrameColor := TColorTools.Brighten(aFrameColor, aBrightenBy);
    aInnerLightColor := TColorTools.Brighten(aInnerLightColor, aBrightenBy);
    aInnerDarkColor := TColortools.Brighten(aInnerDarkColor, aBrightenBy);
    aGradientFromColor := TColorTools.Brighten(aGradientFromColor, aBrightenBy);
    aGradientToColor := TColorTools.Brighten(aGradientToColor, aBrightenBy);
  end;
end;

procedure TSpkElementAppearance.GetIdleColors(IsChecked: Boolean;
  out aFrameColor, aInnerLightColor, aInnerDarkColor, aGradientFromColor,
  aGradientToColor: TColor; out aGradientKind: TBackgroundKind;
  aBrightenBy: Integer = 0);
const
  DELTA = 10;
begin
  if IsChecked then
  begin
    aBrightenBy := DELTA + aBrightenBy;
    aFrameColor := fActiveFrameColor;
    aInnerLightColor := fActiveInnerLightColor;
    aInnerDarkColor := fActiveInnerDarkColor;
    aGradientFromColor := fActiveGradientFromColor;
    aGradientToColor := fActiveGradientToColor;
    aGradientKind := fActiveGradientType;
  end
  else
  begin
    aFrameColor := fIdleFrameColor;
    aInnerLightColor := fIdleInnerLightColor;
    aInnerDarkColor := fIdleInnerDarkColor;
    aGradientFromColor := fIdleGradientFromColor;
    aGradientToColor := fIdleGradientToColor;
    aGradientKind := fIdleGradientType;
  end;

  if aBrightenBy <> 0 then
  begin
    aFrameColor := TColorTools.Brighten(aFrameColor, aBrightenBy);
    aInnerLightColor := TColorTools.Brighten(aInnerLightColor, aBrightenBy);
    aInnerDarkColor := TColorTools.Brighten(aInnerLightColor, aBrightenBy);
    aGradientFromColor := TColorTools.Brighten(aGradientFromColor, aBrightenBy);
    aGradientToColor := TColorTools.Brighten(aGradientToColor, aBrightenBy);
  end;
end;

procedure TSpkElementAppearance.GetHotTrackColors(IsChecked: Boolean;
  out aFrameColor, aInnerLightColor, aInnerDarkColor, aGradientFromColor,
  aGradientToColor: TColor; out aGradientKind: TBackgroundKind;
  aBrightenBy: Integer = 0);
const
  DELTA = 20;
begin
  if IsChecked then
  begin
    aBrightenBy := aBrightenBy + DELTA;
    aFrameColor := fActiveFrameColor;
    aInnerLightColor := fActiveInnerLightColor;
    aInnerDarkColor := fActiveInnerDarkColor;
    aGradientFromColor := fActiveGradientFromColor;
    aGradientToColor := fActiveGradientToColor;
    aGradientKind := fActiveGradientType;
  end
  else
  begin
    aFrameColor := fHotTrackFrameColor;
    aInnerLightColor := fHotTrackInnerLightColor;
    aInnerDarkColor := fHotTrackInnerDarkColor;
    aGradientFromColor := fHotTrackGradientFromColor;
    aGradientToColor := fHotTrackGradientToColor;
    aGradientKind := fHotTrackGradientType;
  end;

  if aBrightenBy <> 0 then
  begin
    aFrameColor := TColorTools.Brighten(aFrameColor, aBrightenBy);
    aInnerLightColor := TColorTools.Brighten(aInnerLightColor, aBrightenBy);
    aInnerDarkColor := TColortools.Brighten(aInnerDarkColor, aBrightenBy);
    aGradientFromColor := TColorTools.Brighten(aGradientFromColor, aBrightenBy);
    aGradientToColor := TColorTools.Brighten(aGradientToColor, aBrightenBy);
  end;
end;

procedure TSpkElementAppearance.LoadFromIni(aIniFile: TCustomIniFile);
begin
  if not Assigned(aIniFile) then
    Exit;

  LoadFontFromIni(aIniFile, INI_CAPTION_FONT_SECTION, fCaptionFont);
  fDisabledCaptionColor.FromString(aIniFile.ReadString(INI_SECTION, 'DisabledCaptionColor', '$00838383'));
  // Idle
  fIdleFrameColor.FromString(aIniFile.ReadString(INI_SECTION, 'IdleFrameColor', 'clBlack'));
  fIdleGradientFromColor.FromString(aIniFile.ReadString(INI_SECTION, 'IdleGradientFromColor', 'clBlack'));
  fIdleGradientToColor.FromString(aIniFile.ReadString(INI_SECTION, 'IdleGradientToColor', 'clBlack'));
  fIdleGradientType := TBackgroundKind(aIniFile.ReadInteger(INI_SECTION, 'IdleGradientType', 0));
  fIdleInnerLightColor.FromString(aIniFile.ReadString(INI_SECTION, 'IdleInnerLightColor', 'clBlack'));
  fIdleInnerDarkColor.FromString(aIniFile.ReadString(INI_SECTION, 'IdleInnerDarkColor', 'clBlack'));
  fIdleCaptionColor.FromString(aIniFile.ReadString(INI_SECTION, 'IdleCaptionColor', 'clBlack'));
  // HotTrack
  fHottrackFrameColor.FromString(aIniFile.ReadString(INI_SECTION, 'HottrackFrameColor', 'clBlack'));
  fHottrackGradientFromColor.FromString(aIniFile.ReadString(INI_SECTION, 'HottrackGradientFromColor', 'clBlack'));
  fHottrackGradientToColor.FromString(aIniFile.ReadString(INI_SECTION, 'HottrackGradientToColor', 'clBlack'));
  fHottrackGradientType := TBackgroundKind(aIniFile.ReadInteger(INI_SECTION, 'HottrackGradientType', 0));
  fHottrackInnerLightColor.FromString(aIniFile.ReadString(INI_SECTION, 'HottrackInnerLightColor', 'clBlack'));
  fHottrackInnerDarkColor.FromString(aIniFile.ReadString(INI_SECTION, 'HottrackInnerDarkColor', 'clBlack'));
  fHottrackCaptionColor.FromString(aIniFile.ReadString(INI_SECTION, 'HottrackCaptionColor', 'clBlack'));
  fHottrackBrightnessChange := aIniFile.ReadInteger(INI_SECTION, 'HottrackBrightnessChange', 0);
  // Active
  fActiveFrameColor.FromString(aIniFile.ReadString(INI_SECTION, 'ActiveFrameColor', 'clBlack'));
  fActiveGradientFromColor.FromString(aIniFile.ReadString(INI_SECTION, 'ActiveGradientFromColor', 'clBlack'));
  fActiveGradientToColor.FromString(aIniFile.ReadString(INI_SECTION, 'ActiveGradientToColor', 'clBlack'));
  fActiveGradientType := TBackgroundKind(aIniFile.ReadInteger(INI_SECTION, 'ActiveGradientType', 0));
  fActiveInnerLightColor.FromString(aIniFile.ReadString(INI_SECTION, 'ActiveInnerLightColor', 'clBlack'));
  fActiveInnerDarkColor.FromString(aIniFile.ReadString(INI_SECTION, 'ActiveInnerDarkColor', 'clBlack'));
  fActiveCaptionColor.FromString(aIniFile.ReadString(INI_SECTION, 'ActiveCaptionColor', 'clBlack'));
  // Other
  fStyle := TSpkElementStyle(aIniFile.ReadInteger(INI_SECTION, 'Style', 0));
end;

procedure TSpkElementAppearance.Reset(aStyle: TSpkStyle = spkOffice2007Blue);
begin
  case aStyle of
    spkOffice2007Blue:
    begin
      fIdleFrameColor := rgb(155, 183, 224);
      fIdleGradientFromColor := rgb(200, 219, 238);
      fIdleGradientToColor := rgb(188, 208, 233);
      fIdleGradientType := bkConcave;
      fIdleInnerLightColor := rgb(213, 227, 241);
      fIdleInnerDarkColor := rgb(190, 211, 236);
      fIdleCaptionColor := rgb(86, 125, 177);
      fHotTrackFrameColor := rgb(221, 207, 155);
      fHotTrackGradientFromColor := rgb(255, 252, 218);
      fHotTrackGradientToColor := rgb(255, 215, 77);
      fHotTrackGradientType := bkConcave;
      fHotTrackInnerLightColor := rgb(255, 241, 197);
      fHotTrackInnerDarkColor := rgb(216, 194, 122);
      fHotTrackCaptionColor := rgb(111, 66, 135);
      fHotTrackBrightnessChange := 40;
      fActiveFrameColor := rgb(139, 118, 84);
      fActiveGradientFromColor := rgb(254, 187, 108);
      fActiveGradientToColor := rgb(252, 146, 61);
      fActiveGradientType := bkConcave;
      fActiveInnerLightColor := rgb(252, 169, 14);
      fActiveInnerDarkColor := rgb(252, 169, 14);
      fActiveCaptionColor := rgb(110, 66, 128);
      fStyle := esRounded;
    end;

    spkOffice2007Silver,
    spkOffice2007SilverTurquoise:
    begin
      fCaptionFont.Style := [];
      fCaptionFont.Color := $008B4215;
      fIdleFrameColor := $00B8B1A9;
      fIdleGradientFromColor := $00F4F4F2;
      fIdleGradientToColor := $00E6E5E3;
      fIdleGradientType := bkConcave;
      fIdleInnerDarkColor := $00C7C0BA;
      fIdleInnerLightColor := $00F6F2F0;
      fIdleCaptionColor := $0060655F;
      fHotTrackBrightnessChange := 40;
      fHotTrackFrameColor := $009BCFDD;
      fHotTrackGradientFromColor := $00DAFCFF;
      fHotTrackGradientToColor := $004DD7FF;
      fHotTrackGradientType := bkConcave;
      fHotTrackInnerDarkColor := $007AC2D8;
      fHotTrackInnerLightColor := $00C5F1FF;
      fHotTrackCaptionColor := $0087426F;
      if aStyle = spkOffice2007SilverTurquoise then
      begin
        fHotTrackFrameColor := $009E7D0E;
        fHotTrackGradientFromColor := $00FBF1D0;
        fHotTrackGradientToColor := $00F4DD8A;
        fHotTrackInnerDarkColor := $00C19A11;
        fHotTrackInnerLightColor := $00FAEFC9;
      end;
      fActiveFrameColor := $0054768B;
      fActiveGradientFromColor := $006CBBFE;
      fActiveGradientToColor := $003D92FC;
      fActiveGradientType := bkConcave;
      fActiveInnerDarkColor := $000EA9FC;
      fActiveInnerLightColor := $000EA9FC;
      fActiveCaptionColor := $0080426E;
      if aStyle = spkOffice2007SilverTurquoise then
      begin
        fActiveFrameColor := $0077620B;
        fActiveGradientFromColor := $00F4DB82;
        fActiveGradientToColor := $00ECC53E;
        fActiveInnerDarkColor := $00735B0B;
        fActiveInnerLightColor := $00F3D87A;
      end;
      fStyle := esRounded;
    end;

    spkMetroLight:
    begin
      fCaptionFont.Style := [];
      fCaptionFont.Color := $003F3F3F;
      fIdleFrameColor := $00CDCDCD;
      fIdleGradientFromColor := $00DFDFDF;
      fIdleGradientToColor := $00DFDFDF;
      fIdleGradientType := bkSolid;
      fIdleInnerDarkColor := $00CDCDCD;
      fIdleInnerLightColor := $00EBEBEB;
      fIdleCaptionColor := $00696969;
      fHotTrackFrameColor := $00F9CEA4;
      fHotTrackGradientFromColor := $00F7EFE8;
      fHotTrackGradientToColor := $00F7EFE8;
      fHotTrackGradientType := bkSolid;
      fHotTrackInnerDarkColor := $00F7EFE8;
      fHotTrackInnerLightColor := $00F7EFE8;
      fHotTrackCaptionColor := $003F3F3F;
      fHotTrackBrightnessChange := 20;
      fActiveFrameColor := $00E4A262;
      fActiveGradientFromColor := $00F7E0C9;
      fActiveGradientToColor := $00F7E0C9;
      fActiveGradientType := bkSolid;
      fActiveInnerDarkColor := $00F7E0C9;
      fActiveInnerLightColor := $00F7E0C9;
      fActiveCaptionColor := $002C2C2C;
      fStyle := esRectangle;
    end;

    spkMetroDark:
    begin
      fCaptionFont.Style := [];
      fCaptionFont.Color := $003F3F3F;
      fIdleFrameColor := $008C8482;
      fIdleGradientFromColor := $00444444;
      fIdleGradientToColor := $00444444;
      fIdleGradientType := bkSolid;
      fIdleInnerDarkColor := $008C8482;
      fIdleInnerLightColor := $00444444;
      fIdleCaptionColor := $00B6B6B6;
      fHotTrackFrameColor := $00C4793C;
      fHotTrackGradientFromColor := $00805B3D;
      fHotTrackGradientToColor := $00805B3D;
      fHotTrackGradientType := bkSolid;
      fHotTrackInnerDarkColor := $00805B3D;
      fHotTrackInnerLightColor := $00805B3D;
      fHotTrackCaptionColor := $00F2F2F2;
      fHotTrackBrightnessChange := 10;
      fActiveFrameColor := $00000000;
      fActiveGradientFromColor := $00000000;
      fActiveGradientToColor := $00000000;
      fActiveGradientType := bkSolid;
      fActiveInnerDarkColor := $00000000;
      fActiveInnerLightColor := $00000000;
      fActiveCaptionColor := $00E4E4E4;
      fStyle := esRectangle;
    end;
  end;
end;

procedure TSpkElementAppearance.SaveToPascal(aList: TStrings);
begin
  with aList do
  begin
    Add('  with Element do begin');
    SaveFontToPascal(aList, fCaptionFont, '    CaptionFont');

    Add('    DisabledCaptionColor := $' + IntToHex(fDisabledCaptionColor, 8) + ';');

    Add('    IdleFrameColor := $' + IntToHex(fIdleFrameColor, 8) + ';');
    Add('    IdleGradientFromColor := $' + IntToHex(fIdleGradientFromColor, 8) + ';');
    Add('    IdleGradientToColor := $' + IntToHex(fIdleGradientToColor, 8) + ';');
    Add('    IdleGradientType := ' + GetEnumName(TypeInfo(TBackgroundKind), ord(fIdleGradientType)) + ';');
    Add('    IdleInnerDarkColor := $' + IntToHex(fIdleInnerDarkColor, 8) + ';');
    Add('    IdleInnerLightColor := $' + IntToHex(fIdleInnerLightColor, 8) + ';');
    Add('    IdleCaptionColor := $' + IntToHex(fIdleCaptionColor, 8) + ';');

    Add('    HotTrackFrameColor := $' + IntToHex(fHotTrackFrameColor, 8) + ';');
    Add('    HotTrackGradientFromColor := $' + IntToHex(fHotTrackGradientFromColor, 8) + ';');
    Add('    HotTrackGradientToColor := $' + IntToHex(fHotTrackGradientToColor, 8) + ';');
    Add('    HotTrackGradientType := ' + GetEnumName(TypeInfo(TBackgroundKind), ord(fHotTrackGradientType)) + ';');
    Add('    HotTrackInnerDarkColor := $' + IntToHex(fHotTrackInnerDarkColor, 8) + ';');
    Add('    HotTrackInnerLightColor := $' + IntToHex(fHotTrackInnerLightColor, 8) + ';');
    Add('    HotTrackCaptionColor := $' + IntToHex(fHotTrackCaptionColor, 8) + ';');
    Add('    HotTrackBrightnessChange := ' + IntToStr(fHotTrackBrightnessChange) + ';');

    Add('    ActiveFrameColor := $' + IntToHex(fActiveFrameColor, 8) + ';');
    Add('    ActiveGradientFromColor := $' + IntToHex(fActiveGradientFromColor, 8) + ';');
    Add('    ActiveGradientToColor := $' + IntToHex(fActiveGradientToColor, 8) + ';');
    Add('    ActiveGradientType := ' + GetEnumName(TypeInfo(TBackgroundKind), ord(fActiveGradientType)) + ';');
    Add('    ActiveInnerDarkColor := $' + IntToHex(fActiveInnerDarkColor, 8) + ';');
    Add('    ActiveInnerLightColor := $' + IntToHex(fActiveInnerLightColor, 8) + ';');
    Add('    ActiveCaptionColor := $' + IntToHex(fActiveCaptionColor, 8) + ';');

    Add('    Style := ' + GetEnumName(TypeInfo(TSpkElementStyle), ord(fStyle)) + ';');
    Add('  end;');
  end;
end;

procedure TSpkElementAppearance.SaveToIni(aIniFile: TCustomIniFile);
begin
  if not Assigned(aIniFile) then
    Exit;

  SaveFontToIni(aIniFile, INI_CAPTION_FONT_SECTION, fCaptionFont);
  aIniFile.WriteString(INI_SECTION, 'DisabledCaptionColor', fDisabledCaptionColor.ToString);
  // Idle
  aIniFile.WriteString(INI_SECTION, 'IdleFrameColor', fIdleFrameColor.ToString);
  aIniFile.WriteString(INI_SECTION, 'IdleGradientFromColor', fIdleGradientFromColor.ToString);
  aIniFile.WriteString(INI_SECTION, 'IdleGradientToColor', fIdleGradientToColor.ToString);
  aIniFile.WriteInteger(INI_SECTION, 'IdleGradientType', Integer(fIdleGradientType));
  aIniFile.WriteString(INI_SECTION, 'IdleInnerLightColor', fIdleInnerLightColor.ToString);
  aIniFile.WriteString(INI_SECTION, 'IdleInnerDarkColor', fIdleInnerDarkColor.ToString);
  aIniFile.WriteString(INI_SECTION, 'IdleCaptionColor', fIdleCaptionColor.ToString);
  // HotTrack
  aIniFile.WriteString(INI_SECTION, 'HottrackFrameColor', fHottrackFrameColor.ToString);
  aIniFile.WriteString(INI_SECTION, 'HottrackGradientFromColor', fHottrackGradientFromColor.ToString);
  aIniFile.WriteString(INI_SECTION, 'HottrackGradientToColor', fHottrackGradientToColor.ToString);
  aIniFile.WriteInteger(INI_SECTION, 'HottrackGradientType', Integer(fHottrackGradientType));
  aIniFile.WriteString(INI_SECTION, 'HottrackInnerLightColor', fHottrackInnerLightColor.ToString);
  aIniFile.WriteString(INI_SECTION, 'HottrackInnerDarkColor', fHottrackInnerDarkColor.ToString);
  aIniFile.WriteString(INI_SECTION, 'HottrackCaptionColor', fHottrackCaptionColor.ToString);
  aIniFile.WriteInteger(INI_SECTION, 'HottrackBrightnessChange', Integer(fHotTrackBrightnessChange));
  // Active
  aIniFile.WriteString(INI_SECTION, 'ActiveFrameColor', fActiveFrameColor.ToString);
  aIniFile.WriteString(INI_SECTION, 'ActiveGradientFromColor', fActiveGradientFromColor.ToString);
  aIniFile.WriteString(INI_SECTION, 'ActiveGradientToColor', fActiveGradientToColor.ToString);
  aIniFile.WriteInteger(INI_SECTION, 'ActiveGradientType', Integer(fActiveGradientType));
  aIniFile.WriteString(INI_SECTION, 'ActiveInnerLightColor', fActiveInnerLightColor.ToString);
  aIniFile.WriteString(INI_SECTION, 'ActiveInnerDarkColor', fActiveInnerDarkColor.ToString);
  aIniFile.WriteString(INI_SECTION, 'ActiveCaptionColor', fActiveCaptionColor.ToString);
  // Other
  aIniFile.WriteInteger(INI_SECTION, 'Style', Integer(fStyle));
end;

procedure TSpkElementAppearance.SetActiveCaptionColor(const Value: TColor);
begin
  fActiveCaptionColor := Value;
  if fDispatch <> nil then
    fDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetActiveFrameColor(const Value: TColor);
begin
  fActiveFrameColor := Value;
  if fDispatch <> nil then
    fDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetActiveGradientFromColor(const Value: TColor);
begin
  fActiveGradientFromColor := Value;
  if fDispatch <> nil then
    fDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetActiveGradientToColor(const Value: TColor);
begin
  fActiveGradientToColor := Value;
  if fDispatch <> nil then
    fDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetActiveGradientType(const Value: TBackgroundKind);
begin
  fActiveGradientType := Value;
  if fDispatch <> nil then
    fDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetActiveInnerDarkColor(const Value: TColor);
begin
  fActiveInnerDarkColor := Value;
  if fDispatch <> nil then
    fDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetActiveInnerLightColor(const Value: TColor);
begin
  fActiveInnerLightColor := Value;
  if fDispatch <> nil then
    fDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetCaptionFont(const Value: TFont);
begin
  fCaptionFont.Assign(Value);
  if fDispatch <> nil then
    fDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetDisabledCaptionColor(const Value: TColor);
begin
  fDisabledCaptionColor := Value;
  if fDispatch <> nil then
    fDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetHotTrackBrightnessChange(const Value: Integer);
begin
  fHotTrackBrightnessChange := Value;
  if fDispatch <> nil then
    fDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetHotTrackCaptionColor(const Value: TColor);
begin
  fHotTrackCaptionColor := Value;
  if fDispatch <> nil then
    fDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetHotTrackFrameColor(const Value: TColor);
begin
  fHotTrackFrameColor := Value;
  if fDispatch <> nil then
    fDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetHotTrackGradientFromColor(const Value: TColor);
begin
  fHotTrackGradientFromColor := Value;
  if fDispatch <> nil then
    fDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetHotTrackGradientToColor(const Value: TColor);
begin
  fHotTrackGradientToColor := Value;
  if fDispatch <> nil then
    fDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetHotTrackGradientType(const Value: TBackgroundKind);
begin
  fHotTrackGradientType := Value;
  if fDispatch <> nil then
    fDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetHotTrackInnerDarkColor(const Value: TColor);
begin
  fHotTrackInnerDarkColor := Value;
  if fDispatch <> nil then
    fDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetHotTrackInnerLightColor(const Value: TColor);
begin
  fHotTrackInnerLightColor := Value;
  if fDispatch <> nil then
    fDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetIdleCaptionColor(const Value: TColor);
begin
  fIdleCaptionColor := Value;
  if fDispatch <> nil then
    fDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetIdleFrameColor(const Value: TColor);
begin
  fIdleFrameColor := Value;
  if fDispatch <> nil then
    fDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetIdleGradientFromColor(const Value: TColor);
begin
  fIdleGradientFromColor := Value;
  if fDispatch <> nil then
     fDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetIdleGradientToColor(const Value: TColor);
begin
  fIdleGradientToColor := Value;
  if fDispatch <> nil then
    fDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetIdleGradientType(const Value: TBackgroundKind);
begin
  fIdleGradientType := Value;
  if fDispatch <> nil then
    fDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetIdleInnerDarkColor(const Value: TColor);
begin
  fIdleInnerDarkColor := Value;
  if fDispatch <> nil then
    fDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetIdleInnerLightColor(const Value: TColor);
begin
  fIdleInnerLightColor := Value;
  if fDispatch <> nil then
    fDispatch.NotifyAppearanceChanged;
end;

procedure TSpkElementAppearance.SetStyle(const Value: TSpkElementStyle);
begin
  fStyle := Value;
  if fDispatch <> nil then
    fDispatch.NotifyAppearanceChanged;
end;

{ TSpkToolbarAppearanceDispatch }

constructor TSpkToolbarAppearanceDispatch.Create(
  aToolbarAppearance: TSpkToolbarAppearance);
begin
  inherited Create;
  fToolbarAppearance := aToolbarAppearance;
end;

procedure TSpkToolbarAppearanceDispatch.NotifyAppearanceChanged;
begin
  if fToolbarAppearance <> nil then
    fToolbarAppearance.NotifyAppearanceChanged;
end;

{ TSpkToolbarAppearance }

constructor TSpkToolbarAppearance.Create(aDispatch : TSpkBaseAppearanceDispatch);
begin
  inherited Create;
  fDispatch := aDispatch;
  fAppearanceDispatch := TSpkToolbarAppearanceDispatch.Create(self);
  fTab := TSpkTabAppearance.Create(fAppearanceDispatch);
  fPane := TSpkPaneAppearance.create(fAppearanceDispatch);
  fElement := TSpkElementAppearance.create(fAppearanceDispatch);
end;

destructor TSpkToolbarAppearance.Destroy;
begin
  fElement.Free;
  fPane.Free;
  fTab.Free;
  fAppearanceDispatch.Free;
  inherited;
end;

procedure TSpkToolbarAppearance.Assign(Source: TPersistent);
var
  Src: TSpkToolbarAppearance;
begin
  if Source is TSpkToolbarAppearance then
  begin
    Src := TSpkToolbarAppearance(Source);

    Self.fTab.Assign(Src.Tab);
    Self.fPane.Assign(Src.Pane);
    Self.fElement.Assign(Src.Element);

    if fDispatch <> nil then
      fDispatch.NotifyAppearanceChanged;
  end
  else
    raise AssignException.Create('TSpkToolbarAppearance.Assign: Cannot assign the object '+Source.ClassName+' to TSpkToolbarAppearance!');
end;

procedure TSpkToolbarAppearance.LoadFromIni(aIniFile: TCustomIniFile);
begin
  if not Assigned(aIniFile) then
    Exit;

  fTab.LoadFromIni(aIniFile);
  fPane.LoadFromIni(aIniFile);
  fElement.LoadFromIni(aIniFile);
end;

procedure TSpkToolbarAppearance.NotifyAppearanceChanged;
begin
  if Assigned(fDispatch) then
     fDispatch.NotifyAppearanceChanged;
end;

procedure TSpkToolbarAppearance.Reset(aStyle: TSpkStyle = spkOffice2007Blue);
begin
  fTab.Reset(aStyle);
  fPane.Reset(aStyle);
  fElement.Reset(aStyle);
  if Assigned(fAppearanceDispatch) then
     fAppearanceDispatch.NotifyAppearanceChanged;
end;

procedure TSpkToolbarAppearance.SaveToPascal(aList: TStrings);
begin
  aList.Add('with Appearance do begin');
  fTab.SaveToPascal(aList);
  fPane.SaveToPascal(aList);
  fElement.SaveToPascal(aList);
  aList.Add('end;');
end;

procedure TSpkToolbarAppearance.SaveToIni(aIniFile: TCustomIniFile);
begin
  fTab.SaveToIni(aIniFile);
  fPane.SaveToIni(aIniFile);
  fElement.SaveToIni(aIniFile);
end;

procedure TSpkToolbarAppearance.SetElementAppearance(
  const Value: TSpkElementAppearance);
begin
  fElement.Assign(Value);
end;

procedure TSpkToolbarAppearance.SetPaneAppearance(const Value: TSpkPaneAppearance);
begin
  fPane.Assign(Value);
end;

procedure TSpkToolbarAppearance.SetTabAppearance(const Value: TSpkTabAppearance);
begin
  fTab.Assign(Value);
end;

end.
