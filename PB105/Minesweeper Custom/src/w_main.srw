$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type st_8 from statictext within w_main
end type
type st_7 from statictext within w_main
end type
type st_4 from statictext within w_main
end type
type rb_7 from radiobutton within w_main
end type
type rb_6 from radiobutton within w_main
end type
type rb_5 from radiobutton within w_main
end type
type rb_4 from radiobutton within w_main
end type
type st_5 from statictext within w_main
end type
type cb_1 from commandbutton within w_main
end type
type st_3 from statictext within w_main
end type
type st_2 from statictext within w_main
end type
type st_1 from statictext within w_main
end type
type em_2 from editmask within w_main
end type
type em_1 from editmask within w_main
end type
type rb_3 from radiobutton within w_main
end type
type rb_2 from radiobutton within w_main
end type
type rb_1 from radiobutton within w_main
end type
type cdw_1 from datawindow within w_main
end type
type gb_1 from groupbox within w_main
end type
type gb_2 from groupbox within w_main
end type
type r_1 from rectangle within w_main
end type
type ln_2 from line within w_main
end type
type ln_3 from line within w_main
end type
type st_6 from statictext within w_main
end type
end forward

global type w_main from window
integer x = 14
integer y = 304
integer width = 5234
integer height = 2280
boolean titlebar = true
string title = "Minesweep Datawindow"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
windowstate windowstate = maximized!
long backcolor = 67108864
event ue_open_shelf ( )
event ue_make_visible ( )
st_8 st_8
st_7 st_7
st_4 st_4
rb_7 rb_7
rb_6 rb_6
rb_5 rb_5
rb_4 rb_4
st_5 st_5
cb_1 cb_1
st_3 st_3
st_2 st_2
st_1 st_1
em_2 em_2
em_1 em_1
rb_3 rb_3
rb_2 rb_2
rb_1 rb_1
cdw_1 cdw_1
gb_1 gb_1
gb_2 gb_2
r_1 r_1
ln_2 ln_2
ln_3 ln_3
st_6 st_6
end type
global w_main w_main

type variables
long il_end = 0
long il_vis[100,100], il_bomb[100,100], il_bombs[100,100], il_done[100,100]
long il_empty[100,100]
string is_fullstate
long il_nummines, il_width, il_height, il_new_width, il_new_height
boolean ib_custom
end variables

event ue_open_shelf();String dw_cmd
Long cnt, cnt2, xloc, pix, ll_num_mines
Long startx, ll_rand, ll_height, ll_width
String ls_name, ls_bomb, ls_bomb_vis, ls_bombs
SetPointer(hourglass!)
If il_new_width = 0 Then
	il_new_width = Long(em_1.Text)
End If
If il_new_height = 0 Then
	il_new_height = Long(em_2.Text)
End If

il_width = il_new_width
il_height = il_new_height

For cnt = 1 To il_width
	xloc = startx + (cnt * 14)
	pix = PixelsToUnits(xloc,xpixelstounits!)
	ls_name = 't'+String(cnt)
	dw_cmd = 'create ellipse(band=detail x="'+String(pix)+'" y="4" height="44" width="50" name=oval'+String(cnt)+' visible="0~tLONG(MID(bomb,'+String(cnt)+',1))" brush.hatch="6" brush.color="255" pen.style="0" pen.width="5" pen.color="0"  background.mode="2" background.color="255" )'
	dw_cmd = dw_cmd+' create compute(band=detail alignment="2" expression="MID(bombs,'+String(cnt)+',1)" border="0" color="0~tCASE (LONG(MID(bombs,'+String(cnt)+',1)) WHEN 1THEN 16711680 WHEN 2 THEN 32768 WHEN 3 THEN 255 WHEN 4 THEN 8388608 WHEN 5 THEN 128 WHEN 6 THEN 25794313 ELSE 0)" x="'+String(pix + 4)+'" y="0" visible="0~tIF(LONG(MID(bombs,'+String(cnt)+',1)) = 0,0,1)" height="42" width="48" font.face="Arial" font.height="-8" font.weight="700"  font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="80269524" )'
	dw_cmd = dw_cmd+'create compute(band=detail alignment="2" expression="MID(text,'+String(cnt)+',1)" name='+ls_name+' border="6" color="30013682" x="'+String(pix)+'" y="0" visible="0~tLONG(MID(vis,'+String(cnt)+',1))" height="46" width="48" font.face="Arial" font.height="-12" font.weight="700"  font.family="2" font.pitch="2" font.charset="0" background.mode="2" background.color="16711680" )'
	
	
	cdw_1.Modify(dw_cmd)
