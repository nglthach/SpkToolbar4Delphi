unit SpkEditWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DesignIntf, DesignEditors, StdCtrls, ImgList, ComCtrls, ToolWin,
  ActnList, Menus,
  spkToolbar, SpkTab, SpkPane, SpkBaseItem, SpkButtons, SpkTypes, SpkCheckboxes, System.Actions, System.ImageList;

type TCreateItemFunc = function(Pane : TSpkPane) : TSpkBaseItem;

type
  TfrmEditWindow = class(TForm)
    aAddCheckbox: TAction;
    aAddRadioButton: TAction;
    ilTreeImages_150: TImageList;
    ilActionImages_150: TImageList;
    ilActionImages_200: TImageList;
    ilTreeImages_200: TImageList;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    tvStructure: TTreeView;
    ilTreeImages: TImageList;
    tbToolBar: TToolBar;
    tbAddTab: TToolButton;
    ilActionImages: TImageList;
    tbRemoveTab: TToolButton;
    ToolButton3: TToolButton;
    tbAddPane: TToolButton;
    tbRemovePane: TToolButton;
    ActionList: TActionList;
    aAddTab: TAction;
    aRemoveTab: TAction;
    aAddPane: TAction;
    aRemovePane: TAction;
    ToolButton6: TToolButton;
    aMoveUp: TAction;
    aMoveDown: TAction;
    tbMoveUp: TToolButton;
    tbMoveDown: TToolButton;
    ToolButton9: TToolButton;
    tbAddItem: TToolButton;
    tbRemoveItem: TToolButton;
    pmAddItem: TPopupMenu;
    SpkLargeButton1: TMenuItem;
    aAddLargeButton: TAction;
    aRemoveItem: TAction;
    aAddSmallButton: TAction;
    SpkSmallButton1: TMenuItem;
    pmStructure: TPopupMenu;
    Addtab1: TMenuItem;
    Removetab1: TMenuItem;
    N1: TMenuItem;
    Addpane1: TMenuItem;
    Removepane1: TMenuItem;
    N2: TMenuItem;
    Additem1: TMenuItem;
    SpkLargeButton2: TMenuItem;
    SpkSmallButton2: TMenuItem;
    Removeitem1: TMenuItem;
    N3: TMenuItem;
    Moveup1: TMenuItem;
    Movedown1: TMenuItem;
    procedure tvStructureChange(Sender: TObject; Node: TTreeNode);
    procedure aAddTabExecute(Sender: TObject);
    procedure aRemoveTabExecute(Sender: TObject);
    procedure aAddPaneExecute(Sender: TObject);
    procedure aRemovePaneExecute(Sender: TObject);
    procedure aMoveUpExecute(Sender: TObject);
    procedure aMoveDownExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure aAddLargeButtonExecute(Sender: TObject);
    procedure aRemoveItemExecute(Sender: TObject);
    procedure aAddSmallButtonExecute(Sender: TObject);
    procedure aAddCheckboxExecute(Sender: TObject);
    procedure aAddRadioButtonExecute(Sender: TObject);
    procedure tvStructureDeletion(Sender:TObject; Node:TTreeNode);
    procedure tvStructureEdited(Sender: TObject; Node: TTreeNode; var S: string);
    procedure tvStructureKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  protected
    FToolbar : TSpkToolbar;
    FDesigner : IDesigner;

    procedure CheckActionsAvailability;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    procedure AddItem(ItemClass: TSpkBaseItemClass);
    function GetItemCaption(Item: TSpkBaseItem): string;
    procedure SetItemCaption(Item: TSpkBaseItem; const Value: String);

    procedure DoRemoveTab;
    procedure DoRemovePane;
    procedure DoRemoveItem;

    function CheckValidTabNode(Node: TTreeNode): boolean;
    function CheckValidPaneNode(Node: TTreeNode): boolean;
    function CheckValidItemNode(Node: TTreeNode): boolean;

    procedure UpdatePPI;
  public
    { Public declarations }
    function ValidateTreeData: boolean;
    procedure BuildTreeData;
    procedure RefreshNames;

    procedure SetData(AToolbar : TSpkToolbar; ADesigner : IDesigner);

    property Toolbar: TSpkToolbar read FToolbar;
  end;

var
  frmEditWindow: TfrmEditWindow;

implementation

{$R *.dfm}

resourcestring
  RSCannotMoveAboveFirstElement = 'You can not move above the top of the first element!';
  RSCannotMoveBeyondLastElement = 'You can not move beyond the last element!';
  RSDamagedTreeStructure = 'Damaged tree structure!';
  RSIncorrectFieldData = 'Incorrect data in the field!';
  RSIncorrectObjectInTree = 'Incorrect object attached to the tree!';
  RSNoObjectSelected = 'No object selected!';
  RSNoObjectSelectedToMove = 'No object selected to move!';


{ TfrmEditWindow }

