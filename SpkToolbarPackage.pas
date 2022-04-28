{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit SpkToolbarPackage; 

interface

uses
  SpkAppearance, SpkBaseItem, SpkButtons, SpkConst, SpkDispatch,
  SpkExceptions, SpkItems, SpkPane, SpkTab, SpkTools, SpkTypes,
  SpkToolbar, SpkMath, SpkGUITools, SpkGraphTools, SpkXMLIni, SpkXMLParser, 
  SpkXMLTools, RegisterSpkToolbar, SpkToolbarEditor, spkte_AppearanceEditor, 
  spkte_EditWindow,DesignEditors, DesignIntf, DesignMenus, VCLEditors;

implementation

procedure Register; 
begin
//  RegisterUnit('RegisterSpkToolbar', @RegisterSpkToolbar.Register);
end;

initialization
//  RegisterPackage('SpkToolbarPackage', @Register);
end.
