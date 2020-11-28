package spaceballs.data.objects {
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;

	public class Countdown extends TextField {
		
		private var _timer:Timer;
		private var _repeatCount:Number;
		private var _finishText:String;
		private var _tFormat:TextFormat;
		
		public function Countdown(delay:Number = 3000, finishText:String = "GO") {
			
			_repeatCount = delay / 1000;
			_repeatCount++;
			_finishText = finishText;
			
			_timer = new Timer(delay / _repeatCount,_repeatCount);
			_timer.addEventListener(TimerEvent.TIMER, onTimerTick);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			
			_tFormat = new TextFormat("Verdana",50,0xFFFFFF);
			
			this.text = String(_repeatCount -1);
			this.setTextFormat(_tFormat);			
			this.autoSize = TextFieldAutoSize.LEFT;
			
			super();
		}
		
		public function start():void {
			_timer.start();
			
			setPosition();
		}
		
		private function onTimerTick(event:TimerEvent):void {
			var timer:Timer = event.currentTarget as Timer;
			
			if (stage) {
			
				var num:Number = _repeatCount - timer.currentCount - 1;
				if (num == 0 && _finishText != null) {
					this.text = _finishText;
				}
				else {
					this.text = num.toString();
				}
				this.setTextFormat(_tFormat);
				
				setPosition();
			}
			else {
				timer.stop();
			}
			
		}
		
		private function setPosition():void {
			this.x = stage.width / 2 - this.width / 2;
			this.y = stage.height / 2 - this.height / 2;
			this.z = 100;
		}
		
		private function onTimerComplete(event:TimerEvent):void {
			dispatchEvent(new Event("countdownFinished"));
		}
		
	}
}