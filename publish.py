# -*- coding:utf-8 -*-
import sys
import os.path
import shutil

import os


all_podspec = ["ZJDigitalAuthSDK.podspec"]
fileFlag = '[publish]'

def push_repo_specs(podspecFiles):
    op_path = os.getcwd()
    cmds = ["cd {}/".format(op_path)]
    for filename in podspecFiles:
        _cmds = "pod trunk push {} --verbose --allow-warnings".format(filename);
        cmds.append(_cmds)
    combinecmd = " && ".join(cmds)
    print(fileFlag + '执行命令列表:{}'.format(combinecmd))
    os.system(combinecmd)


push_repo_specs(all_podspec)
