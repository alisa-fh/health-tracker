{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N-,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$WARN SYMBOL_DEPRECATED ON}
{$WARN SYMBOL_LIBRARY ON}
{$WARN SYMBOL_PLATFORM ON}
{$WARN SYMBOL_EXPERIMENTAL ON}
{$WARN UNIT_LIBRARY ON}
{$WARN UNIT_PLATFORM ON}
{$WARN UNIT_DEPRECATED ON}
{$WARN UNIT_EXPERIMENTAL ON}
{$WARN HRESULT_COMPAT ON}
{$WARN HIDING_MEMBER ON}
{$WARN HIDDEN_VIRTUAL ON}
{$WARN GARBAGE ON}
{$WARN BOUNDS_ERROR ON}
{$WARN ZERO_NIL_COMPAT ON}
{$WARN STRING_CONST_TRUNCED ON}
{$WARN FOR_LOOP_VAR_VARPAR ON}
{$WARN TYPED_CONST_VARPAR ON}
{$WARN ASG_TO_TYPED_CONST ON}
{$WARN CASE_LABEL_RANGE ON}
{$WARN FOR_VARIABLE ON}
{$WARN CONSTRUCTING_ABSTRACT ON}
{$WARN COMPARISON_FALSE ON}
{$WARN COMPARISON_TRUE ON}
{$WARN COMPARING_SIGNED_UNSIGNED ON}
{$WARN COMBINING_SIGNED_UNSIGNED ON}
{$WARN UNSUPPORTED_CONSTRUCT ON}
{$WARN FILE_OPEN ON}
{$WARN FILE_OPEN_UNITSRC ON}
{$WARN BAD_GLOBAL_SYMBOL ON}
{$WARN DUPLICATE_CTOR_DTOR ON}
{$WARN INVALID_DIRECTIVE ON}
{$WARN PACKAGE_NO_LINK ON}
{$WARN PACKAGED_THREADVAR ON}
{$WARN IMPLICIT_IMPORT ON}
{$WARN HPPEMIT_IGNORED ON}
{$WARN NO_RETVAL ON}
{$WARN USE_BEFORE_DEF ON}
{$WARN FOR_LOOP_VAR_UNDEF ON}
{$WARN UNIT_NAME_MISMATCH ON}
{$WARN NO_CFG_FILE_FOUND ON}
{$WARN IMPLICIT_VARIANTS ON}
{$WARN UNICODE_TO_LOCALE ON}
{$WARN LOCALE_TO_UNICODE ON}
{$WARN IMAGEBASE_MULTIPLE ON}
{$WARN SUSPICIOUS_TYPECAST ON}
{$WARN PRIVATE_PROPACCESSOR ON}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}
{$WARN OPTION_TRUNCATED ON}
{$WARN WIDECHAR_REDUCED ON}
{$WARN DUPLICATES_IGNORED ON}
{$WARN UNIT_INIT_SEQ ON}
{$WARN LOCAL_PINVOKE ON}
{$WARN MESSAGE_DIRECTIVE ON}
{$WARN TYPEINFO_IMPLICITLY_ADDED ON}
{$WARN RLINK_WARNING ON}
{$WARN IMPLICIT_STRING_CAST ON}
{$WARN IMPLICIT_STRING_CAST_LOSS ON}
{$WARN EXPLICIT_STRING_CAST OFF}
{$WARN EXPLICIT_STRING_CAST_LOSS OFF}
{$WARN CVT_WCHAR_TO_ACHAR ON}
{$WARN CVT_NARROWING_STRING_LOST ON}
{$WARN CVT_ACHAR_TO_WCHAR ON}
{$WARN CVT_WIDENING_STRING_LOST ON}
{$WARN NON_PORTABLE_TYPECAST ON}
{$WARN XML_WHITESPACE_NOT_ALLOWED ON}
{$WARN XML_UNKNOWN_ENTITY ON}
{$WARN XML_INVALID_NAME_START ON}
{$WARN XML_INVALID_NAME ON}
{$WARN XML_EXPECTED_CHARACTER ON}
{$WARN XML_CREF_NO_RESOLVE ON}
{$WARN XML_NO_PARM ON}
{$WARN XML_NO_MATCHING_PARM ON}
{$WARN IMMUTABLE_STRINGS OFF}
unit globalUnit;


