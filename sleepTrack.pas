unit sleepTrack;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, system.math,
  Vcl.Imaging.pngimage, Vcl.WinXCalendars, Vcl.Grids, globalUnit, dateutils;

type
  Tform_sleepTrack = class(TForm)
    Panel1: TPanel;
    img_icon: TImage;
    lbl_sleepTracker: TLabel;
    lbl_back: TLabel;
    lbl_goal: TLabel;
    lbl_displaygoal: TLabel;
    shp_displayGoal: TShape;
    cbo_selectView: TComboBox;
    lbl_showdata: TLabel;
    cbo_days: TComboBox;
    stg_viewMany: TStringGrid;
    lbl_showOneDay: TLabel;
    stg_viewOne: TStringGrid;
    lbl_viewManyError: TLabel;
    img_qu: TImage;
    mmo_help: TMemo;
    cdr_selectDate: TCalendarView;
    lbl_viewOneError: TLabel;
    procedure lbl_backMouseEnter(Sender: TObject);
    procedure lbl_backClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbo_daysChange(Sender: TObject);
    procedure img_quMouseEnter(Sender: TObject);
    procedure img_quMouseLeave(Sender: TObject);
    procedure cdr_selectDateChange(Sender: TObject);
    procedure lbl_backMouseLeave(Sender: TObject);
    procedure cbo_selectViewChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  form_sleepTrack: Tform_sleepTrack;

implementation

{$R *.dfm}

uses dashboard, sleepEnterDaily;
//changing combobox to change form:
procedure Tform_sleepTrack.cbo_selectViewChange(Sender: TObject);
begin
if cbo_selectView.ItemIndex= 0 then  //if on option 'enter today's data'
  begin
  form_sleepTrack.Hide; //hide the current form
  form_sleepEnterDaily.show; //show the data entry form
  form_sleepEnterDaily.lbl_displaygoal.Caption:= getGoal('sleep') + ' hours'; //display goal
  form_sleepEnterDaily.lbl_date.Caption:= ' Todays date is ' + datetostr(date); //display date
  form_sleepEnterDaily.lbl_displaybmi.caption:= floattostr(roundto(getBMI,-1)); //display BMI
  if isTodayRecorded('sleep') = TRUE then  //if data has been recorded today
    begin
    form_sleepEnterDaily.edt_input.ReadOnly:=TRUE; //make edit box read only
    form_sleepEnterDaily.edt_input.Text:= 'Todays data has been recorded';  //display message
    form_sleepEnterDaily.edt_input.Font.Style:=[fsBold]; //change font to bold
    form_sleepEnterDaily.btn_submit.Hide; //hide the submit button
    end;
  end;
end;
//changing calendar:
procedure Tform_sleepTrack.cdr_selectDateChange(Sender: TObject);
var sleepData: TStringList;
    path: string;
    fileLength, index:integer;
begin
stg_viewOne.Rows[0].Clear; //clearing previous data from the grid
lbl_viewManyError.Hide; //hiding previous error messages
lbl_viewOneError.Hide;  //hiding previous error messages
path:= currentDir + '\' + 'sleepProgress.txt'; //sleepProgress filepath
sleepData:=TStringList.Create; //creating a stringList to hold all the data in sleepProgress
  sleepData.LoadFromFile(path); //loading the sleepProgress data into stringList sleepData
  fileLength:= sleepData.Count; //number of records
  index:= searchDate(sleepData, cdr_selectDate.Date, 1, (fileLength-1)); //calling searchDate, returning the date's index
  if (index = -1) then  //date not found
    begin
    lbl_viewOneError.Show; //show error message
    lbl_viewOneError.Caption:= 'There is no data recorded for '+ #13#10+ datetostr(cdr_selectDate.Date)+'.'; //error message
    end
  else  //if date found
    begin
     stg_viewOne.Cells[0,0]:= datetostr(cdr_selectDate.Date); //outputting date on grid
     stg_viewOne.Cells[1,0]:= sleepData[index+1] + ' hours'; //outputting the date's data
    end;