procedure TfrmEditWindow.aAddPaneExecute(Sender: TObject);
var
  Obj: TObject;
  Node: TTreeNode;
  NewNode: TTreeNode;
  Tab: TSpkTab;
  Pane: TSpkPane;
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;
//  if FDesigner.PropertyEditorHook = nil then
//    exit;

  Node := tvStructure.Selected;
  if Node = nil then
    raise Exception.Create('TfrmEditWindow.aAddPaneExecute: ' + RSNoObjectSelected);
  if Node.Data = nil then
    raise Exception.Create('TfrmEditWindow.aAddPaneExecute: ' + RSDamagedTreeStructure);

  Obj := TObject(Node.Data);
  if Obj is TSpkTab then
  begin
    Tab := TSpkTab(Obj);
    Pane := TSpkPane.Create(FToolbar.Owner);
    Pane.Parent := FToolbar;
    Pane.Name := FDesigner.UniqueName(Pane.ClassName);

    Tab.Panes.AddItem(Pane);
    NewNode := tvStructure.Items.AddChild(Node, Pane.Caption);
    NewNode.Data := Pane;
    NewNode.ImageIndex := 1;
    NewNode.SelectedIndex := 1;
    NewNode.Selected := true;
    CheckActionsAvailability;
  end else
  if Obj is TSpkPane then
  begin
    if not(CheckValidPaneNode(Node)) then
      raise Exception.Create('TfrmEditWindow.aAddPaneExecute: ' + RSDamagedTreeStructure);
    Tab := TSpkTab(Node.Parent.Data);
    Pane := TSpkPane.Create(FToolbar.Owner);
    Pane.Parent := FToolbar;
    Pane.Name := FDesigner.UniqueName(Pane.ClassName);
    Tab.Panes.AddItem(Pane);
    NewNode := tvStructure.Items.AddChild(Node.Parent, Pane.Caption);
    NewNode.Data := Pane;
    NewNode.ImageIndex := 1;
    NewNode.SelectedIndex := 1;
    NewNode.Selected := true;
    CheckActionsAvailability;
  end else
  if Obj is TSpkBaseItem then
  begin
    if not(CheckValidItemNode(Node)) then
      raise Exception.Create('TfrmEditWindow.aAddPaneExecute: ' + RSDamagedTreeStructure);
    Tab := TSpkTab(Node.Parent.Parent.Data);
    Pane := TSpkPane.Create(FToolbar.Owner);
    Pane.Parent := FToolbar;
    Pane.Name := FDesigner.UniqueName(Pane.ClassName);
    Tab.Panes.AddItem(Pane);
    NewNode := tvStructure.Items.AddChild(Node.Parent.Parent, Pane.Caption);
    NewNode.Data := Pane;
    NewNode.ImageIndex := 1;
    NewNode.SelectedIndex := 1;
    NewNode.Selected := true;
    CheckActionsAvailability;
  end else
    raise Exception.Create('TfrmEditWindow.aAddPaneExecute: ' + RSIncorrectObjectInTree);

//  FDesigner.PropertyEditorHook.PersistentAdded(Pane,True);
  FDesigner.Modified;
end;

procedure TfrmEditWindow.aAddSmallButtonExecute(Sender: TObject);
begin
  AddItem(TSpkSmallButton);
end;

procedure TfrmEditWindow.aAddLargeButtonExecute(Sender: TObject);
begin
  AddItem(TSpkLargeButton);
end;

procedure TfrmEditWindow.aAddCheckboxExecute(Sender: TObject);
begin
  AddItem(TSpkCheckbox);
end;

procedure TfrmEditWindow.aAddRadioButtonExecute(Sender: TObject);
begin
  AddItem(TSpkRadioButton);
end;

procedure TfrmEditWindow.aAddTabExecute(Sender: TObject);
var
  Node: TTreeNode;
  Tab: TSpkTab;
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;
//  if FDesigner.PropertyEditorHook = nil then
//    exit;

  Tab := TSpkTab.Create(FToolbar.Owner);
  Tab.Parent := FToolbar;
  FToolbar.Tabs.AddItem(Tab);
  Tab.Name := FDesigner.UniqueName(Tab.ClassName);
  Node := tvStructure.Items.AddChild(nil, Tab.Caption);
  Node.Data := Tab;
  Node.ImageIndex := 0;
  Node.SelectedIndex := 0;
  Node.Selected := true;
  CheckActionsAvailability;

//  FDesigner.PropertyEditorHook.PersistentAdded(Tab,True);
  FDesigner.Modified;
end;

procedure TfrmEditWindow.AddItem(ItemClass: TSpkBaseItemClass);
var
  Node: TTreeNode;
  Obj: TObject;
  Pane: TSpkPane;
  Item: TSpkBaseItem;
  NewNode: TTreeNode;
  s: string;
begin
  if (FToolbar = nil) or (FDesigner = nil) then
   exit;