Next
cdw_1.Object.vis.X = pix

Randomize(0)
For cnt = 1 To il_height
	ls_bomb = ''
	For cnt2 = 1 To il_width
		If Rand(60) < il_nummines Then
			ls_bomb_vis = '1'
			il_bomb[cnt,cnt2] = 1
			ll_num_mines++
		Else
			ls_bomb_vis = '0'
			il_bomb[cnt,cnt2] = 0
		End If
		ls_bomb = ls_bomb+ls_bomb_vis
		il_vis[cnt,cnt2] = 1
	Next
	cdw_1.InsertRow(99999)
	cdw_1.Object.vis[cdw_1.RowCount()] = FillA('1',il_width)
	cdw_1.Object.Text[cdw_1.RowCount()] = FillA(' ',il_width)
	cdw_1.Object.bomb[cdw_1.RowCount()] = ls_bomb
Next

st_6.Text = String(ll_num_mines)
For cnt = 1 To il_height
	For cnt2 = 1 To il_width
		If cnt2 > 1 Then
			If il_bomb[cnt,cnt2] = 1 Then
				If il_bomb[cnt,cnt2 - 1] = 0 Then
					il_bombs[cnt,cnt2 - 1] = il_bombs[cnt,cnt2 - 1] + 1
				End If
				If cnt > 1 Then
					If il_bomb[cnt - 1,cnt2 - 1] = 0 Then
						il_bombs[cnt - 1,cnt2 - 1] = il_bombs[cnt - 1,cnt2 - 1] + 1
					End If
				End If
				If cnt < il_height Then
					If il_bomb[cnt + 1,cnt2 - 1] = 0 Then
						il_bombs[cnt + 1,cnt2 - 1] = il_bombs[cnt + 1,cnt2 - 1] + 1
					End If
				End If
			End If
		End If
		If cnt2 < il_width Then
			If il_bomb[cnt,cnt2] = 1 Then
				If il_bomb[cnt,cnt2 + 1] = 0 Then
					il_bombs[cnt,cnt2 + 1] = il_bombs[cnt,cnt2 + 1] + 1
				End If
				If cnt > 1 Then
					If il_bomb[cnt - 1,cnt2 + 1] = 0 Then
						il_bombs[cnt - 1,cnt2 + 1] = il_bombs[cnt - 1,cnt2 + 1] + 1
					End If
				End If
				If cnt < il_height Then
					If il_bomb[cnt + 1,cnt2 + 1] = 0 Then
						il_bombs[cnt + 1,cnt2 + 1] = il_bombs[cnt + 1,cnt2 + 1] + 1
					End If
				End If
			End If
		End If
		
		If cnt > 1 Then
			If il_bomb[cnt,cnt2] = 1 Then
				If il_bomb[cnt - 1,cnt2] = 0 Then
					il_bombs[cnt - 1,cnt2] = il_bombs[cnt - 1,cnt2] + 1
				End If
			End If
		End If
		If cnt < il_height Then
			If il_bomb[cnt,cnt2] = 1 Then
				If il_bomb[cnt + 1,cnt2] = 0 Then
					il_bombs[cnt + 1,cnt2] = il_bombs[cnt + 1,cnt2] + 1
				End If
			End If
		End If
	Next
Next

For cnt = 1 To il_height
	ls_bomb = ''
	For cnt2 = 1 To il_width
		ls_bomb = ls_bomb+String(il_bombs[cnt,cnt2])
	Next
	cdw_1.Object.bombs[cnt] = ls_bomb
Next

ll_width = pix + 48 + PixelsToUnits(14,xpixelstounits!) + 80
If ll_width > This.WorkSpaceWidth() - (40 + 622) Then
	ll_width = This.WorkSpaceWidth() - (40 + 622)
End If

cdw_1.Width = ll_width

ll_height = 90 + (il_height * 60)
If ll_height + (20 * 2) > This.WorkSpaceHeight() Then
	ll_height = This.WorkSpaceHeight() - (20 * 2)
