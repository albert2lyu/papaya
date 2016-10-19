# move.py
# 1. 导入gdb模块来访问gdb提供的python接口
import gdb
 
def llen():
	return 123

 

listlen()
class listlen(gdb.Command):
	def __init__(self):
		super(self.__class__, self).__init__("listlen", gdb.COMMAND_USER)
 
    # args表示该命令后面所衔接的参数，这里通过string_to_argv转换成数组
	def invoke(self, args, from_tty):
		argv = gdb.string_to_argv(args)
		if len(argv) != 1:
			raise gdb.GdbError('输入参数数目不对，help mv以获得用法')
		print( llen() )
		
listlen()


class Template(gdb.Command):
	def __init__(self):
		super(self.__class__, self).__init__("Template", gdb.COMMAND_USER)
 
    # args表示该命令后面所衔接的参数，这里通过string_to_argv转换成数组
	def invoke(self, args, from_tty):
		argv = gdb.string_to_argv(args)
		if len(argv) != 2:
			raise gdb.GdbError('输入参数数目不对，help mv以获得用法')
		gdb.execute("bt")
