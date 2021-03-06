$PBExportHeader$w_meaning.srw
forward
global type w_meaning from window
end type
type cb_move from picturebutton within w_meaning
end type
end forward

global type w_meaning from window
integer x = 5
integer y = 4
integer width = 2208
integer height = 1348
boolean titlebar = true
string title = "The Meaning of Life"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 74481808
toolbaralignment toolbaralignment = alignatleft!
cb_move cb_move
end type
global w_meaning w_meaning

type variables
integer ii_cb_width,ii_cb_height,ii_win_height,ii_win_width
end variables

forward prototypes
public function integer wf_center ()
end prototypes

public function integer wf_center ();//*-----------------------------------------------------------------*/
//*    f_Center:  Center the window
//*-----------------------------------------------------------------*/
int li_screenheight, li_screenwidth, li_rc, li_x=1, li_y=1
environment	lenv_obj

/*  Check for a window association with this object  */
If IsNull ( this ) Or Not IsValid ( this ) Then Return -1

/*  Get environment  */
If GetEnvironment ( lenv_obj ) = -1 Then Return -1

/*  Determine current screen resolution and validate  */
li_screenheight = PixelsToUnits ( lenv_obj.ScreenHeight, YPixelsToUnits! )
li_screenwidth  = PixelsToUnits ( lenv_obj.ScreenWidth, XPixelsToUnits! )
If Not ( li_screenheight > 0 ) Or Not ( li_screenwidth > 0 ) Then Return -1

/*  Get center points  */
If li_screenwidth > this.Width Then
	li_x = ( li_screenwidth / 2 ) - ( this.Width / 2 )
End If
If li_screenheight > this.Height Then
	li_y = ( li_screenheight / 2 ) - ( this.Height / 2 )
End If

/*  Center window  */
li_rc = this.Move ( li_x, li_y )
If li_rc <> 1 Then Return -1

Return 1
end function

on w_meaning.create
this.cb_move=create cb_move
this.Control[]={this.cb_move}
end on

on w_meaning.destroy
destroy(this.cb_move)
end on

event mousemove;Integer	 	li_PX, li_PY, li_NX, li_NY, li_Top, li_Bottom, li_Left, li_Right
Boolean		lb_Vert, lb_Horiz

li_PX = This.PointerX()
li_PY = This.PointerY()

li_NX = cb_move.X
li_NY = cb_move.Y
lb_Vert = (li_PY > (li_NY - 30)) And (li_PY < (li_NY + ii_cb_height + 30))
lb_Horiz = (li_PX > (li_NX - 30)) And (li_PX < (li_NX + ii_cb_width + 30))

If lb_Vert And  lb_Horiz Then // it's inside so move it
	li_Top = li_PY - (li_NY - 30)
	li_Bottom = (li_NY + ii_cb_height + 30) - li_PY
	li_Left = li_PX - (li_NX - 30)
	li_Right =  (li_NX + ii_cb_width + 30) - li_PX
	
	// Determine which is closer
	If Min(li_Top,li_Bottom) < Min(li_Left,li_Right) Then
		If li_Top > li_Bottom Then
			li_NY = li_PY - (ii_cb_height  + 30)
		Else
			li_NY = li_PY + 30
		End If
	Else
		If li_Right < li_Left Then
			li_NX = li_PX - (ii_cb_width  + 30)
		Else
			li_NX = li_PX + 30
		End If
	End If
	
	// If this would move it off the window, then wrap it to the other side
	If li_NY < 0 Then 	li_NY = ii_win_height - (30+ ii_cb_height)
	If li_NX < 0 Then 	li_NX = ii_win_width - (30+ ii_cb_width)
	If li_NY+ii_cb_height >= ii_win_height Then li_NY = 30
	If li_NX+ii_cb_width >= ii_win_width Then li_NX = 30
	cb_move.Move(li_NX,li_NY)
End If


end event

event close;

end event

event resize;// Remember the initial sizes of the button and window
ii_cb_height = cb_move.Height 
ii_cb_width = cb_move.Width
ii_win_height = This.WorkSpaceHeight()
ii_win_width = This.WorkSpaceWidth()

// Center the cb_move button in the window
cb_move.Move(((ii_win_width - ii_cb_width) / 2), ((ii_win_height - ii_cb_height) / 2))


end event

event open;wf_Center()
end event

type cb_move from picturebutton within w_meaning
event mousemove pbm_mousemove
integer x = 233
integer y = 304
integer width = 430
integer height = 200
integer taborder = 20
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Click Here For The Meaning Of Life"
vtextalign vtextalign = multiline!
end type

event mousemove;parent.postevent('mousemove')
end event

event clicked;Messagebox("The meaning of life", "Don't forget about the tab key!")
Close(Parent)

end event

