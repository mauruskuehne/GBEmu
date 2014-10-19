using System;

namespace GBEmu.Emulation
{
	public static class ArrayExtensions
	{
		public static T[] GetSubArray<T>(this T[] data, int index, int length)
		{
			T[] result = new T[length];
			Array.Copy(data, index, result, 0, length);
			return result;
		}

		/// <summary>
		/// Read the specified data, fromAddress and toAddress. INCLUDES THE DATA AT fromAddress AND toAddress!!
		/// </summary>
		/// <param name="data">Data.</param>
		/// <param name="fromAddress">From address.</param>
		/// <param name="toAddress">To address.</param>
		/// <typeparam name="T">The 1st type parameter.</typeparam>
		public static T[] Read<T>(this T[] data, int fromAddress, int toAddress)
		{
			return data.GetSubArray (fromAddress, toAddress - fromAddress + 1);
		}
	}
}

