﻿package kin.barcode
{
	import flash.display.Sprite;
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	public class Code39 extends Sprite
	{
		private var lib_version:String = '1.1';
		
		private var line_style:int = 2;
		private var line_thickness:int = 0;
		private var line_gap:int = line_style;
		private var border:int = 5;
		
		private var container_width:int = 398;
		private var container_height:int = 100;
		private var container_color:Number =  0xffffff; //0x00ff00;
		
		private var bar_color:Number = 0xff0000;
		private var line_color:Number = 0x000000; //0x0000ff
		private var text_color:Number = 0x000000;
				
		private var display_text:Boolean = true;

		private var text_format:TextFormat;
		
		private var lines_array = new Array();
		private var the_str:String = '';
				
		private var container:Sprite;
		private var bars_mc:Sprite;
		private var text_mc:Sprite;
		
		// ===============================================
		// ::: CONSTRUCTOR :::
		// ===============================================
		
		public function Code39( )
		{
			trace('Code39: Initialised Version ' + lib_version);
			
			this.init();
		}
		
		// ===============================================
		// ::: PUBLIC METHODS :::
		// ===============================================
		
		// GETTERS ***********
		
		// SETTERS ***********
		
		public function setBorder(nWidth)
		{
			this.border = nWidth;	
		}
		
		public function setBackgroundColor(the_color)
		{
			this.container_color = the_color;	
		}
		
		public function setBarColor(the_color)
		{
			this.bar_color = the_color;	
		}
		
		public function setCallbackHandler(method, location)
		{
			//this.callbackHandlerLocation = (location == undefined) ? this.callbackHandlerLocation : location;
			//this.callbackHandler = method;
		}
		
		// METHODS **********
		
		// encodes a string
		public function encode(the_str):Sprite
		{
			this.the_str = the_str.toUpperCase();
			
			var ret:Boolean = this.do_encode();
			
			return container;
		}
		
		// clears the barcode
		public function clear()
		{
			removeChild(container);
			removeChild(bars_mc);
			removeChild(text_mc);
		}
		
		// ===============================================
		// ::: PRIVATE METHODS :::
		// ===============================================
		
		private function do_encode():Boolean
		{			
			//this.clear();
			
			var draw_array:Array;
			var bars_str:String = "";
			var barDepth = 1;
			
			var my_str:String = "*"+this.the_str+"*";
			var str_array = my_str.split("");
			
			var the_mc:Sprite;
			
			var drawBar:int;

			container = new Sprite();
			bars_mc = new Sprite();
			
			// draw line on the left (WHY?)
/*
			the_mc = draw_line();	
			bars_mc.addChild(the_mc);
			//barDepth = barDepth + this.line_gap;
*/
			
			// go through each code and determine 
			// whether a line is necessary
			//
			for (var i = 0; i < str_array.length; i++)
			{
				for (var l in this.lines_array)
				{
					if (str_array[i] == this.lines_array[l].character)
					{
						bars_str += this.lines_array[l].pattern;
						
						break;
					}
				}
			}
			
			//trace(bars_str);
			
			// draw background
			this.container.graphics.beginFill(container_color);
			this.container.graphics.drawRect(0, 0, (this.line_gap*17) *str_array.length, container_height);
			this.container.graphics.endFill();
			
			// go through each code and a draw line
			// if necessary
			//
			draw_array = bars_str.split("");
			
			var c:int = 0;
			
			for (i = 0; i < draw_array.length; i++)
			{
				barDepth = barDepth+this.line_gap;
				drawBar = int(draw_array[i]);
				
				if (drawBar)
				{
					the_mc = draw_line();
					the_mc.x = barDepth;
					bars_mc.addChild(the_mc);
				}
				
				// add an extra white gap between each character
				c++;
				if (c == 12)
				{
/* 					barDepth = barDepth-this.line_gap; */
					c = 0;
				}
			}
			
			// draw text if selected to do so
			if (this.display_text)
			{
				text_mc = new Sprite();
				
				var textWidth = this.bars_mc.width/this.the_str.length;
				var letters_array = this.the_str.split("");
				
				for (i = 0;i<letters_array.length;i++)
				{
					var tf = new TextField();
					
					tf.defaultTextFormat = text_format; //new TextFormat('_sans', 13);
/* 					tf.textColor=0x0000ff; */
					tf.selectable = false;
					tf.text = letters_array[i];
					tf.x = textWidth * i;
					tf.y = this.bars_mc.height+this.border-(15/2);
					
					text_mc.addChild(tf);
				}
				
				this.container.height+=(15/2);

				container.addChild(text_mc);
				text_mc.x = -32;

			}
			
			container.addChild(bars_mc);
			
			this.executeCallback();
			
			return false;
		}
		
		private function executeCallback()
		{
			//this.callbackHandlerLocation[this.callbackHandler](this);
		}	
		
		private function draw_line():Sprite
		{
			var mc = new Sprite();
			
			mc.graphics.beginFill(this.bar_color);
			mc.graphics.lineStyle(this.line_style, this.line_color);
			mc.graphics.moveTo(0,0);
			mc.graphics.lineTo(this.line_thickness,0);
			mc.graphics.lineTo(this.line_thickness, container_height);
			mc.graphics.lineTo(0, container_height);
			mc.graphics.lineTo(0,0);
			mc.graphics.endFill();
			
			return mc;
		}
		
		private function init(use_three:Boolean=false):void {
			
			text_format = new TextFormat();
			
			text_format.font = "Arial";
			text_format.bold = true;
			text_format.size = 15;
			text_format.align = "center";
			text_format.color = this.text_color;
			
			if (use_three)
			{
				// create code39 database array
				this.lines_array.push({character:"0", pattern:"1010001110111010"});
				this.lines_array.push({character:"1", pattern:"1110100010101110"}); // BwbWbwbwB
				this.lines_array.push({character:"2", pattern:"1011100010101110"});
				this.lines_array.push({character:"3", pattern:"1110111000101010"});
				this.lines_array.push({character:"4", pattern:"1010001110101110"});
				this.lines_array.push({character:"5", pattern:"1110100011101010"});
				this.lines_array.push({character:"6", pattern:"1011100011101010"});
				this.lines_array.push({character:"7", pattern:"1010001011101110"});
				this.lines_array.push({character:"8", pattern:"1110100010111010"});
				this.lines_array.push({character:"9", pattern:"1011100010111010"});
				this.lines_array.push({character:"A", pattern:"1110101000101110"});
				this.lines_array.push({character:"B", pattern:"1011101000101110"});
				this.lines_array.push({character:"C", pattern:"1110111010001010"});
				this.lines_array.push({character:"D", pattern:"1010111000101110"});
				this.lines_array.push({character:"E", pattern:"1110101110001010"});
				this.lines_array.push({character:"F", pattern:"1011101110001010"});
				this.lines_array.push({character:"G", pattern:"1010100011101110"});
				this.lines_array.push({character:"H", pattern:"1110101000111010"});
				this.lines_array.push({character:"I", pattern:"1011101000111010"});
				this.lines_array.push({character:"J", pattern:"1010111000111010"});
				this.lines_array.push({character:"K", pattern:"1110101010001110"});
				this.lines_array.push({character:"L", pattern:"1011101010001110"});
				this.lines_array.push({character:"M", pattern:"1110111010100010"});
				this.lines_array.push({character:"N", pattern:"1010111010001110"});
				this.lines_array.push({character:"O", pattern:"1110101110100010"});
				this.lines_array.push({character:"P", pattern:"1011101110100010"});
				this.lines_array.push({character:"Q", pattern:"1010101110001110"});
				this.lines_array.push({character:"R", pattern:"1110101011100010"});
				this.lines_array.push({character:"S", pattern:"1011101011100010"});
				this.lines_array.push({character:"T", pattern:"1010111011100010"});
				this.lines_array.push({character:"U", pattern:"1110001010101110"});
				this.lines_array.push({character:"V", pattern:"1000111010101110"});
				this.lines_array.push({character:"W", pattern:"1110001110101010"});
				this.lines_array.push({character:"X", pattern:"1000101110101110"});
				this.lines_array.push({character:"Y", pattern:"1110001011101010"});
				this.lines_array.push({character:"Z", pattern:"1000111011101010"});
				this.lines_array.push({character:"-", pattern:"1000101011101110"});
				this.lines_array.push({character:".", pattern:"1110001010111010"});
				this.lines_array.push({character:" ", pattern:"1000111010111010"});
				this.lines_array.push({character:"$", pattern:"1000100010001010"});
				this.lines_array.push({character:"/", pattern:"1000100010100010"});
				this.lines_array.push({character:"+", pattern:"1000101000100010"});
				this.lines_array.push({character:"%", pattern:"1010001000100010"});
				this.lines_array.push({character:"*", pattern:"1000101110111010"});
			}
			else
			{
				this.lines_array.push({character:"0", pattern:"1010011011010"});
				this.lines_array.push({character:"1", pattern:"1101001010110"}); // BwbWbwbwB
				this.lines_array.push({character:"2", pattern:"1011001010110"});
				this.lines_array.push({character:"3", pattern:"1101100101010"});
				this.lines_array.push({character:"4", pattern:"1010011010110"});
				this.lines_array.push({character:"5", pattern:"1101001101010"});
				this.lines_array.push({character:"6", pattern:"1011001101010"});
				this.lines_array.push({character:"7", pattern:"1010010110110"});
				this.lines_array.push({character:"8", pattern:"1101001011010"});
				this.lines_array.push({character:"9", pattern:"1011001011010"});
				this.lines_array.push({character:"A", pattern:"1101010010110"});
				this.lines_array.push({character:"B", pattern:"1011010010110"});
				this.lines_array.push({character:"C", pattern:"1101101001010"});
				this.lines_array.push({character:"D", pattern:"1010110010110"});
				this.lines_array.push({character:"E", pattern:"1101011001010"});
				this.lines_array.push({character:"F", pattern:"1011011001010"});
				this.lines_array.push({character:"G", pattern:"1010100110110"});
				this.lines_array.push({character:"H", pattern:"1101010011010"});
				this.lines_array.push({character:"I", pattern:"1011010011010"});
				this.lines_array.push({character:"J", pattern:"1010110011010"});
				this.lines_array.push({character:"K", pattern:"1101010100110"});
				this.lines_array.push({character:"L", pattern:"1011010100110"});
				this.lines_array.push({character:"M", pattern:"1101101010010"});
				this.lines_array.push({character:"N", pattern:"1010110100110"});
				this.lines_array.push({character:"O", pattern:"1101011010010"});
				this.lines_array.push({character:"P", pattern:"1011011010010"});
				this.lines_array.push({character:"Q", pattern:"1010101100110"});
				this.lines_array.push({character:"R", pattern:"1101010110010"});
				this.lines_array.push({character:"S", pattern:"1011010110010"});
				this.lines_array.push({character:"T", pattern:"1010110110010"});
				this.lines_array.push({character:"U", pattern:"1100101010110"});
				this.lines_array.push({character:"V", pattern:"1001101010110"});
				this.lines_array.push({character:"W", pattern:"1100110101010"});
				this.lines_array.push({character:"X", pattern:"1001011010110"});
				this.lines_array.push({character:"Y", pattern:"1100101101010"});
				this.lines_array.push({character:"Z", pattern:"1001101101010"});
				this.lines_array.push({character:"-", pattern:"1001010110110"});
				this.lines_array.push({character:".", pattern:"1100101011010"});
				this.lines_array.push({character:" ", pattern:"1001101011010"});
				this.lines_array.push({character:"$", pattern:"1001001001010"});
				this.lines_array.push({character:"/", pattern:"1001001010010"});
				this.lines_array.push({character:"+", pattern:"1001010010010"});
				this.lines_array.push({character:"%", pattern:"1010010010010"});
				this.lines_array.push({character:"*", pattern:"1001011011010"});
			}
			
			if ((this.the_str).length > 0)
			{
				this.encode(this.the_str);	
			}
		}
	}
}

