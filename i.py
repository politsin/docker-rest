import sys
import uuid
import os

#print 'Number of arguments:', len(sys.argv), 'arguments.'
#print 'Argument List:', str(sys.argv)

passw = str(sys.argv[1])
if len(passw) < 3:
    uid = uuid.uuid4()
    passw = uid.hex
print 'Pass=', passw

docker_check = os.system("dpkg -l | grep -c docker")
docker_ver = os.system("docker --version")
print docker_check, docker_ver

if docker_check == 1:
    print 'Docker exist', os.system("docker --version")
else:
    print 'Need docker'
