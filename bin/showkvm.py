#!/bin/python
import sys
try:
    import pydot
    import libvirt
    from libvirt import VIR_CONNECT_LIST_DOMAINS_PERSISTENT
    from PIL import Image
    from xml.etree import ElementTree
except:
    print "The program requires the following Python packages: libvirt, pydot, xml, PIL"
    exit(1)



if '--help' in sys.argv:
    print '''\
This program displays a graph of network connections on KVM host.
Usage:
    showkvm.py [OPTION]...
    
    --help           print this help message
    --all            show both active and inactive domains (by default only active shown)
    --text           print a table of the domains and interfaces, no graphics
    --default-net    show "default" network connection (by default not shown)
'''
    sys.exit()


#main graph and its basic properties 
graph = pydot.Dot(ranksep=2, mindist=50, concentrate = 'true', nodesep=1)

#used to generate different node colors
colornum=1

#globally used font
FONT_NAME = 'Arial'
FONT_SIZE = 9

#textual representation of KVM and their interfaces for table print 
txtDomains = {}


#scan for virtual domains
V=libvirt.openReadOnly("qemu:///system")
for dom in V.listAllDomains(VIR_CONNECT_LIST_DOMAINS_PERSISTENT):
    
    if not '--all' in sys.argv and not dom.isActive():
        continue

    #node name must be quoted since it may contain non-alphanumeric characters
    domainNodeName = '"' + dom.name() + '"'

    txtDomains[dom.name()] = []

    #each domain represented as graphviz record node, this is the opening brace of record        
    label = '{' + dom.name()

    #each record field must have a number so that later we can connect an edge
    #directly to the field (i.e. interface) rather than to whole record 
    recordField = 0
    
    #scan the domain for interfaces
    for iface in ElementTree.fromstring(dom.XMLDesc(0)).findall("devices/interface"):
        recordField += 1
        recordFieldName = str(recordField)
        
        address = iface.find("mac").get("address")
        bridge  = iface.find("source").get("bridge") 
        network = iface.find("source").get("network")
        try:
            target =  ' ' + iface.find("target").get("dev")
        except:
            target = ''
         
        label += '| <' + recordFieldName + '> ' + address + target

        #now we need to find to which network/bridge this interface is connected
        edgeEnd = iface.find("source").get("bridge")
        if not edgeEnd:
            edgeEnd = iface.find("source").get("network")
        
        #show "default" network connection only if requested by cmd param to prevent diagram clutter
        if edgeEnd == 'default' and not '--default-net' in sys.argv:
            edgeEnd = None

        #draw an endge: first edge endpoint is connected to the interface, the second to edgeEnd           
        if edgeEnd:
            graph.add_node(pydot.Node(edgeEnd, shape='circle', label=edgeEnd, fontsize=FONT_SIZE ,fontname=FONT_NAME))

            fieldName = domainNodeName + ':' + recordFieldName
            graph.add_edge(pydot.Edge(fieldName, edgeEnd, dir='none', color=colornum, colorscheme='dark28')) 
            colornum = colornum % 8 + 1 #dark28 has color names from 1 to 8

        #update the list of interfaces for the domain
        txtIface = ''
        for t in [address, network, edgeEnd, target]:
            if t: txtIface += t + ' '
        txtDomains[dom.name()].append(txtIface)

    #domain is done: close record node        
    label+='}'
    
    if dom.isActive():
        stateColor = 'black'
    else:
        stateColor = 'grey'
   
    #add the domain node to graph
    graph.add_node(pydot.Node(domainNodeName, shape='Mrecord', label=label, color=stateColor,
                               fontcolor=stateColor, fontsize=FONT_SIZE ,fontname=FONT_NAME))
    
#done scannig domains


#only print a table, no graphics    
if '--text' in sys.argv:
    for dom in txtDomains.keys():
        print dom
        for iface in txtDomains[dom]:
            print iface
        print
    sys.exit() 


#generate graph file
fileName = '/tmp/kvm.png'
graph.write_png(fileName)
graph.write(path='/tmp/kvm.dot', format='raw')
print 'Saved', fileName

Image.open(fileName).show()

