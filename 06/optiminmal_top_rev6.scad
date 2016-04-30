//Thickness of entire plate
plateThickness = 6;
//Unit square length, from Cherry MX data sheet
lkey = 19.2;
//Hole size, from Cherry MX data sheet
holesize = 14;

//length, in units, of board
width = 15.3;
//Height, in units, of board
height = 5.4;

//Radius of mounting holes
mountingholeradius = 1.11;
//height of switch clasp cutouts
cutoutheight = 3;
//width of switch clasp cutouts
cutoutwidth = 1;

//calculated vars
holediff = lkey - holesize;
w = width * lkey;
h = height * lkey;

TOP_PLATE_FILE = "/Users/broden/dev/keyboards/optiminimal/06/top_plate_rev6.dxf";

layout = [
//start column 0
[[0,0],1.5],
  [[0,1],1.5],
  [[0,2],1.5],
  [[0,3],1.5],
  [[0,4],1.5],
  //start column 1
  [[1.5,0],1],
  [[1.5,1],1],
  [[1.5,2],1],
  [[1.5,3],1],
  [[1.5,4],1],
  //start column 2
  [[2.5,0],1],
  [[2.5,1],1],
  [[2.5,2],1],
  [[2.5,3],1],
  [[2.5,4],1],
  //start column 3
  [[3.5,0],1],
  [[3.5,1],1],
  [[3.5,2],1],
  [[3.5,3],1],
  [[3.5,4],1],
  //start column 4
  [[4.5,0],1],
  [[4.5,1],1],
  [[4.5,2],1],
  [[4.5,3],1],
  [[4.5,4],2],//SPACEBAR
  //start column 5
  [[5.5,0],1],
  [[5.5,1],1],
  [[5.5,2],1],
  [[5.5,3],1],
  //start column 6
  [[7,0],1],
  [[7,1],1],
  [[7,2],1],
  [[7,3],1],
  [[7,4],2],//SPACEBAR
  //start column 7
  [[8,0],1],
  [[8,1],1],
  [[8,2],1],
  [[8,3],1],
  //start column 8
  [[9,0],1],
  [[9,1],1],
  [[9,2],1],
  [[9,3],1],
  [[9,4],1],
  //start column 9
  [[10,0],1],
  [[10,1],1],
  [[10,2],1],
  [[10,3],1],
  [[10,4],1],
  //start column 10
  [[11,0],1],
  [[11,1],1],
  [[11,2],1],
  [[11,3],1],
  [[11,4],1],
  //start column 11
  [[12,0],1],
  [[12,1],1],
  [[12,2],1],
  [[12,3],1],
  [[12,4],1],
  //start column 12
  [[13,0],1],
  [[13,1],1],
  [[13,2],2],//ENTER
  [[13,3],1],
  [[13,4],1],
  //start column 13
  [[14,0],1],
  [[14,1],1],

  [[14,3],1],
  [[14,4],1],
  ];




module plate(xdim, ydim, zdim, rdim) {
  hull() {
    translate([rdim, rdim,0]) cylinder(r=rdim,h=zdim);
    translate([xdim-rdim,rdim,0]) cylinder(r=rdim,h=zdim);
    translate([rdim, ydim-rdim,0]) cylinder(r=rdim,h=zdim);
    translate([xdim-rdim, ydim-rdim,0]) cylinder(r=rdim,h=zdim);
  }
}

holetype = 1;
module holeMatrix(holes, depth, startX, startY){
  depth = 0;
  for (key = holes) {
    translate([
        (lkey * key[0][0]) + startX,
        h - (lkey * (key[0][1]+1)) - startY,// - holesize + h,*/
        depth
        ])
      translate([
          ((lkey * key[1] - holesize ) / 2 ) - holesize/4,
          (lkey - holesize) / 2,
          depth
          ])
      switchSocket(holetype);
  }
}

mounts = [
[1.2, 3.5],
  [6.3, 3.5],
  [1.2, 1.5],
  [6.3, 1.5],
  [13.3, 2.2],
  [12.4, 4.4],
  ];
module mountingholes(offsetX, offsetY){
  for(mount = mounts) {
    translate([(mount[0] * lkey) + offsetX, (mount[1] * lkey) + offsetY, 0])
      cylinder(h=plateThickness,r=mountingholeradius, $fn=24);
  }
}

module switchSocket(holetype){
  if (holetype == 0){
    union(){
      cube([holesize,holesize,plateThickness]);
      translate([-cutoutwidth,1,0])
        cube([holesize+2*cutoutwidth,cutoutheight,plateThickness]);

      translate([-cutoutwidth,holesize-1-cutoutheight,0])
        cube([holesize+2*cutoutwidth,cutoutheight,plateThickness]);
    }
  }
  if (holetype == 1){
    union(){
      cube([holesize,holesize,plateThickness]);

      translate([-cutoutwidth,1,0])
        cube([holesize+2*cutoutwidth,holesize-2,plateThickness]);
    }
  }
  if (holetype == 2){
    cube([holesize,holesize,plateThickness]);
  }
}



