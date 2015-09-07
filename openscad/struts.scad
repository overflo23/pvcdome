/*

2. sept 2015 - overflo from metalab.at / https://metalab.at/wiki/Benutzer:Overflo

This work is licensed under
Creative Commons Attribution 4.0 International License

CC-BY (make sure to mention me / link back here if you use this for your project)

This script generates connectors for a PVC pipe dome.

I built a dome out of wooden staffs @ CCCamp2015 and it was good, but hard to transport because it is so heavy.
So i came up with the idea of a PVC pipe dome as they are cheap and readly available in all european countries.

During the night of day4 we had an apocalypse aka thunderstorm with lightnings, power failures and everything.
I was "trapped" at the belgian fablab bus but it turned out to be very good.
There i met Lieven Standaert and we had a little chat and i told him about my PVC dome plans and suddenly he pulled out a little connector that he made for exactly that purpose.

Out of the ~5000 people at the campsite, i met the one i needed to talk to about this project.
He gave me a sample connector he made out of 6mm Polypropylene at his hackerspace for me as a sample.
Some weeks later i got this script working and can now generate any kind of connector.

Usage:
Just call the connector() function with a list of variables and degree offsets and you are fine.
The samples below are from http://www.acidome.ru/lab/calc/
V4, equal arcs, flat base

For usage skip to the last 20 lines or so and you will find a list of labels and degrees and how to call the connector() function. It is easy.




Have fun and tell me about your project!
I love to see how the world is changing trough things that people share..

*/

// defines the thickness of the material (not so important after all as we will make a 2d projection in the end)
baseplate_height=6;
// the inner ring diameter of the connector
baseplate_inner_dia=66;


// there is a hole in the middle
mount_hole_dia=10;


// how width should each strut be (aka inner diameter of your pipe - some)
strut_width=18;

// how long should each strut stand out of the baseplate (approximation-3mm)
strut_length=33;

// should there be a hole for a ziptie in the struts?
ziptie_hole_dia=5;






// just so that the variables read nicely
connector_height=baseplate_height;



module baseplate()
{
 
    // the base
    difference()
    {
        
     // base plate inner   
     cylinder(r=baseplate_inner_dia/2, h=baseplate_height,center=true,$fn=200);
     //hole in the middle   
     cylinder(r=mount_hole_dia/2, h=baseplate_height,center=true,$fn=200);    
    }       
}




module strut()
{
      difference()
      {
       // the strut itself           
       translate([0,((strut_length/2)+(baseplate_inner_dia/2))-3,0])  cube([strut_width,strut_length,connector_height],center=true);
         
          
       //make the outer ends a little pointy to make the rod slip in easy
       translate([strut_width/2+4,(baseplate_inner_dia/2)+(strut_length)-3,0])  rotate([0,0,8])  cube([10,20,connector_height],center=true);         
       translate([-(strut_width/2+4),(baseplate_inner_dia/2)+(strut_length)-3,0])  rotate([0,0,-8])  cube([10,20,connector_height],center=true);      
   
}   
          
      
      

      
      
      
    }
    


    
module strut_outline(label)
{
        
       // slot left and right 
       translate([  strut_width/2+1 ,(baseplate_inner_dia/2)-3,0])  cube([2,10,  connector_height] ,center=true);
       translate([-(strut_width/2+1) ,(baseplate_inner_dia/2)-3,0])  cube([2,10,connector_height],center=true);       
        
    
       // round hole at the end for "zugentlastung" 
       translate([strut_width/2+1.5,baseplate_inner_dia/2-8,0]) cylinder(r=1.5, h=connector_height,center=true,$fn=200);           
       translate([-(strut_width/2+1.5),baseplate_inner_dia/2-8,0]) cylinder(r=1.5, h=connector_height,center=true,$fn=200);    

       // hole in the middle of sytrut for zip tie 
       translate([0,(baseplate_inner_dia/2),0]) cylinder(r=ziptie_hole_dia/2, h=connector_height,center=true,$fn=200);   
        
        
        
        
        