//  if FDesigner.PropertyEditorHook = nil then
//   exit;

  Node := tvStructure.Selected;
  if Node = nil then
    raise Exception.Create('TfrmEditWindow.AddItem: ' + RSNoObjectSelected);
  if Node.Data = nil then
    raise Exception.Create('TfrmEditWindow.AddItem: ' + RSDamagedTreeStructure);

  Obj := TObject(Node.Data);
  if Obj is TSpkPane then
  begin
    Pane := TSpkPane(Obj);
    Item := ItemClass.Create(FToolbar.Owner);
    Item.Parent := FToolbar;
    Pane.Items.AddItem(Item);
    Item.Name := FDesigner.UniqueName(Item.ClassName);
    s := GetItemCaption(Item);
    NewNode := tvStructure.Items.AddChild(Node, s);
    NewNode.Data := Item;
    NewNode.Selected := true;
    CheckActionsAvailability;
  end else
  if Obj is TSpkBaseItem then
  begin
    if not CheckValidItemNode(Node) then
      raise Exception.Create('TfrmEditWindow.AddItem: ' + RSDamagedTreeStructure);
    Pane := TSpkPane(Node.Parent.Data);
    Item := ItemClass.Create(FToolbar.Owner);
    Item.Parent := FToolbar;
    Pane.Items.AddItem(Item);
    Item.Name := FDesigner.UniqueName(Item.ClassName);
    s := GetItemCaption(Item);
    NewNode := tvStructure.Items.AddChild(Node.Parent, s);
    NewNode.Data := Item;
    NewNode.Selected := true;
    CheckActionsAvailability;
  end else
    raise Exception.Create('TfrmEditWindow.AddItem: ' + RSIncorrectObjectInTree);
  if ItemClass = TSpkLargeButton then
    NewNode.ImageIndex := 2
  else
  if ItemClass = TSpkSmallButton then
    NewNode.ImageIndex := 3
  else
  if ItemClass = TSpkCheckbox then
    NewNode.ImageIndex := 4
  else
  if ItemClass = TSpkRadioButton then
    NewNode.ImageIndex := 5
  else
    raise Exception.Create('Item class not supported');
  NewNode.SelectedIndex := NewNode.ImageIndex;
//  FDesigner.PropertyEditorHook.PersistentAdded(Item,True);
  FDesigner.Modified;
end;

procedure TfrmEditWindow.aMoveDownExecute(Sender: TObject);
var
  Node: TTreeNode;
  Tab: TSpkTab;
  Pane: TSpkPane;
  Obj: TObject;
  index: Integer;
  Item: TSpkBaseItem;
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

  Node := tvStructure.Selected;
  if Node = nil then
    raise Exception.Create('TfrmEditWindow.aMoveDownExecute: ' + RSNoObjectSelectedToMove);
  if Node.Data = nil then
    raise Exception.Create('TfrmEditWindow.aMoveDownExecute: ' + RSDamagedTreeStructure);

  Obj := TObject(Node.Data);
  if Obj is TSpkTab then
  begin
    if not CheckValidTabNode(Node) then
      raise Exception.Create('TfrmEditWindow.aMoveDownExecute: ' + RSDamagedTreeStructure);

    Tab := TSpkTab(Node.Data);
    index := FToolbar.Tabs.IndexOf(Tab);
    if (index = -1) then
      raise Exception.Create('TfrmEditWindow.aMoveDownExecute: ' + RSDamagedTreeStructure);
    if (index = FToolbar.Tabs.Count - 1) then
      raise Exception.Create('TfrmEditWindow.aMoveDownExecute: ' + RSCannotMoveBeyondLastElement);

    FToolbar.Tabs.Exchange(index, index+1);
    FToolbar.TabIndex := index+1;

    Node.GetNextSibling.MoveTo(Node, naInsert);
    Node.Selected := true;
    CheckActionsAvailability;
  end
  else
  if Obj is TSpkPane then
  begin
    if not CheckValidPaneNode(Node) then
      raise Exception.Create('TfrmEditWindow.aMoveDownExecute: ' + RSDamagedTreeStructure);

    Pane := TSpkPane(Node.Data);
    Tab := TSpkTab(Node.Parent.Data);

    index := Tab.Panes.IndexOf(Pane);
    if (index = -1) then
      raise Exception.Create('TfrmEditWindow.aMoveDownExecute: ' + RSDamagedTreeStructure);
    if (index = Tab.Panes.Count - 1) then
      raise Exception.Create('TfrmEditWindow.aMoveDownExecute: ' + RSCannotMoveBeyondLastElement);

    Tab.Panes.Exchange(index, index+1);

    Node.GetNextSibling.MoveTo(Node, naInsert);
    Node.Selected := true;
    CheckActionsAvailability;
  end
  else
  if Obj is TSpkBaseItem then
  begin
    if not CheckValidItemNode(Node) then
      raise Exception.Create('TfrmEditWindow.aMoveDown.Execute: ' + RSDamagedTreeStructure);

    Item := TSpkBaseItem(Node.Data);
    Pane := TSpkPane(Node.Parent.Data);

    index := Pane.Items.IndexOf(Item);
    if (index = -1) then
      raise Exception.Create('TfrmEditWindow.aMoveDownExecute: ' + RSDamagedTreeStructure);
    if (index = Pane.Items.Count - 1) then
      raise Exception.Create('TfrmEditWindow.aMoveDownExecute: ' + RSCannotMoveBeyondLastElement);

    Pane.Items.Exchange(index, index+1);

    Node.GetNextSibling.MoveTo(Node, naInsert);
    Node.Selected := true;
    CheckActionsAvailability;
  end
  else
    raise Exception.Create('TfrmEditWindow.aMoveDownExecute: ' + RSIncorrectObjectInTree);
end;