/*

Barcodes must fit in an area of 398x114

AS3 9Barcode builder http://activeden.net/item/barcode-builder/105485

Code 128 JS: http://zanstra.com/my/Barcode.html?barcode=1

Test with on-line generator: http://www.terryburton.co.uk/barcodewriter/generator/



Flash Help: http://www.adobe.com/support/flash/

Barcode Fonts: http://www.adams1.com/fonts.html
Code 39: http://www.adams1.com/39code.html
Creating 2D Barcodes with AS3: http://bumpslide.com/blog/2008/07/30/pdf417lib_as3/
Useful: http://www.barcodeisland.com/
Super Barcode Generator: http://superbarcode.110mb.com/

*/

// Class Definition
// Librarian (www.flashcomponents.net) - AS 2.0 / Flash Player 7 and above
// Chad Adams's BarCode39 Class -  original development AS 1.0 / Flash Player 6

/* NOTE: 


		//---------------------------------------//
	   //  Visit  www.FlashComponents.net  	//
	  //-------------------------------------//


version 1.0 - 1874 bytes

currently only encodes code 39 type barCodes
this component is good, because you don't have to 
embed large BarCode fonts!



/**/

// ::: BarCode39 Class :::
/*
create a barcode out of a string, if the string contains a 
character which cannot be encoded, it will skip that character
/**/
