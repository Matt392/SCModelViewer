package com.custardsquare
{
	import away3d.core.managers.Stage3DManager;
	import away3d.core.managers.Stage3DProxy;
	import away3d.events.Stage3DEvent;
	import com.custardsquare.battlesystem.KeyHandler;
	import com.custardsquare.core.CustardSquareStage;
	import com.custardsquare.core.DefaultDisplay;
	import com.custardsquare.display.CompositeModel;
	import com.custardsquare.display.Custard3DStage;
	import com.custardsquare.display.ModelAssetLibrary;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import starling.core.Starling;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author Matt Dalzell
	 */
	public class Main extends Sprite 
	{
		
		public function Main():void 
		{
			initProxies();
		}
		
		public var starling:Starling;
		private var stage3DManager:Stage3DManager;
		private var stage3DProxy:Stage3DProxy;
		
		private var _model:CompositeModel;
		
		private var _keyHandeler:KeyHandler;
		
		private var _scale:Number;
		private var _depth:Number;
		
		private var _rotX:Number;
		private var _rotY:Number;
		private var _rotZ:Number;
		
		private var _info:TextField;

		private function initProxies(e:Event = null):void
		{
			// Define a new Stage3DManager for the Stage3D objects
			stage3DManager = Stage3DManager.getInstance(stage);
		  
			// Create a new Stage3D proxy to contain the separate views
			stage3DProxy = stage3DManager.getFreeStage3DProxy();
			stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_CREATED, onContextCreated);
			stage3DProxy.antiAlias = 8;
			stage3DProxy.color = 0x0;
			
			
			_scale = 1;
			_depth = 10;
			
			_rotX = 90;
			_rotY = 0;
			_rotZ = 0;
		}
		private function onContextCreated(event : Stage3DEvent) : void 
		{
			stage3DProxy.removeEventListener(Stage3DEvent.CONTEXT3D_CREATED, onContextCreated);
			
			initAway3D();
			initStarling();
			
			_info = new TextField(200, 200, "##Model Info##", "Verdana", 16, 0x00ffff);
			
			_info.x = 0;
			_info.y = 100;
			_info.pivotX = 0;
			_info.pivotY = 0;
			_info.vAlign = "top";
			_info.hAlign = "left";
			_info.touchable = false;
			
			starling.stage.addChild(_info);
			
			KeyHandler.instance.init(starling.stage);
			KeyHandler.instance.debugInfo = false;
			
			//_keyHandeler = new KeyHandler();
			
			ModelAssetLibrary.library.localDir = true;
			
			_model = new CompositeModel( [ "model" ], "parts/" );
			_model.addToStage();
			_model.root.z = 10;
			_model.root.x = 0;
			_model.root.rotationX = _rotX;
			//_model.root.scale(0.05);
		
		}
		
		private function initAway3D():void
		{
			Custard3DStage.instance.init(this, stage3DProxy, true, true, false);
			
			Custard3DStage.instance.camera.x = 0;
			Custard3DStage.instance.camera.y = 0;
			Custard3DStage.instance.camera.z = -200;
			Custard3DStage.instance.camera.rotationX = 0;
		}
		
		private function initStarling():void
		{
			//removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			
			starling = new Starling(CustardSquareStage, this.stage, stage3DProxy.viewPort, stage3DProxy.stage3D, "auto", "baseline");
			starling.start();
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			//AnimationController.instance.initialize(this.starling.stage);
			//ApplicationFacade.getInstance().startup(this);
			
			CSLogger.log.initialize(this);
			
		}
		
		private function update():void
		{
			_info.text = _model.info();
			if (KeyHandler.isKeyPressed(Keyboard.F1))
			{
				_model.playAnim("melee");
			}
			if (KeyHandler.isKeyPressed(Keyboard.F2))
			{
				_model.playAnim("rifle");
			}
			if (KeyHandler.isKeyPressed(Keyboard.F3))
			{
				_model.playAnim("");
			}
			
			if (KeyHandler.isKeyDown(Keyboard.F5))
			{
				_scale -= 0.05;
				_model.root.scaleX = _scale;
				_model.root.scaleY = _scale;
				_model.root.scaleZ = _scale;
				CSLogger.log.info("Scale: " + _scale);
			}
			if (KeyHandler.isKeyDown(Keyboard.F6))
			{
				_scale += 0.05;
				_model.root.scaleX = _scale;
				_model.root.scaleY = _scale;
				_model.root.scaleZ = _scale;
				CSLogger.log.info("Scale: " + _scale);
			}
			
			
			if (KeyHandler.isKeyDown(Keyboard.F7))
			{
				_depth -= 10;
				_model.root.z = _depth;
				CSLogger.log.info("Depth: " + _depth);
			}
			if (KeyHandler.isKeyDown(Keyboard.F8))
			{
				_depth += 10;
				_model.root.z = _depth;
				CSLogger.log.info("Depth: " + _depth);
			}
			
			
			if (KeyHandler.isKeyDown(Keyboard.W))
			{
				_rotX -= 5;
				_model.root.rotationX = _rotX;
				CSLogger.log.info("Rot X: " + _rotX);
			}
			if (KeyHandler.isKeyDown(Keyboard.S))
			{
				_rotX += 5;
				_model.root.rotationX = _rotX;
				CSLogger.log.info("Rot X: " + _rotX);
			}
			
			
			if (KeyHandler.isKeyDown(Keyboard.A))
			{
				_rotY -= 5;
				_model.root.rotationY = _rotY;
				CSLogger.log.info("Rot Y: " + _rotY);
			}
			if (KeyHandler.isKeyDown(Keyboard.D))
			{
				_rotY += 5;
				_model.root.rotationY = _rotY;
				CSLogger.log.info("Rot Y: " + _rotY);
			}
			
			
			if (KeyHandler.isKeyDown(Keyboard.Q))
			{
				_rotZ -= 5;
				_model.root.rotationZ = _rotZ;
				CSLogger.log.info("Rot Z: " + _rotZ);
			}
			if (KeyHandler.isKeyDown(Keyboard.E))
			{
				_rotZ += 5;
				_model.root.rotationZ = _rotZ;
				CSLogger.log.info("Rot Z: " + _rotZ);
			}
		}
		
		/**
		 * The main rendering loop
		 */
		private function onEnterFrame(event : Event) : void 
		{
			update();
			
		 
			// Clear the Context3D object
			stage3DProxy.clear();

			// Render the Starling animation layer
			//starlingCheckerboard.nextFrame();
			starling.nextFrame();

			// Render the Away3D layer
			Custard3DStage.instance.render();

			// Render the Starling stars layer
			//starlingStars.nextFrame();

			// Present the Context3D object to Stage3D
			stage3DProxy.present();
		}
	}
	
}