procedure TfrmEditWindow.aMoveUpExecute(Sender: TObject);
var
  Node: TTreeNode;
  Tab: TSpkTab;
  Pane: TSpkPane;
  Obj: TObject;
  index: Integer;
  Item: TSpkBaseItem;
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

  Node := tvStructure.Selected;
  if Node = nil then
    raise Exception.Create('TfrmEditWindow.aMoveUpExecute: '+ RSNoObjectSelectedToMove);
  if Node.Data = nil then
    raise Exception.Create('TfrmEditWindow.aMoveUpExecute: ' + RSDamagedTreeStructure);

  Obj := TObject(Node.Data);
  if Obj is TSpkTab then
  begin
    if not CheckValidTabNode(Node) then
      raise Exception.Create('TfrmEditWindow.aMoveUpExecute: ' + RSDamagedTreeStructure);

    Tab := TSpkTab(Node.Data);
    index := FToolbar.Tabs.IndexOf(Tab);
    if (index = -1) then
      raise Exception.Create('TfrmEditWindow.aMoveUpExecute: ' + RSDamagedTreeStructure);
    if (index = 0) then
      raise Exception.Create('TfrmEditWindow.aMoveUpExecute: ' + RSCannotMoveAboveFirstElement);

    FToolbar.Tabs.Exchange(index, index-1);
    FToolbar.TabIndex := index-1;

    Node.MoveTo(Node.getPrevSibling, naInsert);
    Node.Selected := true;
    CheckActionsAvailability;
  end
  else
  if Obj is TSpkPane then
  begin
    if not CheckValidPaneNode(Node) then
      raise Exception.Create('TfrmEditWindow.aMoveUpExecute: ' + RSDamagedTreeStructure);

    Pane := TSpkPane(Node.Data);
    Tab := TSpkTab(Node.Parent.Data);
    index := Tab.Panes.IndexOf(Pane);
    if (index = -1) then
      raise Exception.Create('TfrmEditWindow.aMoveUpExecute: ' + RSDamagedTreeStructure);
    if (index = 0) then
      raise Exception.Create('TfrmEditWindow.aMoveUpExecute: ' + RSCannotMoveAboveFirstElement);

    Tab.Panes.Exchange(index, index-1);

    Node.MoveTo(Node.GetPrevSibling, naInsert);
    Node.Selected := true;
    CheckActionsAvailability;
  end
  else
  if Obj is TSpkBaseItem then
  begin
    if not CheckValidItemNode(Node) then
      raise Exception.Create('TfrmEditWindow.aMoveUpExecute: ' + RSDamagedTreeStructure);

    Item := TSpkBaseItem(Node.Data);
    Pane := TSpkPane(Node.Parent.Data);
    index := Pane.Items.IndexOf(Item);
    if (index = -1) then
      raise Exception.Create('TfrmEditWindow.aMoveUpExecute: ' + RSDamagedTreeStructure);
    if (index = 0) then
      raise Exception.Create('TfrmEditWindow.aMoveUpExecute: ' + RSCannotMoveAboveFirstElement);

    Pane.Items.Exchange(index, index-1);

    Node.MoveTo(Node.GetPrevSibling, naInsert);
    Node.Selected := true;
    CheckActionsAvailability;
  end else
    raise Exception.Create('TfrmEditWindow.aMoveUpExecute: ' + RSIncorrectObjectInTree);
end;

procedure TfrmEditWindow.aRemoveItemExecute(Sender: TObject);
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;
  DoRemoveItem;
end;

procedure TfrmEditWindow.aRemovePaneExecute(Sender: TObject);

begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;
  DoRemovePane;
end;

procedure TfrmEditWindow.aRemoveTabExecute(Sender: TObject);
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;
  DoRemoveTab;
end;

procedure TfrmEditWindow.CheckActionsAvailability;
var
  Node: TTreeNode;
  Obj: TObject;
  Tab: TSpkTab;
  Pane: TSpkPane;
  index: integer;
  Item: TSpkBaseItem;
