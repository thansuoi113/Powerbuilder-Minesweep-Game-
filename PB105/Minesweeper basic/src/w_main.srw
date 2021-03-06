$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type dw_1 from datawindow within w_main
end type
type cb_3 from commandbutton within w_main
end type
type cb_model from statictext within w_main
end type
type r_border from rectangle within w_main
end type
end forward

global type w_main from window
integer width = 1755
integer height = 1488
boolean titlebar = true
string title = "Minesweeper"
string menuname = "m_menu"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
event butdown pbm_lbuttondown
dw_1 dw_1
cb_3 cb_3
cb_model cb_model
r_border r_border
end type
global w_main w_main

type variables
//border r_border
Long il_border_width = 1300,il_border_height = 1100
Long il_border_x = 10,il_border_y = 10
//Button cb_model
Long il_model_width = 100,il_model_height = 80
// thunder number
Long il_ray_number = 40
//size 9x9
Long il_row = 19 //Number of rows
Long il_col = 19 //number of columns

//game pattern
statictext is_pattern[19,19]
//Used to store the button click state (0-not clicked, 1-clicked, 2-flag, 3-question mark)
Long il_click[19,19]
// store the number
Long il_counts[19,19]
// Used to store whether there are mines
Boolean ibool_state[19,19];

// used to empty the array
statictext is_null[19,19]
Long il_null[19,19]
Boolean ibool_null[19,19]

end variables
forward prototypes
public subroutine wf_draw_win ()
public subroutine wf_random_ray ()
public subroutine wf_place_flag (integer al_x, integer al_y)
public subroutine wf_show_ray ()
public subroutine wf_write_blank (integer ai_x, integer ai_y)
public subroutine wf_delete_con ()
public function integer wf_return_coordinates (string as_tag, string as_bool)
public subroutine wf_draw_cb (string as_tag, integer ai_bool)
public subroutine wf_game ()
end prototypes

public subroutine wf_draw_win ();//==============================
//draw interface
//==============================
Long ll_for_row,ll_for_col
Long ll_x,ll_y,ll_old_x,ll_old_y
statictext lst_cb

ll_old_x = r_border.X +4
ll_old_y = r_border.Y +4
ll_x = ll_old_x
ll_y = ll_old_y

//draw game map
For ll_for_row = 1 To il_row
	For ll_for_col = 1 To il_col
		lst_cb = Create Using "cb_model"
		lst_cb.Visible = True
		lst_cb.Width = il_model_width //set properties
		lst_cb.Height = il_model_height
		lst_cb.Tag = String(ll_for_row)+","+String(ll_for_col)
		This.OpenUserObject(lst_cb,""+String(ll_for_col)+"", ll_x,ll_y)
		
		ll_x = ll_x+il_model_width
		is_pattern[ll_for_row,ll_for_col] = lst_cb
		//messagebox("",string(ll_for_row)+","+string(ll_for_col))
		il_click[ll_for_row,ll_for_col] = 0
		il_counts[ll_for_row,ll_for_col] = 0
		ibool_state[ll_for_row,ll_for_col] = False
		
		
	Next
	ll_y+= il_model_height
	ll_x = ll_old_x
Next

r_border.Width = ll_old_x+il_model_width * il_row
r_border.Height = ll_old_y+il_model_height * il_col

This.Width = ll_old_x+il_model_width * il_row +100
This.Height = ll_old_y+il_model_height * il_col +260

end subroutine

public subroutine wf_random_ray ();//=========================================
//draw thunder
//=========================================
Long ll_ray_x,ll_ray_y
Long ll_number

