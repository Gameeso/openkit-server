# Welcome to the Gameeso Server

The Gameeso server is what maintains and keeps your user's data. This is where your games connect to.
There are a few ways to get a Gameeso Server.


##Hosted Solution (easiest way)
**Coming soon...**

##Local server (for testing or development)
**Platform-agnostic**

`stuff written like this are commands!`

### Install

1. Download & install Vagrant if you haven't done already (see: [vagrantup.com](http://www.vagrantup.com/))
2. In your terminal, create a empty directory for your server, and run: `vagrant init (coming soon)`
3. Now boot up your dev-environment using `vagrant up`
4. The server will automatically run on localhost using port `3000`! That being said, in your desktop, go to `http://localhost:3000` and you're on!

### Work on the server
1. If you want to make changes, contribute or otherwise edit the Gameeso server, you can just open up your file explorer to the empty (well, not so empty now huh?) directory you created in the in **step 2 of the install docs**.
2. The sources you edit here are 100% in-sync with the Vagrant instance.
3. You can do `git pull` to get the latest source updates from this repository.
4. If you created a fork of Gameeso, you can remove the orignal repo and clone your fork:
	1. Go to the /Vargrant dir: `cd /Vagrant`
	2. Remove the current repo: `rm -rf openkit-server`
	3. Clone your own repo: `git clone -b development https://github.com/<your name>/openkit-server.git`
	
		- Change < your name > to your username where you forked openkit-server to
		
	4. Reboot using `vagrant reload` to be sure your fork is loaded.
	5. You can now freely edit and push your sources 

##Cloud Options
Gameeso can run on several cloud providers out of the box. **More provider-support will be added soon!**

###DigitalOcean
1. Clone this repo if you haven't done already: `git clone -b development https://github.com/Gameeso/openkit-server.git`
2. Download & install Packer if you haven't done already (see: [packer.io](http://packer.io/))
3. In your DigitalOcean dashboard, create & copy your client id and API key. You're gonna need those.
4. In your terminal, cd to the cloud_images/ directory in this repo.
5. Create a file named 'packer_variables.json'
	In this file, add the following contents:
		
		{
	      "digitalocean_client_id": "<your client id>",
	      "digitalocean_api_key": "<your api key>"
	    }
		
	Replace the <> values by your own api key and client id
	
6. You are now ready to build! Run: `packer build -var-file=packer_variables.json -only=digitalocean packer.io.json`
7. After a while you have a snapshot named 'Gameeso < random timestap >', which you can use to set up gameeso servers.
8. After instantiating a snapshot, your server is automatically booted and running at your ip on port: 3000

##Building your image from source (not needed for development)

If you want to roll your own images, we use a sophisticated automated build system called Packer ([packer.io](packer.io))

1. Download & install Vagrant if you haven't done already (see: [vagrantup.com](http://www.vagrantup.com/))
	- It needs Vagrant because Packer also will export a Vagrant box for you.
2. Download & install Packer if you haven't done already (see: [packer.io](http://packer.io/))
3. Clone this repo if you haven't done already: `git clone -b development https://github.com/Gameeso/openkit-server.git`
4. In your terminal, cd to the cloud_images/ directory in this repo.
5. If you want to build a VirtualBox appliance, run `packer build -only=virtualbox-iso packer.io.json`
	- Please note that this also will generate a Vagrant box, which you can use in the Installation tutorial.
6. If you want to build a VMWare appliance (untested), run `packer build -only=vmware-iso packer.io.json`.

##Security
All Gameeso images have a non-root user to run the server, called "gameeso". It's default password is also gameeso, which is fine for local development, but you might want to change the default password so you can safely ssh into your server when using in production. Fortunately, I took that into account ;)

- **I assume you already have cloned the repo and installed packer**
- In your terminal, cd to the cloud_images/ directory in this repo.
- Create (or edit) a file named 'packer_variables.json'
	In this file, add the following contents:
		
		{
	      "user_password": "<your new password>"
	    }
	
- When you now build your image, the default gameeso-user will contain this new password for you to login with.


###Other Security notes

MySQL has a default root password 'gameeso'. **This is not a problem.** All Gameeso images are running a firewall (UFW) that only allows you to connect to the following ports: 80, 443, 3000 and 22 for allowing ssh. The MySQL, ftp or other ports are unexposed and thus do not form a threat.


##FAQ

### OMG you **** I want to keep my Mac!! Why using a VM?

**Dont worry!** I too want to keep my tools! While engineering the images, and it's build-platform, I took into account that the VM will **just be the server**, meaning that the sources are exposed to your host-machine. You can edit & commit them with whatever you want!

One thing I've seen at OpenKit is that the curve to run the server is pretty steep. There is nothing wrong with that, but I think it's better if developer can get started quicker and dive faster in the code, not having to worry about anything server-related.

In order to provide a nice way for us to work on Gameeso we provide and encourage to develop in a isolated environment using Vagrant. The reason why is that we have a complicated piece of software here, with a lot of dependencies.

If we were to let everyone work in their own environment we have to write a lot of instructions, for osx, linux, windows, 64bit, 32bit, and you have to follow those just to get started! No way! We want to get straight up & running, aren't we?