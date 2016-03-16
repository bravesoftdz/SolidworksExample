unit Konich_bob;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SldWorks_tlb, SwConst_TLB, StdCtrls, ExtCtrls, jpeg, math;

type
  Massiv = array of array of Double;

  procedure Postroenie(var Db,Dst,l1,l2,c,k1,k2,s1,g,m,b: Double; z: integer; out Y2:real; var md: IModelDoc2 );

implementation

procedure Postroenie(var Db,Dst,l1,l2,c,k1,k2,s1,g,m,b: Double; z: integer; out Y2:real; var md: IModelDoc2);
var   Y1: real;
      Dfe,De,Dae,Lst,D1,D2: Double;
      i: integer;
      MasPoint: Massiv;  //Массив координта точек эскиза
      sw: ISldWorks;     //Интерфейс запуска приложения SolidWorks
      p: IPartDoc;       //Деталь
      //md: IModelDoc2;    //Документ модели
      SL: ISelectionMgr; //Менеджер выделений
      Bobishka : IFeature;    // Элементы дерева конструирования: Бобышка провернуть
      StartPoint: ISketchPoint;              // Исходня точка
      Seg: array[0..21] of ISketchSegment;   // Элементы эскиза
      Sep: array[0..18] of ISketchPoint;     // Точки эскиза
      Sel: array[0..12] of ISketchLine;      // Линии эскиза


begin
  sw:= CoSldWorks_.Create;    //Запуск приложения
  sw.Visible:= True;          //Видимость
  p:= sw.INewPart;            //Новая деталь
  p.QueryInterface(IID_IModelDoc2, md);     // Новый документ модели
  md.InsertSketch;                          // Вставка эскиза на текущую плоскость
  md.SetInferenceMode(false);               // Отключение автопривязок
  md.SetUserPreferenceToggle( swInputDimValOnCreate,False );    // Не спрашивать размеры

  //Расчет координат точек
SetLength(MasPoint,17,3);

  De:=m*z;
  Dae:=m*z+sin(g)*2*m;
  Dfe:=m*z-sin(g)*2.4*m;

  MasPoint[0,0]:=RoundTo(De/(2*tan(g)),-13);
  MasPoint[0,1]:=RoundTo(De/2,-13);

  MasPoint[1,0]:=RoundTo(MasPoint[0,0]-tan(g)*(Dae-De)/2,-13);
  MasPoint[1,1]:=RoundTo(Dae/2,-13);

    Y1:=arctan(MasPoint[1,1]/MasPoint[1,0]);
    D1:=b/cos(Y1-G);

  MasPoint[2,0]:=RoundTo(MasPoint[0,0]-tan(g)*(Dae-De)/2-D1*cos(y1),-13);
  MasPoint[2,1]:=RoundTo(Dae/2-D1*sin(y1),-13);

  MasPoint[3,0]:=RoundTo(MasPoint[0,0]-b*cos(g),-13);
  MasPoint[3,1]:=RoundTo(MasPoint[0,1]-b*sin(g),-13);

    Y2:=RoundTo(arctan((Dfe/2)/(MasPoint[0,0]+tan(g)*(De-Dfe)/2)),-13);
    D2:=b/cos(G-Y2);

  MasPoint[4,0]:=RoundTo(MasPoint[0,0]+tan(g)*(De-Dfe)/2-D2*cos(y2),-13);
  MasPoint[4,1]:=RoundTo(Dfe/2-D2*sin(y2),-13);

  MasPoint[5,0]:=RoundTo(MasPoint[4,0]+S1*sin(g),-13);
  MasPoint[5,1]:=RoundTo(MasPoint[4,1]-S1*cos(g),-13);

  MasPoint[6,0]:=RoundTo(MasPoint[5,0]+k1,-13);
  MasPoint[6,1]:=RoundTo(MasPoint[5,1],-13);

  MasPoint[7,0]:=RoundTo(MasPoint[6,0],-13);
  MasPoint[7,1]:=RoundTo(Dst/2,-13);

  MasPoint[8,0]:=RoundTo(MasPoint[5,0]-l1,-13);
  MasPoint[8,1]:=RoundTo(Dst/2,-13);

  MasPoint[9,0]:=RoundTo(MasPoint[8,0],-13);
  MasPoint[9,1]:=RoundTo(Db/2,-13);

  Lst:=l1+l2+k1+k2+c;

  MasPoint[10,0]:=RoundTo(MasPoint[9,0]+Lst,-13);
  MasPoint[10,1]:=RoundTo(Db/2,-13);

  MasPoint[11,0]:=RoundTo(MasPoint[10,0],-13);
  MasPoint[11,1]:=RoundTo(Dst/2,-13);

  MasPoint[12,0]:=RoundTo(MasPoint[7,0]+c,-13);
  MasPoint[12,1]:=RoundTo(Dst/2,-13);

  MasPoint[13,0]:=RoundTo(MasPoint[12,0],-13);
  MasPoint[13,1]:=RoundTo(MasPoint[6,1],-13);

  MasPoint[14,0]:=RoundTo(MasPoint[13,0]+k2,-13);
  MasPoint[14,1]:=RoundTo(MasPoint[6,1],-13);

  MasPoint[15,0]:=RoundTo(MasPoint[14,0],-13);
  MasPoint[15,1]:=RoundTo(MasPoint[14,1]+S1,-13);

  MasPoint[16,0]:=RoundTo(MasPoint[0,0]+tan(g)*(De-Dfe)/2,-13);
  MasPoint[16,1]:=RoundTo(Dfe/2,-13);

  //Перевод из миллиметровой СИ в метрическую
  for i:=0 to 16 do
  begin
    MasPoint[i,0]:=MasPoint[i,0]/1000;
    MasPoint[i,1]:=MasPoint[i,1]/1000;
  end;

