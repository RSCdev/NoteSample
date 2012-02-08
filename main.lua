--*********************************************************************************************
--
-- ====================================================================
-- Corona SDK "NOTE" Sample Code
-- ====================================================================
--
-- File: main.lua
--
-- Version 1.0
--
-- Copyright (C) 2011 ANSCA Inc. All Rights Reserved.
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of 
-- this software and associated documentation files (the "Software"), to deal in the 
-- Software without restriction, including without limitation the rights to use, copy, 
-- modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, 
-- and to permit persons to whom the Software is furnished to do so, subject to the 
-- following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all copies 
-- or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
-- DEALINGS IN THE SOFTWARE.
--
-- Published changes made to this software and associated documentation and module files (the
-- "Software") may be used and distributed by ANSCA, Inc. without notification. Modifications
-- made to this software and associated documentation and module files may or may not become
-- part of an official software release. All modifications made to the software will be
-- licensed under these same terms and conditions.
--
--*********************************************************************************************

display.setStatusBar( display.DefaultStatusBar )

local widget = require "widget"
local sbHeight = display.statusBarHeight
local tbHeight = 44
local top = sbHeight + tbHeight

-- forward declarations
local titleField, noteText, loadSavedNote, saveNote

-- create background for the app
local bg = display.newImageRect( "stripes.jpg", display.contentWidth, display.contentHeight )
bg:setReferencePoint( display.TopLeftReferencePoint )
bg.x, bg.y = 0, 0

-- create a gradient for the top-half of the toolbar
local toolbarGradient = graphics.newGradient( {168, 181, 198, 255 }, {139, 157, 180, 255}, "down" )

-- create toolbar to go at the top of the screen
local titleBar = widget.newTabBar{
	top = sbHeight,
	gradient = toolbarGradient,
	bottomFill = { 117, 139, 168, 255 },
	height = 44
}

-- create embossed text to go on toolbar
local titleText = display.newEmbossedText( "NOTE", 0, 0, native.systemFontBold, 20 )
titleText:setReferencePoint( display.CenterReferencePoint )
titleText:setTextColor( 255 )
titleText.x = 160
titleText.y = titleBar.y

-- create a shadow underneath the titlebar (for a nice touch)
local shadow = display.newImage( "shadow.png" )
shadow:setReferencePoint( display.TopLeftReferencePoint )
shadow.x, shadow.y = 0, top
shadow.xScale = 320 / shadow.contentWidth
shadow.yScale = 0.25

-- create load button (top left)
local loadBtn = widget.newButton{
	label = "Load",
	labelColor = { default={255}, over={255} },
	font = native.systemFontBold,
	xOffset=2, yOffset=-1,
	default = "load-default.png",
	over = "load-over.png",
	width=60, height=30,
	left=10, top=28
}

-- onRelease listener callback for loadBtn
local function onLoadRelease( event )
	loadSavedNote()
end
loadBtn.onRelease = onLoadRelease	-- set as loadBtn's onRelease listener

-- create save button (top right)
local saveBtn = widget.newButton{
	label = "Save",
	labelColor = { default={255}, over={255} },
	font = native.systemFontBold,
	xOffset=2, yOffset=-1,
	default = "save-default.png",
	over = "save-over.png",
	width=60, height=30,
	left=display.contentWidth-70, top=28
}

-- onRelease listener callback for saveBtn
local function onSaveRelease( event )
	saveNote()
end
saveBtn.onRelease = onSaveRelease	-- set as saveBtn's onRelease listener

-- display warning that will show at the bottom of screen
local warning = display.newImageRect( "warning.png", 300, 180 )
warning:setReferencePoint( display.BottomCenterReferencePoint )
warning.x = display.contentWidth * 0.5
warning.y = display.contentHeight - 28

-------------------------------------------------------------------------------------
-- Create textFields

local textFont = native.newFont( native.systemFont )
local currentTop = sbHeight+tbHeight+shadow.contentHeight+10
local padding = 10

-- create textField
titleField = native.newTextField( padding, sbHeight+tbHeight+shadow.contentHeight+10, display.contentWidth-(padding*2), 28 )
titleField.font = textFont
titleField.size = 14

currentTop = currentTop + 28 + padding

-- create textBox
noteText = native.newTextBox( padding, currentTop, display.contentWidth-(padding*2), 264-currentTop-padding )
noteText.isEditable = true
noteText.font = textFont
noteText.size = 14

-------------------------------------------------------------------------------------
-- Saving and Loading functions

function loadSavedNote()
	local title_path = system.pathForFile( "title.txt", system.DocumentsDirectory )
	local note_path = system.pathForFile( "note.txt", system.DocumentsDirectory )
	local fh_title = io.open( title_path, "r" )
	local fh_note = io.open( note_path, "r" )
	
	-- load the title
	if fh_title then
		titleField.text = fh_title:read()
		io.close( fh_title )
	end
	
	-- load the note
	if fh_note then
		noteText.text = fh_note:read( "*a" )	-- '*a' is important to preserve line breaks
		io.close( fh_note )
	end
end

function saveNote()
	local title_path = system.pathForFile( "title.txt", system.DocumentsDirectory )
	local note_path = system.pathForFile( "note.txt", system.DocumentsDirectory )
	local fh_title = io.open( title_path, "w+" )
	local fh_note = io.open( note_path, "w+" )
	
	-- load the title
	if fh_title then
		fh_title:write( titleField.text )
		io.close( fh_title )
	end
	
	-- load the note
	if fh_note then
		fh_note:write( noteText.text )
		io.close( fh_note )
	end
end

loadSavedNote()	-- on app start, load previously saved note