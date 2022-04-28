unit SpkAppearanceEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, SpkTab,
  SpkGUITools,
  SpkButtons, SpkBaseItem, SpkPane, SpkTypes, SpkToolbar,
  SpkAppearance;

type
  TfrmAppearanceEditWindow = class(TForm)
    gbPreview: TGroupBox;
    tbPreview: TSpkToolbar;
    SpkTab1: TSpkTab;
    SpkPane1: TSpkPane;
    SpkLargeButton1: TSpkLargeButton;
    SpkLargeButton3: TSpkLargeButton;
    SpkLargeButton2: TSpkLargeButton;
    SpkPane2: TSpkPane;
    SpkSmallButton1: TSpkSmallButton;
    SpkSmallButton2: TSpkSmallButton;
    SpkSmallButton3: TSpkSmallButton;
    SpkPane3: TSpkPane;
    SpkSmallButton4: TSpkSmallButton;
    SpkSmallButton5: TSpkSmallButton;
    SpkSmallButton6: TSpkSmallButton;
    SpkSmallButton7: TSpkSmallButton;
    SpkSmallButton8: TSpkSmallButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Label2: TLabel;
    pTabFrame: TPanel;
    pTabGradientFrom: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    pTabGradientTo: TPanel;
    cbTabGradientKind: TComboBox;
    Label5: TLabel;
    Label6: TLabel;
    pTabHeaderFont: TPanel;
    Label8: TLabel;
    pPaneBorderDark: TPanel;
    pPaneBorderLight: TPanel;
    Label21: TLabel;
    Label9: TLabel;
    pPaneGradientFrom: TPanel;
    pPaneGradientTo: TPanel;
    Label10: TLabel;
    Label11: TLabel;
    cbPaneGradientKind: TComboBox;
    pPaneCaptionBackground: TPanel;
    Label12: TLabel;
    Label13: TLabel;
    pPaneCaptionFont: TPanel;
    Label1: TLabel;
    Label7: TLabel;
    Label14: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    pItemFont: TPanel;
    cbItemIdleGradientKind: TComboBox;
    pItemIdleGradientTo: TPanel;
    pItemIdleGradientFrom: TPanel;
    pItemIdleFrame: TPanel;
    Label27: TLabel;
    Label28: TLabel;
    pItemIdleCaptionColor: TPanel;
    Label29: TLabel;
    pItemIdleInnerDark: TPanel;
    Label30: TLabel;
    pItemIdleInnerLight: TPanel;
    cbItemHottrackGradientKind: TComboBox;
    pItemHottrackGradientTo: TPanel;
    pItemHottrackGradientFrom: TPanel;
    pItemHottrackFrame: TPanel;
    Label15: TLabel;
    pItemHottrackCaptionColor: TPanel;
    pItemHottrackInnerDark: TPanel;
    pItemHottrackInnerLight: TPanel;
    cbItemActiveGradientKind: TComboBox;
    pItemActiveGradientTo: TPanel;
    pItemActiveGradientFrom: TPanel;
    pItemActiveFrame: TPanel;
    Label16: TLabel;
    pItemActiveCaptionColor: TPanel;
    pItemActiveInnerDark: TPanel;
    pItemActiveInnerLight: TPanel;
    bOK: TButton;
    bCancel: TButton;
    cdColorDialog: TColorDialog;
    fdFontDialog: TFontDialog;
    pTabHeaderFontColor: TPanel;
    pPaneCaptionFontColor: TPanel;
    TabSheet4: TTabSheet;
    bImport: TButton;
    bExport: TButton;
    mXML: TMemo;
    sTabRectangle: TShape;
    cbLinkTab: TCheckBox;
    sPaneRectangle: TShape;
    cbLinkPane: TCheckBox;
    cbLinkItem: TCheckBox;
    sItemRectangle: TShape;
    TabSheet5: TTabSheet;
    Label17: TLabel;
    bReset: TButton;
    procedure pTabFrameClick(Sender: TObject);
    procedure pTabGradientFromClick(Sender: TObject);
    procedure pTabGradientToClick(Sender: TObject);
    procedure pPaneBorderDarkClick(Sender: TObject);
    procedure pPaneBorderLightClick(Sender: TObject);
    procedure pPaneGradientFromClick(Sender: TObject);
    procedure pPaneGradientToClick(Sender: TObject);
    procedure pPaneCaptionBackgroundClick(Sender: TObject);
    procedure pItemIdleFrameClick(Sender: TObject);
    procedure pItemIdleGradientFromClick(Sender: TObject);
    procedure pItemIdleGradientToClick(Sender: TObject);
    procedure pItemIdleCaptionColorClick(Sender: TObject);
    procedure pItemIdleInnerDarkClick(Sender: TObject);
    procedure pItemIdleInnerLightClick(Sender: TObject);
    procedure pItemHottrackFrameClick(Sender: TObject);
    procedure pItemHottrackGradientFromClick(Sender: TObject);
    procedure pItemHottrackGradientToClick(Sender: TObject);
    procedure pItemHottrackCaptionColorClick(Sender: TObject);
    procedure pItemHottrackInnerDarkClick(Sender: TObject);
    procedure pItemHottrackInnerLightClick(Sender: TObject);
    procedure pItemActiveFrameClick(Sender: TObject);
    procedure pItemActiveGradientFromClick(Sender: TObject);
    procedure pItemActiveGradientToClick(Sender: TObject);
    procedure pItemActiveCaptionColorClick(Sender: TObject);
    procedure pItemActiveInnerDarkClick(Sender: TObject);
    procedure pItemActiveInnerLightClick(Sender: TObject);
    procedure pTabHeaderFontClick(Sender: TObject);
    procedure pPaneCaptionFontClick(Sender: TObject);
    procedure pItemFontClick(Sender: TObject);
    procedure cbTabGradientKindChange(Sender: TObject);
    procedure cbPaneGradientKindChange(Sender: TObject);
    procedure cbItemIdleGradientKindChange(Sender: TObject);
    procedure cbItemHottrackGradientKindChange(Sender: TObject);
    procedure cbItemActiveGradientKindChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure pTabHeaderFontColorClick(Sender: TObject);
    procedure pPaneCaptionFontColorClick(Sender: TObject);
    procedure bExportClick(Sender: TObject);
    procedure bImportClick(Sender: TObject);
    procedure cbLinkTabClick(Sender: TObject);
    procedure cbLinkPaneClick(Sender: TObject);
    procedure cbLinkItemClick(Sender: TObject);
    procedure bResetClick(Sender: TObject);
  private
    { Private declarations }
    procedure SetLinkedFrameColor(AColor : TColor);
    procedure SetLinkedGradientFromColor(AColor : TColor);
    procedure SetLinkedGradientToColor(AColor : TColor);
    procedure SetLinkedGradientKind(AKindIndex : integer);

    function GetAppearance: TSpkToolbarAppearance;
    procedure SetAppearance(const Value: TSpkToolbarAppearance);

    procedure SwitchAttributesLink(const Value : boolean);

    function ChangeColor(Panel : TPanel) : boolean;
    procedure SetPanelColor(Panel: TPanel; AColor : TColor);
    function ChangeFont(Panel : TPanel) : boolean;
    procedure SetPanelFont(Panel : TPanel; AFont : TFont);
    procedure SetComboGradientKind(Combo : TComboBox; GradientType : TBackgroundKind);
    procedure LoadAppearance(AAppearance : TSpkToolbarAppearance);
  public
    property Appearance : TSpkToolbarAppearance read GetAppearance write SetAppearance;
    { Public declarations }
  end;