//Построение линий
  //Получение указателя на исходную точку
  SL:=md.ISelectionManager;
  md.SelectByID('Point1@Исходная точка', 'EXTSKETCHPOINT', 0, 0, 0);
  StartPoint:= SL.GetSelectedObject(1) as ISketchPoint;

  //Осевая горизонтальная
  Seg[0]:=md.ICreateLine2(0,0,0,MasPoint[0,0],0,0);
  Seg[0].ConstructionGeometry:=true;
  md.SketchAddConstraints('sgHORIZONTAL');
  Seg[0].QueryInterface(IID_ISketchLine, Sel[0]);   //S0-L0
  Sep[0]:=Sel[0].IGetStartPoint2;                   //P0
  StartPoint.Select(False);
  Sep[0].Select(True);
  md.SketchAddConstraints('sgCOINCIDENT');

  //Осевая наклонная
  Seg[1]:=md.ICreateLine2 (0,0,0,MasPoint[0,0],MasPoint[0,1],MasPoint[0,2]);
  Seg[1].ConstructionGeometry:=true;
  Seg[1].QueryInterface(IID_ISketchLine, Sel[1]);     //S1-L1
  Sep[1]:=Sel[1].IGetStartPoint2;                     //P1
  Sep[0].Select(False);
  Sep[1].Select(True);
  md.SketchAddConstraints('sgMERGEPOINTS');

  //Простановка угла G
  Seg[0].Select(false);
  Seg[1].Select(true);
  md.AddDimension2(0.02, 0.02, 0);

  //Вспомогательные осевые
  Seg[2]:=md.ICreateLine2 (0,0,0,MasPoint[1,0],MasPoint[1,1],MasPoint[1,2]);
  Seg[2].ConstructionGeometry:=true;
  Seg[2].QueryInterface(IID_ISketchLine, Sel[2]);    //S2-L2
  Sep[2]:=Sel[2].IGetStartPoint2;                    //P2
  Sep[0].Select(False);
  Sep[2].Select(True);
  md.SketchAddConstraints('sgMERGEPOINTS');

  Seg[3]:=md.ICreateLine2 (0,0,0,MasPoint[16,0],MasPoint[16,1],MasPoint[16,2]);
  Seg[3].ConstructionGeometry:=true;
  StartPoint.Select(False);
  Seg[3].QueryInterface(IID_ISketchLine, Sel[3]);    //S3-L3
  Sep[3]:=Sel[3].IGetStartPoint2;                    //P3
  Sep[0].Select(False);
  Sep[3].Select(True);
  md.SketchAddConstraints('sgMERGEPOINTS');

  Seg[4]:=md.ICreateLine2 (MasPoint[0,0],0,0,MasPoint[0,0],MasPoint[0,1],MasPoint[0,2]);
  Seg[4].ConstructionGeometry:=true;
  md.SketchAddConstraints('sgVERTICAL');
  Sep[5]:=Sel[0].IGetEndPoint2;                        //P5
  Seg[4].QueryInterface(IID_ISketchLine, Sel[4]);      //S4-L4
  Sep[6]:=Sel[4].IGetStartPoint2;                      //P6
  Sep[5].Select(False);
  Sep[6].Select(True);
  md.SketchAddConstraints('sgMERGEPOINTS');
  Sep[7]:=Sel[4].IGetEndPoint2;                      //P7
  Sep[8]:=Sel[1].IGetEndPoint2;                      //P8
  Sep[7].Select(False);
  Sep[8].Select(True);
  md.SketchAddConstraints('sgMERGEPOINTS');

  //Прорисовка вершин зубьев
  Seg[5]:=md.ICreateLine2 (MasPoint[0,0],MasPoint[0,1],MasPoint[0,2],MasPoint[1,0],MasPoint[1,1],MasPoint[1,2]);
  Seg[1].Select(false);
  Seg[5].Select(true);
  md.SketchAddConstraints('sgPERPENDICULAR');

  Seg[6]:=md.ICreateLine2 (MasPoint[1,0],MasPoint[1,1],MasPoint[1,2],MasPoint[2,0],MasPoint[2,1],MasPoint[2,2]);
  Seg[7]:=md.ICreateLine2 (MasPoint[2,0],MasPoint[2,1],MasPoint[2,2],MasPoint[3,0],MasPoint[3,1],MasPoint[3,2]);
  Seg[7].Select(false);
  Seg[1].Select(true);
  md.SketchAddConstraints('sgPERPENDICULAR');
  seg[5].Select(False);
  seg[7].Select(True);
  md.AddDimension2(MasPoint[1,0]-0.01, MasPoint[1,1], 0);

  //Прорисовка остльного венца
  Seg[8]:=md.ICreateLine2 (MasPoint[3,0],MasPoint[3,1],MasPoint[3,2],MasPoint[4,0],MasPoint[4,1],MasPoint[4,2]);
  Seg[7].Select(False);
  Seg[8].Select(True);
  md.SketchAddConstraints('sgCOLINEAR');

  Seg[9]:=md.ICreateLine2 (MasPoint[4,0],MasPoint[4,1],MasPoint[4,2],MasPoint[5,0],MasPoint[5,1],MasPoint[5,2]);
  md.AddDimension2(MasPoint[5,0]-0.01, MasPoint[5,1]-0.01, 0);
  Seg[8].Select(False);
  Seg[9].Select(True);
  md.SketchAddConstraints('sgCOLINEAR');

  Seg[21]:=md.ICreateLine2 (MasPoint[0,0],MasPoint[0,1],MasPoint[0,2],MasPoint[16,0],MasPoint[16,1],MasPoint[16,2]);
  Seg[5].Select(False);
  Seg[21].Select(True);
  md.SketchAddConstraints('sgCOLINEAR');

  Seg[10]:=md.ICreateLine2 (MasPoint[5,0],MasPoint[5,1],MasPoint[5,2],MasPoint[6,0],MasPoint[6,1],MasPoint[6,2]);
  md.SketchAddConstraints('sgHORIZONTAL');
  md.AddHorizontalDimension2(MasPoint[6,0]-0.005, MasPoint[6,1]-0.01, 0);

  //Прорисовка ступицы
  Seg[11]:=md.ICreateLine2 (MasPoint[6,0],MasPoint[6,1],MasPoint[6,2],MasPoint[7,0],MasPoint[7,1],MasPoint[7,2]);
  md.SketchAddConstraints('sgVERTICAL');

  Seg[12]:=md.ICreateLine2 (MasPoint[7,0],MasPoint[7,1],MasPoint[7,2],MasPoint[8,0],MasPoint[8,1],MasPoint[8,2]);
  md.SketchAddConstraints('sgHORIZONTAL');
  Seg[0].Select(false);
  Seg[12].Select(True);
  md.AddDiameterDimension(MasPoint[5,0], 0.01, 0);

  Seg[13]:=md.ICreateLine2 (MasPoint[8,0],MasPoint[8,1],MasPoint[8,2],MasPoint[9,0],MasPoint[9,1],MasPoint[9,2]);
  md.SketchAddConstraints('sgVERTICAL');

  Seg[10].QueryInterface(IID_ISketchLine, Sel[5]);     //S10-L5
  Sep[9]:=Sel[5].IGetStartPoint2;                      //P9
  Seg[13].Select(false);
  Sep[9].Select(True);
  md.AddHorizontalDimension(MasPoint[6,0]-0.01, MasPoint[6,1]-0.01, 0);

  Seg[14]:=md.ICreateLine2 (MasPoint[9,0],MasPoint[9,1],MasPoint[9,2],MasPoint[10,0],MasPoint[10,1],MasPoint[10,2]);
  md.SketchAddConstraints('sgHORIZONTAL');
  Seg[14].Select(false);
  Seg[0].Select(True);
  md.AddDiameterDimension(MasPoint[10,0], 0.01, 0);

  Seg[15]:=md.ICreateLine2 (MasPoint[10,0],MasPoint[10,1],MasPoint[10,2],MasPoint[11,0],MasPoint[11,1],MasPoint[11,2]);
  md.SketchAddConstraints('sgVERTICAL');

  Seg[16]:=md.ICreateLine2 (MasPoint[11,0],MasPoint[11,1],MasPoint[11,2],MasPoint[12,0],MasPoint[12,1],MasPoint[12,2]);
  md.SketchAddConstraints('sgHORIZONTAL');
  Seg[12].Select(false);
  Seg[16].Select(True);
  md.SketchAddConstraints('sgCOLINEAR');

  Seg[17]:=md.ICreateLine2 (MasPoint[12,0],MasPoint[12,1],MasPoint[12,2],MasPoint[13,0],MasPoint[13,1],MasPoint[13,2]);
  md.SketchAddConstraints('sgVERTICAL');
  Seg[11].Select(False);
  Seg[17].Select(True);
  md.AddHorizontalDimension2(MasPoint[6,0]-0.005, MasPoint[6,1]-0.01, 0);

  Seg[18]:=md.ICreateLine2 (MasPoint[13,0],MasPoint[13,1],MasPoint[13,2],MasPoint[14,0],MasPoint[14,1],MasPoint[14,2]);
  md.SketchAddConstraints('sgHORIZONTAL');
  md.AddHorizontalDimension2(MasPoint[14,0]-0.005, MasPoint[14,1]-0.01, 0);
  Seg[10].Select(False);
  Seg[18].Select(True);
  md.SketchAddConstraints('sgCOLINEAR');

  Seg[18].QueryInterface(IID_ISketchLine, Sel[6]);     //S18-L6
  Sep[10]:=Sel[6].IGetEndPoint2;                       //P10
  Seg[15].Select(false);
  Sep[10].Select(True);
  md.AddHorizontalDimension(MasPoint[14,0]+0.01, MasPoint[14,1]-0.01, 0);

  Seg[19]:=md.ICreateLine2 (MasPoint[15,0],MasPoint[15,1],MasPoint[15,2],MasPoint[14,0],MasPoint[14,1],MasPoint[14,2]);
  md.SketchAddConstraints('sgVERTICAL');

  Seg[20]:=md.ICreateLine2 (MasPoint[16,0],MasPoint[16,1],MasPoint[16,2],MasPoint[15,0],MasPoint[15,1],MasPoint[15,2]);
  Seg[21].Select(False);
  Seg[20].Select(True);
  md.SketchAddConstraints('sgCOLINEAR');

  Seg[20].QueryInterface(IID_ISketchLine, Sel[7]);      //S20-L7
  Sep[11]:=Sel[7].IGetEndPoint2;                        //P11
  Seg[19].QueryInterface(IID_ISketchLine, Sel[8]);      //S19-L8
  Sep[12]:=Sel[8].IGetStartPoint2;                      //P12
  Sep[11].Select(False);
  Sep[12].Select(True);
  md.SketchAddConstraints('sgMERGEPOINTS');

  //Простановка диаметров
  Seg[5].QueryInterface(IID_ISketchLine, Sel[9]);       //S5-L9
  Sep[13]:=Sel[9].IGetEndPoint2;                        //P13
  Sep[14]:=Sel[9].IGetStartPoint2;                      //P14

  Seg[21].QueryInterface(IID_ISketchLine, Sel[10]);     //S21-L10
  Sep[15]:=Sel[10].IGetEndPoint2;                       //P15

  Sep[13].Select(false);
  Seg[0].Select(True);
  md.AddDimension(MasPoint[10,0]+0.05, MasPoint[10,1], 0);

  Sep[14].Select(false);
  Seg[0].Select(True);
  md.AddDimension(MasPoint[10,0]+0.06, MasPoint[10,1], 0);

  Sep[15].Select(false);
  Seg[0].Select(True);
  md.AddDimension(MasPoint[10,0]+0.07, MasPoint[10,1], 0);

  //Дополнительные взаимосвязи
  Seg[1].Select(False);
  Sep[14].Select(True);
  md.SketchAddConstraints('sgCOINCIDENT');

  Seg[2].Select(False);
  Sep[13].Select(True);
  md.SketchAddConstraints('sgCOINCIDENT');

  Seg[3].Select(False);
  Sep[15].Select(True);
  md.SketchAddConstraints('sgCOINCIDENT');

  Seg[7].QueryInterface(IID_ISketchLine, Sel[11]);      //S7-L11
  Sep[16]:=Sel[11].IGetStartPoint2;                     //P16
  Seg[2].Select(False);
  Sep[16].Select(True);
  md.SketchAddConstraints('sgCOINCIDENT');

  Sep[17]:=Sel[11].IGetEndPoint2;                       //P17
  Seg[1].Select(False);
  Sep[17].Select(True);
  md.SketchAddConstraints('sgCOINCIDENT');

  Seg[8].QueryInterface(IID_ISketchLine, Sel[12]);      //S8-L12
  Sep[18]:=Sel[12].IGetEndPoint2;                       //P18
  Seg[3].Select(False);
  Sep[18].Select(True);
  md.SketchAddConstraints('sgCOINCIDENT');

  Seg[14].Select(False);
  Sep[7].Select(True);
  md.SketchAddConstraints('sgMERGEPOINTS');

  md.SetInferenceMode(true);  //Включение автопривязок
  md.SetUserPreferenceToggle(SWInputDimValOnCreate, true);                      //Включить диалог проставления размеров
  seg[0].Select(false);                                                         //Выделение осевой для кручения
  Bobishka:=MD.FeatureManager.FeatureRevolve(2*pi,false,0,0,0,true,false,false); //Бобышка - повернуть
end;

end.
