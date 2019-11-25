unit bmiTrack;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.WinXCalendars, Vcl.StdCtrls,
  Vcl.Grids, Vcl.ExtCtrls, Vcl.Imaging.pngimage, dashboard, bmiEnterDaily, globalUnit, system.Math;

type
  Tform_bmiTrack = class(TForm)
    lbl_BMI: TLabel;
    lbl_displayBMI: TLabel;
    shp_displayBMI: TShape;
    lbl_showdata: TLabel;
    lbl_showOneDay: TLabel;
    lbl_viewManyError: TLabel;
    img_qu: TImage;
    lbl_viewOneError: TLabel;
    Panel1: TPanel;
    img_icon: TImage;
    lbl_bmiTracker: TLabel;
    lbl_back: TLabel;
    cbo_selectView: TComboBox;
    cbo_days: TComboBox;
    stg_viewMany: TStringGrid;
    stg_viewOne: TStringGrid;
    mmo_help: TMemo;
    cdr_selectDate: TCalendarView;
    btn_charts: TButton;
    procedure cbo_selectViewChange(Sender: TObject);
    procedure cdr_selectDateChange(Sender: TObject);
    procedure cbo_daysChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure img_quMouseEnter(Sender: TObject);
    procedure img_quMouseLeave(Sender: TObject);
    procedure lbl_backClick(Sender: TObject);
    procedure lbl_backMouseEnter(Sender: TObject);
    procedure lbl_backMouseLeave(Sender: TObject);
    procedure btn_chartsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  form_bmiTrack: Tform_bmiTrack;

implementation

{$R *.dfm}

uses bmiCharts;

procedure Tform_bmiTrack.btn_chartsClick(Sender: TObject);
begin
form_bmiCharts.show;
end;

procedure Tform_bmiTrack.cbo_daysChange(Sender: TObject);
var path, aDate, aValue: string;
    numdays, I, fileLength, row:integer;
    bmiData: TStringList;
    recordsDisplayed: double;
begin
lbl_viewManyError.Hide; //hide error messages
lbl_viewOneError.Hide;
for I := 0 to 1 do
  stg_viewMany.Cols[I].Clear; //clearing contents of stringgrid
numDays:= cbo_days.ItemIndex +1; //number of days requested. +1 because indexing begins at 0
path:= currentDir + '\' + 'bmiProgress.txt'; //bmiProgress filepath
bmiData:=TStringList.Create; //creating a stringList to hold all the data in bmiProgress
  bmiData.LoadFromFile(path); //loading the bmiProgress data into stringList bmiData
  fileLength:= bmiData.Count; //number of records
  if (((fileLength)-1)/2)>= numDays then  //if the user has the requested number of entries
    begin
    i:= (fileLength+1)- numdays*2;  //pointer on the first record
    row:= 0; //initialising first row
    while I < fileLength do  //loop for each entry
     begin
     aDate:=bmiData[I-1]; //assigning aDate from bmiData
     stg_viewMany.Cells[0,row]:=aDate; //output date on stringgrid
     i:= i +1;
     aValue:= bmiData[I-1]; //assigning aValue from bmiData
     stg_viewMany.Cells[1,row]:= ('BMI: '+aValue);  //output value on stringgrid
     i:=i+1;
     row:=row+1; //next stringgrid row
     end;
    bmiData.Free; //free stringlist
    end
 else
    begin
    lbl_viewManyError.Show; //show the error label
    recordsDisplayed:= 0.5*(fileLength-1); //the number of records recorded
    lbl_viewManyError.Caption:= 'You do not yet have '+inttostr(numdays)+' entries recorded.'+#13#10+' The last '+floattostr(recordsDisplayed) + ' values have been displayed' ; //the error message
    I:= 1; //initialising pointer to the first date
    row:= 0; //initialising string grid row
    WHILE I< fileLength-1 do //iteration for each record, until end of string list
      begin
      aDate:=bmiData[I]; //assigning the date from string list
      stg_viewMany.Cells[0, row]:= aDate; //displaying the date
      I:= I + 1; //incrment stringlist pointer
      aValue:= bmiData[I]; //assigning the value
      stg_viewMany.Cells[1, row]:= aValue; //displaying the value
      I:= I +1;  //increment stringlist pointer
      row:= row+1; //next string grid row
      end;
    bmiData.Free; //free stringlist
    end;
