package kin.barcode
{
	import flash.display.Sprite;
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	public class Code128 extends Sprite
	{
		public var mc_on_stage:Sprite;
		
		private var lib_version:String = '1.1';
				
		private var BARS = new Array(212222,222122,222221,121223,121322,131222,122213,122312,132212,221213,221312,231212,112232,122132,122231,113222,123122,123221,223211,221132,221231,213212,223112,312131,311222,321122,321221,312212,322112,322211,212123,212321,232121,111323,131123,131321,112313,132113,132311,211313,231113,231311,112133,112331,132131,113123,113321,133121,313121,211331,231131,213113,213311,213131,311123,311321,331121,312113,312311,332111,314111,221411,431111,111224,111422,121124,121421,141122,141221,112214,112412,122114,122411,142112,142211,241211,221114,413111,241112,134111,111242,121142,121241,114212,124112,124211,411212,421112,421211,212141,214121,412121,111143,111341,131141,114113,114311,411113,411311,113141,114131,311141,411131,211412,211214,211232,23311120);
		private var START_BASE = 38;
		private var STOP = 106; //BARS[STOP]==23311120 (manually added a zero at the end)
		private var fromType:Object;
				
		private var line_style:int = 1;
		private var line_thickness:int = 0;
		private var line_gap:int = line_style;
		private var border:int = 5;
		
		private var container_width:int = 398;
		private var container_height:int = 114;
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
		
		public function Code128()
		{
			trace('Code128 Initialised Version ' + lib_version);
			
			this.init();
		}
		
		// ===============================================
		// ::: PUBLIC METHODS :::
		// ===============================================
		
		// GETTERS ***********
		
		// SETTERS ***********
		
		public function setLineWidth(nWidth)
		{
			this.line_style = nWidth;
			this.line_gap = nWidth;
		}
		
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
			this.the_str = the_str;
			
			do_encode(this.code128(the_str));
			
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
		
		private function do_encode(bars_str:String):Boolean
		{			
			//this.clear();
			
			var draw_array:Array;
			var barDepth = 1;
			
			var my_str:String = this.the_str;
			var str_array = my_str.split("");
			
			var the_mc:Sprite;
			
			var drawBar:int;

			container = new Sprite();
			bars_mc = new Sprite();
			
			// draw background
			this.container.graphics.beginFill(container_color);
			this.container.graphics.drawRect(0, 0, (this.line_gap*17) *str_array.length, container_height);
			this.container.graphics.endFill();
			
			// go through each code and a draw line
			// if necessary
			//
			draw_array = bars_str.split("");
			
			var c:int = 0;
			
			for (var i = 0; i < draw_array.length; i++)
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
					
					//new TextFormat('_sans', 13);
 					//tf.textColor=0x0000ff;
					
					tf.defaultTextFormat = text_format;
					tf.selectable = false;
					tf.text = letters_array[i];
					tf.x = textWidth * i - (10/this.line_style);
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

		private function init():void {

			text_format = new TextFormat();
			
			text_format.font = "Arial";
			text_format.bold = true;
			text_format.size = 10;
			text_format.align = "center";
			text_format.color = this.text_color;			
		}
		
		private function code128(code:String, barcodeType:String=null):String
		{
			if (arguments.length<2)
				barcodeType = code128Detect(code);
			
			// bob
			barcodeType = code128Detect(code);
			
			if (barcodeType=='C' && code.length%2==1)
				code = '0'+code;
			
			var a = parseBarcode(code,  barcodeType);
			
			//trace(bar2html(a.join('')) + '<label>' + code + '</label>');
			
			return form_lines(a.join(''));
		}

		private function form_lines(s:String)
		{
			var ret:String = '';
			
			for(var pos=0; pos<s.length; pos+=2)
				ret += charRepeat('1', int(s.charAt(pos))) + charRepeat('0', int(s.charAt(pos+1)));
			
			return ret;
		}
				
		public static function charRepeat( char:String, rep:uint ):String
		{
			var s:String = "";
			while (rep--) s += char;
			return s;
		}
		
		private function bar2html(s:String)
		{
			var sb = new Array();
			for(var pos=0; pos<s.length; pos+=2)
				sb.push('<div class="bar' + s.charAt(pos) + ' space' + s.charAt(pos+1) + '"></div>' + "\n");
			
			return sb.join('');
		}

		function code128Detect(code)
		{
			if (/^[0-9]+$/.test(code))
				return 'C';
			
			if (/[a-z]/.test(code))
				return 'B';
			
			return 'A';
		}
		
		private function getFromType(charCode:int, barcodeType:String):int
		{
			var ret:int = charCode;
			
			switch(barcodeType)
			{
				case 'A':
					if (charCode>=0 && charCode<32)
						ret = charCode+64;
					if (charCode>=32 && charCode<96)
						ret = charCode-32;
					break;
				
				case 'B':
					if (charCode>=32 && charCode<128)
						ret = charCode-32;
					break;
				
				case 'C':
					break;
			}
			
			return ret;
		}
		
		private function parseBarcode(barcode:String, barcodeType:String)
		{
			var bars = new Array();
			
			bars.add = function(nr) {
				var nrCode = BARS[nr];
				this.check = this.length==0 ? nr : this.check + nr*this.length;
				//JS:
				//this.push( nrCode || format("UNDEFINED: %1->%2", nr, nrCode) );
				this.push( nrCode || "UNDEFINED: "+nr+"->"+nrCode);
			};
			
			bars.add(START_BASE + barcodeType.charCodeAt(0));
			
			var code = '';
			var converted = '';
			
			for(var i=0; i<barcode.length; i++)
			{
				//code = (barcodeType=='C') ? code+barcode.substr(i++, 2) : barcode.charCodeAt(i);
				code = (barcodeType=='C') ?		   barcode.substr(i++, 2) : barcode.charCodeAt(i);
				
				//converted = fromType[barcodeType](code);
				converted = getFromType(code, barcodeType);
				
				if (isNaN(converted) || converted<0 || converted>106)
				{
					//throw new Error(format("Unrecognized character (%1) at position %2 in code '%3'.", code, i, barcode));
					trace("Unrecognized character (%1) at position %2 in code '%3'.");
				}
				bars.add( converted );
			}
			
			bars.push(BARS[bars.check % 103], BARS[STOP]);
			
			return bars;
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