var
  frmAppearanceEditWindow: TfrmAppearanceEditWindow;

implementation

uses
  IniFiles;

{$R *.dfm}

{ TForm3 }

procedure TfrmAppearanceEditWindow.SetAppearance(const Value: TSpkToolbarAppearance);
begin
tbPreview.Appearance.Assign(Value);
end;

procedure TfrmAppearanceEditWindow.SetComboGradientKind(Combo: TComboBox;
  GradientType: TBackgroundKind);
begin
case GradientType of
     bkSolid: Combo.itemindex:=0;
     bkHorizontalGradient: Combo.itemindex:=1;
     bkVerticalGradient: Combo.itemindex:=2;
     bkConcave: Combo.itemindex:=3;
end;
end;

procedure TfrmAppearanceEditWindow.SetLinkedFrameColor(AColor: TColor);
begin
tbPreview.Appearance.Tab.BorderColor:=AColor;
SetPanelColor(pTabFrame, AColor);

tbPreview.Appearance.Pane.BorderDarkColor:=AColor;
SetPanelColor(pPaneBorderDark, AColor);

tbPreview.Appearance.Element.IdleFrameColor:=AColor;
SetPanelColor(pItemIdleFrame, AColor);
end;

procedure TfrmAppearanceEditWindow.SetLinkedGradientFromColor(AColor: TColor);
begin
tbPreview.Appearance.Tab.GradientFromColor:=AColor;
SetPanelColor(pTabGradientFrom, AColor);