Do While ll_number < il_ray_number
	ll_ray_x = Rand(il_row) //Row
	ll_ray_y = Rand(il_col)
	
	If Not ibool_state[ll_ray_x,ll_ray_y] Then
		ibool_state[ll_ray_x,ll_ray_y] = True
		
		If ll_ray_x > 1 And ll_ray_y > 1 Then il_counts[ll_ray_x -1,ll_ray_y -1] = il_counts[ll_ray_x -1,ll_ray_y -1] +1
		If ll_ray_x > 1 Then il_counts[ll_ray_x -1,ll_ray_y] = il_counts[ll_ray_x -1,ll_ray_y] +1
		If ll_ray_x > 1 And ll_ray_y < il_col  Then il_counts[ll_ray_x -1,ll_ray_y +1] = il_counts[ll_ray_x -1,ll_ray_y +1] +1
		
		If ll_ray_y > 1 Then il_counts[ll_ray_x,ll_ray_y -1] = il_counts[ll_ray_x,ll_ray_y -1] +1
		If ll_ray_y < il_col Then il_counts[ll_ray_x,ll_ray_y +1] = il_counts[ll_ray_x,ll_ray_y +1] +1
		
		If ll_ray_x < il_row And ll_ray_y > 1 Then il_counts[ll_ray_x +1,ll_ray_y -1] = il_counts[ll_ray_x +1,ll_ray_y -1] +1
		If ll_ray_x < il_row Then il_counts[ll_ray_x +1,ll_ray_y] = il_counts[ll_ray_x +1,ll_ray_y] +1
		If ll_ray_x < il_row  And ll_ray_y < il_col Then il_counts[ll_ray_x +1,ll_ray_y +1] = il_counts[ll_ray_x +1,ll_ray_y +1] +1
		
		ll_number+= 1
		//is_pattern[ll_ray_x,ll_ray_y].backcolor=134217750
	End If
Loop

end subroutine

public subroutine wf_place_flag (integer al_x, integer al_y);//======================================
//flag, question mark
//======================================
statictext lst_st
Long ll_flag
ll_flag = il_click[al_x,al_y]
If ll_flag = 0 Then
	lst_st = is_pattern[al_x,al_y]
	lst_st.Text = '♀'
	il_click[al_x,al_y] = 2
ElseIf ll_flag = 2 Then
	lst_st = is_pattern[al_x,al_y]
	lst_st.Text = '?'
	il_click[al_x,al_y] = 3
ElseIf ll_flag = 3 Then
	lst_st = is_pattern[al_x,al_y]
	lst_st.Text = ''
	il_click[al_x,al_y] = 0
End If

end subroutine

public subroutine wf_show_ray ();//===================================
//game over; show thunder
//===================================
statictext lst_st
Long ll_col,ll_row
For ll_row = 1 To il_row
	For ll_col = 1 To il_col
		If ibool_state[ll_row,ll_col] Then
			lst_st = is_pattern[ll_row,ll_col]
			lst_st.BorderStyle = styleBox!
			lst_st.BackColor = 134217750
			lst_st.Text = '●'
		End If
	Next
Next

end subroutine

public subroutine wf_write_blank (integer ai_x, integer ai_y);//I originally wanted to use recursion; I found that the program would be stuck; so I used a queue
Long ll_x,ll_y,ll_i
Long ll_new_x,ll_new_y
Long ll_insertrow,ll_rowocunt
Long ll_counts,ll_click
statictext ls_st

ll_counts = il_counts[ai_x,ai_y]


ls_st = is_pattern[ai_x,ai_y]
ls_st.BorderStyle = styleBox!
ls_st.BackColor = 134217750
il_click[ai_x,ai_y] = 1
If ll_counts = 0 Then
	ls_st.Text = ''
Else
	ls_st.Text = String(ll_counts)
End If

If ll_counts = 1 Then
	ls_st.TextColor = 134217856
ElseIf ll_counts = 2 Then
	ls_st.TextColor = 32768
ElseIf ll_counts = 3 Then
	ls_st.TextColor = 255
End If

