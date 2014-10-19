using System;
using System.Collections.Generic;

namespace GBEmu.Emulation
{
	public partial class CPU
	{
		Dictionary<byte,Instruction> _dict;
		partial void FillOpCodeDictionary ()
		{
			LD<byte>.FillOpcodeList(_dict);
			LD<UInt16>.FillOpcodeList(_dict);
		}
	}
}

