// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package cadetEditor3D.tools
{
	import cadet3D.components.core.MeshComponent;
	import cadet3D.components.materials.ColorMaterialComponent;
	
	import flash.events.MouseEvent;
	
	import core.editor.CoreEditor;
	import core.app.operations.AddItemOperation;
	import core.app.operations.ChangePropertyOperation;
	import core.app.operations.UndoableCompoundOperation;

	public class AbstractPrimitveTool extends AbstractTool
	{
		static protected var defaultMaterialComponent	:ColorMaterialComponent;
	
		private var active	:Boolean = false;
		
		protected var meshComponent			:MeshComponent;
		
		public function AbstractPrimitveTool()
		{
			if ( defaultMaterialComponent == null )
			{
				defaultMaterialComponent = new ColorMaterialComponent();
				defaultMaterialComponent.name = "Default Primitive Material";
			}
		}
		
		override protected function performEnable():void
		{
			super.performEnable();
			
			renderer.view3D.addEventListener( MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		
		override protected function performDisable():void
		{
			super.performDisable();
			
			if ( active )
			{
				CoreEditor.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
				CoreEditor.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
				end();
			}
			
			renderer.view3D.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		
		private function mouseDownHandler( event:MouseEvent ):void
		{
			var operation:UndoableCompoundOperation = new UndoableCompoundOperation()
			operation.label = "Create primitive";
			
			if ( defaultMaterialComponent.parentComponent == null )
			{
				operation.addOperation(new AddItemOperation( defaultMaterialComponent, context.scene.children ) );
			}
			meshComponent = new MeshComponent();
			meshComponent.materialComponent = defaultMaterialComponent;
			
			operation.addOperation( new AddItemOperation( meshComponent, context.scene.children ) );
			
			operation.addOperation( new ChangePropertyOperation( context.selection, "source", [meshComponent] ) );
			
			
			context.operationManager.addOperation(operation);
			
			begin();
			update();
			CoreEditor.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			CoreEditor.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		private function mouseMoveHandler( event:MouseEvent ):void
		{
			update();
		}
		
		private function mouseUpHandler( event:MouseEvent ):void
		{
			CoreEditor.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			CoreEditor.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			end();
		}
		
		protected function begin():void {}
		protected function update():void {}
		protected function end():void {}
	}
}