tbPreview.Appearance.Pane.GradientFromColor:=AColor;
SetPanelColor(pPaneGradientFrom, AColor);

tbPreview.Appearance.Element.IdleGradientFromColor:=AColor;
SetPanelColor(pItemIdleGradientFrom, AColor);
end;

procedure TfrmAppearanceEditWindow.SetLinkedGradientKind(AKindIndex: integer);

var Kind : TBackgroundKind;

begin
case AKindIndex of
     0 : Kind:=bkSolid;
     1 : Kind:=bkHorizontalGradient;
     2 : Kind:=bkVerticalGradient;
     3 : Kind:=bkConcave;
else Kind:=bkSolid;
end;

tbPreview.Appearance.Tab.GradientType:=Kind;
SetComboGradientKind(cbTabGradientKind, Kind);

tbPreview.Appearance.Pane.GradientType:=Kind;
SetComboGradientKind(cbPaneGradientKind, Kind);

tbPreview.Appearance.Element.IdleGradientType:=Kind;
SetComboGradientKind(cbItemIdleGradientKind, Kind);
end;

procedure TfrmAppearanceEditWindow.SetLinkedGradientToColor(AColor: TColor);
begin
tbPreview.Appearance.Tab.GradientToColor:=AColor;
SetPanelColor(pTabGradientTo, AColor);

tbPreview.Appearance.Pane.GradientToColor:=AColor;
SetPanelColor(pPaneGradientTo, AColor);

tbPreview.Appearance.Element.IdleGradientToColor:=AColor;
SetPanelColor(pItemIdleGradientTo, AColor);
end;

procedure TfrmAppearanceEditWindow.SetPanelColor(Panel: TPanel; AColor : TColor);
begin
  Panel.Color := AColor;
  if Panel.Color<>AColor then
     Showmessage('lipa!');
  if (GetRValue(AColor) + GetGValue(AColor) + GetBValue(AColor)) div 3 >= 128 then
    Panel.Font.Color := clBlack
  else
    Panel.Font.Color := clWhite;
  Panel.Caption := '$' + IntToHex(AColor, 8);
end;

procedure TfrmAppearanceEditWindow.SetPanelFont(Panel: TPanel; AFont: TFont);
begin
Panel.Font.assign(AFont);
Panel.Caption:=AFont.Name+', '+inttostr(AFont.Size);
end;

procedure TfrmAppearanceEditWindow.SwitchAttributesLink(const Value: boolean);
begin
cbLinkTab.checked:=Value;
cbLinkPane.Checked:=Value;
cbLinkItem.Checked:=Value;

sTabRectangle.visible:=Value;
sPaneRectangle.Visible:=Value;
sItemRectangle.Visible:=Value;
end;

procedure TfrmAppearanceEditWindow.cbItemHottrackGradientKindChange(Sender: TObject);
begin
case (Sender as TCombobox).ItemIndex of
     0 : tbPreview.Appearance.Element.HottrackGradientType:=bkSolid;
     1 : tbPreview.Appearance.Element.HottrackGradientType:=bkHorizontalGradient;
     2 : tbPreview.Appearance.Element.HottrackGradientType:=bkVerticalGradient;
     3 : tbPreview.Appearance.Element.HottrackGradientType:=bkConcave;
end;
end;

procedure TfrmAppearanceEditWindow.cbItemIdleGradientKindChange(Sender: TObject);
begin
case (Sender as TCombobox).ItemIndex of
     0 : tbPreview.Appearance.Element.IdleGradientType:=bkSolid;
     1 : tbPreview.Appearance.Element.IdleGradientType:=bkHorizontalGradient;
     2 : tbPreview.Appearance.Element.IdleGradientType:=bkVerticalGradient;
     3 : tbPreview.Appearance.Element.IdleGradientType:=bkConcave;
end;

