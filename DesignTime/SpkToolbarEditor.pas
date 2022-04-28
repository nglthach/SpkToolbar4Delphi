unit SpkToolbarEditor;

interface

uses Windows, Controls, Classes, DesignEditors, DesignIntf, TypInfo, Dialogs,
     SysUtils,
     spkToolbar, SpkTab, SpkPane, SpkAppearance,
     SpkEditWindow, SpkAppearanceEditor;

const PROPERTY_CONTENTS_NAME = 'Contents';
      PROPERTY_CONTENTS_VALUE = 'Open editor...';

type TAddContentsFilter = class(TSelectionEditor, ISelectionPropertyFilter)
     public
       procedure FilterProperties(const ASelection: IDesignerSelections; const ASelectionProperties: IInterfaceList);
     end;

type TSpkToolbarContentsEditor = class(TBasePropertyEditor, IProperty, IPropertyKind)
     private
     protected
       FPropList : PInstPropList;
       FPropCount : integer;
       FDesigner : IDesigner;
       FToolbar : TSpkToolbar;

       procedure SetPropEntry(Index: Integer; AInstance: TPersistent;
          APropInfo: PPropInfo); override;
       procedure Initialize; override;
     public
       constructor Create(const ADesigner: IDesigner; APropCount: Integer); override;
       destructor Destroy; override;

       procedure Activate;
       function AllEqual: Boolean;
       function AutoFill: Boolean;
       procedure Edit;
       function HasInstance(Instance: TPersistent): Boolean;
       function GetAttributes: TPropertyAttributes;
       function GetEditLimit: Integer;
       function GetEditValue(out Value: string): Boolean;
       function GetName: string;
       procedure GetProperties(Proc: TGetPropProc);
       function GetPropInfo: PPropInfo;
       function GetPropType: PTypeInfo;
       function GetValue: string;
       procedure GetValues(Proc: TGetStrProc);
       procedure Revert;
       procedure SetValue(const Value: string);
       function ValueAvailable: Boolean;

       function GetKind: TTypeKind;

       property PropCount : integer read FPropCount;
       property Designer : IDesigner read FDesigner;
       property Toolbar : TSpkToolbar read FToolbar write FToolbar;
     end;

type TSpkToolbarCaptionEditor = class(TStringProperty)
     private
     protected
     public
       procedure SetValue(const Value: string); override;
     end;

type TSpkToolbarAppearanceEditor = class(TClassProperty)
     private
     protected
     public
       function GetAttributes: TPropertyAttributes; override;
       procedure Edit; override;
     end;

type TSpkToolbarEditor = class(TComponentEditor)
     protected
       procedure DoOpenContentsEditor;
     public
       procedure Edit; override;
       procedure ExecuteVerb(Index: Integer); override;
       function GetVerb(Index: Integer): string; override;
       function GetVerbCount: Integer; override;
     end;

var EditWindow : TfrmEditWindow;

implementation

{ TSpkToolbarEditor }

procedure TSpkToolbarContentsEditor.Activate;
begin
//
end;

function TSpkToolbarContentsEditor.AllEqual: Boolean;
begin
result:=FPropCount = 1;
end;

function TSpkToolbarContentsEditor.AutoFill: Boolean;
begin
result:=false;
end;

constructor TSpkToolbarContentsEditor.Create(const ADesigner: IDesigner;
  APropCount: Integer);
begin
  inherited Create(ADesigner, APropCount);
  FDesigner:=ADesigner;
  FPropCount:=APropCount;
  FToolbar:=nil;
  GetMem(FPropList, APropCount * SizeOf(TInstProp));
  FillChar(FPropList^, APropCount * SizeOf(TInstProp), 0);
end;

destructor TSpkToolbarContentsEditor.Destroy;
begin
  if FPropList <> nil then
    FreeMem(FPropList, FPropCount * SizeOf(TInstProp));
  inherited;
end;

procedure TSpkToolbarContentsEditor.Edit;
begin
  EditWindow.SetData(FToolbar,self.Designer);
  EditWindow.Show;
end;

function TSpkToolbarContentsEditor.GetAttributes: TPropertyAttributes;
begin
result:=[paDialog, paReadOnly];
end;

function TSpkToolbarContentsEditor.GetEditLimit: Integer;
begin
result:=0;
end;

function TSpkToolbarContentsEditor.GetEditValue(out Value: string): Boolean;
begin
Value:=GetValue;
result:=true;
end;

function TSpkToolbarContentsEditor.GetKind: TTypeKind;
begin
result:=tkClass;
end;

function TSpkToolbarContentsEditor.GetName: string;
begin
result:=PROPERTY_CONTENTS_NAME;
end;

procedure TSpkToolbarContentsEditor.GetProperties(Proc: TGetPropProc);
begin
//
end;

function TSpkToolbarContentsEditor.GetPropInfo: PPropInfo;
begin
Result:=nil;
end;

function TSpkToolbarContentsEditor.GetPropType: PTypeInfo;
begin
Result:=nil;
end;