interface
  uses Vcl.Graphics, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Math, classes;
  function searchDate(aList: TStringList; dateSought: TDate; first, last:integer):integer;
  type
    TMatrix= array of array of double;
    T4DArray=array of array of TMatrix;
  function getBMI: double;
  function getRecent(factorProgress:string):double;
  function arrayRecent:TMatrix;
  function calcRegression(indepVar:TMatrix):double;
  procedure insertFactorBMI;
  function changeETB(factor:string; barVal: double):double;
  function isPlan(factorProgress:string):boolean;
  function getFactorBMI:double;
  procedure saveGoal(factor:string; barVal: double);
  function getGoal(factor:string):string;
  function isTodayRecorded(factor:string):boolean;
  procedure saveData(factor:string; input:string);
  procedure updateFactorBMI;
  function validateDailyInput(factorIndex: integer; anInput:string):boolean;


  var
    currentUser:string;  //current username
    currentBMI: double;  //current user's BMI
    factorBMI: double;
    ary_coeff:TMatrix; //holds the four coefficients
    ary_bmi: TMatrix; //holds all the BMI data read from the database
    ary_factors: TMatrix; //holds all the factor data read from the database
    intUserDetails: textfile; //usernames and passwords of all users
    currentDir: string; //current users pathname
    origSleep: double;  //original factor values
    origWater:integer;
    origHappi:integer;
    origExerc:double;
    isSleep, isWater, isExerc, isHappi: boolean; //factor plan flags

implementation
//checking if data is recorded for today
function isTodayRecorded(factor:string):boolean; //takes factor as parameter
var path: string;
    factorData:TStringList;
    length: integer;
begin
path:= currentDir + '\' + factor +'Progress.txt'; //directory of the user's factor progress file
factorData:=TStringList.Create; //creating a stringList to hold all the data in the progress file
factorData.LoadFromFile(path); //loading the file data into stringList factorData
length:= factorData.Count;//getting length of factorData
if strtodate(factorData[length-2]) = date then //if the last date recorded = todays date
  result:= TRUE
else
  result:= FALSE;
end;
//save daily data on file
procedure saveData(factor:string; input:string); //parameters: factor and users input
var intFile: textfile;
    path: string;
begin
path:= currentDir + '\' + factor +'Progress.txt'; //directory of the user's factor progress file
AssignFile(intFile, path);
  Append(intFile); //opening intFile
  Writeln(intFile, datetostr(date));  //writing the date
  Writeln(intFile, input); //writing the users input
Closefile(intFile); //close file      f
end;
//getting recently recorded data average
function getAverage(factor:string):double;
var factorData: TStringList;
    path:string;
    numLines, I, entryCount, anIndex: integer;
    total, anEntry, avg:double;
begin
path:= currentDir + '\' + factor +'Progress.txt'; //directory of the user's factor progress file
factorData:=TStringList.Create; //creating a stringList to hold all the data in the progress file
factorData.LoadFromFile(path); //loading the file data into stringList factorData
numLines:= (factorData.Count)-1;//getting length of factorData
total:= 0;
entryCount := 0; //initialising entryCount
if numLines <=20 then
  begin
  I:= 2; //first data begins at index 2
  while I <= numLines do
    begin
    anEntry:= strtofloat(factorData[I]); //reading in data
    entryCount:= entryCount+1;
    total:= total+ anEntry; //running total
    I:= I +2;  //data is every second entry
    end;
  avg:=(total/entryCount); //average
  end
else
  begin
  anIndex:= numLines-20; //initialising index to read last 10 entries
  for I := 1 to 10 do //loop for each entry to be read
    begin
    anEntry:= strtofloat(factorData[anIndex]); //reading in data
    anIndex:= anIndex + 2; //data is every second entry
    total:= total+anEntry; //running total
    end;
  avg:= (total/10); //average
  end;
factordata.Free; //freeing factor data
result:= avg;  //returning average
end;
//validating daily inputs
function validateDailyInput(factorIndex: integer; anInput:string):boolean; //validate daily input values
//factor indexes: 0=sleep, 1=water, 2=happiness, 3=exercise
var isError:boolean;
    isBlank:boolean;
    value: double;
    intValue:integer;
begin
isBlank:= FALSE;    //initialising flags
isError:= FALSE;
if anInput= '' then  //if field is blank
  begin
  messageDlg('Field must not be blank', mtError, [mbCancel], 0); //error message
  isError:= TRUE;
  isBlank:= TRUE;
  end;
