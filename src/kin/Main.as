package kin
{
	import flash.display.Sprite;
	import kin.barcode.Barcode;

	public class Main extends Sprite
	{
		private var barcode:Barcode;
		
		public function Main( )
		{
			this.barcode = new Barcode( this.stage );
		}
	}
}