begin
  if (FToolbar = nil) or (FDesigner = nil) then
  begin
    // Brak toolbara lub designera
    aAddTab.Enabled := false;
    aRemoveTab.Enabled := false;
    aAddPane.Enabled := false;
    aRemovePane.Enabled := false;
    aAddLargeButton.Enabled := false;
    aAddSmallButton.Enabled := false;
    aAddCheckbox.Enabled := false;
    aAddRadioButton.Enabled := false;
    aRemoveItem.Enabled := false;
    aMoveUp.Enabled := false;
    aMoveDown.Enabled := false;
  end
  else
  begin
    Node := tvStructure.Selected;
    if Node = nil then
    begin
      // Pusty toolbar
      aAddTab.Enabled := true;
      aRemoveTab.Enabled := false;
      aAddPane.Enabled := false;
      aRemovePane.Enabled := false;
      aAddLargeButton.Enabled := false;
      aAddSmallButton.Enabled := false;
      aAddCheckbox.Enabled := false;
      aAddRadioButton.Enabled := false;
      aRemoveItem.Enabled := false;
      aMoveUp.Enabled := false;
      aMoveDown.Enabled := false;
    end
    else
    begin
      Obj := TObject(Node.Data);
      if Obj = nil then
        raise Exception.Create('TfrmEditWindow.CheckActionsAvailability: ' + RSIncorrectFieldData);

      if Obj is TSpkTab then
      begin
        Tab := Obj as TSpkTab;

        if not CheckValidTabNode(Node) then
          raise Exception.Create('TfrmEditWindow.CheckActionsAvailability: ' + RSDamagedTreeStructure);

        aAddTab.Enabled := true;
        aRemoveTab.Enabled := true;
        aAddPane.Enabled := true;
        aRemovePane.Enabled := false;
        aAddLargeButton.Enabled := false;
        aAddSmallButton.Enabled := false;
        aAddCheckbox.Enabled := false;
        aAddRadioButton.Enabled := false;
        aRemoveItem.Enabled := false;

        index := FToolbar.Tabs.IndexOf(Tab);
        if index = -1 then
          raise Exception.Create('TfrmEditWindow.CheckActionsAvailability: ' + RSDamagedTreeStructure);

        aMoveUp.Enabled := (index > 0);
        aMoveDown.enabled := (index < FToolbar.Tabs.Count-1);
      end else
      if Obj is TSpkPane then
      begin
        Pane := TSpkPane(Obj);
        if not(CheckValidPaneNode(Node)) then
          raise Exception.Create('TfrmEditWindow.CheckActionsAvailability: ' + RSDamagedTreeStructure);

        Tab := TSpkTab(Node.Parent.Data);

        aAddTab.Enabled := true;
        aRemoveTab.Enabled := false;
        aAddPane.Enabled := true;
        aRemovePane.Enabled := true;
        aAddLargeButton.Enabled := true;
        aAddSmallButton.Enabled := true;
        aAddCheckbox.Enabled := true;
        aAddRadiobutton.Enabled := true;
        aRemoveItem.Enabled := false;

        index := Tab.Panes.IndexOf(Pane);
        if index = -1 then
          raise Exception.Create('TfrmEditWindow.CheckActionsAvailability: ' + RSDamagedTreeStructure);

        aMoveUp.Enabled := (index > 0);
        aMoveDown.Enabled := (index < Tab.Panes.Count-1);
      end else
      if Obj is TSpkBaseItem then
      begin
        Item := TSpkBaseItem(Obj);
        if not CheckValidItemNode(Node) then
          raise Exception.Create('TfrmEditWindow.CheckActionsAvailability: ' + RSDamagedTreeStructure);

        Pane := TSpkPane(Node.Parent.Data);

        aAddTab.Enabled := true;
        aRemoveTab.Enabled := false;
        aAddPane.Enabled := true;
        aRemovePane.Enabled := false;
        aAddLargeButton.Enabled := true;
        aAddSmallButton.Enabled := true;
        aAddCheckbox.Enabled := true;
        aAddRadioButton.Enabled := true;
        aRemoveItem.Enabled := true;

        index := Pane.Items.IndexOf(Item);
        if index = -1 then
          raise Exception.Create('TfrmEditWindow.CheckActionsAvailability: ' + RSDamagedTreeStructure);

        aMoveUp.Enabled := (index > 0);
        aMoveDown.Enabled := (index < Pane.Items.Count - 1);
      end else
        raise Exception.Create('TfrmEditWindow.CheckActionsAvailability: ' + RSIncorrectObjectInTree);
    end;
  end;
end;

function TfrmEditWindow.CheckValidItemNode(Node: TTreeNode): boolean;
begin
  Result := false;
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;
  {$B-}
  Result:=(Node <> nil) and
          (Node.Data <> nil) and
          (TObject(Node.Data) is TSpkBaseItem) and
          CheckValidPaneNode(Node.Parent);
end;

function TfrmEditWindow.CheckValidPaneNode(Node: TTreeNode): boolean;
begin
  Result := false;
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;
  {$B-}
  Result := (Node <> nil) and
            (Node.Data <> nil) and
            (TObject(Node.Data) is TSpkPane) and
            CheckValidTabNode(Node.Parent);
end;

function TfrmEditWindow.CheckValidTabNode(Node: TTreeNode): boolean;
begin
  Result := false;
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;
  {$B-}
  result := (Node <> nil) and
            (Node.Data <> nil) and
            (TObject(Node.Data) is TSpkTab);
end;

procedure TfrmEditWindow.FormActivate(Sender: TObject);
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;
  UpdatePPI;
  if not ValidateTreeData then
    BuildTreeData;
end;

procedure TfrmEditWindow.FormDestroy(Sender: TObject);
begin
  if FToolbar <> nil then
    FToolbar.RemoveFreeNotification(self);
end;

procedure TfrmEditWindow.FormShow(Sender: TObject);
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;
  BuildTreeData;
end;

function TfrmEditWindow.GetItemCaption(Item: TSpkBaseItem): string;
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;
  if Item is TSpkBaseButton then
    Result := TSpkBaseButton(Item).Caption
  else
    Result := '<Unknown caption>';
end;

procedure TfrmEditWindow.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;

  if (AComponent = FToolbar) and (Operation = opRemove) then
  begin
    // The toolbar is currently released, whose content is displayed in the
    // editor window. Need to clean up the content - otherwise the window will
    // have references to the already removed toolbars, which will end in AVs ...
    SetData(nil, nil);
  end;
end;

procedure TfrmEditWindow.SetItemCaption(Item: TSpkBaseItem; const Value : string);
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

  if Item is TSpkBaseButton then
    TSpkBaseButton(Item).Caption := Value;
end;

procedure TfrmEditWindow.SetData(AToolbar: TSpkToolbar; ADesigner: IDesigner);

