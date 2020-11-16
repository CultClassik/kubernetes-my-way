#!/bin/bash
vboxmanage controlvm kn1 poweroff
vboxmanage unregistervm kn1 --delete
vboxmanage controlvm kn2 poweroff
vboxmanage unregistervm kn2 --delete
vboxmanage controlvm kn3 poweroff
vboxmanage unregistervm kn3 --delete