If ll_counts = 0 Then
	ll_insertrow = dw_1.InsertRow(0)
	dw_1.Object.ai_x[ll_insertrow] = ai_x
	dw_1.Object.ai_y[ll_insertrow] = ai_y
	ll_rowocunt = dw_1.RowCount()
	
	Do While ll_rowocunt > 0
		For ll_i = ll_rowocunt To 1 Step - 1
			ll_x = dw_1.Object.ai_x[ll_i]
			ll_y = dw_1.Object.ai_y[ll_i]
			dw_1.DeleteRow(ll_i)
			
			ll_new_x = ll_x - 1
			If ll_new_x > 0 Then
				ll_counts = il_counts[ll_new_x,ll_y]
				ll_click = il_click[ll_new_x,ll_y]
				If (ll_click = 0 Or ll_click = 3) Then
					ls_st = is_pattern[ll_new_x,ll_y]
					ls_st.BackColor = 134217750
					ls_st.BorderStyle = styleBox!
					il_click[ll_new_x,ll_y] = 1
					If ll_counts = 0 Then
						ll_insertrow = dw_1.InsertRow(0)
						dw_1.Object.ai_x[ll_insertrow] = ll_new_x
						dw_1.Object.ai_y[ll_insertrow] = ll_y
					Else
						ls_st.Text = String(ll_counts)
						If ll_counts = 1 Then
							ls_st.TextColor = 134217856
						ElseIf ll_counts = 2 Then
							ls_st.TextColor = 32768
						ElseIf ll_counts = 3 Then
							ls_st.TextColor = 255
						End If
					End If
				End If
			End If
			
			ll_new_x = ll_x + 1
			If ll_new_x <= il_row Then
				ll_counts = il_counts[ll_new_x,ll_y]
				ll_click = il_click[ll_new_x,ll_y]
				If (ll_click = 0 Or ll_click = 3) Then
					ls_st = is_pattern[ll_new_x,ll_y]
					ls_st.BackColor = 134217750
					ls_st.BorderStyle = styleBox!
					il_click[ll_new_x,ll_y] = 1
					If ll_counts = 0 Then
						ll_insertrow = dw_1.InsertRow(0)
						dw_1.Object.ai_x[ll_insertrow] = ll_new_x
						dw_1.Object.ai_y[ll_insertrow] = ll_y
					Else
						ls_st.Text = String(ll_counts)
						If ll_counts = 1 Then
							ls_st.TextColor = 134217856
						ElseIf ll_counts = 2 Then
							ls_st.TextColor = 32768
						ElseIf ll_counts = 3 Then
							ls_st.TextColor = 255
						End If
					End If
				End If
			End If
			
			ll_new_y = ll_y - 1
			If ll_new_y > 0 Then
				ll_counts = il_counts[ll_x,ll_new_y]
				ll_click = il_click[ll_x,ll_new_y]
				If (ll_click = 0 Or ll_click = 3) Then
					ls_st = is_pattern[ll_x,ll_new_y]
					ls_st.BackColor = 134217750
					ls_st.BorderStyle = styleBox!
					il_click[ll_x,ll_new_y] = 1
					If ll_counts = 0 Then
						ll_insertrow = dw_1.InsertRow(0)
						dw_1.Object.ai_x[ll_insertrow] = ll_x
						dw_1.Object.ai_y[ll_insertrow] = ll_new_y
					Else
						ls_st.Text = String(ll_counts)
						If ll_counts = 1 Then
							ls_st.TextColor = 134217856
						ElseIf ll_counts = 2 Then
							ls_st.TextColor = 32768
						ElseIf ll_counts = 3 Then
							ls_st.TextColor = 255
						End If
					End If
				End If
			End If
			
			ll_new_y = ll_y + 1
			If ll_new_y <= il_col Then
				ll_counts = il_counts[ll_x,ll_new_y]
				ll_click = il_click[ll_x,ll_new_y]
				If (ll_click = 0 Or ll_click = 3) Then
					ls_st = is_pattern[ll_x,ll_new_y]
					ls_st.BackColor = 134217750
					ls_st.BorderStyle = styleBox!
					il_click[ll_x,ll_new_y] = 1
					If ll_counts = 0 Then
						ll_insertrow = dw_1.InsertRow(0)
						dw_1.Object.ai_x[ll_insertrow] = ll_x
						dw_1.Object.ai_y[ll_insertrow] = ll_new_y
					Else
						ls_st.Text = String(ll_counts)
						If ll_counts = 1 Then
							ls_st.TextColor = 134217856
						ElseIf ll_counts = 2 Then
							ls_st.TextColor = 32768
						ElseIf ll_counts = 3 Then
							ls_st.TextColor = 255
						End If
					End If
				End If
			End If
		Next
		ll_rowocunt = dw_1.RowCount()
	Loop
