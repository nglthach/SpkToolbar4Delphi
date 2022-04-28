unit SpkItems;

interface

{$I Spk.inc}

uses
  Classes,
  Controls,
  SysUtils,
  SpkAppearance,
  SpkBaseItem,
  SpkTypes,
  SpkButtons,
  SpkCheckboxes;

type
  TSpkItems = class(TSpkCollection)
  private
    fToolbarDispatch: TSpkBaseToolbarDispatch;
    fAppearance: TSpkToolbarAppearance;
    fImages: TImageList;
    fDisabledImages: TImageList;
    fLargeImages: TImageList;
    fDisabledLargeImages: TImageList;
    fImagesWidth: Integer;
    fLargeImagesWidth: Integer;
    procedure SetToolbarDispatch(const Value: TSpkBaseToolbarDispatch);
    function GetItems(aIndex: integer): TSpkBaseItem; reintroduce;
    procedure SetAppearance(const Value: TSpkToolbarAppearance);
    procedure SetImages(const Value: TImageList);
    procedure SetDisabledImages(const Value: TImageList);
    procedure SetLargeImages(const Value: TImageList);
    procedure SetDisabledLargeImages(const Value: TImageList);
    procedure SetImagesWidth(const Value: Integer);
    procedure SetLargeImagesWidth(const Value: Integer);
  public
    function AddLargeButton: TSpkLargeButton;
    function AddSmallButton: TSpkSmallButton;
    function AddCheckbox: TSpkCheckbox;
    function AddRadioButton: TSpkRadioButton;
    // *** Reaction to changes in the list ***
    procedure Notify(Item: TComponent; Operation: TOperation); override;
    procedure Update; override;
  public
    property Items[index: integer]: TSpkBaseItem read GetItems; default;
    property ToolbarDispatch: TSpkBaseToolbarDispatch read fToolbarDispatch write SetToolbarDispatch;
    property Appearance: TSpkToolbarAppearance read fAppearance write SetAppearance;
    property Images: TImageList read fImages write SetImages;
    property DisabledImages: TImageList read fDisabledImages write SetDisabledImages;
    property LargeImages: TImageList read fLargeImages write SetLargeImages;
    property DisabledLargeImages: TImageList read fDisabledLargeImages write SetDisabledLargeImages;
    property ImagesWidth: Integer read fImagesWidth write SetImagesWidth;
    property LargeImagesWidth: Integer read fLargeImagesWidth write SetLargeImagesWidth;
  end;

implementation

{ TSpkItems }

function TSpkItems.AddLargeButton: TSpkLargeButton;
begin
  Result := TSpkLargeButton.Create(fRootComponent);
  Result.Parent := fRootComponent;
  AddItem(Result);
end;

function TSpkItems.AddSmallButton: TSpkSmallButton;
begin
  Result := TSpkSmallButton.Create(fRootComponent);
  Result.Parent := fRootComponent;
  AddItem(Result);
end;

function TSpkItems.AddCheckbox: TSpkCheckbox;
begin
  Result := TSpkCheckbox.Create(fRootComponent);
  Result.Parent := fRootComponent;
  AddItem(Result);
end;

function TSpkItems.AddRadioButton: TSpkRadioButton;
begin
  Result := TSpkRadioButton.Create(fRootComponent);
  Result.Parent := fRootComponent;
  AddItem(Result);
end;

function TSpkItems.GetItems(aIndex: integer): TSpkBaseItem;
begin
  Result := TSpkBaseItem(inherited Items[aIndex]);
end;

procedure TSpkItems.Notify(Item: TComponent; Operation: TOperation);
begin
  inherited Notify(Item, Operation);

  case Operation of
    opInsert:
      begin
        // Setting the dispatcher to nil will cause that during the ownership
        // assignment, the Notify method will not be called
        TSpkBaseItem(Item).ToolbarDispatch := nil;
        TSpkBaseItem(Item).Appearance := fAppearance;
        TSpkBaseItem(Item).Images := fImages;
        TSpkBaseItem(Item).DisabledImages := fDisabledImages;
        TSpkBaseItem(Item).LargeImages := fLargeImages;
        TSpkBaseItem(Item).DisabledLargeImages := fDisabledLargeImages;
        TSpkBaseItem(Item).ImagesWidth := fImagesWidth;
        TSpkBaseItem(Item).LargeImagesWidth := fLargeImagesWidth;
        TSpkBaseItem(Item).ToolbarDispatch := fToolbarDispatch;
      end;

    opRemove:
      if not (csDestroying in Item.ComponentState) then
      begin
        TSpkBaseItem(Item).ToolbarDispatch := nil;
        TSpkBaseItem(Item).Appearance := nil;
        TSpkBaseItem(Item).Images := nil;
        TSpkBaseItem(Item).DisabledImages := nil;
        TSpkBaseItem(Item).LargeImages := nil;
        TSpkBaseItem(Item).DisabledLargeImages := nil;
      end;
  end;
end;

procedure TSpkItems.SetAppearance(const Value: TSpkToolbarAppearance);
var
  i: Integer;
begin
  fAppearance := Value;
  for i := 0 to Count - 1 do
    Items[i].Appearance := Value;
end;

procedure TSpkItems.SetDisabledImages(const Value: TImageList);
var
  i: Integer;
begin
  fDisabledImages := Value;
  for i := 0 to Count - 1 do
    Items[i].DisabledImages := Value;
end;

procedure TSpkItems.SetDisabledLargeImages(const Value: TImageList);
var
  i: Integer;
begin
  fDisabledLargeImages := Value;
  for i := 0 to Count - 1 do
    Items[i].DisabledLargeImages := Value;
end;

procedure TSpkItems.SetImages(const Value: TImageList);
var
  i: Integer;
begin
  fImages := Value;
  for i := 0 to Count - 1 do
    Items[i].Images := Value;
end;

procedure TSpkItems.SetImagesWidth(const Value: Integer);
var
  i: Integer;
begin
  fImagesWidth := Value;
  for i := 0 to Count - 1 do
    Items[i].ImagesWidth := Value;
end;

procedure TSpkItems.SetLargeImages(const Value: TImageList);
var
  i: Integer;
begin
  fLargeImages := Value;
  for i := 0 to Count - 1 do
    Items[i].LargeImages := Value;
end;

procedure TSpkItems.SetLargeImagesWidth(const Value: Integer);
var
  i: Integer;
begin
  fLargeImagesWidth := Value;
  for i := 0 to Count - 1 do
    Items[i].LargeImagesWidth := Value;
end;

procedure TSpkItems.SetToolbarDispatch(const Value: TSpkBaseToolbarDispatch);
var
  i : integer;
begin
  fToolbarDispatch := Value;
  for i := 0 to Count - 1 do
    Items[i].ToolbarDispatch := Value;
end;

procedure TSpkItems.Update;
begin
  inherited Update;
  if Assigned(fToolbarDispatch) then
     fToolbarDispatch.NotifyItemsChanged;
end;

end.
