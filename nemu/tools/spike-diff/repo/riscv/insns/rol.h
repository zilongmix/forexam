require_extension(EXT_ZBB);
int shamt = RS2 & (xlen-1);
int rshamt = -shamt & (xlen-1);
WRITE_RD(sext_xlen((RS1 << shamt) | (zext_xlen(RS1) >> rshamt)));