End If
//if il_counts[ai_x -1,ai_y] =0 then
//   il_queue_x[upperbound(il_queue_x) +1]=ai_x -1
//end if
//il_counts[ai_x +1,ai_y]
//
//il_counts[ai_x,ai_y -1]
//il_counts[ai_x,ai_y +1]



//if ai_x>1 and ai_y < il_col then
//   wf_test(ai_x -1,ai_y +1)
//end if
//
//if ai_y>1 then
//   wf_test(ai_x,ai_y -1)
//end if

//if ai_y<il_col then
//   wf_test(ai_x,ai_y +1)
//end if
//
//if ai_x>1 and ai_y>1 then
//   if (il_click[ai_x,ai_y] =0 or il_click[ai_x,ai_y] =3) and il_counts[ai_x,ai_y]=0 then
//      ls_st=is_pattern[ai_x,ai_y]
//      ls_st.backcolor=134217750
//      ls_st.borderstyle=styleBox!
//      il_click[ai_x,ai_y]=1
//   end if
//   wf_write_blank(ai_x -1,ai_y -1);
//end if
//
//if ai_x>1 and ai_y <=il_col then
//   if (il_click[ai_x,ai_y] =0 or il_click[ai_x,ai_y] =3) and il_counts[ai_x,ai_y]=0 then
//      ls_st=is_pattern[ai_x,ai_y]
//      ls_st.backcolor=134217750
//      ls_st.borderstyle=styleBox!
//      il_click[ai_x,ai_y]=1
//   end if
//   wf_write_blank(ai_x -1,ai_y);
//end if
//
//if ai_x>1 and ai_y < il_col then
//   if (il_click[ai_x,ai_y] =0 or il_click[ai_x,ai_y] =3) and il_counts[ai_x,ai_y]=0 then
//      ls_st=is_pattern[ai_x,ai_y]
//      ls_st.backcolor=134217750
//      ls_st.borderstyle=styleBox!
//      il_click[ai_x,ai_y]=1
//   end if
//   wf_write_blank(ai_x+1,ai_y +1);
//end if
//
//if ai_y>1 then
//   if (il_click[ai_x,ai_y] =0 or il_click[ai_x,ai_y] =3) and il_counts[ai_x,ai_y]=0 then
//      ls_st=is_pattern[ai_x,ai_y]
//      ls_st.backcolor=134217750
//      ls_st.borderstyle=styleBox!
//      il_click[ai_x,ai_y]=1
//   end if
//   wf_write_blank(ai_x+1,ai_y +1);
//end if
//
//if ai_y<il_col then
//   if (il_click[ai_x,ai_y] =0 or il_click[ai_x,ai_y] =3) and il_counts[ai_x,ai_y]=0 then
//      ls_st=is_pattern[ai_x,ai_y]
//      ls_st.backcolor=134217750
//      ls_st.borderstyle=styleBox!
//      il_click[ai_x,ai_y]=1
//   end if
//   wf_write_blank(ai_x+1,ai_y +1);
//end if
//
//if ai_x<il_row and ai_y>1 then
//   if (il_click[ai_x,ai_y] =0 or il_click[ai_x,ai_y] =3) and il_counts[ai_x,ai_y]=0 then
//      ls_st=is_pattern[ai_x,ai_y]
//      ls_st.backcolor=134217750
//      ls_st.borderstyle=styleBox!
//      il_click[ai_x,ai_y]=1
//   end if
//   wf_write_blank(ai_x+1,ai_y +1);
//end if
//
//if ai_x<il_row then
//   if (il_click[ai_x,ai_y] =0 or il_click[ai_x,ai_y] =3) and il_counts[ai_x,ai_y]=0 then
//      ls_st=is_pattern[ai_x,ai_y]
//      ls_st.backcolor=134217750
//      ls_st.borderstyle=styleBox!
//      il_click[ai_x,ai_y]=1
//   end if
//   wf_write_blank(ai_x+1,ai_y +1);
//end if
//
//
//if ai_x<il_row and ai_y<il_col then
//   if (il_click[ai_x,ai_y] =0 or il_click[ai_x,ai_y] =3) and il_counts[ai_x,ai_y]=0 then
//      ls_st=is_pattern[ai_x,ai_y]
//      ls_st.backcolor=134217750
//      ls_st.borderstyle=styleBox!
//      il_click[ai_x,ai_y]=1
//   end if
//   wf_write_blank(ai_x+1,ai_y +1);
//end if
//

