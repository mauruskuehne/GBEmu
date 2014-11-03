using System;

namespace GBEmu.Emulation
{
	public interface IRegisterAccess
	{
		byte GetSingleRegister (Register register);
		void SetSingleRegister (Register register, byte val);
		UInt16 GetDoubleRegister (Register register);
		void SetDoubleRegister (Register register, UInt16 value);
		UInt16 GetPC (UInt16 amount = 1, bool peek = false);
	}
}

