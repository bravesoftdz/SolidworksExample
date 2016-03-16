 unit Konich_zub;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SldWorks_tlb, SwConst_TLB, StdCtrls, ExtCtrls, math;
type

 Tarrays= array of double;

procedure narezanie(g, m: double;  z: integer; B: Double; Y2:real; var md:  IModelDoc2);

implementation

procedure narezanie(g, m: Double;  z: integer; B: Double; Y2:real; var md:  IModelDoc2);
var    sig, sgx2,sgy2: real;
       de, x1,y1,z1, Fi1, zen, rig, lef: Double;                              //zen, rig, lef - ���������� ��� ����
       t:integer;
       sw: ISldWorks;
       vPoints: variant;
       SL: ISelectionMgr;
       l1: ISketchSegment;
       f1,f2: iFeature;
       s1: ISketch;
       F: IFeatureManager;
       Disp: IDispatch;
       RPlane: IRefPlane;
       v: Variant;
       StartPoint: ISketchPoint;                    // ������� �����
       Seg1,seg2: array[0..21] of ISketchSegment;   // �������� ������
       Sep1,sep2: array[0..18] of ISketchPoint;     // ����� ������
       Sel1,sel2: array[0..12] of ISketchLine;      // ����� ������
       ar1:array[0..3] of ISketchArc;               // ���� ������
       pointtArray, pointtArray1: tarrays;