end subroutine

public subroutine wf_delete_con ();Long ll_i,ll_j

For ll_i = 1 To il_row
	For ll_j = 1 To il_col
		CloseUserObject(is_pattern[ll_i,ll_j])
	Next
Next

end subroutine

public function integer wf_return_coordinates (string as_tag, string as_bool);Long ll_zb

If as_bool = '1' Then //X
	ll_zb = Long(Mid(as_tag,0,Pos(as_tag,',') -1))
Else //Y
	ll_zb = Long(Mid(as_tag,Pos(as_tag,',') +1,Len(as_tag)))
End If

Return ll_zb

end function

public subroutine wf_draw_cb (string as_tag, integer ai_bool);Long ll_ray_x,ll_ray_y
Long ll_coordinates_x,ll_coordinates_y

ll_ray_x = wf_return_coordinates(as_tag,'1')
ll_ray_y = wf_return_coordinates(as_tag,'2')

//or il_click[ll_ray_x,ll_ray_y] =3
If il_click[ll_ray_x,ll_ray_y] = 0  Then
	If ai_bool = 1 Then
		is_pattern[ll_ray_x,ll_ray_y].BackColor = 134217741
		is_pattern[ll_ray_x,ll_ray_y].BorderStyle = styleraised!
	Else
		is_pattern[ll_ray_x,ll_ray_y].BackColor = 134217750
		is_pattern[ll_ray_x,ll_ray_y].BorderStyle = styleBox!
	End If
End If
ll_coordinates_x = ll_ray_x -1
//v 134217750
If ll_coordinates_x > 0 And ll_coordinates_x <= il_col Then
	If il_click[ll_coordinates_x,ll_ray_y] = 0 Then
		If ai_bool = 1 Then
			is_pattern[ll_coordinates_x,ll_ray_y].BackColor = 134217741
			is_pattern[ll_coordinates_x,ll_ray_y].BorderStyle = styleraised!
		Else
			is_pattern[ll_coordinates_x,ll_ray_y].BackColor = 134217750
			is_pattern[ll_coordinates_x,ll_ray_y].BorderStyle = styleBox!
		End If
	End If
End If
//right
ll_coordinates_x = ll_ray_x +1
If ll_coordinates_x > 0 And ll_coordinates_x <= il_col Then
	If il_click[ll_coordinates_x,ll_ray_y] = 0 Then
		If ai_bool = 1 Then
			is_pattern[ll_coordinates_x,ll_ray_y].BackColor = 134217741
			is_pattern[ll_coordinates_x,ll_ray_y].BorderStyle = styleraised!
		Else
			is_pattern[ll_coordinates_x,ll_ray_y].BackColor = 134217750
			is_pattern[ll_coordinates_x,ll_ray_y].BorderStyle = styleBox!
		End If
	End If
End If
//up
ll_coordinates_y = ll_ray_y -1
If ll_coordinates_y > 0 And ll_coordinates_y <= il_row Then
	If il_click[ll_ray_x,ll_coordinates_y] = 0  Then
		If ai_bool = 1 Then
			is_pattern[ll_ray_x,ll_coordinates_y].BackColor = 134217741
			is_pattern[ll_ray_x,ll_coordinates_y].BorderStyle = styleraised!
		Else
			is_pattern[ll_ray_x,ll_coordinates_y].BackColor = 134217750
			is_pattern[ll_ray_x,ll_coordinates_y].BorderStyle = styleBox!
		End If
	End If
End If
//Down
ll_coordinates_y = ll_ray_y +1
If ll_coordinates_y > 0 And ll_coordinates_y <= il_row  Then
	If il_click[ll_ray_x,ll_coordinates_y] = 0 Then
		If ai_bool = 1 Then
			is_pattern[ll_ray_x,ll_coordinates_y].BackColor = 134217741
			is_pattern[ll_ray_x,ll_coordinates_y].BorderStyle = styleraised!
		Else
			is_pattern[ll_ray_x,ll_coordinates_y].BackColor = 134217750
			is_pattern[ll_ray_x,ll_coordinates_y].BorderStyle = styleBox!
		End If
	End If
