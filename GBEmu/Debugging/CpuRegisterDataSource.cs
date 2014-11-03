using System;
using MonoMac.AppKit;
using GBEmu.Emulation;
using MonoMac.Foundation;

namespace GBEmu
{
	[Register]
	class CpuRegisterDataSource : NSTableViewDataSource
	{
		Registers _registers;

		public CpuRegisterDataSource (Registers reg)
		{
			_registers = reg;
		}

		public override int GetRowCount (NSTableView tableView)
		{
			return 14;
		}

		public override NSObject GetObjectValue (NSTableView tableView, NSTableColumn tableColumn, int row)
		{

			if (tableColumn.Identifier == "Register") {
				switch (row) {
				case 0:
					return new NSString ("A");
				case 1:
					return new NSString ("B");
				case 2:
					return new NSString ("C");
				case 3:
					return new NSString ("D");
				case 4:
					return new NSString ("E");
				case 5:
					return new NSString ("H");
				case 6:
					return new NSString ("L");
				case 7:
					return new NSString ("F");
				case 8:
					return new NSString ("AF");
				case 9:
					return new NSString ("BC");
				case 10:
					return new NSString ("DE");
				case 11:
					return new NSString ("HL");
				case 12:
					return new NSString ("SP");
				case 13:
					return new NSString ("PC");
				default:
					// We need a default value.
					return null;
				}
			} else if (tableColumn.Identifier == "Decimal" || tableColumn.Identifier == "Hexadecimal") {

				string formatStringByte = tableColumn.Identifier == "Decimal" ? "d" : "X2";
				string formatString2Byte = tableColumn.Identifier == "Decimal" ? "d" : "X4";

				switch (row) {
				case 0:
					return new NSString (_registers.A.ToString (formatStringByte));
				case 1:
					return new NSString (_registers.B.ToString (formatStringByte));
				case 2:
					return new NSString (_registers.C.ToString (formatStringByte));
				case 3:
					return new NSString (_registers.D.ToString (formatStringByte));
				case 4:
					return new NSString (_registers.E.ToString (formatStringByte));
				case 5:
					return new NSString (_registers.H.ToString (formatStringByte));
				case 6:
					return new NSString (_registers.L.ToString (formatStringByte));
				case 7:
					return new NSString (_registers.F.ToString (formatStringByte));
				case 8:
					return new NSString (_registers.AF.ToString (formatStringByte));
				case 9:
					return new NSString (_registers.BC.ToString (formatStringByte));
				case 10:
					return new NSString (_registers.DE.ToString (formatString2Byte));
				case 11:
					return new NSString (_registers.HL.ToString (formatString2Byte));
				case 12:
					return new NSString (_registers.SP.ToString (formatString2Byte));
				case 13:
					return new NSString (_registers.PC.ToString (formatString2Byte));
				default:
					// We need a default value.
					return null;
				}
			} else {
				switch (row) {
				case 0:
					return new NSString (Convert.ToString(_registers.A, 2).PadLeft(8, '0'));
				case 1:
					return new NSString (Convert.ToString(_registers.B, 2).PadLeft(8, '0'));
				case 2:
					return new NSString (Convert.ToString(_registers.C, 2).PadLeft(8, '0'));
				case 3:
					return new NSString (Convert.ToString(_registers.D, 2).PadLeft(8, '0'));
				case 4:
					return new NSString (Convert.ToString(_registers.E, 2).PadLeft(8, '0'));
				case 5:
					return new NSString (Convert.ToString(_registers.H, 2).PadLeft(8, '0'));
				case 6:
					return new NSString (Convert.ToString(_registers.L, 2).PadLeft(8, '0'));
				case 7:
					return new NSString (Convert.ToString(_registers.F, 2).PadLeft(8, '0'));
				case 8:
					return new NSString (Convert.ToString(_registers.AF, 2).PadLeft(16, '0'));
				case 9:
					return new NSString (Convert.ToString(_registers.BC, 2).PadLeft(16, '0'));
				case 10:
					return new NSString (Convert.ToString(_registers.DE, 2).PadLeft(16, '0'));
				case 11:
					return new NSString (Convert.ToString(_registers.HL, 2).PadLeft(16, '0'));
				case 12:
					return new NSString (Convert.ToString(_registers.SP, 2).PadLeft(16, '0'));
				case 13:
					return new NSString (Convert.ToString(_registers.PC, 2).PadLeft(16, '0'));
				default:
					// We need a default value.
					return null;
				}
			}
		}

	}
}