End If
cdw_1.Height = ll_height
cdw_1.Y = (This.WorkSpaceHeight() - cdw_1.Height) / 2
cdw_1.X = (((This.WorkSpaceWidth() - 622) - cdw_1.Width) / 2) + 622
il_done = il_vis
This.Event Post ue_make_visible()


end event

event ue_make_visible();SetPointer(arrow!)
cdw_1.Visible = True
cb_1.Text = 'J'
This.SetRedraw(True)
cdw_1.SetFocus()

end event

event open;
is_fullstate = cdw_1.Object.datawindow.Syntax
This.Event Post ue_open_shelf()


end event

on w_main.create
this.st_8=create st_8
this.st_7=create st_7
this.st_4=create st_4
this.rb_7=create rb_7
this.rb_6=create rb_6
this.rb_5=create rb_5
this.rb_4=create rb_4
this.st_5=create st_5
this.cb_1=create cb_1
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.em_2=create em_2
this.em_1=create em_1
this.rb_3=create rb_3
this.rb_2=create rb_2
this.rb_1=create rb_1
this.cdw_1=create cdw_1
this.gb_1=create gb_1
this.gb_2=create gb_2
this.r_1=create r_1
this.ln_2=create ln_2
this.ln_3=create ln_3
this.st_6=create st_6
this.Control[]={this.st_8,&
this.st_7,&
this.st_4,&
this.rb_7,&
this.rb_6,&
this.rb_5,&
this.rb_4,&
this.st_5,&
this.cb_1,&
this.st_3,&
this.st_2,&
this.st_1,&
this.em_2,&
this.em_1,&
this.rb_3,&
this.rb_2,&
this.rb_1,&
this.cdw_1,&
this.gb_1,&
this.gb_2,&
this.r_1,&
this.ln_2,&
this.ln_3,&
this.st_6}
end on

on w_main.destroy
destroy(this.st_8)
destroy(this.st_7)
destroy(this.st_4)
destroy(this.rb_7)
destroy(this.rb_6)
destroy(this.rb_5)
destroy(this.rb_4)
destroy(this.st_5)
destroy(this.cb_1)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.em_2)
destroy(this.em_1)
destroy(this.rb_3)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.cdw_1)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.r_1)
destroy(this.ln_2)
destroy(this.ln_3)
destroy(this.st_6)
end on

type st_8 from statictext within w_main
integer x = 27
integer y = 1712
integer width = 503
integer height = 108
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
boolean enabled = false
string text = "(Best viewed at 1024x768)"
alignment alignment = center!
long bordercolor = 67108864
boolean focusrectangle = false
end type

type st_7 from statictext within w_main
integer x = 366
integer y = 1268
integer width = 137
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16777215
boolean focusrectangle = false
end type

type st_4 from statictext within w_main
integer x = 82
integer y = 1256
integer width = 233
integer height = 116
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16711680
string text = "Mines Deployed"
boolean focusrectangle = false
end type

type rb_7 from radiobutton within w_main
integer x = 73
integer y = 432
integer width = 402
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16711680
string text = "Custom"
end type

event clicked;il_new_width = 0
il_new_height = 0
end event

type rb_6 from radiobutton within w_main
integer x = 73
integer y = 1156
integer width = 402
integer height = 80
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16711680
string text = "Lots"
end type

event clicked;il_nummines = 14
end event

type rb_5 from radiobutton within w_main
integer x = 73
integer y = 1056
integer width = 402
integer height = 96
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16711680
string text = "Some"
boolean checked = true
end type

event clicked;il_nummines = 9
end event

event constructor;il_nummines = 9
end event

type rb_4 from radiobutton within w_main
integer x = 73
integer y = 960
integer width = 402
integer height = 96
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16711680
string text = "Few"
end type

event clicked;il_nummines = 4



end event

type st_5 from statictext within w_main
integer x = 105
integer y = 852
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16711680
string text = "Mines"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_main
integer x = 155
integer y = 1488
integer width = 279
integer height = 208
integer taborder = 100
integer textsize = -36
integer weight = 700
fontcharset fontcharset = symbol!
fontpitch fontpitch = variable!
string facename = "Wingdings"
string text = "J"
end type

event clicked;cdw_1.SetRedraw(False)

cb_1.Text = 'K'
cdw_1.Reset()
cdw_1.Modify("datawindow.syntax = '"+is_fullstate+"'")
il_vis = il_empty
il_bomb = il_empty
il_bombs = il_empty
il_done = il_empty
Parent.Event ue_open_shelf()
il_end = 0