End If
//upper left
ll_coordinates_x = ll_ray_x -1
ll_coordinates_y = ll_ray_y +1
If ll_coordinates_x > 0 And ll_coordinates_x <= il_col And ll_coordinates_y > 0 And ll_coordinates_y <= il_row Then
	If il_click[ll_coordinates_x,ll_coordinates_y] = 0 Then
		If ai_bool = 1 Then
			is_pattern[ll_coordinates_x,ll_coordinates_y].BackColor = 134217741
			is_pattern[ll_coordinates_x,ll_coordinates_y].BorderStyle = styleraised!
		Else
			is_pattern[ll_coordinates_x,ll_coordinates_y].BackColor = 134217750
			is_pattern[ll_coordinates_x,ll_coordinates_y].BorderStyle = styleBox!
		End If
	End If
End If
//top right
ll_coordinates_x = ll_ray_x +1
If ll_coordinates_x > 0 And ll_coordinates_x <= il_col And ll_coordinates_y > 0 And ll_coordinates_y <= il_row Then
	If il_click[ll_coordinates_x,ll_coordinates_y] = 0 Then
		If ai_bool = 1 Then
			is_pattern[ll_coordinates_x,ll_coordinates_y].BackColor = 134217741
			is_pattern[ll_coordinates_x,ll_coordinates_y].BorderStyle = styleraised!
		Else
			is_pattern[ll_coordinates_x,ll_coordinates_y].BackColor = 134217750
			is_pattern[ll_coordinates_x,ll_coordinates_y].BorderStyle = styleBox!
		End If
	End If
End If
//lower left
ll_coordinates_x = ll_ray_x -1
ll_coordinates_y = ll_ray_y -1
If ll_coordinates_x > 0 And ll_coordinates_x <= il_col And ll_coordinates_y > 0 And ll_coordinates_y <= il_row Then
	If il_click[ll_coordinates_x,ll_coordinates_y] = 0 Then
		If ai_bool = 1 Then
			is_pattern[ll_coordinates_x,ll_coordinates_y].BackColor = 134217741
			is_pattern[ll_coordinates_x,ll_coordinates_y].BorderStyle = styleraised!
		Else
			is_pattern[ll_coordinates_x,ll_coordinates_y].BackColor = 134217750
			is_pattern[ll_coordinates_x,ll_coordinates_y].BorderStyle = styleBox!
		End If
	End If
End If
//lower right
ll_coordinates_x = ll_ray_x +1
ll_coordinates_y = ll_ray_y -1
If ll_coordinates_x > 0 And ll_coordinates_x <= il_col And ll_coordinates_y > 0 And ll_coordinates_y <= il_row Then
	If il_click[ll_coordinates_x,ll_coordinates_y] = 0 Then
		If ai_bool = 1 Then
			is_pattern[ll_coordinates_x,ll_coordinates_y].BackColor = 134217741
			is_pattern[ll_coordinates_x,ll_coordinates_y].BorderStyle = styleraised!
		Else
			is_pattern[ll_coordinates_x,ll_coordinates_y].BackColor = 134217750
			is_pattern[ll_coordinates_x,ll_coordinates_y].BorderStyle = styleBox!
		End If
	End If
End If

end subroutine

public subroutine wf_game ();Long ll_for_row,ll_for_col

For ll_for_row = 1 To il_row
	For ll_for_col = 1 To il_col
		If il_click[ll_for_row,ll_for_col] = 1 Then
		ElseIf il_click[ll_for_row,ll_for_col] = 2 Then
			If Not ibool_state[ll_for_row,ll_for_col] Then
				//messagebox("",1)
				Return
			End If
		Else
			//messagebox("",2)
			Return
		End If
	Next
Next
MessageBox("Tips", "Victory")


end subroutine

