# angular2-chrome-extension

Samba docker container for learning Angular2:  Fischaela's Chrome extension angular typescript Demo

# How to use this image
## Host setup
- Docker toolbox for Windows v1.12.2
- Oracle VM VirtualBox 5.1.6 
or 
- Hyper-V (see https://msdn.microsoft.com/en-us/virtualization/hyperv_on_windows/quick_start/walkthrough_install)

## Running container

    docker run -p 139:139 -p 445:445 -p 8000:8000 -p 3001:3001 -d --name ng2ce dman1680/angular2-chrome-extension
        
## Accessing container
### Find docker machine ip

    docker-machine ip

### Browse demo webpage
    
    http://<docker machine ip>:8000

### Setup network share access

    docker exec -d ng2ce samba.sh -u "testuser;pass" -s "usr;/usr;no;no;no;testuser"

### Access network share folder
    
    \\<docker machine ip>\usr
    # login: testuser / pass

### Enter container's bash
    
    docker exec -it ng2ce bash