end event

type st_3 from statictext within w_main
integer x = 128
integer y = 60
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16711680
string text = "Playing Field"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_main
integer x = 82
integer y = 680
integer width = 224
integer height = 128
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16711680
string text = "Height (Max. 99)"
boolean focusrectangle = false
end type

type st_1 from statictext within w_main
integer x = 82
integer y = 552
integer width = 256
integer height = 128
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16711680
string text = " Width (Max. 60)"
boolean focusrectangle = false
end type

type em_2 from editmask within w_main
integer x = 347
integer y = 692
integer width = 114
integer height = 88
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "##"
end type

type em_1 from editmask within w_main
integer x = 347
integer y = 564
integer width = 114
integer height = 88
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "##"
end type

type rb_3 from radiobutton within w_main
integer x = 73
integer y = 352
integer width = 434
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16711680
string text = "Large (60x40)"
end type

event clicked;il_new_width = 60
il_new_height = 40
end event

type rb_2 from radiobutton within w_main
integer x = 73
integer y = 256
integer width = 434
integer height = 96
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16711680
string text = "Medium (40x30)"
boolean checked = true
end type

event clicked;il_new_width = 40
il_new_height = 30
end event

event constructor;il_new_width = 40
il_new_height = 20
end event

type rb_1 from radiobutton within w_main
integer x = 73
integer y = 160
integer width = 402
integer height = 96
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16711680
string text = "Small (20x10)"
end type

event clicked;il_new_width = 20
il_new_height = 10

end event

type cdw_1 from datawindow within w_main
event lbd pbm_lbuttondown
event oe_toast ( )
event oe_setpointer ( )
boolean visible = false
integer x = 622
integer y = 32
integer width = 4498
integer height = 2816
integer taborder = 110
string dataobject = "d_minesweep"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event lbd;String ls_vis, ls_vis_array[]
Long row, ll_seq, ll_cnt1, ll_cnt2, ll_test
Long ll_new_row, ll_new_seq
String ls_object
Long ll_row_hilo[2], ll_seq_hilo[2]

If il_end = 1 Then
	Return
End If

ls_object = This.GetObjectAtPointer()

