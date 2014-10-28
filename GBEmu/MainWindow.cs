
using System;
using System.Collections.Generic;
using System.Linq;
using MonoMac.Foundation;
using MonoMac.AppKit;
using GBEmu.Emulation;

namespace GBEmu
{
  class CpuRegisterTableViewDelegate : NSTableViewDelegate
  {
    public override NSCell GetDataCell(NSTableView tableView, NSTableColumn tableColumn, int row)
    {
      NSTableCellView view = tableView.MakeView("", this) as NSTableCellView;

      view.TextField.StringValue = tableView.DataSource.GetObjectValue(tableView, tableColumn, row) as NSString;

      return view;
    }
  }

  [Register]
  class CpuRegisterDataSource : NSTableViewDataSource
  {
    Registers _registers;

    public CpuRegisterDataSource(Registers reg)
    {
      _registers = reg;
    }

    public override int GetRowCount(NSTableView tableView)
    {
      return 14;
    }

    public override NSObject GetObjectValue(NSTableView tableView, NSTableColumn tableColumn, int row)
    {

      if (tableColumn.Identifier == "Register")
      {
        switch (row)
        {
          case 0:
            return new NSString("A");
          case 1:
            return new NSString("B");
          case 2:
            return new NSString("C");
          case 3:
            return new NSString("D");
          case 4:
            return new NSString("E");
          case 5:
            return new NSString("H");
          case 6:
            return new NSString("L");
          case 7:
            return new NSString("F");
          case 8:
            return new NSString("AF");
          case 9:
            return new NSString("BC");
          case 10:
            return new NSString("DE");
          case 11:
            return new NSString("HL");
          case 12:
            return new NSString("SP");
          case 13:
            return new NSString("PC");
          default:
            // We need a default value.
            return null;
        }
      }
      else
      {
        switch (row)
        {
          case 0:
            return new NSString(_registers.A.ToString());
          case 1:
            return new NSString(_registers.B.ToString());
          case 2:
            return new NSString(_registers.C.ToString());
          case 3:
            return new NSString(_registers.D.ToString());
          case 4:
            return new NSString(_registers.E.ToString());
          case 5:
            return new NSString(_registers.H.ToString());
          case 6:
            return new NSString(_registers.L.ToString());
          case 7:
            return new NSString(_registers.F.ToString());
          case 8:
            return new NSString(_registers.AF.ToString());
          case 9:
            return new NSString(_registers.BC.ToString());
          case 10:
            return new NSString(_registers.DE.ToString());
          case 11:
            return new NSString(_registers.HL.ToString());
          case 12:
            return new NSString(_registers.SP.ToString());
          case 13:
            return new NSString(_registers.PC.ToString());
          default:
            // We need a default value.
            return null;
        }
      }
    }

  }

	public partial class MainWindow : MonoMac.AppKit.NSWindow
	{
		#region Constructors

		// Called when created from unmanaged code
		public MainWindow (IntPtr handle) : base (handle)
		{
			Initialize ();
		}
		
		// Called when created directly from a XIB file
		[Export ("initWithCoder:")]
		public MainWindow (NSCoder coder) : base (coder)
		{
			Initialize ();
		}
		
		// Shared initialization code
		void Initialize ()
    {
		}

		#endregion

		[Export("open:")]
		public void Open(NSObject sender)
		{
			NSOpenPanel panel = new NSOpenPanel ();
			panel.AllowsMultipleSelection = false;
			panel.AllowedFileTypes = new string[] { "gb" };
			panel.RunModal ();

			var url = panel.Url;

			var data = NSData.FromUrl (url);
			var bytes = data.ToArray ();

      Controller.LoadRom(bytes);
      RegisterTable.DataSource = new CpuRegisterDataSource(Controller.Emulator.Cpu.Registers);
      RegisterTable.Delegate = new CpuRegisterTableViewDelegate();
		}

    public MainWindowController Controller
    {
      get
      {
        return (MainWindowController)WindowController;
      }
    }
	}
}