begin

  SL:=md.ISelectionManager;
  //���� � �����, ���������� �������������� ������, ������ 100��
  md.Extension.SelectByID2('�������', 'PLANE', 0, 0, 0, False, 0, Nil, 0);
  md.InsertSketch;
  md.SetUserPreferenceToggle( swInputDimValOnCreate,False );

  ////****���������� ����� 1������****


    //��������� ��������� �� �������� �����

  md.SelectByID('Point1@�������� �����', 'EXTSKETCHPOINT', 0, 0, 0);
  StartPoint:= SL.GetSelectedObject(1) as ISketchPoint;

  seg1[0]:=md.iCreateLine2(0,0,0,0.1,0,0);
  Seg1[0].ConstructionGeometry:=true;
  md.SketchAddConstraints('sgHORIZONTAL');
  Seg1[0].QueryInterface(IID_ISketchLine, Sel1[0]);   //S0-L0
  Sep1[0]:=Sel1[0].IGetStartPoint2;                   //P0
  StartPoint.Select(False);
  Sep1[0].Select(True);
  md.SketchAddConstraints('sgCOINCIDENT');

  //������ ���� � ��������
  sig:=g;   //*pi/180;
  de:=m*z*0.001*0.5;
  //���������� ���������� � ��� ���������� ��������� ������
  x1:=de/tan(sig);
  //���������� ��������� ������ ������ ������, ��� �������� �������
  seg1[1]:=md.ICreateLine2(0,0,0,x1,de,0);
  Seg1[1].ConstructionGeometry:=true;
  Seg1[1].QueryInterface(IID_ISketchLine, Sel1[1]);     //S1-L1
  Sep1[1]:=Sel1[1].IGetStartPoint2;                     //P1
  Sep1[0].Select(False);
  Sep1[1].Select(True);
  md.SketchAddConstraints('sgMERGEPOINTS');
  //����������� ���� G
  Seg1[0].Select(false);
  Seg1[1].Select(true);

  md.AddDimension2(0.02, 0.02, 0);
  //���������� ����� �� ����� ��������� �� ������ ����� ������.
  seg1[2]:=md.ICreateLine2(x1,de,0,x1,0,0);
  Seg1[2].ConstructionGeometry:=true;
  Sep1[2]:=sel1[0].IGetEndPoint2;                 // sep1[2]  -   2 ����� ��������� ������
  md.ClearSelection2(true);
  Seg1[2].Select(true);
  Sep1[2].Select(True);
  md.SketchAddConstraints('sgCOINCIDENT');
  md.SketchAddConstraints('sgMERGEPOINTS');
  //�����������    de
  md.ClearSelection2(true);
  seg1[2].Select(false);
  md.AddDimension2(0.1, 0.04,0);

   md.SketchManager.InsertSketch(false);
  //���������� ����� ��������� ���������������� ����������� ��������� ������ � ����� ����� ��� ������.
  md.ClearSelection2(true);
  sep1[3]:=sel1[1].IGetEndPoint2;
  sep1[3].Select(true);
  seg1[1].Select(true);

  md.CreatePlanePerCurveAndPassPoint3(false,true);

  //���������� � ��������� ��������� ������
  md.SelectionManager;
  md.SelectByID('���������4', 'PLANE', 0, 0, 0);
  md.SketchManager.InsertSketch(false);
  //����� ���� ��� ����� �������� �����������
  md.ShowNamedView2 ('���������', 7);                                                    Sleep(500);
  md.ViewZoomTo2 (-0.00772668, 0.0357606, 0.0670649, 0.110297, -0.0618019, 0.0670649);
  //�������� ����� ���������
    //�������� ������ ������� ����
  seg2[0]:=md.ICreateLine2(0,0,0,(1.35*m*0.001), 0,0);
  Seg2[0].ConstructionGeometry:=true;
  Seg2[0].Select(True);
  md.SketchAddConstraints('sgVertical');
     // �������� ������ ��������� ����
  seg2[1]:=md.ICreateLine2(0,0,0, (-1.2*m*0.001),0,0);
  Seg2[1].ConstructionGeometry:=true;
  seg2[1].Select(false);
  md.SketchAddConstraints('sgVertical');
     //����������� ������������ � ��������
  Seg2[0].QueryInterface(IID_ISketchLine, Sel2[0]);
  Seg2[1].QueryInterface(IID_ISketchLine, Sel2[1]);
  sep2[0]:=sel2[0].iGetEndPoint2;
  sep2[1]:=sel2[0].iGetStartPoint2;
  sep2[2]:=sel2[1].iGetEndPoint2;
  md.ClearSelection2(true);
  sep2[0].Select(true);
  sep2[1].Select(true);
  md.AddDimension2(0.01,0.5*m*0.001,0.001);
  md.ClearSelection2(true);
  sep2[1].Select(true);
  sep2[2].Select(true);
  md.AddDimension2(0.03,-0.5*m*0.001,0.003);

  //�������� ���� �������� - ������� �/�� �������
  md.SetInferenceMode(false);

  //      zen, rig, lef
  // ���������� ������ ����: 0-1.2*m-m*z*0.5
  //���������� y ����� ����� ����:  -1.2*m-m*z*0.5+ sqrt( (m*z*0.5)^2 -(0.4*m)^2)
  //���������� x ����� ����� ����:  +- 0.4*m
  zen:=0-1.2*m-m*z*0.5;
  zen:=zen/1000;
  rig:=-1.2*m-m*z*0.5+ sqrt( sqr(m*z*0.5) -sqr(0.4*m));
  rig:=rig/1000;

  seg2[2]:=md.SketchManager.CreateArc(zen,0,0,   zen,rig,0,   zen,-rig,0,    1);

  seg2[2].QueryInterface(IID_ISketchArc, ar1[0]);
  sep2[3]:=ar1[0].IGetCenterPoint2;
  md.ClearSelection2(true);
  sep2[3].Select(true);
  md.SketchAddConstraints('sgFIXED');
  md.ClearSelection2(true);

  //�������� �����
  sep2[4]:=md.iCreatePoint2(rig, -0.4*m/1000,0);
  sep2[5]:=md.iCreatePoint2(rig, 0.4*m/1000,0);
  sep2[4].Select(true);

  md.SketchAddConstraints('sgFIXED');

  //������ ����� ������ � ����� ���� � ������������ �������
  md.ClearSelection2(true);
  sep2[6]:=ar1[0].IGetStartPoint2;
  sep2[6].Select(true);
  sep2[4].Select(true);
  sep2[10]:=ar1[0].IGetendPoint2;
  md.SketchAddConstraints('sgCOINCIDENT');

  //�������� ������ ��� ���������� ������� ���� � ������� �������.
  md.SetInferenceMode(false);
  seg2[4]:=md.iCreateLine2(rig, 0.4*m/1000,0,    0,(pi*m*z/(4*z))*0.001,0) ;
  Seg2[4].ConstructionGeometry:=true;
  seg2[5]:=md.ICreateLine2(rig, 0.4*m/1000,0,     (1.35*m*0.001),0.4*m*0.001+((2.5*m*tan(25*pi/180))*0.001),0 );
  Seg2[5].ConstructionGeometry:=true;

  md.SetInferenceMode(true);
  seg2[4].QueryInterface(IID_ISketchLine, Sel2[3]);
  sep2[7]:=sel2[3].IGetEndPoint2;
  seg2[5].QueryInterface(IID_ISketchLine, sel2[4]);
  sep2[8]:=sel2[4].IGetEndPoint2;
  md.ClearSelection2(true);
  seg2[2].Select(true);

  // ������� ������� ����
  md.SketchTrim(0,1,zen*tan(-pi/4),zen*tan(-pi/4));
  md.ClearSelection2(true);
  sep2[9]:=sel2[3].IGetStartPoint2;

  //�������� 2 ������� ������� ����
  md.ClearSelection2(true);
  t:=3;
  SetLength(pointtArray,t*3);
  pointtArray[0]:= rig;
  pointtArray[1]:= 0.4*m/1000;
  pointtArray[2]:= 0;
  pointtArray[3]:= 0;
  pointtArray[4]:= (pi*m*z/(4*z))*0.001;
  pointtArray[5]:= 0;
  pointtArray[6]:= (1.35*m*0.001);
  pointtArray[7]:= 0.4*m*0.001+((2.5*m*tan(25*pi/180))*0.001);
  pointtArray[8]:= 0;

  md.SetInferenceMode(false);
  disp:=md.CreateSpline(pointtarray);

  //�������� 2 ������ ������ ����� ��� ���������� ������� ����
  seg2[6]:=md.iCreateLine2(rig, -0.4*m/1000,0,   0,(pi*m*z/(-4*z))*0.001,0) ;
  Seg2[6].ConstructionGeometry:=true;
  seg2[7]:=md.ICreateLine2(rig, -0.4*m/1000,0,   (1.35*m*0.001),-0.4*m*0.001+((-2.5*m*tan(25*pi/180))*0.001) ,0 );
  Seg2[7].ConstructionGeometry:=true;

  SetLength(pointtArray1,t*3);

  pointtArray1[0]:= rig;
  pointtArray1[1]:= -0.4*m/1000;
  pointtArray1[2]:= 0;
  pointtArray1[3]:= 0;
  pointtArray1[4]:= -(pi*m*z/(4*z))*0.001;
  pointtArray1[5]:= 0;
  pointtArray1[6]:= (1.35*m*0.001);
  pointtArray1[7]:=- 0.4*m*0.001+((-2.5*m*tan(25*pi/180))*0.001);
  pointtArray1[8]:= 0;

  md.CreateSpline(pointtArray1);

  seg2[8]:=md.ICreateLine2((1.35*m*0.001) ,0.4*m*0.001+((2.5*m*tan(25*pi/180))*0.001),0,     2.8*m*0.001,0,0);
  seg2[9]:=md.ICreateLine2((1.35*m*0.001) ,-0.3*m*0.001+((-2.5*m*tan(25*pi/180))*0.001),0,   2.8*m*0.001,0,0);
  md.SetInferenceMode(true);

  Seg2[8].QueryInterface(IID_ISketchLine, Sel2[6]);
  seg2[7].QueryInterface(IID_ISketchLine, Sel2[5]);
  seg2[9].QueryInterface(IID_ISketchLine, Sel2[7]);
  sep2[11]:=sel2[7].IGetendPoint2;
  sep2[12]:=sel2[5].IGetendPoint2;
  sep2[10]:=sel2[7].IGetStartPoint2;
  sep2[13]:=sel2[6].IGetEndPoint2;
  md.ClearSelection2(true);
  sep2[10].Select(true);
  sep2[12].Select(true);
  md.SketchAddConstraints('sgMERGEPOINTS');

  md.ClearSelection2(true);
  sep2[13].Select(true);
  sep2[11].Select(true);
  md.SketchAddConstraints('sgMERGEPOINTS');

  //����� ����
  md.FeatureManager.FeatureCut (False, False, False, 0, 0, (B+1)/1000, (B+1)/1000, True, True, False, True, g-y2, g-y2, False, False, False, False, false, true, true);

  //�������� ������ ���������
  md.Extension.SelectByID2('��������1', 'BODYFEATURE', 0, 0, 0, False, 4, nil, 0);
  md.Extension.SelectByID2('�����1','SKETCH', 0, 0, 0, True, 1, nil, 0);
  md.FeatureManager.FeatureCircularPattern2(z, 2*pi/z, True, 'NULL', False);
  md.ClearSelection2(true);
end;

end.
