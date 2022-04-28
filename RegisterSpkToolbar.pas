unit RegisterSpkToolbar;

{$H+}

interface

uses
  Classes, SysUtils, SpkToolbar, DesignEditors, DesignIntf, DesignMenus, VCLEditors,
  SpkToolbarEditor, SpkButtons, SpkPane, SpkTab, SpkAppearance;

procedure Register;

implementation


procedure Register;
begin
  RegisterComponents('SpkToolbar', [TSpkToolbar]);
  RegisterNoIcon([TSpkLargeButton, TSpkSmallButton]);
  RegisterNoIcon([TSpkPane]);
  RegisterNoIcon([TSpkTab]);

  RegisterComponentEditor(TSpkToolbar, TSpkToolbarEditor);
  RegisterPropertyEditor(TypeInfo(TSpkToolbarAppearance), TSpkToolbar,
    'Appearance', TSpkToolbarAppearanceEditor);
end;

end.