if cbLinkItem.Checked then
   SetLinkedGradientKind((Sender as TComboBox).ItemIndex);
end;

procedure TfrmAppearanceEditWindow.cbLinkItemClick(Sender: TObject);
begin
SwitchAttributesLink(cbLinkItem.Checked);
end;

procedure TfrmAppearanceEditWindow.cbLinkPaneClick(Sender: TObject);
begin
SwitchAttributesLink(cbLinkPane.Checked);
end;

procedure TfrmAppearanceEditWindow.cbLinkTabClick(Sender: TObject);
begin
SwitchAttributesLink(cbLinkTab.Checked);
end;

procedure TfrmAppearanceEditWindow.cbTabGradientKindChange(Sender: TObject);
begin
case (Sender as TCombobox).ItemIndex of
     0 : tbPreview.Appearance.Tab.GradientType:=bkSolid;
     1 : tbPreview.Appearance.Tab.GradientType:=bkHorizontalGradient;
     2 : tbPreview.Appearance.Tab.GradientType:=bkVerticalGradient;
     3 : tbPreview.Appearance.Tab.GradientType:=bkConcave;
end;

if cbLinkTab.Checked then
   SetLinkedGradientKind((Sender as TComboBox).ItemIndex);
end;

function TfrmAppearanceEditWindow.ChangeColor(Panel: TPanel): boolean;
begin
cdColorDialog.Color:=Panel.Color;
if cdColorDialog.Execute then
   begin
   SetPanelColor(Panel, cdColorDialog.Color);
   result:=true
   end
else
   result:=false;
end;

function TfrmAppearanceEditWindow.ChangeFont(Panel: TPanel): boolean;
begin
fdFontDialog.Font.assign(Panel.font);
if fdFontDialog.Execute then
   begin
   SetPanelFont(Panel, fdFontDialog.Font);
   result:=true;
   end
else
   result:=false;
end;

procedure TfrmAppearanceEditWindow.FormShow(Sender: TObject);
begin
LoadAppearance(tbPreview.Appearance);
end;

function TfrmAppearanceEditWindow.GetAppearance: TSpkToolbarAppearance;
begin
result:=tbPreview.Appearance;
end;

procedure TfrmAppearanceEditWindow.LoadAppearance(AAppearance: TSpkToolbarAppearance);
begin
with AAppearance do
     begin
     with Tab do
          begin
          SetPanelColor(pTabFrame, BorderColor);
          SetPanelColor(pTabGradientFrom, GradientFromColor);
          SetPanelColor(pTabGradientTo, GradientToColor);
          SetComboGradientKind(cbTabGradientKind, GradientType);
          SetPanelFont(pTabHeaderFont, TabHeaderFont);
          SetPanelColor(pTabHeaderFontColor, TabHeaderFont.Color);
          end;

     with Pane do
          begin
          SetPanelColor(pPaneBorderDark, BorderDarkColor);
          SetPanelColor(pPaneBorderLight, BorderLightColor);
          SetPanelColor(pPaneGradientFrom, GradientFromColor);
          SetPanelColor(pPaneGradientTo, GradientToColor);
          SetComboGradientKind(cbPaneGradientKind, GradientType);
          SetPanelColor(pPaneCaptionBackground, CaptionBgColor);
          SetPanelFont(pPaneCaptionFont, CaptionFont);
          SetPanelColor(pPaneCaptionFontColor, CaptionFont.Color);
          end;

     with Element do
          begin
          SetPanelFont(pItemFont, CaptionFont);

          SetPanelColor(pItemIdleFrame, IdleFrameColor);
          SetPanelColor(pItemIdleGradientFrom, IdleGradientFromColor);
          SetPanelColor(pItemIdleGradientTo, IdleGradientToColor);
          SetComboGradientKind(cbItemIdleGradientKind, IdleGradientType);
          SetPanelColor(pItemIdleCaptionColor, IdleCaptionColor);
          SetPanelColor(pItemIdleInnerDark, IdleInnerDarkColor);
          SetPanelColor(pItemIdleInnerLight, IdleInnerLightColor);

          SetPanelColor(pItemHottrackFrame, HottrackFrameColor);
          SetPanelColor(pItemHottrackGradientFrom, HottrackGradientFromColor);
          SetPanelColor(pItemHottrackGradientTo, HottrackGradientToColor);
          SetComboGradientKind(cbItemHottrackGradientKind, HottrackGradientType);
          SetPanelColor(pItemHottrackCaptionColor, HottrackCaptionColor);
          SetPanelColor(pItemHottrackInnerDark, HottrackInnerDarkColor);
          SetPanelColor(pItemHottrackInnerLight, HottrackInnerLightColor);

          SetPanelColor(pItemActiveFrame, ActiveFrameColor);
          SetPanelColor(pItemActiveGradientFrom, ActiveGradientFromColor);
          SetPanelColor(pItemActiveGradientTo, ActiveGradientToColor);
          SetComboGradientKind(cbItemActiveGradientKind, ActiveGradientType);
          SetPanelColor(pItemActiveCaptionColor, ActiveCaptionColor);
          SetPanelColor(pItemActiveInnerDark, ActiveInnerDarkColor);
          SetPanelColor(pItemActiveInnerLight, ActiveInnerLightColor);
          end;
     end;
