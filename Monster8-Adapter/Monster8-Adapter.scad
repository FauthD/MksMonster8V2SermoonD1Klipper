// An adapter to mount the MKS Monster 8 board into Creality mounting holes.
// Aimed for the Sermoon D1.
// For mounting you need 4 * M3 heat inserts (OD=5mm, l=4mm).
// I recommend to replace the original screws from the old board with ones with 
// flatter head.
// For the Fan you need 4 * M4 heat inserts (OD=6mm, l=5mm).
// Copyright (C) 2023 Dieter Fauth
// This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
// Contact: dieter.fauth at web.de

/* [Print] */

PrintThis = "all"; // ["all", "mount", "nothing"]

/* [Board Sizes] */
BoardLenght=160;
BoardWidth=90;

DrillLenght=152;
DrillWidth=82;
CrealityDrillDiameter=3.8;
// For M3 heat inserts use 4.5 else 2.5.
BoardDrillDiameter=4.7;
MountDiameter=8;
MountDiameter2=11;

MountHeight=6;
Thickness=3;

// Move Board to the left
Offset_X=-15;
// Move Board to upper
Offset_Y=10;

/* [Options] */
UseFan=true;
FanDiameter=120;
FanScrewDistance=105;
// For M4 heat inserts use 5.7 else 3.5.
FanScrewDiameters=5.7;
FanMountingPostDiameter=11;
FanHeight=36;
// Move Fan to the left
FanOffset_X=-10;

Fontsize=5;

/* [Hidden] */

module __Customizer_Limit__ () {}
    shown_by_customizer = false;

$fa = $preview ? 2 : 0.5;
$fs = $preview ? 1 : 0.5;

// If you enable the next line, the $fa and $fs are ignored.
// $fn = $preview ? 12 : 100;
Epsilon = 0.01;
epsilon = Epsilon;

include <svn_rev.scad>

/* Creality holes */
// These are relative to the lower left corner of the board.
// I took them from the BTT E3 Mini board.
// https://github.com/bigtreetech/BIGTREETECH-SKR-mini-E3/blob/master/hardware/BTT%20SKR%20MINI%20E3%20V3.0.1/Hardware/BTT%20E3%20SKR%20MINI%20V3.0.1_SIZE.pdf

E3Mini=[103.75, 70.25];

UnkownDifference=-1.0;  // one hole was not correct, empiric fix with a slotted hole

Drill1=[23.4,67.03, 0];
Drill2=[85.55, E3Mini.y-3.02, 0];
Drill3=[5.54, 32.05, 0];
Drill4=[37.34, 29.41, 0];
Drill5=[101.22, 2.56, 0];

Rounding=MountDiameter2/2;

FanOffset_Y=0;
Enlarge=3;

FanSize=FanScrewDistance+FanMountingPostDiameter;


///////////////////////////////////////////////////////////////////////////////
// halign: String. The horizontal alignment for the text. Possible values are "left", "center" and "right". Default is "left".
// valign : String. The vertical alignment for the text. Possible values are "top", "center", "baseline" and "bottom". Default is "baseline".

module WriteRevision(rev="", height=0.3, fontsize=6, font = "Liberation Mono:bold", halign="left", valign="top", mirror=false, rot=[0,0,0])
{
	rotate(rot)
		mirror([mirror?1:0,0,0])
			linear_extrude(height = height, center = true, convexity = 10)
			{
				text(rev, size=fontsize, font = font, halign=halign, valign=valign);
			}
}

///////////////////////////////////////////////////////////////////////////////
// Some helpers to round combined objects
module RoundConvex(r)
{
	offset(r = r)
	{
		offset(delta = -r)
		{
			children();
		}
	}
}

module RoundConcave(r)
{
	offset(r = -r)
	{
		offset(delta = r)
		{
			children();
		}
	}
}

module RoundThis(r)
{
	RoundConcave(r) RoundConvex(r) children();
}

// Can round combined 2D objects and make them 3D
module RoundExtrude(r, h)
{
	linear_extrude(height = h)
		RoundThis(r) children();
}

