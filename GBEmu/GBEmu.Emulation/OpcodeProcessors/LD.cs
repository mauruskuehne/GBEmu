using System;

namespace GBEmu.Emulation
{
	public class LD : OpcodeProcessor
	{
		public LD (UInt16 opcode) : base(opcode)
		{
		}



		public override UInt16[] HandledOpcodes {
			get {
				return new UInt16[] { 0x06, 0x0E, 0x16, 0x1E, 0x26, 0x2E, 0x7F, 0x78, 0x79, 0x7A, 0x7B, 0x7C, 0x7D, 0x7E, 0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x48, 0x49, 0x4A, 0x4B, 0x4C, 0x4D, 0x4E, 
									  0x50, 0x51, 0x52, 0x53, 0x54, 0x55, 0x56, 0x58, 0x59, 0x5A, 0x5B, 0x5C, 0x5D, 0x5E, 0x60, 0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x68, 0x69, 0x6A, 0x6B, 0x6C, 0x6D, 0x6E,
									  0x70, 0x71, 0x72, 0x73, 0x74, 0x75, 0x36, 0x0A, 0x1A, 0xFA, 0x3E, 0x47, 0x4F, 0x57, 0x5F, 0x67, 0x6F, 0x02, 0x12, 0x77, 0xEA, 0xF2, 0xE2, 0x3A, 0x32, 0x22, 0xE0, 0xF0};
			}
		}

		protected override void RunInternal(IRegisterAccess registers, IMemoryAccess memoryAccess)
		{

			//NO
			Register registerToSet;
			Func<byte> readAction;
			switch (Opcode) {
			case 0x7F:
				//LD A,A
				registerToSet = Register.A;
				readAction = () => registers.GetSingleRegister (Register.A);
				break;
			case 0x78:
				//LD A,B
				registerToSet = Register.A;
				readAction = () => registers.GetSingleRegister (Register.B);
				break;
			case 0x79:
				//LD A,C
				registerToSet = Register.A;
				readAction = () => registers.GetSingleRegister (Register.C);
				break;
			case 0x7A:
				//LD A,D
				registerToSet = Register.A;
				readAction = () => registers.GetSingleRegister (Register.D);
				break;
			case 0x7B:
				//LD A,E
				registerToSet = Register.A;
				readAction = () => registers.GetSingleRegister (Register.E);
				break;
			case 0x7C:
				//LD A,H
				registerToSet = Register.A;
				readAction = () => registers.GetSingleRegister (Register.H);
				break;
			case 0x7D:
				//LD A,L
				registerToSet = Register.A;
				readAction = () => registers.GetSingleRegister (Register.L);
				break;
			case 0x7E:
				//LD A,(HL)
				registerToSet = Register.A;
				readAction = () => memoryAccess.ReadByteAtAddress(registers.GetDoubleRegister(Register.HL));
				break;
			case 0x0A:
				//LD A,(BC)
				registerToSet = Register.A;
				readAction = () => memoryAccess.ReadByteAtAddress(registers.GetDoubleRegister(Register.BC));
				break;
			case 0x1A:
				//LD A,(DE)
				registerToSet = Register.A;
				readAction = () => memoryAccess.ReadByteAtAddress(registers.GetDoubleRegister(Register.DE));
				break;
			case 0xFA:
				//LD A,(nn)
				registerToSet = Register.A;
				readAction = () => memoryAccess.ReadByteAtAddress(memoryAccess.ReadUInt16AtAddress(registers.GetPC(2)));
				break;
			case 0x3E:
				//LD A,#
				registerToSet = Register.A;
				readAction = () => memoryAccess.ReadByteAtAddress(registers.GetPC());
				break;
			case 0xF2:
				//LD A,($FF00 + C)
				registerToSet = Register.A;
				readAction = () => {
					var address = (UInt16)(0xFF00 + registers.GetSingleRegister(Register.C));
					return memoryAccess.ReadByteAtAddress (address);
				};
				break;
			default:
				break;
			}
		}
	}
}