end;

procedure TfrmAppearanceEditWindow.pItemActiveCaptionColorClick(Sender: TObject);
begin
if ChangeColor(Sender as TPanel) then
   tbPreview.Appearance.Element.ActiveCaptionColor:=(Sender as TPanel).Color;
end;

procedure TfrmAppearanceEditWindow.pItemActiveFrameClick(Sender: TObject);
begin
if ChangeColor(Sender as TPanel) then
   tbPreview.Appearance.Element.ActiveFrameColor:=(Sender as TPanel).Color;
end;

procedure TfrmAppearanceEditWindow.pItemActiveGradientFromClick(Sender: TObject);
begin
if ChangeColor(Sender as TPanel) then
   tbPreview.Appearance.Element.ActiveGradientFromColor:=(Sender as TPanel).Color;
end;

procedure TfrmAppearanceEditWindow.bExportClick(Sender: TObject);
var
  LIni: TMemIniFile;
  LStrings: TStrings;
begin
  LIni := TMemIniFile.Create('');
  LStrings := TStringList.Create;
  try
    tbPreview.Appearance.SaveToIni(LIni);
    LIni.GetStrings(LStrings);
    mXML.Lines.Text := LStrings.Text;
  finally
    LIni.Free;
    LStrings.Free;
  end;
end;

procedure TfrmAppearanceEditWindow.bImportClick(Sender: TObject);
var
  LIni: TMemIniFile;
  LStrings: TStrings;
begin
  LIni := TMemIniFile.Create('');
  try
    LIni.SetStrings(mXML.Lines);
    tbPreview.Appearance.LoadFromIni(LIni);
  finally
    LIni.Free;
  end;
end;

procedure TfrmAppearanceEditWindow.bResetClick(Sender: TObject);
begin
tbPreview.Appearance.Reset;
LoadAppearance(tbPreview.Appearance);
end;

procedure TfrmAppearanceEditWindow.cbItemActiveGradientKindChange(Sender: TObject);
begin
case (Sender as TCombobox).ItemIndex of
     0 : tbPreview.Appearance.Element.ActiveGradientType:=bkSolid;
     1 : tbPreview.Appearance.Element.ActiveGradientType:=bkHorizontalGradient;
     2 : tbPreview.Appearance.Element.ActiveGradientType:=bkVerticalGradient;
     3 : tbPreview.Appearance.Element.ActiveGradientType:=bkConcave;
end;
end;

procedure TfrmAppearanceEditWindow.pItemActiveGradientToClick(Sender: TObject);
begin
if ChangeColor(Sender as TPanel) then
   tbPreview.Appearance.Element.ActiveGradientToColor:=(Sender as TPanel).Color;
end;

procedure TfrmAppearanceEditWindow.pItemActiveInnerDarkClick(Sender: TObject);
begin
if ChangeColor(Sender as TPanel) then
   tbPreview.Appearance.Element.ActiveInnerDarkColor:=(Sender as TPanel).Color;
end;

procedure TfrmAppearanceEditWindow.pItemActiveInnerLightClick(Sender: TObject);
begin
if ChangeColor(Sender as TPanel) then
   tbPreview.Appearance.Element.ActiveInnerLightColor:=(Sender as TPanel).Color;
end;