module stabilizer(){
  cube([3.3, 14, plateThickness]);
}

module stabilizer2u(x,y,l){
  translate([0+lkey*x, h-lkey-lkey*y, 0])
    translate([(lkey*l-holesize)/2,(lkey - holesize)/2, 0])
    translate([-6.6,-.75,0])
    union(){
      stabilizer();
      translate([3.3 + 20.6,0,0]) stabilizer();
    }
}

module stabilizers() {
  stabilizer2u(4.35, 4, 2);
  stabilizer2u(6.85, 4, 2);
  stabilizer2u(12.85, 2, 2);
}

module screwNozzle(x, y) {
  difference() {
    translate([x, y, 1+(caseThickness/3)]) cylinder(h=caseThickness/3, r1=2.1, r2=1.4);
    translate([x, y, 2+(caseThickness/3)]) cylinder(h=plateThickness, r=mountingholeradius-0.2, $fn=24);

  }
}



module topPlate(holes) {
  offSet = 0;

  difference() {
    /*
       plate(w + paddingX/2, h, plateThickness, 4);
       holeMatrix(holes, plateThickness, 0, 0);
       mountingholes(0, 0);
       stabilizers();
       */
    /*translate([130,0,0]) cube([1000,150,150]);//left side*/
    /*translate([0,0,0]) cube([230,150,150]); // right side*/
  }

  difference() {
    linear_extrude (width=0,height=4) import (TOP_PLATE_FILE);
    //translate([100,0,0]) cube([1000,150,150]);//left side*/
    //translate([200,0,0]) cube([1000,150,150]); // middle side

  }


}

caseThickness = 16;

paddingX = 6;
paddingY = 6;
module bottomCase() {

  difference() {

    plate(w + paddingX/2, h, caseThickness, 4);

    translate([paddingX / 2, paddingY / 2,  (caseThickness/4)])
      resize([w - paddingX, h - paddingY, 0])
      plate(w, h, caseThickness, 1);



    union() {
      translate([6, 6, 6])
        cylinder(h=4, r1=3, r2=3);

      translate([150, 6, 6])
        cylinder(h=4, r1=3, r2=3);

      translate([294, 6, 6])
        cylinder(h=4, r1=3, r2=3);

      translate([6, 104, 6])
        cylinder(h=4, r1=3, r2=3);

      translate([150, 104, 6])
        cylinder(h=4, r1=3, r2=3);

      translate([294, 104, 6])
        cylinder(h=4, r1=3, r2=3);

      translate([2.2, 2.2, caseThickness-4]) linear_extrude (width=0,height=4) import (TOP_PLATE_FILE);
    }

  }


  difference() {

    union() {
      translate([4, 4, 2]) {
        difference() {
          cylinder(h=10, r1=2, r2=2);
          cylinder(h=plateThickness, r=mountingholeradius-0.3, $fn=24);
        }
      }

      translate([150, 4, 2]) {
        difference() {
          cylinder(h=9, r1=2, r2=2);
          cylinder(h=plateThickness, r=mountingholeradius-0.3, $fn=24);
        }
      }

      translate([294, 4, 2]) {
        difference() {
          cylinder(h=9, r1=2, r2=2);
          cylinder(h=plateThickness, r=mountingholeradius-0.3, $fn=24);
        }
      }

      translate([4, 105.5, 2]) {
        difference() {
          cylinder(h=9, r1=2, r2=2);
          cylinder(h=plateThickness, r=mountingholeradius-0.3, $fn=24);
        }
      }

      translate([146, 105.5, 2]) {
        difference() {
          cylinder(h=9, r1=2, r2=2);
          cylinder(h=plateThickness, r=mountingholeradius-0.3, $fn=24);
        }
      }

      translate([294, 105.5, 2]) {
        difference() {
          cylinder(h=9, r1=2, r2=2);
          cylinder(h=plateThickness, r=mountingholeradius-0.3, $fn=24);
        }
      }
    }

    union() {
      translate([6, 6, 12])
        cylinder(h=4, r1=3, r2=3);

      translate([150, 6, 12])
        cylinder(h=4, r1=3, r2=3);

      translate([294, 6, 12])
        cylinder(h=4, r1=3, r2=3);

      translate([6, 104, 12])
        cylinder(h=4, r1=3, r2=3);

      translate([150, 104, 12])
        cylinder(h=4, r1=3, r2=3);

      translate([294, 104, 12])
        cylinder(h=4, r1=3, r2=3);

      translate([2.2, 2.2, caseThickness-4]) linear_extrude (width=0,height=4) import (TOP_PLATE_FILE);
    }




  }

  for(mount = mounts) {
    screwNozzle(mount[0] * lkey, mount[1] * lkey);
  }
}

//translate([2, 2, 22])
topPlate(layout);

//bottomCase();