begin
  if FToolbar <> nil then
    FToolbar.RemoveFreeNotification(self);

  FToolbar := AToolbar;
  FDesigner := ADesigner;

  if FToolbar <> nil then
    FToolbar.FreeNotification(self);

  BuildTreeData;
end;

procedure TfrmEditWindow.DoRemoveItem;
var
  Item: TSpkBaseItem;
  index: Integer;
  Node: TTreeNode;
  Pane: TSpkPane;
  NextNode: TTreeNode;
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

  Node := tvStructure.Selected;
  if not (CheckValidItemNode(Node)) then
    raise Exception.Create('TfrmEditWindow.aRemoveItemExecute: ' + RSDamagedTreeStructure);
  Item := TSpkBaseItem(Node.Data);
  Pane := TSpkPane(Node.Parent.Data);
  index := Pane.Items.IndexOf(Item);
  if index = -1 then
    raise Exception.Create('TfrmEditWindow.aRemoveItemExecute: ' + RSDamagedTreeStructure);
  if Node.getPrevSibling <> nil then
    NextNode := Node.getPrevSibling
  else if Node.GetNextSibling <> nil then
    NextNode := Node.getNextSibling
  else
    NextNode := Node.Parent;
  Pane.Items.Delete(index);
  tvStructure.Items.delete(node);
  NextNode.Selected := true;
  CheckActionsAvailability;
end;

procedure TfrmEditWindow.DoRemovePane;
var
  Pane: TSpkPane;
  NextNode: TTreeNode;
  index: Integer;
  Node: TTreeNode;
  Tab: TSpkTab;
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

  Node := tvStructure.Selected;
  if not (CheckValidPaneNode(Node)) then
    raise Exception.Create('TfrmEditWindow.aRemovePaneExecute: ' + RSDamagedTreeStructure);
  Pane := TSpkPane(Node.Data);
  Tab := TSpkTab(Node.Parent.Data);
  index := Tab.Panes.IndexOf(Pane);
  if index = -1 then
    raise Exception.Create('TfrmEditWindow.aRemovePaneExecute: ' + RSDamagedTreeStructure);
  if Node.GetPrevSibling <> nil then
    NextNode := Node.GetPrevSibling
  else if Node.GetNextSibling <> nil then
    NextNode := Node.GetNextSibling
  else
    NextNode := Node.Parent;
  Tab.Panes.Delete(index);
  tvStructure.Items.Delete(Node);
  NextNode.Selected := true;
  CheckActionsAvailability;
end;

procedure TfrmEditWindow.DoRemoveTab;
var
  Node: TTreeNode;
  Tab: TSpkTab;
  index: Integer;
  NextNode: TTreeNode;
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

  Node := tvStructure.Selected;
  if not (CheckValidTabNode(Node)) then
    raise Exception.Create('TfrmEditWindow.aRemoveTabExecute: ' + RSDamagedTreeStructure);
  Tab := TSpkTab(Node.Data);
  index := FToolbar.Tabs.IndexOf(Tab);
  if index = -1 then
    raise Exception.Create('TfrmEditWindow.aRemoveTabExecute: ' + RSDamagedTreeStructure);
  if Node.GetPrevSibling <> nil then
    NextNode := Node.GetPrevSibling
  else if Node.GetNextSibling <> nil then
    NextNode := Node.GetNextSibling
  else
    NextNode := nil;
  FToolbar.Tabs.Delete(index);
  tvStructure.Items.Delete(Node);
  if Assigned(NextNode) then
  begin
    // The OnChange event will trigger an update of the selected object in
    // the Object Inspector
    NextNode.Selected := true;
    CheckActionsAvailability;
  end
  else
  begin
    // There are no more objects in the list, but something has to be displayed
    // in the Object Inspector - so we will display the toolbars itself
    // (otherwise the IDE will attempt to display the object's properties in
    // the Object Inspector, which will end, say, not very nice)
    //DesignObj := PersistentToDesignObject(FToolbar);
    FDesigner.SelectComponent(FToolbar);
    CheckActionsAvailability;
  end;
end;

procedure TfrmEditWindow.BuildTreeData;
var
  i: Integer;
  panenode: TTreeNode;
  j: Integer;
  tabnode: TTreeNode;
  k : Integer;
  itemnode: TTreeNode;
  Obj: TSpkBaseItem;
  s: string;
  node: TTreeNode;
