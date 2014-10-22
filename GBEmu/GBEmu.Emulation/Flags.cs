using System;

namespace GBEmu.Emulation
{
	[Flags]
	public enum Flags : byte
	{
		/// <summary>
		/// Zero
		/// </summary>
		Z = 1 << 7, //Zero
		/// <summary>
		/// Subtract
		/// </summary>
		N = 1 << 6, //Subtract
		/// <summary>
		/// HalfCarry
		/// </summary>
		H = 1 << 5, //HalfCarry
		/// <summary>
		/// Carry
		/// </summary>
		C = 1 << 4  //Carry
	}
}