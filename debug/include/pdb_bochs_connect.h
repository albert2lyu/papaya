#ifndef PDB_BOCHS_CONNECT_H
#define PDB_BOCHS_CONNECT_H
/**@return
 * when pdb succeeds parsing the command, 1 will be
 * returned,indicating that all parse job has been 
 * done. If it can not specify the command or just
 * parses a part of the command, 0 wil be returned.
 */
int try_parse_cmd(char *buf);
void read_paddr(int cpu, unsigned addr, unsigned len, void *data);

#ifndef I_AM_PDB
void read_paddr(int cpu, unsigned addr, unsigned len, void *data){
	BX_MEM_C::readPhysicalPage(cpu, addr, len, data);
}
#endif


#endif
