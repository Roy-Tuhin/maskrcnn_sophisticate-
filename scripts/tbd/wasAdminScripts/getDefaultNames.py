print AdminConfig.getid('/Server:/')
print AdminConfig.getid('/Cell:/')
print AdminConfig.getid('/Node:/')

f=open('defaultNames.txt','w')

print >>f,AdminConfig.getid('/Server:/')
print >>f,AdminConfig.getid('/Cell:/')
print >>f,AdminConfig.getid('/Node:/')

