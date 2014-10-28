// WARNING
//
// This file has been generated automatically by Xamarin Studio to store outlets and
// actions made in the UI designer. If it is removed, they will be lost.
// Manual changes to this file may not be handled correctly.
//
using MonoMac.Foundation;
using System.CodeDom.Compiler;

namespace GBEmu
{
	[Register ("MainWindow")]
	partial class MainWindow
	{
		[Outlet]
		MonoMac.AppKit.NSTableView RegisterTable { get; set; }
		
		void ReleaseDesignerOutlets ()
		{
			if (RegisterTable != null) {
				RegisterTable.Dispose ();
				RegisterTable = null;
			}
		}
	}

	[Register ("MainWindowController")]
	partial class MainWindowController
	{
		[Action ("executeNextStep:")]
		partial void ExecuteNextStep (MonoMac.Foundation.NSObject sender);
		
		void ReleaseDesignerOutlets ()
		{
		}
	}
}
