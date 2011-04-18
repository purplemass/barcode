package kin.barcode
{
	import flash.display.Sprite;
	
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import flash.events.Event;
	import flash.events.*;
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import kin.barcode.Code39;
	import kin.barcode.Code128;
	
	public class Barcode extends Sprite
	{
		private var _stage :Stage;
		
		private var barcodeText:TextField;
		private var button:Sprite;

		private var code39:Code39 = new Code39();
		private var code128:Code128 = new Code128();
		
		private var _height:int;
		private var _xscale:int;
		private var _yscale:int;
		
		private var start_str:String = '0123456789';//'Wikipedia';
		
		public function Barcode( stage :Stage )
		{
			this._stage = stage;
			
			//addEventListener(Event.ADDED_TO_STAGE, init);
			this.buildStage();
			
			// add text
			barcodeText.text = this.start_str;

			// Code39
			code39.setLineWidth(1);
			code39.mc_on_stage = this.showResult(code39.encode(this.start_str), code39, 100);
			
			// Code128
			code128.setLineWidth(1);
			code128.mc_on_stage = this.showResult(code128.encode(this.start_str), code128, 300);
		}
		
		private function buildStage( )
		{
			barcodeText = getTextField( 400, 0, true );
			barcodeText.x = PADDING;
			barcodeText.y = PADDING;
			this._stage.addChild( barcodeText );
			
			button = drawButton();
			button.x = PADDING + barcodeText.width + 10;
			button.y = PADDING - 2;
			this._stage.addChild( button );
			button.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			
			// set dimensions
			this._height = 100; //this.bar_height;//this._height;
			this._xscale = this._yscale = 300;
			
			//MovieClip.addListener(this);
			// callbackHandler = name of function to call
/*
			this.callbackHandlerLocation = this._parent;
			this.deadPreview_mc.unloadMovie();
*/
		}

		private function mouseDownHandler(event:MouseEvent):void
		{
			code39.mc_on_stage = this.showResult(code39.encode(barcodeText.text), code39, 100);
			code128.mc_on_stage = this.showResult(code128.encode(barcodeText.text), code128, 300);
		}		
		
		private function showResult(mc:Sprite, my_obj=null, my_y:int=500):Sprite
		{
		 	if ( mc )
			{
				if (my_obj)
				{
					if(my_obj.mc_on_stage)
						this._stage.removeChild(my_obj.mc_on_stage);
				}
				
				mc.x = 10;
				mc.y = my_y;
				
				this._stage.addChild(mc);
			}
			
			return mc;
		}
		
		// ===============================================
		// ::: PRIVATE METHODS (helpers and constants) :::
		// ===============================================
		
		private const PADDING:uint = 20;
		
		private function getTextField( width:Number, color:Number=0, isInputField:Boolean=false ) : TextField
		{
			var t:TextField = new TextField();
			
			t.multiline = t.wordWrap = true;
			
			if (isInputField)
			{
				t.border = true;
				t.type = TextFieldType.INPUT;
				t.background = true;
				t.backgroundColor = 0xeeeeee;
			}
			
			t.textColor=color;
			t.width = width;	
			t.type = TextFieldType.INPUT;
			t.autoSize = TextFieldAutoSize.LEFT;		
			t.defaultTextFormat = new TextFormat('_sans', 13);
			
			return t;
		}
		
		private function drawButton():Sprite
		{
			var textLabel:TextField = new TextField()
			var button:Sprite = new Sprite();
			
			button.graphics.clear();
			button.graphics.beginFill(0xD4D4D4); // grey color
			button.graphics.drawRoundRect(0, 0, 80, 25, 10, 10); // x, y, width, height, ellipseW, ellipseH
			button.graphics.endFill();
			
			textLabel.text = "Click Me!";
			textLabel.selectable = false;
			textLabel.x = 13;
			textLabel.y = 5;
			
			button.addChild(textLabel);
			
			return button;
  		}	
	}
}