end;

//changing form using combo box to data entry form
procedure Tform_bmiTrack.cbo_selectViewChange(Sender: TObject);
begin
  begin
  form_bmiTrack.Hide; //hide the current form
  form_bmiEnterDaily.show; //show the data entry form
  form_bmiEnterDaily.lbl_date.Caption:= ' Todays date is ' + datetostr(date); //display date
  form_bmiEnterDaily.lbl_displaybmi.caption:= floattostr(roundto(getBMI,-1)); //display BMI
  if isTodayRecorded('bmi') = TRUE then  //if data has been recorded today
    begin
    form_bmiEnterDaily.edt_height.hide; //hide edit boxes
    form_bmiEnterDaily.edt_weight.hide;
    form_bmiEnterDaily.edt_message.Show; //show appropriate message
    form_bmiEnterDaily.btn_submit.Hide; //hide the submit button
    end;
  end;
end;
//changing calendar date
procedure Tform_bmiTrack.cdr_selectDateChange(Sender: TObject);
var bmiData: TStringList;
    path: string;
    fileLength, index:integer;
begin
stg_viewOne.Rows[0].Clear; //clearing previous data from the grid
lbl_viewManyError.Hide; //hiding previous error messages
lbl_viewOneError.Hide;  //hiding previous error messages
path:= currentDir + '\' + 'bmiProgress.txt'; //bmiProgress filepath
bmiData:=TStringList.Create; //creating a stringList to hold all the data in bmiProgress
  bmiData.LoadFromFile(path); //loading the bmiProgress data into stringList bmiData
  fileLength:= bmiData.Count; //number of records
  index:= searchDate(bmiData, cdr_selectDate.Date, 1, (fileLength-1)); //calling searchDate, returning the date's index
  if (index = -1) then  //date not found
    begin
    lbl_viewOneError.Show; //show error message
    lbl_viewOneError.Caption:= 'There is no data recorded for '+ #13#10+ datetostr(cdr_selectDate.Date)+'.'; //error message
    end
  else
    begin
     stg_viewOne.Cells[0,0]:= datetostr(cdr_selectDate.Date); //outputting date on grid
     stg_viewOne.Cells[1,0]:= 'BMI: '+ bmiData[index+1];//outputting the date's data
    end;
bmiData.Free;//free stringlist
end;
// on creating form
procedure Tform_bmiTrack.FormCreate(Sender: TObject);
begin
cbo_days.ItemHeight:= 0;  //setting default index
lbl_viewManyError.Hide; //hiding the error message
lbl_viewOneError.Hide;
mmo_help.Hide;
end;
//on mouse entering question bubble
procedure Tform_bmiTrack.img_quMouseEnter(Sender: TObject);
begin
mmo_help.show; //show help memo
mmo_help.Text:= 'Select a date from the calendar'; //text on help memo
end;
//on mouse leaving question bubble
procedure Tform_bmiTrack.img_quMouseLeave(Sender: TObject);
begin
mmo_help.hide; //hide help memo
end;
//clicking 'Back to dashboard'
procedure Tform_bmiTrack.lbl_backClick(Sender: TObject);
begin
form_dashboard.show; //show dashboard
form_bmiTrack.Hide;  //hide current form
end;
//hovering over 'back to dashboard'
procedure Tform_bmiTrack.lbl_backMouseEnter(Sender: TObject);
begin
lbl_back.Font.Style:=[fsBold, fsUnderline]; //style: bold and underlined
end;
//hovering off 'back to dashboard'
procedure Tform_bmiTrack.lbl_backMouseLeave(Sender: TObject);
begin
lbl_back.Font.Style:=[fsUnderline]; //style: underlined
end;
end.