if isBlank=FALSE then  //if the input is not blank
  begin
    case factorIndex of //factor dependent validation
      0: if TryStrToFloat(anInput, value) = TRUE then   //if its a float value
                  begin
                  if (value<0) OR (value >24) then //if incorrect range
                    begin
                    isError:=TRUE;
                    MessageDlg('Hours of sleep should be between 0 and 24', mtError, [mbCancel], 0); //error message
                    end
                  end
                else  //not a float value
                  begin
                  isError:= TRUE;
                  MessageDlg('Hours of sleep should be a numerical value', mtError, [mbCancel], 0); //error message
                  end;

      1:  if TryStrToInt(anInput, intValue) = TRUE then  //if its an integer value
                  begin
                  if (intvalue <0) OR (intvalue >200) then  //if incorrect range
                    begin
                    isError:= TRUE; //error flag set to true
                    MessageDlg('Glasses of water should be a sensible number', mtError, [mbCancel], 0);//error alert
                    end
                  end
                  else //if not an integer
                  begin
                  isError:= TRUE;
                  MessageDlg('Glasses of water should be a whole numerical value', mtError, [mbCancel], 0);//error alert
                  end;
      2:   if TryStrToInt(anInput, intValue) = TRUE then //if its an integer
                  begin
                  if (intValue <1) OR (intValue >10) then //if incorrect range
                    begin
                    isError:= TRUE;  //setting error flag as TRUE
                    MessageDlg('Happiness rating should be between 1 and 10', mtError, [mbCancel], 0);//error alert
                    end
                  end
                  else //if not an integer
                  begin
                  isError:= TRUE;  //setting error flag as TRUE
                  MessageDlg('Happiness rating should be a whole number', mtError, [mbCancel], 0); //error alert
                  end;
      3:   if TryStrToFloat(anInput, value) = TRUE then //if its a float value
                  begin
                  if (value <0) OR (value >24) then //if incorrect range
                    begin
                    isError:= TRUE;  //setting error flag as TRUE
                    MessageDlg('Hours of exercise should be a sensible number', mtError, [mbCancel], 0); //error alert
                    end
                  end
                  else //if not float value
                  begin
                  isError:= TRUE;  //setting error flag as TRUE
                  MessageDlg('Hours of exercise should be a numerical value', mtError, [mbCancel], 0); //error alert
                  end;
    end;
  end;
result:= isError;  //returning isError
end;
//updating factorBMI to stay consistent with user changing lifestyle
procedure updateFactorBMI;
var ary_avg: TMatrix;
begin
setlength(ary_avg, 4, 1); //dimensions of ary_avg
//getting the average from each factor's recent data
ary_avg[0,0]:=getAverage('sleep');
ary_avg[1,0]:=getAverage('water');
ary_avg[2,0]:=getAverage('happi');
ary_avg[3,0]:=getAverage('exerc');
factorBMI:= calcRegression(ary_avg); //updates factorBMI
insertFactorBMI; //inserts factorBMI back into bmiProgress
end;
//getting user's factor goal
function getGoal(factor:string):string;
var path:string;
    intFactorProgress: textfile;
    goal: string;
begin
path:= currentDir + '\' + factor + 'progress.txt'; // pathname of progress file
Assignfile(intFactorProgress, path); //opening internal version of progress file
  reset(intFactorProgress); //open a read only version of the file
  readln(intFactorProgress, goal); //assigning 'goal' the first line of the file
closeFile(intFactorProgress);  //close file
result:= goal; //return goal
end;
//getting user's current BMI
function getBMI:double;
var intBmiProgress: textfile;
    readBmi: string;
    valBmi: double;
