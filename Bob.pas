unit Bob;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SldWorks_tlb, SwConst_TLB, StdCtrls, ExtCtrls, jpeg, math, Konich_bob, Konich_zub;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Panel2: TPanel;
    Diametr_of_shaft: TLabeledEdit;
    Button1: TButton;
    Diametr_of_nave: TLabeledEdit;
    Left_distance_nave_of_disk: TLabeledEdit;
    Right_distance_nave_of_disk: TLabeledEdit;
    Thickness_of_disk: TLabeledEdit;
    Disk_bor_left: TLabeledEdit;
    Disk_bor_right: TLabeledEdit;
    Thickness_of_teeth: TLabeledEdit;
    Gearing_corner: TLabeledEdit;
    Modul: TLabeledEdit;
    Width_of_wreath: TLabeledEdit;
    Number_of_teeths: TLabeledEdit;
    procedure Button1Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var Db,Dst,l1,l2,c,k1,k2,s1,g,m,b: Double;
z: integer;
Y2: real;
md: IModelDoc2;
i1,i2: extended;
begin

try
  Db:=StrToFloat(Diametr_of_shaft.Text);
  except
    ShowMessage('Некорректный ввод параметра');
    Diametr_of_shaft.SetFocus;
    exit;
  end;

  try
  Dst:=StrToFloat(Diametr_of_nave.Text);
  except
    ShowMessage('Некорректный ввод параметра');
    Diametr_of_nave.SetFocus;
    exit;
  end;

  if Db>Dst then
  begin
    ShowMessage('Некорректный ввод диаметров. Увеличьте диаметр ступицы или уменьшите диаметр вала');
    Diametr_of_nave.SetFocus;
    exit;
  end;

  try
  l1:=StrToFloat(Left_distance_nave_of_disk.Text);
  except
    ShowMessage('Некорректный ввод параметра');
    Left_distance_nave_of_disk.SetFocus;
    exit;
  end;

  try
  l2:=StrToFloat(Right_distance_nave_of_disk.Text);
  except
    ShowMessage('Некорректный ввод параметра');
    Right_distance_nave_of_disk.SetFocus;
    exit;
  end;

  try
  c:=StrToFloat(Thickness_of_disk.Text);
  except
    ShowMessage('Некорректный ввод параметра');
    Thickness_of_disk.SetFocus;
    exit;
  end;

  try
  k1:=StrToFloat(Disk_bor_left.Text);
  except
    ShowMessage('Некорректный ввод параметра');
    Disk_bor_left.SetFocus;
    exit;
  end;

  try
  k2:=StrToFloat(Disk_bor_right.Text);
  except
    ShowMessage('Некорректный ввод параметра');
    Disk_bor_left.SetFocus;
    exit;
  end;

  try
  s1:=StrToFloat(Thickness_of_teeth.Text);
  except
    ShowMessage('Некорректный ввод параметра');
    Thickness_of_teeth.SetFocus;
    exit;
  end;

  try
  g:=StrToFloat(Gearing_corner.Text)*pi/180;
  except
    ShowMessage('Некорректный ввод параметра');
    Gearing_corner.SetFocus;
    exit;
  end;

  try
  m:=StrToFloat(Modul.Text);
  except
    ShowMessage('Некорректный ввод параметра');
    Modul.SetFocus;
    exit;
  end;

  try
  z:=strtoint(Number_of_teeths.Text);
  except
    ShowMessage('Некорректный ввод параметра');
    Number_of_teeths.SetFocus;
    exit;
  end;

  try
  b:=StrToFloat(Width_of_wreath.Text);
  except
    ShowMessage('Некорректный ввод параметра');
    Width_of_wreath.SetFocus;
    exit;
  end;

  i1:=b*cos(g);
  i2:=K1+K2+C;
  if i1>i2 then
  begin
    ShowMessage('Некорректный ввод параметра. Увеличьте параметры К1, К2, С, угол g или уменьшите ширину зубчатого венца');
    Width_of_wreath.SetFocus;
    exit;
  end;

  i1:=(b*sin(g))+s1*cos(g)+2.2*m+(Dst/2);
  i2:=(m*z+sin(g)*2*m)/2;
  if i1>i2 then
  begin
    ShowMessage('Некорректный ввод параметров. Увеличьте количество зубьев или модуль, или уменьшите B, S1, Dst');
    Width_of_wreath.SetFocus;
    exit;
  end;

  //Процедура создания бобышки
  Postroenie(Db,Dst,l1,l2,c,k1,k2,s1,g,m,b,z,Y2,md);
  //Процедура нарезания зубьев
  narezanie(g,m,z,b,Y2,md);

end;



end.