function TSpkToolbarContentsEditor.GetValue: string;
begin
result:=PROPERTY_CONTENTS_VALUE;
end;

procedure TSpkToolbarContentsEditor.GetValues(Proc: TGetStrProc);
begin
//
end;

function TSpkToolbarContentsEditor.HasInstance(Instance: TPersistent): Boolean;
begin
  result:=EditWindow.Toolbar = Instance;
end;

procedure TSpkToolbarContentsEditor.Initialize;
begin
  inherited;
end;

procedure TSpkToolbarContentsEditor.Revert;
begin
//
end;

procedure TSpkToolbarContentsEditor.SetPropEntry(Index: Integer; AInstance: TPersistent;
  APropInfo: PPropInfo);
begin
with FPropList^[Index] do
     begin
     Instance := AInstance;
     PropInfo := APropInfo;
     end;
end;

procedure TSpkToolbarContentsEditor.SetValue(const Value: string);
begin
//
end;

function TSpkToolbarContentsEditor.ValueAvailable: Boolean;
begin
result:=true;
end;

{ TSelectionFilter }

procedure TAddContentsFilter.FilterProperties(
  const ASelection: IDesignerSelections;
  const ASelectionProperties: IInterfaceList);

var ContentsEditor : TSpkToolbarContentsEditor;
    Prop : IProperty;
    i : integer;
    Added : boolean;

begin
if ASelection.Count<>1 then
   exit;

if ASelection[0] is TSpkToolbar then
   begin
   ContentsEditor:=TSpkToolbarContentsEditor.Create(inherited Designer, 1);
   ContentsEditor.Toolbar:=ASelection[0] as TSpkToolbar;

   i:=0;
   Added:=false;
   while (i<ASelectionProperties.Count) and not Added do
         begin
         ASelectionProperties.Items[i].QueryInterface(IProperty, Prop);
         if (assigned(Prop)) and (Prop.GetName>PROPERTY_CONTENTS_NAME) then
            begin
            ASelectionProperties.Insert(i, ContentsEditor);
            Added:=true;
            end;
         inc(i);
         end;

   if not(Added) then
      ASelectionProperties.Add(ContentsEditor as IProperty);
   end;
end;

{ TSpkToolbarEditor }

procedure TSpkToolbarEditor.DoOpenContentsEditor;

var Component : TComponent;
    Toolbar : TSpkToolbar;
    Designer : IDesigner;

begin
Component:=self.GetComponent;
if not(assigned(Component)) then
   exit;

if not(Component is TSpkToolbar) then
   exit;

Toolbar:=Component as TSpkToolbar;
Designer:=self.GetDesigner;

EditWindow.SetData(Toolbar,Designer);
EditWindow.Show;
end;

procedure TSpkToolbarEditor.Edit;

begin
DoOpenContentsEditor;
end;

procedure TSpkToolbarEditor.ExecuteVerb(Index: Integer);
begin
case Index of
     0 : DoOpenContentsEditor;
end;
end;

function TSpkToolbarEditor.GetVerb(Index: Integer): string;
begin
case Index of
     0 : result:='Contents editor...';
end;
end;

function TSpkToolbarEditor.GetVerbCount: Integer;
begin
result:=1;
end;

{ TSpkToolbarCaptionEditor }

procedure TSpkToolbarCaptionEditor.SetValue(const Value: string);
begin
  inherited;
  EditWindow.RefreshNames;
end;

{ TSpkToolbarAppearanceEditor }

procedure TSpkToolbarAppearanceEditor.Edit;

var Obj : TObject;
    Toolbar : TSpkToolbar;
    Tab : TSpkTab;
    AppearanceEditor : tfrmAppearanceEditWindow;

begin
Obj:=GetComponent(0);
if Obj is TSpkToolbar then
   begin
   Toolbar:=(Obj as TSpkToolbar);

   AppearanceEditor:=TfrmAppearanceEditWindow.Create(nil);
   try
     AppearanceEditor.Appearance.Assign(Toolbar.Appearance);
     if AppearanceEditor.ShowModal = mrOK then
        begin
        Toolbar.Appearance.Assign(AppearanceEditor.Appearance);
        Modified;
        end;
   finally
     AppearanceEditor.Free;
   end;

   end else
if Obj is TSpkTab then
   begin
   Tab:=(Obj as TSpkTab);

   AppearanceEditor:=TfrmAppearanceEditWindow.Create(nil);
   try
     AppearanceEditor.Appearance.Assign(Tab.CustomAppearance);
     if AppearanceEditor.ShowModal = mrOK then
        begin
        Tab.CustomAppearance.Assign(AppearanceEditor.Appearance);
        Modified;
        end;
   finally
     AppearanceEditor.Free;
   end;

   end;
end;

function TSpkToolbarAppearanceEditor.GetAttributes: TPropertyAttributes;
begin
  result:=inherited GetAttributes + [paDialog] - [paMultiSelect];
end;

initialization

EditWindow:=TfrmEditWindow.create(nil);

finalization

EditWindow.Free;

end.
