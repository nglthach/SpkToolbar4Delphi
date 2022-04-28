unit SpkBaseItem;

interface

{$I Spk.inc}

uses
  Graphics,
  Classes,
  Controls,
  SpkAppearance,
  SpkMath,
  SpkTypes;

type
  TSpkItemSizeType = (
    isLarge,
    isNormal
  );

  TSpkItemTableBehaviour = (
    tbBeginsRow,
    tbBeginsColumn,
    tbContinuesRow
  );

  TSpkItemGroupBehaviour = (
    gbSingleItem,
    gbBeginsGroup,
    gbContinuesGroup,
    gbEndsGroup
  );

  /// <summary>
  ///
  /// </summary>
  TSpkBaseItem = class abstract(TSpkComponent)
  protected
    fAppearance: TSpkToolbarAppearance;
    fBeginAGroup: Boolean;
    fDisabledImages: TImageList;
    fDisabledLargeImages: TImageList;
    fEnabled: Boolean;
    fImages: TImageList;
    fImagesWidth: Integer;
    fLargeImages: TImageList;
    fLargeImagesWidth: Integer;
    fRect: T2DIntRect;
    fToolbarDispatch: TSpkBaseToolbarDispatch;
    fVisible: Boolean;
    procedure SetAppearance(const aValue: TSpkToolbarAppearance);
    procedure SetBeginAGroup(const Value: Boolean);
    procedure SetDisabledImages(const aValue: TImageList); virtual;
    procedure SetDisabledLargeImages(const aValue: TImageList); virtual;
    procedure SetEnabled(const aValue: boolean); virtual;
    procedure SetImages(const aValue: TImageList); virtual;
    procedure SetImagesWidth(const aValue: Integer);
    procedure SetLargeImages(const aValue: TImageList); virtual;
    procedure SetLargeImagesWidth(const aValue: Integer);
    procedure SetRect(const aValue: T2DIntRect); virtual;
    procedure SetVisible(const aValue: boolean); virtual;
  public
    constructor Create(aOwner: TComponent); override;
    ///
    function GetWidth: integer; virtual; abstract;
    function GetTableBehaviour: TSpkItemTableBehaviour; virtual; abstract;
    function GetGroupBehaviour: TSpkItemGroupBehaviour; virtual; abstract;
    function GetSizeType: TSpkItemSizeType; virtual; abstract;
    ///
    procedure MouseLeave; virtual; abstract;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual; abstract;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); virtual; abstract;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual; abstract;
    ///
    procedure Draw(aBuffer: TBitmap; ClipRect: T2DIntRect); virtual; abstract;
    ///
    procedure NotifyVisualsChanged;
    procedure NotifyMetricsChanged;
  public
    property Appearance: TSpkToolbarAppearance read fAppearance write SetAppearance;
    property BeginAGroup: Boolean read fBeginAGroup write SetBeginAGroup default False;
    property DisabledImages: TImageList read fDisabledImages write SetDisabledImages;
    property DisabledLargeImages: TImageList read fDisabledLargeImages write SetDisabledLargeImages;
    property Images: TImageList read fImages write SetImages;
    property ImagesWidth: Integer read fImagesWidth write SetImagesWidth;
    property LargeImages: TImageList read fLargeImages write SetLargeImages;
    property LargeImagesWidth: Integer read fLargeImagesWidth write SetLargeImagesWidth;
    property Rect: T2DIntRect read fRect write SetRect;
    property ToolbarDispatch: TSpkBaseToolbarDispatch read fToolbarDispatch write fToolbarDispatch;
  published
    property Enabled: boolean read fEnabled write SetEnabled default True;
    property Visible: boolean read fVisible write SetVisible default True;
  end;

  TSpkBaseItemClass = class of TSpkBaseItem;

implementation

{ TSpkBaseItem }

constructor TSpkBaseItem.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);

  fRect := T2DIntRect.Create(0, 0, 0, 0);
  fToolbarDispatch := nil;
  fAppearance := nil;
  fImages := nil;
  fDisabledImages := nil;
  fLargeImages := nil;
  fDisabledLargeImages := nil;
  fVisible := true;
  fEnabled := true;
end;

procedure TSpkBaseItem.NotifyMetricsChanged;
begin
  if Assigned(fToolbarDispatch) then
    fToolbarDispatch.NotifyMetricsChanged;
end;

procedure TSpkBaseItem.NotifyVisualsChanged;
begin
  if Assigned(fToolbarDispatch) then
    fToolbarDispatch.NotifyVisualsChanged;
end;

procedure TSpkBaseItem.SetAppearance(const aValue: TSpkToolbarAppearance);
begin
  fAppearance := aValue;
  NotifyMetricsChanged;
end;

procedure TSpkBaseItem.SetBeginAGroup(const Value: Boolean);
begin
  if fBeginAGroup <> Value then
  begin
    fBeginAGroup := Value;
    NotifyMetricsChanged;
  end;
end;

procedure TSpkBaseItem.SetDisabledImages(const aValue: TImageList);
begin
  fDisabledImages := aValue;
end;

procedure TSpkBaseItem.SetDisabledLargeImages(const aValue: TImageList);
begin
  fDisabledLargeImages := aValue;
end;

procedure TSpkBaseItem.SetEnabled(const aValue: boolean);
begin
  if aValue <> fEnabled then
  begin
    fEnabled := aValue;
    NotifyVisualsChanged;
  end;
end;

procedure TSpkBaseItem.SetImages(const aValue: TImageList);
begin
  fImages := aValue;
end;

procedure TSpkBaseItem.SetImagesWidth(const aValue: Integer);
begin
  fImagesWidth := aValue;
end;

procedure TSpkBaseItem.SetLargeImages(const aValue: TImageList);
begin
  fLargeImages := aValue;
end;

procedure TSpkBaseItem.SetLargeImagesWidth(const aValue: Integer);
begin
  fLargeImagesWidth := aValue;
end;

procedure TSpkBaseItem.SetRect(const aValue: T2DIntRect);
begin
  fRect := aValue;
end;

procedure TSpkBaseItem.SetVisible(const aValue: boolean);
begin
  if aValue <> fVisible then
  begin
    fVisible := aValue;
    NotifyMetricsChanged;
  end;
end;

end.