begin
  Caption:='Editing TSpkToolbar contents';

  // Clear tree, but don't remove existing toolbar children from the form
  tvStructure.OnDeletion := nil;
  tvStructure.Items.Clear;
  tvStructure.OnDeletion := tvStructureDeletion;

  if (FToolbar <> nil) and (FDesigner <> nil) then
  begin
    for i := 0 to FToolbar.Tabs.Count - 1 do
    begin
      tabnode := tvStructure.Items.AddChild(nil, FToolbar.Tabs[i].Caption);
      tabnode.ImageIndex := 0;
      tabnode.SelectedIndex := 0;
      tabnode.Data := FToolbar.Tabs[i];
      for j := 0 to FToolbar.Tabs.Items[i].Panes.Count - 1 do
      begin
        panenode := tvStructure.Items.AddChild(tabnode, FToolbar.Tabs[i].Panes[j].Caption);
        panenode.ImageIndex := 1;
        panenode.SelectedIndex := 1;
        panenode.Data := FToolbar.Tabs[i].Panes[j];
        for k := 0 to FToolbar.Tabs[i].Panes[j].Items.Count - 1 do
        begin
          Obj := FToolbar.Tabs[i].Panes[j].Items[k];
          s := GetItemCaption(Obj);
          itemnode := tvStructure.Items.AddChild(panenode,s);
          itemnode.Imageindex := 2;
          itemnode.Selectedindex := 2;
          itemnode.Data := Obj;
        end;
      end;
    end;
  end;

  if (tvStructure.Items.Count > 0) and (FToolbar.TabIndex > -1) then begin
    node := tvStructure.Items[0];
    while (node <> nil) do begin
      if TSpkTab(node.Data) = FToolbar.Tabs[FToolbar.TabIndex] then break;
      node := node.GetNextSibling;
    end;
    if (node <> nil) then begin
      node.Selected := true;
      node.Expand(true);
    end;
  end;

  CheckActionsAvailability;
end;

procedure TfrmEditWindow.RefreshNames;
var
  tabnode, panenode, itemnode: TTreeNode;
  Obj: TSpkBaseItem;
  s: string;

begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

  tabnode := tvStructure.Items.GetFirstNode;
  while tabnode<>nil do
  begin
    if not CheckValidTabNode(tabnode) then
      raise Exception.Create('TfrmEditWindow.RefreshNames: ' + RSDamagedTreeStructure);

    tabnode.Text := TSpkTab(tabnode.Data).Caption;

    panenode := tabnode.getFirstChild;
    while panenode <> nil do
    begin
      if not CheckValidPaneNode(panenode) then
        raise Exception.Create('TfrmEditWindow.RefreshNames: ' + RSDamagedTreeStructure);

      panenode.Text := TSpkPane(panenode.Data).Caption;

      itemnode := panenode.getFirstChild;
      while itemnode <> nil do
      begin
        if not CheckValidItemNode(itemnode) then
          raise Exception.Create('TfrmEditWindow.RefreshNames: ' + RSDamagedTreeStructure);

        Obj := TSpkBaseItem(itemnode.Data);
        s := GetItemCaption(Obj);
        itemnode.Text := s;
        itemnode := itemnode.getNextSibling;
      end;

      panenode := panenode.getNextSibling;
    end;

    tabnode := tabnode.getNextSibling;
  end;
end;

procedure TfrmEditWindow.tvStructureChange(Sender: TObject; Node: TTreeNode);
var
  Obj: TObject;
  Tab: TSpkTab;
  Pane: TSpkPane;
  Item: TSpkBaseItem;
  index: integer;
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

  if Assigned(Node) then
  begin
    Obj := TObject(Node.Data);
    if Obj = nil then
      raise Exception.Create('TfrmEditWindow.tvStructureChange: ' + RSIncorrectFieldData);
    if Obj is TSpkTab then
    begin
      Tab := TSpkTab(Obj);
      FDesigner.SelectComponent(Tab);
      index := FToolbar.Tabs.IndexOf(Tab);
      if index=-1 then
        raise Exception.Create('TfrmEditWindow.tvStructureChange: ' + RSDamagedTreeStructure);
      FToolbar.TabIndex := index;
    end else
    if Obj is TSpkPane then
    begin
      Pane := TSpkPane(Obj);
      FDesigner.SelectComponent(Pane);
      if not(CheckValidPaneNode(Node)) then
        raise Exception.Create('TfrmEditWindow.tvStructureChange: ' + RSDamagedTreeStructure);
      Tab := TSpkTab(Node.Parent.Data);
      index := FToolbar.Tabs.IndexOf(Tab);
      if index = -1 then
        raise Exception.Create('TfrmEditWindow.tvStructureChange: ' + RSDamagedTreeStructure);
      FToolbar.TabIndex := index;
    end else
    if Obj is TSpkBaseItem then
    begin
      Item := TSpkBaseItem(Obj);
      FDesigner.SelectComponent(Item);
      if not CheckValidItemNode(Node) then
        raise Exception.Create('TfrmEditWindow.tvStructureChange: ' + RSDamagedTreeStructure);
      Tab := TSpkTab(Node.Parent.Parent.Data);
      index := FToolbar.Tabs.IndexOf(Tab);
      if index = -1 then
        raise Exception.Create('TfrmEditWindow.tvStructureChange: ' + RSDamagedTreeStructure);
      FToolbar.TabIndex := index;
    end else
      raise Exception.Create('TfrmEditWindow.tvStructureChange: ' + RSIncorrectObjectInTree);
   end else
     FDesigner.SelectComponent(FToolbar);

  CheckActionsAvailability;
end;

procedure TfrmEditWindow.tvStructureDeletion(Sender:TObject; Node:TTreeNode);
var
  RunNode: TTreeNode;
begin
  if Node = nil then
    exit;
  // Recursively delete children and destroy their data
  RunNode := Node.GetFirstChild;
  while RunNode <> nil do begin
    RunNode.Delete;
    RunNode := RunNode.GetNextSibling;
  end;
  // Destroy node's data
  TSpkComponent(Node.Data).Free;
end;

