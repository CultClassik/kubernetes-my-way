#!/bin/bash
vboxmanage controlvm kn1 poweroff
vboxmanage controlvm kn2 poweroff
vboxmanage controlvm kn3 poweroff
vboxmanage unregistervm kn1 --delete
vboxmanage unregistervm kn2 --delete
vboxmanage unregistervm kn3 --delete

