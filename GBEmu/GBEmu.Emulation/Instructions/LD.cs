using System;
using System.Collections.Generic;
using System.Linq.Expressions;
using System.Reflection;

namespace GBEmu.Emulation
{
	//... neu mache!
	public class LD<TSize> : Instruction
	{
		public override int CpuCycles {
			get {
				return 8;
			}
		}

		PropertyInfo _registerProperty;

		private LD (Expression<Func<Registers, TSize>> registerToLoad)
		{
			var member = registerToLoad.Body as MemberExpression;

			_registerProperty = member.Member as PropertyInfo;
		}

		public override void Execute (MemoryAccess memory, Registers registers)
		{
			_registerProperty.SetValue(registers, memory.ReadAtAddress(registers.GetPC()));
		}

		public static void FillOpcodeList(Dictionary<byte, Instruction> dict)
		{
			if (typeof(TSize) == typeof(byte)) {
				dict.Add (0x06, new LD<byte> (r => r.B));
				dict.Add (0x0E, new LD<byte> (r => r.C));
				dict.Add (0x16, new LD<byte> (r => r.D));
				dict.Add (0x1E, new LD<byte> (r => r.E));
				dict.Add (0x26, new LD<byte> (r => r.H));
				dict.Add (0x2E, new LD<byte> (r => r.L));
			}
			else if (typeof(TSize) == typeof(byte)) {

			}
		}
	}
}