sleepData.Free; //free stringlist
end;
//changing days combobox:
procedure Tform_sleepTrack.cbo_daysChange(Sender: TObject);
var path, aDate, aValue: string;
    numdays, I, fileLength, row:integer;
    sleepData: TStringList;
    recordsDisplayed: double;
begin
lbl_viewManyError.Hide; //hide error messages
lbl_viewOneError.Hide;
for I := 0 to 1 do
  stg_viewMany.Cols[I].Clear; //clearing contents of stringgrid
numDays:= cbo_days.ItemIndex +1; //number of days requested. +1 because indexing begins at 0
path:= currentDir + '\' + 'sleepProgress.txt'; //sleepProgress filepath
sleepData:=TStringList.Create; //creating a stringList to hold all the data in sleepProgress
  sleepData.LoadFromFile(path); //loading the sleepProgress data into stringList sleepData
  fileLength:= sleepData.Count; //number of records
  if (((fileLength)-1)/2)>= numDays then  //if the user has the requested number of entries
    begin
    i:= (fileLength+1)- numdays*2;  //pointer on the first record
    row:= 0; //initialising first row
    while I < fileLength do  //loop for each entry
     begin
     aDate:=sleepData[I-1]; //assigning aDate from sleepData
     stg_viewMany.Cells[0,row]:=aDate; //output date on stringgrid
     i:= i +1; //increment pointer
     aValue:= sleepData[I-1]; //assigning aValue from sleepData
     stg_viewMany.Cells[1,row]:= (aValue + ' hours');  //output value on stringgrid
     i:=i+1;
     row:=row+1; //next stringgrid row
     end;
    sleepData.Free;
    end
 else //if user doesnt have requested number of entries
    begin
    lbl_viewManyError.Show; //show the error label
    recordsDisplayed:= 0.5*(fileLength-1); //the number of records recorded
    lbl_viewManyError.Caption:= 'You do not yet have '+inttostr(numdays)+' entries recorded.'+#13#10+' The last '+floattostr(recordsDisplayed) + ' values have been displayed' ; //the error message
    I:= 1; //initialising pointer to the first date
    row:= 0; //initialising string grid row
    WHILE I< fileLength-1 do //iteration for each record, until end of string list
      begin
      aDate:=sleepData[I]; //assigning the date from string list
      stg_viewMany.Cells[0, row]:= aDate; //displaying the date
      I:= I + 1;
      aValue:= sleepData[I]; //assigning the value
      stg_viewMany.Cells[1, row]:= aValue; //displaying the value
      I:= I +1;
      row:= row+1; //next string grid row
      end;
    sleepData.Free; //free stringlist
    end;
end;
//on creating form:
procedure Tform_sleepTrack.FormCreate(Sender: TObject);
begin
cbo_days.ItemHeight:= 0;  //setting default index
lbl_viewManyError.Hide; //hiding the error messages
lbl_viewOneError.Hide;
mmo_help.Hide; //hiding help memo
end;
//hovering over question bubble:
procedure Tform_sleepTrack.img_quMouseEnter(Sender: TObject); //hover over qu mark
begin
mmo_help.show; //show help memo
mmo_help.Text:= 'Select a date from the calendar'; //text on help memo
end;
//hovering off question bubble:
procedure Tform_sleepTrack.img_quMouseLeave(Sender: TObject); //move mouse off
begin
mmo_help.hide; //hide help memo
end;
//clicking 'back to dashboard':
procedure Tform_sleepTrack.lbl_backClick(Sender: TObject);
begin
form_dashboard.show; //show dashboard
form_sleepTrack.Hide; //hide current form
end;
//hovering over 'back to dashboard':
procedure Tform_sleepTrack.lbl_backMouseEnter(Sender: TObject);
begin
lbl_back.Font.Style:=[fsBold, fsUnderline];  //style bold and underlined
end;
//hovering off 'back to dashboard':
procedure Tform_sleepTrack.lbl_backMouseLeave(Sender: TObject);
begin
lbl_back.Font.Style:=[fsUnderline];//style underlined
end;
end.