procedure TfrmAppearanceEditWindow.pItemHottrackCaptionColorClick(Sender: TObject);
begin
if ChangeColor(Sender as TPanel) then
   tbPreview.Appearance.Element.HotTrackCaptionColor:=(Sender as TPanel).Color;
end;

procedure TfrmAppearanceEditWindow.pItemHottrackFrameClick(Sender: TObject);
begin
if ChangeColor(Sender as TPanel) then
   tbPreview.Appearance.Element.HotTrackFrameColor:=(Sender as TPanel).Color;
end;

procedure TfrmAppearanceEditWindow.pItemHottrackGradientFromClick(Sender: TObject);
begin
if ChangeColor(Sender as TPanel) then
   tbPreview.Appearance.Element.HotTrackGradientFromColor:=(Sender as TPanel).Color;
end;

procedure TfrmAppearanceEditWindow.pItemHottrackGradientToClick(Sender: TObject);
begin
if ChangeColor(Sender as TPanel) then
   tbPreview.Appearance.Element.HotTrackGradientToColor:=(Sender as TPanel).Color;
end;

procedure TfrmAppearanceEditWindow.pItemHottrackInnerDarkClick(Sender: TObject);
begin
if ChangeColor(Sender as TPanel) then
   tbPreview.Appearance.Element.HotTrackInnerDarkColor:=(Sender as TPanel).Color;
end;

procedure TfrmAppearanceEditWindow.pItemHottrackInnerLightClick(Sender: TObject);
begin
if ChangeColor(Sender as TPanel) then
   tbPreview.Appearance.Element.HotTrackInnerLightColor:=(Sender as TPanel).Color;
end;

procedure TfrmAppearanceEditWindow.pItemIdleCaptionColorClick(Sender: TObject);
begin
if ChangeColor(Sender as TPanel) then
   tbPreview.Appearance.Element.IdleCaptionColor:=(Sender as TPanel).Color;
end;

procedure TfrmAppearanceEditWindow.pItemIdleFrameClick(Sender: TObject);
begin
if ChangeColor(Sender as TPanel) then
   begin
   tbPreview.Appearance.Element.IdleFrameColor:=(Sender as TPanel).Color;

   if cbLinkItem.Checked then
      SetLinkedFrameColor((Sender as TPanel).Color);
   end;
end;

procedure TfrmAppearanceEditWindow.pItemIdleGradientFromClick(Sender: TObject);
begin
if ChangeColor(Sender as TPanel) then
   begin
   tbPreview.Appearance.Element.IdleGradientFromColor:=(Sender as TPanel).Color;

   if cbLinkItem.Checked then
      SetLinkedGradientFromColor((Sender as TPanel).Color);
   end;
end;

procedure TfrmAppearanceEditWindow.pItemIdleGradientToClick(Sender: TObject);
begin
if ChangeColor(Sender as TPanel) then
   begin
   tbPreview.Appearance.Element.IdleGradientToColor:=(Sender as TPanel).Color;

   if cbLinkItem.Checked then
      SetLinkedGradientToColor((Sender as TPanel).Color);
   end;
end;

procedure TfrmAppearanceEditWindow.pItemIdleInnerDarkClick(Sender: TObject);
begin
if ChangeColor(Sender as TPanel) then
   tbPreview.Appearance.Element.IdleInnerDarkColor:=(Sender as TPanel).Color;
end;

procedure TfrmAppearanceEditWindow.pItemIdleInnerLightClick(Sender: TObject);
begin
if ChangeColor(Sender as TPanel) then
   tbPreview.Appearance.Element.IdleInnerLightColor:=(Sender as TPanel).Color;
end;

procedure TfrmAppearanceEditWindow.pItemFontClick(Sender: TObject);
begin
if ChangeFont(Sender as TPanel) then
   tbPreview.Appearance.Element.CaptionFont.Assign((Sender as TPanel).Font);
tbPreview.ForceRepaint;
end;

procedure TfrmAppearanceEditWindow.pPaneBorderDarkClick(Sender: TObject);
begin
if ChangeColor(Sender as TPanel) then
   begin
   tbPreview.Appearance.Pane.BorderDarkColor:=(Sender as TPanel).Color;

   if cbLinkPane.Checked then
      SetLinkedFrameColor((Sender as TPanel).Color);
   end;
end;