procedure TfrmEditWindow.tvStructureEdited(Sender: TObject; Node: TTreeNode;
  var S: string);
var
  Tab: TSpkTab;
  Pane: TSpkPane;
  Item: TSpkBaseItem;
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

  if Node.Data = nil then
    raise Exception.Create('TfrmEditWindow.tvStructureEdited: ' + RSDamagedTreeStructure);

  if TObject(Node.Data) is TSpkTab then
  begin
    Tab := TSpkTab(Node.Data);
    Tab.Caption := S;
    FDesigner.Modified;
  end else
  if TObject(Node.Data) is TSpkPane then
  begin
    Pane := TSpkPane(Node.Data);
    Pane.Caption := S;
    FDesigner.Modified;
  end else
  if TObject(Node.Data) is TSpkBaseItem then
  begin
    Item := TSpkBaseItem(Node.Data);
    SetItemCaption(Item, S);
    FDesigner.Modified;
  end else
    raise Exception.Create('TfrmEditWindow.tvStructureEdited: ' + RSDamagedTreeStructure);
end;

procedure TfrmEditWindow.tvStructureKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

  if Key = VK_DELETE then
  begin
    if tvStructure.Selected <> nil then
    begin
      // We check what kind of object is selected - just test the type of the object
      if TObject(tvStructure.Selected.Data) is TSpkTab then
        DoRemoveTab
      else if TObject(tvStructure.Selected.Data) is TSpkPane then
        DoRemovePane
      else if TObject(tvStructure.Selected.Data) is TSpkBaseItem then
        DoRemoveItem
      else
        raise Exception.Create('TfrmEditWindow.tvStructureKeyDown: ' + RSDamagedTreeStructure);
    end;
   end;
end;

function TfrmEditWindow.ValidateTreeData: boolean;
var
  i: Integer;
  TabsValid: Boolean;
  TabNode: TTreeNode;
  j: Integer;
  PanesValid: Boolean;
  PaneNode: TTreeNode;
  k: Integer;
  ItemsValid: Boolean;
  ItemNode: TTreeNode;
begin
  Result := false;
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

  i := 0;
  TabsValid := true;
  TabNode := tvStructure.Items.GetFirstNode;

  while (i < FToolbar.Tabs.Count) and TabsValid do
  begin
    TabsValid := TabsValid and (TabNode <> nil);
    if TabsValid then
      TabsValid := TabsValid and (TabNode.Data = FToolbar.Tabs[i]);
    if TabsValid then
    begin
      j := 0;
      PanesValid := true;
      PaneNode := TabNode.GetFirstChild;
      while (j < FToolbar.Tabs[i].Panes.Count) and PanesValid do
      begin
        PanesValid := PanesValid and (PaneNode <> nil);
        if PanesValid then
          PanesValid := PanesValid and (PaneNode.Data = FToolbar.Tabs[i].Panes[j]);
        if PanesValid then
        begin
          k := 0;
          ItemsValid := true;
          ItemNode := PaneNode.GetFirstChild;
          while (k < FToolbar.Tabs[i].Panes[j].Items.Count) and ItemsValid do
          begin
            ItemsValid := ItemsValid and (ItemNode <> nil);
            if ItemsValid then
              ItemsValid := ItemsValid and (ItemNode.Data = FToolbar.Tabs[i].Panes[j].Items[k]);
            if ItemsValid then
            begin
              inc(k);
              ItemNode := ItemNode.GetNextSibling;
            end;
          end;

          // Important! You need to make sure that there are no extra items in the tree!
          ItemsValid := ItemsValid and (ItemNode = nil);
          PanesValid := PanesValid and ItemsValid;
        end;

        if PanesValid then
        begin
          inc(j);
          PaneNode := PaneNode.GetNextSibling;
        end;
      end;

      // Important! You need to make sure that there are no extra items in the tree!
      PanesValid := PanesValid and (PaneNode = nil);
      TabsValid := TabsValid and PanesValid;
    end;

    if TabsValid then
    begin
      inc(i);
      TabNode := TabNode.GetNextSibling;
    end;
  end;

  // Important! You need to make sure that there are no extra items in the tree!
  TabsValid := TabsValid and (TabNode = nil);
  Result := TabsValid;
end;

procedure TfrmEditWindow.UpdatePPI;
begin
  tbToolbar.Images := nil;
  if Screen.PixelsPerInch >= 180 then begin
    ActionList.Images := ilActionImages_200;
    tbToolbar.Images := ilActionImages_200;
    tvStructure.Images := ilTreeImages_200;
    pmAddItem.Images := ilActionImages_200;
    pmStructure.Images := ilActionImages_200;
  end else
  if Screen.PixelsPerInch >= 135 then begin
    ActionList.Images := ilActionImages_150;
    tbToolbar.Images := ilActionImages_150;
    tvStructure.Images := ilTreeImages_150;
    pmAddItem.Images := ilActionImages_150;
    pmStructure.Images := ilActionImages_150;
  end else begin
    ActionList.Images := ilActionImages;
    tbToolbar.Images := ilActionImages;
    tvStructure.Images := ilTreeImages;
    pmAddItem.Images := ilActionImages;
    pmStructure.Images := ilActionImages;
  end;
  tbToolbar.ButtonHeight := tbToolbar.Images.Height + 8;
end;

end.