begin
assignfile(intBmiProgress, currentDir+'\'+'bmiProgress.txt'); //copy file to internal file
  reset(intBmiProgress); //open a read only version
  while not eof(intBmiProgress) do //moving pointer to the end
      readln(intBmiProgress, readBMI); //reading the final, most recent line
closefile(intBmiProgress); //close file

valBMI:= strtofloat(readBMI); //turning the string into float and assigning to valBMI
result:=valBMI; //returning the BMI
end;
//getting most recent factor data
function getRecent(factorProgress:string): double;
var aFile:textFile;
    path:string;
    recentData:string;
begin
path:= currentDir+ '\' + factorProgress + '.txt';
AssignFile(aFile, path); //opening an internal version of the factorProgress file
Reset(aFile); //opening a read-only version of the file
while NOT eof(aFile) do  //moving to the end of the file
  readln(aFile, recentData);
CloseFile(aFile);
result:=strtofloat(recentData);    //return the final record
end;
//get array of recent factor data
function arrayRecent:TMatrix;
var ary_recent:TMatrix; //the array to be returned
begin
setLength(ary_recent,4,1); //setting the dimensions to 4 x 1
ary_recent[0,0]:= getRecent('sleepProgress'); //getting the most recent sleep data
ary_recent[1,0]:= getRecent('waterProgress'); //getting the most recent water data
ary_recent[2,0]:= getRecent('happiProgress'); //getting the most recent happiness data
ary_recent[3,0]:= getRecent('exercProgress'); //getting the most recent exercise data
result:= ary_recent;  //returing ary_recent
end;
//calculate using regression equation
function calcRegression(indepVar:TMatrix):double; //independent variables as parameter
var total:double; //holds the running total
    I: integer;
begin
total:= 0; //intialising total
for I := 0 to 3 do
  total:= total + ary_coeff[i,0] * indepVar[i,0]; //multiplying each independent variable with its coefficient
result:= total; //returning the total
end;
//insert factorbmi into bmiprogress
procedure insertFactorBMI;
var
bmiData: TStringList;
path:string;
begin
path:= currentDir + '\' + 'bmiProgress.txt'; //directory of the user's bmiProgress file
bmiData:=TStringList.Create; //creating a stringList to hold all the data in bmiProgress
  try
    bmiData.LoadFromFile(path); //loading the bmiProgress data into stringList bmiData
    bmiData[0]:= floattostr(roundTo(factorBMI,-4)); //inserting factorBMI at the beginning of the stringList
    bmiData.SaveToFile(path); //saving the stringList back into file factorBMI
  finally
    bmiData.Free; //free bmidata stringlist
  end;
end;
//changing effect textbox
function changeETB(factor:string; barVal:double):double; //the factor being examined and the trackbar value
var difference:double; //the predicted difference in BMI
    ary_tempIndep: TMatrix; //array of factor values
    predictedBMI: double; //the predicted BMI based on factors
begin
setlength(ary_tempIndep, 4, 1); //setting the dimensions of ary_tempIndep
ary_tempIndep:=arrayRecent; //gets an array of the most recently recorded factor data

//adding the trackbar value to ary_tempIndep
if factor = 'sleep' then
  ary_tempIndep[0,0]:= barVal;
if factor = 'water' then
  ary_tempIndep[1,0]:= barVal;
if factor = 'happi' then
  ary_tempIndep[2,0]:= barVal;
if factor = 'exerc' then
  ary_tempIndep[3,0]:= barVal;

predictedBMI:= calcRegression(ary_tempIndep); //using the regression calculation to calculate the predicted BMI
difference:= factorBMI-predictedBMI; //subtracting predicted BMI from current factorBMI
result:=difference; //returning the predicted difference
end;
//checking if there is a factor plan
function isPlan(factorProgress:string):boolean; //factorProgress is the particular filename
var intFactor:textfile; //internal version of file
    aLine, path: string;
begin
path:= currentDir + '\' + factorProgress+'.txt';
AssignFile(intFactor, path); //creating internal version of factor file
  Reset(intFactor); //opening file for reading
  Readln(intFactor, aLine);
  if aLine = '' then //if the first line is blank, no goal has been saved
    result := FALSE
  else
     result:=TRUE;
CloseFile(intFactor);
end;
//getting users factorBMI
function getFactorBMI:double;
var intBMIProgress: textfile;
    readBMI: string;
begin
assignfile(intBmiProgress, currentDir+'\'+'bmiProgress.txt');
  reset(intBmiProgress); //opening a read only version of bmiProgress
  readln(intBmiProgress, readBMI); //assinging the first line, factorBMI, to readBMI
closefile(intBmiProgress); //closing bmiProgress
result:= strtofloat(readBMI); //returning factorBMI as a float data type
end;
//save users goal into file
procedure saveGoal(factor:string; barVal:double);
var
factorData: TStringList;
path:string;
begin
//changing the isFactor flag depending on the factor being saved
if factor = 'sleep' then
  isSleep := TRUE;
if factor = 'water' then
  isWater := TRUE;
if factor = 'happi' then
  isHappi := TRUE;
if factor = 'exerc' then
  isExerc := TRUE;
path:= currentDir + '\' + factor +'Progress.txt'; //directory of the user's factor progress file
factorData:=TStringList.Create; //creating a stringList to hold all the data in the progress file
  try
    factorData.LoadFromFile(path); //loading the file data into stringList factorData
    factorData[0]:= floattostr(barVal); //inserting the trackbar value at the beginning of the stringList
    factorData.SaveToFile(path); //saving the stringList back in the progress file
  finally
    factorData.Free; //free factor data stringlist
  end;

end;
//binary recursive search
function searchDate(aList: TStringList; dateSought: TDate; first, last:integer):integer;
//parameters: list to be searched, item being sought, first index, last index
var midpoint: integer;
begin
if (first mod 2) = 0 then  //if pointer is even, change so it points to a date
  first:= first-1;
if (last mod 2) = 0 then   //if pointer is even, change so it points to a date
  last:= last-1;
if last< first then
  result:= -1   //not found
else
  begin
  midpoint:= (first + last) div 2; //initialising midpoint
  if (midpoint mod 2) =0 then //if midpoint is even, change so it points to a date
    midpoint:= midpoint -1;
  if (strtodate(aList[midpoint]) > dateSought) then  //comparing date to midpoint date
    result:= searchDate(aList, dateSought, first, midpoint-2)  //calling function
  else if StrToDate(aList[midpoint]) < dateSought then  //comparing date to midpoint date
    result:= searchDate(aList, dateSought, midpoint +2, last)  //calling function
  else
    result:= midpoint;   //if dateSought = midpoint
  end;
end;
end.

