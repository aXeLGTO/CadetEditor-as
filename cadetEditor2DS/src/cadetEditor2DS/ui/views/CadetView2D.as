package cadetEditor2DS.ui.views
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import cadet.core.IRenderer;
	import cadet.events.InvalidationEvent;
	
	import cadet2D.components.renderers.IRenderer2D;
	
	import cadetEditor.assets.CadetEditorIcons;
	
	import flox.editor.core.IViewContainer;
	import flox.ui.components.Button;
	import flox.ui.components.RadioButtonGroup;
	import flox.ui.components.UIComponent;
	
	public class CadetView2D extends UIComponent
	{
		// Child elements
		private var container		:UIComponent;
		public  var toggleBtnBar	:RadioButtonGroup;
		private var rewindBtn		:Button;
		private var pauseBtn		:Button;
		private var playBtn			:Button;
		
		// Properties
		private var _renderer		:IRenderer2D;
				
		public function CadetView2D()
		{
			super();
		}
		
		override protected function init():void
		{
			container = new UIComponent();
			addChild(container);
			
			toggleBtnBar = new RadioButtonGroup();
			
			rewindBtn = new Button();
			rewindBtn.icon = CadetEditorIcons.Rewind;
			toggleBtnBar.addChild(rewindBtn);
			
			pauseBtn = new Button();
			pauseBtn.icon = CadetEditorIcons.Pause;
			toggleBtnBar.addChild(pauseBtn);
			
			playBtn = new Button();
			playBtn.icon = CadetEditorIcons.Play;
			toggleBtnBar.addChild(playBtn);
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		override protected function validate():void
		{
			if ( _renderer )
			{
				_renderer.viewportWidth = _width;
				_renderer.viewportHeight = _height;
			}
		}
		
		private function addedToStageHandler( event:Event ):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			IViewContainer(parent.parent).actionBar.addChild(toggleBtnBar);
		}
		
		public function set renderer( value:IRenderer2D ):void
		{
			if ( value is IRenderer )
			{
				if ( _renderer )
				{
					_renderer.removeEventListener(InvalidationEvent.INVALIDATE, invalidateRendererHandler);
					_renderer.disable();
				}
				_renderer = value;
				if ( _renderer )
				{
					_renderer.addEventListener(InvalidationEvent.INVALIDATE, invalidateRendererHandler);
					_renderer.enable(container);
				}
			}
			
			invalidate();
		}
		public function get renderer():IRenderer2D { return _renderer; }
		
		private function invalidateRendererHandler( event:InvalidationEvent ):void
		{
			invalidate();
		}
		
		public function get viewportWidth():int
		{
			return _width;
		}
		
		public function get viewportHeight():int
		{
			return _height;
		}
		
		public function getContent():DisplayObjectContainer { return container; }		
	}
}