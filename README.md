# angular2-chrome-extension

Samba docker container for learning Angular2:  Fischaela's Chrome extension angular typescript Demo
(folked from https://github.com/dperson/samba)

# How to use this image

## Host setup
- Docker toolbox for Windows v1.12.2
- Oracle VM VirtualBox 5.1.6 
or 
- Hyper-V (see https://msdn.microsoft.com/en-us/virtualization/hyperv_on_windows/quick_start/walkthrough_install)

## Build Image (optional: when not using dockerhub)

    docker build --no-cache -t dman1680/angular2-chrome-extension .

## Running container

    docker run -p 139:139 -p 445:445 -p 3000:3000 -p 3001:3001 -d --name ng2ce dman1680/angular2-chrome-extension
        
## Accessing container
### Find docker machine ip

    docker-machine ip

### Browse demo webpage
    
    http://<docker machine ip>:3000

### Setup network share access

    docker exec -d ng2ce samba.sh -u "testuser;pass" -s "usr;/usr;no;no;no;testuser"

### Access network share folder
    
    \\<docker machine ip>\usr
    # login: testuser / pass

### Enter container's bash
    
    docker exec -it ng2ce bash

# Details from dperson/samba

By default there are no shares configured, additional ones can be added.

## Hosting a Samba instance

    sudo docker run -it -p 139:139 -p 445:445 -d dperson/samba

OR set local storage:

    sudo docker run -it --name samba -p 139:139 -p 445:445 \
                -v /path/to/directory:/mount \
                -d dperson/samba

## Configuration

    sudo docker run -it --rm dperson/samba -h
    Usage: samba.sh [-opt] [command]
    Options (fields in '[]' are optional, '<>' are required):
        -h          This help
        -c "<from:to>" setup character mapping for file/directory names
                    required arg: "<from:to>" character mappings separated by ','
        -i "<path>" Import smbpassword
                    required arg: "<path>" - full file path in container
        -n          Start the 'nmbd' daemon to advertise the shares
        -p          Set ownership and permissions on the shares
        -s "<name;/path>[;browse;readonly;guest;users;admins;wl]" Config a share
                    required arg: "<name>;<comment>;</path>"
                    <name> is how it's called for clients
                    <path> path to share
                    NOTE: for the default values, just leave blank
                    [browsable] default:'yes' or 'no'
                    [readonly] default:'yes' or 'no'
                    [guest] allowed default:'yes' or 'no'
                    [users] allowed default:'all' or list of allowed users
                    [admins] allowed default:'none' or list of admin users
                    [writelist] list of users that can write to a RO share
        -t ""       Configure timezone
                    possible arg: "[timezone]" - zoneinfo timezone for container
        -u "<username;password>[;ID;group]"       Add a user
                    required arg: "<username>;<passwd>"
                    <username> for user
                    <password> for user
                    [ID] for user
                    [group] for user
        -w "<workgroup>"       Configure the workgroup (domain) samba should use
                    required arg: "<workgroup>"
                    <workgroup> for samba

    The 'command' (if provided and valid) will be run instead of samba

ENVIRONMENT VARIABLES (only available with `docker run`)

 * `CHARMAP` - As above, configure character mapping
 * `NMBD` - As above, enable nmbd
 * `TZ` - As above, set a zoneinfo timezone, IE `EST5EDT`
 * `WORKGROUP` - As above, set workgroup

**NOTE**: if you enable nmbd (via `-n` or the `NMBD` environment variable), you
will also want to expose port 137 and 138 with `-p 137:137/udp -p 138:138/udp`.

## Examples

Any of the commands can be run at creation with `docker run` or later with
`docker exec -it samba.sh` (as of version 1.3 of docker).

### Setting the Timezone

    sudo docker run -it -p 139:139 -p 445:445 -d dperson/samba -t EST5EDT

OR using `environment variables`

    sudo docker run -it -e TZ=EST5EDT -p 139:139 -p 445:445 -d dperson/samba