///////////////////////////////////////////////////////////////////////////////
// long hole
module SlottedHole(d, h, length)
{
   translate([0, 0, h/2])
      cube(size=[length, d, h+Epsilon], center=true);
      
   for(x=[-length/2,length/2])
   {
      translate([x, 0, h/2])
      {
         cylinder(d=d, h=h+Epsilon, center=true);
      }
   }
}

///////////////////////////////////////////////////////////////////////////////
// Helper for mounting step down boards with MP1584EN

module PcbMount(size, pcb)
{
   len=size.x;
   width=size.y+6;
   screw_dia=1.8;

   difference()
   {
      translate([0,0,size.z/2])
         cube([len,width, size.z], center=true);

      translate([0,0,size.z])
         cube([len+Epsilon,size.y, 2*pcb], center=true);

      translate([0,0,size.z/2])
         cube([len+Epsilon,size.y-1, size.z+Epsilon], center=true);

      for(n=[-1,1])
      {
         for(m=[-1:0.4:1])
         {
            translate([m*(len/2-2),n*(width/2-1.5),size.z/2])
               cylinder(d=screw_dia, h=20*size.z, center=true);
         }
      }
   }
}

MP1584EN_Size=[22.5, 17.1, 6.5];

module StepDown_MP1584EN()
{
   PcbMount(size=MP1584EN_Size, pcb=1.4);
}

///////////////////////////////////////////////////////////////////////////////
// The Fan

module Fan(h=25)
{
   for(a=[45:90:360-Epsilon])
   {
      rotate([0,0,a])
         translate([FanScrewDistance/1.414, 0, 0])
         {
            difference()
            {
               cylinder(d=FanMountingPostDiameter, h=h, center=true);
               translate([0,0,h/2])
                  cylinder(d=FanScrewDiameters, h=h, center=true);
            }
         }
   }
}
///////////////////////////////////////////////////////////////////////////////
// holder for cable tie
module CableMount(len=15, h=5)
{
	thick=3.5;
	translate([0,0,h/2])
		difference()
		{
			cube(size=[len, thick, h], center=true);

			translate([0,0,-thick/2])
				cube(size=[len-2*thick, 2*thick, h], center=true);
		}
}

///////////////////////////////////////////////////////////////////////////////
// The adapter

module CrealityHoles(d, h=5*Thickness)
{
   translate(Drill1)
      cylinder(d=d, h=h, center=true);
   translate(Drill2)
      cylinder(d=d, h=h, center=true);
   translate(Drill3)
      cylinder(d=d, h=h, center=true);
   translate(Drill4)
      cylinder(d=d, h=h, center=true);
   translate(Drill5)
      cylinder(d=d, h=h, center=true);
// fix some unknown difference in hole position
   translate([0,UnkownDifference,-h/2])
      translate(Drill5)
         rotate([0,0,90])
            SlottedHole(d=d, h=h, length=d/2);
}

module BoardHoles()
{
      for(x=[-1,1])
      {
         for(y=[-1,1])
         {
            translate([x*DrillLenght/2, y*DrillWidth/2, 0])
               cylinder(d=BoardDrillDiameter, h=10*Thickness);
         }
      }
}

module BasePlate()
{
   r=Rounding;

   RoundExtrude(r, Thickness)
   {
      square([BoardLenght+Enlarge, BoardWidth+Enlarge], center=true);
      // ensure the holes are covered by the size of the old board
      translate([Offset_X, -Offset_Y])
         square(E3Mini, center=true);


      x=E3Mini.x;
      y=E3Mini.y+7;
      translate([FanOffset_X, -12.5])
         square([FanSize, FanSize], center=true);

      if(UseFan)
      {
         translate([FanOffset_X, FanOffset_Y])
            square([FanSize, FanSize], center=true);
      }
   }
}