on w_main.create
if this.MenuName = "m_menu" then this.MenuID = create m_menu
this.dw_1=create dw_1
this.cb_3=create cb_3
this.cb_model=create cb_model
this.r_border=create r_border
this.Control[]={this.dw_1,&
this.cb_3,&
this.cb_model,&
this.r_border}
end on

on w_main.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.cb_3)
destroy(this.cb_model)
destroy(this.r_border)
end on

event open;r_border.X = il_border_x
r_border.Y = il_border_y

Randomize(0)

wf_draw_win()
wf_random_ray()

end event

type dw_1 from datawindow within w_main
boolean visible = false
integer x = 1810
integer y = 960
integer width = 690
integer height = 580
integer taborder = 20
string title = "none"
string dataobject = "d_test"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_3 from commandbutton within w_main
boolean visible = false
integer x = 50
integer y = 1100
integer width = 457
integer height = 128
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "restart"
end type

event clicked;wf_delete_con()

il_click=il_null
is_pattern=is_null
ibool_state=ibool_null
il_counts=il_null
dw_1.reset( )

wf_draw_win()
wf_random_ray()


end event

type cb_model from statictext within w_main
event butonup pbm_lbuttonup
event mdown pbm_mbuttondown
event monup pbm_mbuttonup
event butdown pbm_lbuttondown
boolean visible = false
integer x = 1550
integer y = 596
integer width = 101
integer height = 80
integer textsize = -12
integer weight = 400
fontcharset fontcharset = gb2312charset!
fontpitch fontpitch = variable!
string facename = "宋体"
long textcolor = 33554432
long backcolor = 134217741
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event butonup;long ll_flag
long ll_x,ll_y
string ls_tag

ls_tag=this.tag
ll_x=wf_return_coordinates(ls_tag,'1')
ll_y=wf_return_coordinates(ls_tag,'2')

ll_flag=il_click[ll_x,ll_y]
if ll_flag =0 or ll_flag=3 then
	this.backcolor=134217741
	this.borderstyle=styleraised!
end if
end event

event mdown;wf_draw_cb(this.tag,2)
end event

event monup;wf_draw_cb(this.tag,1)
end event

event butdown;long ll_flag
long ll_x,ll_y
string ls_tag

ls_tag=this.tag
ll_x=wf_return_coordinates(ls_tag,'1')
ll_y=wf_return_coordinates(ls_tag,'2')

ll_flag=il_click[ll_x,ll_y]

if ll_flag =0 or ll_flag=3 then
	this.backcolor=134217750
	this.borderstyle=styleBox!
end if
end event

event clicked;long ll_flag
long ll_x,ll_y
string ls_tag
long ll_ray_number

ls_tag=this.tag
ll_x=wf_return_coordinates(ls_tag,'1')
ll_y=wf_return_coordinates(ls_tag,'2')

ll_flag=il_click[ll_x,ll_y]

if ll_flag =0 or ll_flag=3 then	
	if ibool_state[ll_x,ll_y] then
		wf_show_ray()
		messagebox("","game over")
		return
	end if

//	ll_ray_number=il_counts[ll_x,ll_y]
//	
//	if ll_ray_number=1 then
//		this.textcolor=134217856
//	elseif ll_ray_number=2 then
//		this.textcolor=32768
//	elseif ll_ray_number=3 then
//		this.textcolor=255
//	end if
	wf_write_blank(ll_x,ll_y)
	
//	if ll_ray_number = 0 then 
//		
//		this.text=''
//	else
//		this.text=string(ll_ray_number)
//	end if
//	this.borderstyle=styleBox!
//	this.backcolor=134217750
//	il_click[ll_x,ll_y]=1
	wf_game()
end if

//wf_model_click(this)
end event

event rbuttondown;long ll_x,ll_y
string ls_tag

ls_tag=this.tag
ll_x=wf_return_coordinates(ls_tag,'1')
ll_y=wf_return_coordinates(ls_tag,'2')
wf_place_flag(ll_x,ll_y)
wf_game()
end event

type r_border from rectangle within w_main
long linecolor = 33554432
integer linethickness = 4
long fillcolor = 1073741824
integer x = 78
integer y = 44
integer width = 1298
integer height = 1004
end type

