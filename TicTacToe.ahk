#SingleInstance Force
SetWorkingDir %A_ScriptDir%
CreateGui()
return


PutSquareOrLine:
global Column_Row_Points, Turn, DiagonalSpotsTaken, NumberDiagonalSpotsTaken, BoxSize, Diagonal1Points, Diagonal2Points
global GlobalDiagonalPoint, SpotsTaken

if (SpotsTaken.MaxIndex() >= 9) then
{
	Msgbox, what happened???
	return
}

for index, value in SpotsTaken
{
	if (A_GuiControl == value) then
	{
		Msgbox, pick another box
		return
	}
}

SpotsTaken.Push(A_GuiControl)

Column_Row := StrSplit(A_GuiControl, " ")

ColumnRowString := ""
for index, Column_Or_Row in Column_Row
{
	if InStr(Column_Or_Row, "Column") then
	{
		NumberColumn := StrSplit(Column_Or_Row, "_")
		ColumnRowString .= NumberColumn[2] "_"
		if (Turn) then
			Column_Row_Points[NumberColumn[1] NumberColumn[2]]++
		else
			Column_Row_Points[NumberColumn[1] NumberColumn[2]]--
	}
	else
	if InStr(Column_Or_Row, "Row") then
	{
		NumberRow := StrSplit(Column_Or_Row, "_")
		ColumnRowString .= NumberRow[2]
		if (Turn) then
			Column_Row_Points[NumberRow[1] NumberRow[2]]++
		else
			Column_Row_Points[NumberRow[1] NumberRow[2]]--
	}
	
	if (index == Column_Row.MaxIndex()) then
	{
		ColumnRowString := StrSplit(ColumnRowString, "_")
		if (Turn) then
		{
			GuiControl, Move, % "Line_" NumberDiagonalSpotsTaken + 1, % "x" (BoxSize // 2) + (BoxSize * (ColumnRowString[1] - 1)) " y" (BoxSize // 10) + (BoxSize * (ColumnRowString[2] - 1))
		}
		else
		{
			if !(Square_Index) then
				global Square_Index := 1
			else
				Square_Index++
			
			GuiControl, Move, % "SqLineNumx1_" Square_Index, % "x" (BoxSize // 11) + (BoxSize * (ColumnRowString[1] - 1)) " y" (BoxSize // 10) + (BoxSize * (ColumnRowString[2] - 1))
			GuiControl, Move, % "SqLineNumx2_" Square_Index, % "x" (BoxSize - ((BoxSize // 8) * 1)) + (BoxSize * (ColumnRowString[1] - 1)) " y" (BoxSize // 10) + (BoxSize * (ColumnRowString[2] - 1))
			GuiControl, Move, % "SqLineNumx3_" Square_Index, % "x" (BoxSize // 11) + (BoxSize * (ColumnRowString[1] - 1)) " y" (BoxSize - ((BoxSize // 8) * 1) - 1) + (BoxSize * (ColumnRowString[2] - 1))
			GuiControl, Move, % "SqLineNumx4_" Square_Index, % "x" (BoxSize // 11) + (BoxSize * (ColumnRowString[1] - 1)) " y" (BoxSize // 10) + (BoxSize * (ColumnRowString[2] - 1))
		}
	}
}

DiagonalSpotsTaken.Push(Column_Row[1] "A" Column_Row[2] " " (Turn ? "Line" : "Square"))
for index, SpotTaken in DiagonalSpotsTaken
{
	SpotTaken := StrSplit(SpotTaken, " ")
	if (SpotTaken[1] == "Column_1ARow_1") then
	{
		if (SpotTaken[2] == "Line") then
		{
			Diagonal1Points++
		}
		else
		{
			Diagonal1Points--
		}
	}
	else
	if (SpotTaken[1] == "Column_3ARow_3") then
	{
		if (SpotTaken[2] == "Line") then
		{
			Diagonal1Points++
		}
		else
		{
			Diagonal1Points--
		}
	}
	if (SpotTaken[1] == "Column_3ARow_1") then
	{
		if (SpotTaken[2] == "Line") then
		{
			Diagonal2Points++
		}
		else
		{
			Diagonal2Points--
		}
	}
	else
	if (SpotTaken[1] == "Column_1ARow_3") then
	{
		if (SpotTaken[2] == "Line") then
		{
			Diagonal2Points++
		}
		else
		{
			Diagonal2Points--
		}
	}
	else
	if (SpotTaken[1] == "Column_2ARow_2") then
	{
		if (SpotTaken[2] == "Line") then
		{
			GlobalDiagonalPoint++
		}
		else
		{
			GlobalDiagonalPoint--
		}
	}
}
DiagonalSpotsTaken := []
if (GlobalDiagonalPoint) then
{
	Diagonal1Points += GlobalDiagonalPoint
	Diagonal2Points += GlobalDiagonalPoint
	GlobalDiagonalPoint := 0
}
;Msgbox % Diagonal1Points " and " Diagonal2Points " and " GlobalDiagonalPoint

for Column_Row_Name, Column_Row_Value in Column_Row_Points
{
	if (Abs(Column_Row_Value) == 3 or (Abs(Diagonal1Points) == 3 or Abs(Diagonal2Points) == 3)) then
	{
		Msgbox, % (Turn ? "Line" : "Square") " Won"
		Gui, %Gui_Name%:Destroy
		CreateGui()
	}
}

NumberDiagonalSpotsTaken++
Turn := !Turn
return


CreateGui() {
	global Gui_Name := "TicTacToeGame"
	global Gui_Width := 450
	global Gui_Height := 450
	global Gui_XPos := (A_ScreenWidth // 2) - (Gui_Width // 2)
	global Gui_YPos := (A_ScreenHeight // 2) - (Gui_Height // 2)
	global GuiMainColor := "111111"
	global GuiTextColor := "E4F0F6"
	global GuiFont := "MS Sans Serif"
	
	global GridLineThickness := 3
	global BoxSize := (Gui_Width / 3) ; width and height (of the gui) are the same (which is what boxsize is)
	Turn := true ; line is when turn is true || square is when turn is false
	global Column_Row_Points := {"Column1": 0, "Column2": 0, "Column3": 0
	, "Row1": 0, "Row2": 0, "Row3": 0}
	global Diagonal1Points := 0
	global Diagonal2Points := 0
	global GlobalDiagonalPoint := 0
	LThinkness := 4 ; Line thickness
	SqThickess := 4 ; square line thickness
	
	global SpotsTaken := []
	global NumberDiagonalSpotsTaken := 0
	global DiagonalSpotsTaken := []
	
	global Line_1, Line_2, Line_3, Line_4, Line_5
	global Line_6, Line_7, Line_8, Line_9
	
	global SqLineNumx1_1, SqLineNumx2_1, SqLineNumx3_1, SqLineNumx4_1
	global SqLineNumx1_2, SqLineNumx2_2, SqLineNumx3_2, SqLineNumx4_2
	global SqLineNumx1_3, SqLineNumx2_3, SqLineNumx3_3, SqLineNumx4_3
	global SqLineNumx1_4, SqLineNumx2_4, SqLineNumx3_4, SqLineNumx4_4
	global SqLineNumx1_5, SqLineNumx2_5, SqLineNumx3_5, SqLineNumx4_5
	global SqLineNumx1_6, SqLineNumx2_6, SqLineNumx3_6, SqLineNumx4_6
	global SqLineNumx1_7, SqLineNumx2_7, SqLineNumx3_7, SqLineNumx4_7
	global SqLineNumx1_8, SqLineNumx2_8, SqLineNumx3_8, SqLineNumx4_8
	global SqLineNumx1_9, SqLineNumx2_9, SqLineNumx3_9, SqLineNumx4_9

	Gui, %Gui_Name%:New
	Gui, %Gui_Name%:Color, %GuiMainColor%
	Gui, %Gui_Name%:Font, c%GuiMainColor%
	
	Gui, %Gui_Name%:Add, Text, % "x" 0 " y" 0 " w" BoxSize " h" BoxSize " gPutSquareOrLine", Column_1 Row_1
	Gui, %Gui_Name%:Add, Text, % "x" 0 " y" Gui_Height / 3 " w" BoxSize " h" BoxSize " gPutSquareOrLine", Column_1 Row_2
	Gui, %Gui_Name%:Add, Text, % "x" 0 " y" ((Gui_Height / 3) * 2) " w" BoxSize " h" BoxSize " gPutSquareOrLine", Column_1 Row_3
	
	Gui, %Gui_Name%:Add, Text, % "x" Gui_Width / 3 " y" 0 " w" BoxSize " h" BoxSize " gPutSquareOrLine", Column_2 Row_1
	Gui, %Gui_Name%:Add, Text, % "x" Gui_Width / 3 " y" (Gui_Height / 3) " w" BoxSize " h" BoxSize " gPutSquareOrLine", Column_2 Row_2
	Gui, %Gui_Name%:Add, Text, % "x" Gui_Width / 3 " y" ((Gui_Height / 3) * 2) " w" BoxSize " h" BoxSize " gPutSquareOrLine", Column_2 Row_3
	
	Gui, %Gui_Name%:Add, Text, % "x" ((Gui_Width / 3) * 2) " y" 0 " w" BoxSize " h" BoxSize " gPutSquareOrLine", Column_3 Row_1
	Gui, %Gui_Name%:Add, Text, % "x" ((Gui_Width / 3) * 2) " y" (Gui_Height / 3) " w" BoxSize " h" BoxSize " gPutSquareOrLine", Column_3 Row_2
	Gui, %Gui_Name%:Add, Text, % "x" ((Gui_Width / 3) * 2) " y" ((Gui_Height / 3) * 2) " w" BoxSize " h" BoxSize " gPutSquareOrLine", Column_3 Row_3
	
	Loop, 9
	{
		Gui, %Gui_Name%:Add, Progress, % "vLine_" A_Index " x" -1000 " y" -1000 " w" LThinkness " h" (BoxSize - ((BoxSize // 10) * 2)) " Background" GuiTextColor
		
		SqLineNumber := 1
		Gui, %Gui_Name%:Add, Progress, % "vSqLineNumx" SqLineNumber "_" A_Index " x" -1000 " y" -1000 " w" (BoxSize - ((BoxSize // 10) * 2)) " h" SqThickess " Background" GuiTextColor
		SqLineNumber++
		Gui, %Gui_Name%:Add, Progress, % "vSqLineNumx" SqLineNumber "_" A_Index " x" -1000 " y" -1000 " w" SqThickess " h" (BoxSize - ((BoxSize // 10) * 2)) " Background" GuiTextColor
		SqLineNumber++
		Gui, %Gui_Name%:Add, Progress, % "vSqLineNumx" SqLineNumber "_" A_Index " x" -1000 " y" -1000 " w" (BoxSize - ((BoxSize // 10) * 2)) " h" SqThickess " Background" GuiTextColor
		SqLineNumber++
		Gui, %Gui_Name%:Add, Progress, % "vSqLineNumx" SqLineNumber "_" A_Index " x" -1000 " y" -1000 " w" SqThickess " h" (BoxSize - ((BoxSize // 10) * 2)) " Background" GuiTextColor
		SqLineNumber++
	}
	
	Draw_Line(Gui_Name, Gui_Width / 3, 0, GridLineThickness, Gui_Height, GuiTextColor)
	Draw_Line(Gui_Name, (Gui_Width / 3) * 2, 0, GridLineThickness, Gui_Height, GuiTextColor)
	; width/height divided by 3 puts it in the 1/3 spot and multiplying it by 2
	; puts it in the 2/3 spot
	Draw_Line(Gui_Name, 0, Gui_Height / 3, Gui_Width, GridLineThickness, GuiTextColor)
	Draw_Line(Gui_Name, 0, (Gui_Height / 3) * 2, Gui_Width, GridLineThickness, GuiTextColor)
	
	OnMessage(0x201, "WM_LBUTTONDOWN")
	Gui, %Gui_Name%:+AlwaysOnTop +ToolWindow ; -Caption
	Gui, %Gui_Name%:Show, % "NoActivate W" Gui_Width " H" Gui_Height " X" Gui_XPos " Y" Gui_YPos, Tic Tac Toe
}


WM_LBUTTONDOWN(wParam, lParam, msg, hwnd) {
		PostMessage, 0xA1, 2,,, A
}


Draw_Outline(Gui_Name,x,y,w,h,Color:="Black",thickness:=1){
    x2:=X+W-thickness
    Gui,% Gui_Name ":Add",Progress,% "x" X " y" Y " w" W " h" thickness " Background" Color 
    Gui,% Gui_Name ":Add",Progress,% "x" X " y" Y " w" thickness " h" H " Background" Color 
    Gui,% Gui_Name ":Add",Progress,% "x" X " y" Y+H-thickness " w" W " h" thickness " Background" Color 
    Gui,% Gui_Name ":Add",Progress,% "x" X+W-thickness " y" Y " w" thickness " h" H " Background" Color     
}
Draw_Line(Gui_Name,x,y,w,h,color){
    Gui,% Gui_Name ":Add",Progress,% "x" X " y" Y " w" W " h" H " Background" Color 
}


*$f7::
Reload
return


RemoveTT:
ToolTip
return
