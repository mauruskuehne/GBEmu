using System;

namespace GBEmu.Emulation
{
	public class ROM
	{
		byte[] _data;
		byte[] _nintendoGraphic;
		string _title;
		bool? _isGbColorGame;
		MemorySize _ramSize;
		MemorySize _romSize;
		CartridgeType? _cartridgeType;

		public byte[] RawData {
			get {
				return _data;
			}
		}

		public CartridgeType CartridgeType {
			get 
			{
				if (_cartridgeType == null) {
					byte type = _data [0x0147];

					_cartridgeType = (CartridgeType)type;
				}

				return _cartridgeType.Value;

			}
		}

		public byte DestinationCode {
			get 
			{
				throw new NotImplementedException ();
			}
		}

		public MemorySize ROMSize {
			get 
			{
				if (_romSize == null) {
					int size = _data [0x0148];

					switch (size) {
					case 0x0:
						_romSize = new MemorySize (2);
						break;
					case 0x1:
						_romSize = new MemorySize (4);
						break;
					case 0x2:
						_romSize = new MemorySize (8);
						break;
					case 0x3:
						_romSize = new MemorySize (16);
						break;
					case 0x4:
						_romSize = new MemorySize (32);
						break;
					case 0x5:
						_romSize = new MemorySize (64);
						break;
					case 0x6:
						_romSize = new MemorySize (128);
						break;
					case 0x52:
						_romSize = new MemorySize (72);
						break;
					case 0x53:
						_romSize = new MemorySize (80);
						break;
					case 0x54:
						_romSize = new MemorySize (96);
						break;
					}
				}

				return _romSize;
			}
		}

		public MemorySize RAMSize {
			get 
			{
				if (_romSize == null) {
					int size = _data [0x0149];

					switch (size) {
					case 0x0:
						_ramSize = new MemorySize (0);
						break;
					case 0x1:
						_ramSize = new MemorySize (1, 16 * 1024); //16kbit
						break;
					case 0x2:
						_ramSize = new MemorySize (1, 64 * 1024); // 64kbit
						break;
					case 0x3:
						_ramSize = new MemorySize (4, 256 * 1024); // 256kbit
						break;
					case 0x4:
						_ramSize = new MemorySize (16, 1024 * 1024); // 1mbit
						break;
					}
				}

				return _ramSize;
			}
		}

		public byte MaskRomVersion {
			get 
			{
				throw new NotImplementedException ();
			}
		}

		public byte ComplementCheck {
			get 
			{
				throw new NotImplementedException ();
			}
		}

		public Int16 Checksum {
			get 
			{
				throw new NotImplementedException ();
			}
		}

		public string LicenseeCode {
			get 
			{
				throw new NotImplementedException ();
			}
		}

		public bool IsGbColorGame {
			get
			{
				if (!_isGbColorGame.HasValue) {
					_isGbColorGame = _data [0x0143] == 0x80;
				}

				return _isGbColorGame.Value;
			}
		}

		public string Title {
			get
			{
				if (String.IsNullOrWhiteSpace (_title)) {
					var titleBytes = _data.Read (0x0134, 0x0142);
					_title = System.Text.ASCIIEncoding.ASCII.GetString (titleBytes);
				}

				return _title;
			}
		}

		public byte[] NintendoGraphic {
			get
			{
				if (_nintendoGraphic == null) {
					_nintendoGraphic = _data.Read (0x0104, 0x0133);
					
				}

				return _nintendoGraphic;
			}
		}

		public ROM (byte[] romData)
		{
			_data = romData;
		}


	}
}