procedure TfrmAppearanceEditWindow.pPaneBorderLightClick(Sender: TObject);
begin
if ChangeColor(Sender as TPanel) then
   tbPreview.Appearance.Pane.BorderLightColor:=(Sender as TPanel).Color;
end;

procedure TfrmAppearanceEditWindow.pPaneCaptionBackgroundClick(Sender: TObject);
begin
if ChangeColor(Sender as TPanel) then
   tbPreview.Appearance.Pane.CaptionBgColor:=(Sender as TPanel).Color;
end;

procedure TfrmAppearanceEditWindow.pPaneCaptionFontClick(Sender: TObject);
begin
if ChangeFont(Sender as TPanel) then
   tbPreview.Appearance.Pane.CaptionFont.Assign((Sender as TPanel).Font);
tbPreview.ForceRepaint;
end;

procedure TfrmAppearanceEditWindow.pPaneCaptionFontColorClick(Sender: TObject);
begin
if ChangeColor(Sender as TPanel) then
   begin
   tbPreview.Appearance.Pane.CaptionFont.Color:=((Sender as TPanel).Color);
   pPaneCaptionFont.Font.color:=((Sender as TPanel).Color);
   end;
end;

procedure TfrmAppearanceEditWindow.pPaneGradientFromClick(Sender: TObject);
begin
if ChangeColor(Sender as TPanel) then
   begin
   tbPreview.Appearance.Pane.GradientFromColor:=(Sender as TPanel).Color;

   if cbLinkPane.Checked then
      SetLinkedGradientFromColor((Sender as TPanel).Color);
   end;
end;

procedure TfrmAppearanceEditWindow.cbPaneGradientKindChange(Sender: TObject);
begin
case (Sender as TCombobox).ItemIndex of
     0 : tbPreview.Appearance.Pane.GradientType:=bkSolid;
     1 : tbPreview.Appearance.Pane.GradientType:=bkHorizontalGradient;
     2 : tbPreview.Appearance.Pane.GradientType:=bkVerticalGradient;
     3 : tbPreview.Appearance.Pane.GradientType:=bkConcave;
end;

if cbLinkPane.Checked then
   SetLinkedGradientKind((Sender as TComboBox).ItemIndex);
end;

procedure TfrmAppearanceEditWindow.pPaneGradientToClick(Sender: TObject);
begin
if ChangeColor(Sender as TPanel) then
   begin
   tbPreview.Appearance.Pane.GradientToColor:=(Sender as TPanel).Color;

   if cbLinkPane.Checked then
      SetLinkedGradientToColor((Sender as TPanel).Color);
   end;
end;

procedure TfrmAppearanceEditWindow.pTabFrameClick(Sender: TObject);
begin
if ChangeColor(Sender as TPanel) then
   begin
   tbPreview.Appearance.Tab.BorderColor:=(Sender as TPanel).Color;

   if cbLinkTab.checked then
      SetLinkedFrameColor((Sender as TPanel).Color);
   end;
end;

procedure TfrmAppearanceEditWindow.pTabGradientFromClick(Sender: TObject);
begin
if ChangeColor(Sender as TPanel) then
   begin
   tbPreview.Appearance.Tab.GradientFromColor:=(Sender as TPanel).Color;

   if cbLinkTab.Checked then
      SetLinkedGradientFromColor((Sender as TPanel).Color);
   end;
end;

procedure TfrmAppearanceEditWindow.pTabGradientToClick(Sender: TObject);
begin
if ChangeColor(Sender as TPanel) then
   begin
   tbPreview.Appearance.Tab.GradientToColor:=(Sender as TPanel).Color;

   if cbLinkTab.Checked then
      SetLinkedGradientToColor((Sender as TPanel).Color);
   end;
end;

procedure TfrmAppearanceEditWindow.pTabHeaderFontClick(Sender: TObject);
begin
if ChangeFont(Sender as TPanel) then
   tbPreview.Appearance.Tab.TabHeaderFont.Assign((Sender as TPanel).Font);
tbPreview.ForceRepaint;
end;

procedure TfrmAppearanceEditWindow.pTabHeaderFontColorClick(Sender: TObject);
begin
if ChangeColor(Sender as TPanel) then
   begin
   tbPreview.Appearance.Tab.TabHeaderFont.Color:=((Sender as TPanel).Color);
   pTabHeaderFont.Font.color:=((Sender as TPanel).Color);
   end;
end;

end.