If LeftA(ls_object,1) = 't' Then
	
	row = Long(RightA(ls_object,LenA(ls_object) - PosA(ls_object,'~t')))
	ls_object = LeftA(ls_object,PosA(ls_object,'~t'))
	ll_seq = Long(RightA(ls_object,LenA(ls_object) - 1))
	
	If il_bomb[row,ll_seq] = 1 Then
		ls_vis_array = This.Object.vis.current
		For ll_cnt1 = 1 To il_height
			For ll_cnt2 = 1 To il_width
				If il_bomb[ll_cnt1,ll_cnt2] = 1 Then
					ls_vis_array[ll_cnt1] = ReplaceA(ls_vis_array[ll_cnt1],ll_cnt2,1,'0')
				End If
			Next
		Next
		This.Object.vis.current = ls_vis_array
		il_end = 1
		This.Event Post oe_toast()
		cb_1.Text = 'L'
		Return
	Else
		If il_bombs[row,ll_seq] = 0 Then
			SetPointer(hourglass!)
			cb_1.Text = 'K'
			
			If row - 1 < 1 Then
				ll_row_hilo[1] = 1
			Else
				ll_row_hilo[1] = row - 1
			End If
			ll_row_hilo[2] = row + 1
			If ll_seq - 1 < 1 Then
				ll_seq_hilo[1] = 1
			Else
				ll_seq_hilo[1] = ll_seq - 1
			End If
			ll_seq_hilo[2] = ll_seq + 1
			
			//O mah gosh...   a goto statement  :-(
			here:
			If row - 1 < ll_row_hilo[1] And row - 1 > 0 Then
				ll_row_hilo[1] = row - 1
			ElseIf row + 1 > ll_row_hilo[2] And row + 1 < il_height + 1 Then
				ll_row_hilo[2] = row + 1
			End If
			If ll_seq - 1 < ll_seq_hilo[1] And ll_seq - 1 > 0 Then
				ll_seq_hilo[1] = ll_seq - 1
			ElseIf ll_seq + 1 > ll_seq_hilo[2] And ll_seq + 1 < il_width + 1 Then
				ll_seq_hilo[2] = ll_seq + 1
			End If
			
			For ll_cnt1 = -1 To 1
				If row + ll_cnt1 > 0 And row + ll_cnt1 < il_height + 1 Then
					ls_vis = This.Object.vis[row + ll_cnt1]
					If ll_seq - 1 > 0 Then
						il_vis[row + ll_cnt1,ll_seq - 1] = 0
						ls_vis = ReplaceA(ls_vis,ll_seq - 1,3,'000')
					Else
						ls_vis = ReplaceA(ls_vis,ll_seq - 1,2,'00')
					End If
					il_vis[row + ll_cnt1,ll_seq] = 0
					il_vis[row + ll_cnt1,ll_seq + 1] = 0
					This.Object.vis[row + ll_cnt1] = ls_vis
					il_done[row,ll_seq] = 0
				End If
			Next
			For ll_cnt1 = -1 To 1
				For ll_cnt2 = -1 To 1
					If row + ll_cnt2 > 0 And ll_seq + ll_cnt1 > 0 Then
						If il_bombs[row + ll_cnt2,ll_seq + ll_cnt1] = 0 And il_done[row + ll_cnt2,ll_seq + ll_cnt1] = 1 Then
							ll_new_row = row + ll_cnt2
							ll_new_seq = ll_seq + ll_cnt1
							If ll_new_row > 0 And ll_new_row < il_height + 1 And &
								ll_new_seq > 0 And ll_new_seq < il_width + 1 Then
								row = ll_new_row
								ll_seq = ll_new_seq
								Goto here
							End If
						End If
					End If
				Next
			Next
			For ll_cnt1 = ll_row_hilo[1] To ll_row_hilo[2]
				For ll_cnt2 = ll_seq_hilo[1] To ll_seq_hilo[2]
					If il_done[ll_cnt1,ll_cnt2] = 1 And il_vis[ll_cnt1,ll_cnt2] = 0 And &
						il_bomb[ll_cnt1,ll_cnt2] = 0 And il_bombs[ll_cnt1,ll_cnt2] = 0 Then
						row = ll_cnt1
						ll_seq = ll_cnt2
						Goto here
					End If
				Next
			Next
			This.Event Post oe_setpointer()
		Else
			ls_vis = This.Object.vis[row]
			il_vis[row,ll_seq] = 0
			This.Object.vis[row] = ReplaceA(ls_vis,ll_seq,1,'0')
		End If
	End If
	If il_bomb = il_vis Then
		il_end = 1
		MessageBox('HOORAY!!!!','Victory!',exclamation!)
	End If
End If


end event

event oe_toast();messagebox('BOOM!!!!','Your have been failed!',exclamation!)
end event

event oe_setpointer;setpointer(arrow!)
cb_1.text = 'J'
end event

event rbuttondown;String ls_object, ls_text
Long ll_seq

ls_object = This.GetObjectAtPointer()

If LeftA(ls_object,1) = 't' Then
	ls_object = LeftA(ls_object,PosA(ls_object,'~t'))
	ll_seq = Long(RightA(ls_object,LenA(ls_object) - 1))
	ls_text = This.Object.Text[row]
	If MidA(ls_text,ll_seq,1) = '^' Then
		This.Object.Text[row] = ReplaceA(ls_text,ll_seq,1,' ')
	Else
		This.Object.Text[row] = ReplaceA(ls_text,ll_seq,1,'^')
	End If
End If

end event

type gb_1 from groupbox within w_main
boolean visible = false
integer x = 69
integer y = 160
integer width = 411
integer height = 372
integer taborder = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16711680
string text = "none"
end type

type gb_2 from groupbox within w_main
boolean visible = false
integer x = 55
integer y = 576
integer width = 411
integer height = 352
integer taborder = 130
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16711680
string text = "none"
end type

type r_1 from rectangle within w_main
long linecolor = 16777215
long fillcolor = 16711680
integer x = 18
integer y = 40
integer width = 576
integer height = 1380
end type

type ln_2 from line within w_main
long linecolor = 15793151
integer beginx = 23
integer beginy = 132
integer endx = 590
integer endy = 132
end type

type ln_3 from line within w_main
long linecolor = 15793151
integer beginx = 23
integer beginy = 924
integer endx = 590
integer endy = 924
end type

type st_6 from statictext within w_main
integer x = 370
integer y = 1272
integer width = 128
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16711680
alignment alignment = center!
boolean focusrectangle = false
end type