// also saves material
module CoolingHelper()
{
   RoundExtrude(Rounding, 10*Thickness)
   {
      translate([FanOffset_X+10, 15])
         square([35,60], center=true);

      translate([FanOffset_X+10, 25-DrillWidth/2])
         square([70,55], center=true);

      translate([BoardLenght/2-7, 0])
         square([20,70], center=true);
   }
}

module BoardMounts(l,w)
   {
      for(x=[-1,1])
      {
         for(y=[-1,1])
         {
            translate([x*l/2, y*w/2, MountHeight/2+Thickness])
               cylinder(d=MountDiameter, h=MountHeight, center=true);
            translate([x*l/2, y*w/2, MountHeight/2+Thickness-1])
               cylinder(d=MountDiameter2, h=MountHeight-3, center=true);
         }
      }
   }

module BoardHolder()
{
   BasePlate();
   BoardMounts(DrillLenght, DrillWidth);
}

module Adapter()
{
   difference()
   {
      union()
      {
         BoardHolder();
         extra=30;
         for(n=[1,0,-1])
         {
            translate([n*extra+FanOffset_X, -FanDiameter/2+1, Thickness/2])
               StepDown_MP1584EN();
         }
      }

      translate([0, 0, Thickness])
         BoardHoles();

      translate([-E3Mini.x/2+Offset_X, -E3Mini.y/2-Offset_Y, 0])
         CrealityHoles(CrealityDrillDiameter);

      dept=Thickness;
      translate([-E3Mini.x/2+Offset_X, -E3Mini.y/2-Offset_Y, 0])
         CrealityHoles(6.5,dept);
      
      // improve cooling
      translate([FanOffset_X,0,-Epsilon])
         CoolingHelper();
   }
   if(UseFan)
   {
      translate([FanOffset_X, FanOffset_Y, FanHeight/2+Thickness])
         Fan(h=FanHeight+Epsilon);

      w=3;
      h=3;
      h2=3*h;
      translate([FanSize/2-w/2+FanOffset_X, 0, Thickness+h/2])
         cube([w, FanScrewDistance, h], center=true);
      translate([-(FanSize/2-w/2)+FanOffset_X, 0, Thickness+h/2])
         cube([w, FanScrewDistance, h], center=true);
      translate([FanOffset_X, FanSize/2-w/2, Thickness+h2/2])
         cube([FanScrewDistance, w, h2], center=true);
      translate([FanOffset_X, -(FanSize/2-w/2), Thickness+h/2])
         cube([FanScrewDistance, w, h], center=true);

      // for cable ties
      len=30;
      space=5;
      for(x=[-1,1])
         for(y=[-1,1])
         {
            translate([x*(FanScrewDistance/2)+FanOffset_X, 
                        y*(FanScrewDistance/2+FanMountingPostDiameter/2-1)+FanOffset_Y,
                        len/2])
               rotate([0,90,y*90])
                  CableMount(len=len, h=space);
         }
   }
   // enforcing
   l=45;
   w=3;
   h=3;
   for(y=[-1,1])
   {
      translate([DrillLenght/2-l/2-MountDiameter/2, y*(DrillWidth/2-w/2), Thickness+h/2])
         cube([l, w, h], center=true);
   }

   // print revision
	if(Fontsize>0)	// turn of by setting font size to 0
	{
		emboss=0.3;
		color("black")
		{
			translate([FanScrewDistance/2-3*Fontsize, 0, Thickness])
				WriteRevision(rev=SVN_RevisionStr, fontsize=Fontsize, halign="center", rot=[0,0,90]);
		}
	}

   // debug:
   // see where the CAN connector is located
      // translate([DrillLenght/2-26/2, -DrillWidth/2, Thickness+5/2])
      //    #cube([26, 3, 5], center=true);
   // see how much space we need downwards
   // s=25;
   //    translate([FanScrewDistance/2+FanOffset_X, -s/2-DrillWidth/2-5, Thickness+5/2])
   //       #cube([5, s, 5], center=true);
}

module print(what="all")
{
   if(what == "all")
   {
      Adapter();
   }
}

print(PrintThis);