              // text label 

     translate([-(strut_width/2)+5,18,-(baseplate_height/2)-1])   linear_extrude(height = baseplate_height+2) { 
     text(str(label), font = "Liberation Sans", size = 7,center=true); 
         }

        
        
        
        
        
}





// this makes an actual connector

module  connector(strutlist, halfconnector=0)
{
 difference()
 {
  union()
  {    
   baseplate();  
   for (a = strutlist)    
   {  
    rotate([0,0,180-a[0]]) strut();
   }    
  } //union
  
  //difference
  for (a = strutlist)    
  {  
    rotate([0,0,180-a[0]])  strut_outline(a[1]);
  }  
  
   // remove some of the connector if this is a bottom part
   if(halfconnector ==1)
   {
     translate([baseplate_inner_dia/2+18,0,0]) cube([baseplate_inner_dia,baseplate_inner_dia,connector_height],center=true);
   }
  
  
 }   
 

 
 
}




///////////////















// v4 DESIGN has 8 different connectors
// see: http://www.acidome.ru/lab/calc/#Align_5/8_Arcs_Piped_D108_4V_R4.2_beams_150x50

// 30x Vertices 1
strutlist_1= [
   [55.1,   "D"],
   [110.2,  "C"],
   [168.3, "D"],
   [235.1,   "B"],
   [301.9,  "C"],
   [360, "B"]
 ];


// 30x
strutlist_2= [
   [0,   "E"],
   [60.8,    "E"],
   [123.1,    "A"],
   [177.4,    "B"],
   [243.5,    "B"],
   [297.8,    "A"]
 ];




// 10x bottom part #1, cut off base!
strutlist_3= [
   [0,   "I"],
   [56.2,  "H"],
   [126.5, "G"],
   [184.1,   "F"],
 ];


// 10x bottompart #2, cut off base!
strutlist_4= [
   [0,   "D"],
   [58.1,    "B"],
   [124.9,    "C"],
   [184.2,    "F"],
 ];



// 10x
strutlist_5= [
   [0,   "A"],
   [61.1,    "C"],
   [122.2,    "A"],
   [176,    "G"],
   [241.1,    "C"],
   [302.2,    "A"]
 ];

 //10x
 strutlist_6= [
   [0,   "A"],
   [61.1,    "C"],
   [122.2,    "A"],
   [180.1,    "A"],
   [241.2,    "C"],
   [302.3,    "A"]
 ];
 
 // 6x
 strutlist_7= [
   [0,   "C"],
   [72,    "C"],
   [144,    "C"],
   [216,    "C"],
   [288,    "C"],
 ];
 

//5x 
 strutlist_8= [
   [0,   "B"],
   [66.1,    "B"],
   [120.4,    "A"],
   [178.3,    "H"],
   [247.8,    "H"],
   [302.1,    "A"]
 ];

module arrange_in_grid(spacing) {
    rows = ceil(sqrt($children));
    for(row = [0:rows]) {
        for(column = [0:rows]) {
            if(row*rows + column < $children)
                translate([spacing * row, spacing * column, 0]) children(row*rows + column);
        }
    }
}



// 3d view
//connector(strutlist_1);


/*
use this for 2d vectorpaths that you can export as .dxf for the lazzzor
*/

arrange_in_grid(baseplate_inner_dia + strut_length*2) {
    projection(cut = false)  connector(strutlist_1);
    projection(cut = false)  connector(strutlist_2);

    // these need a flat base so add ,1 as parameter
    projection(cut = false)  connector(strutlist_3,1);
    projection(cut = false)  connector(strutlist_4,1);

    projection(cut = false)  connector(strutlist_5);
    projection(cut = false)  connector(strutlist_6);
    projection(cut = false)  connector(strutlist_7);
    projection(cut = false)  connector(strutlist_8);
}



